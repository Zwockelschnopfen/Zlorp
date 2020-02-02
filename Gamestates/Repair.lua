local TMG          = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local Physics      = require "Code.Components.Physics"
local Sprite       = require "Code.Components.Sprite"
local Anim         = require "Code.Components.Anim"
local Transform    = require "Code.Components.Transform"
local Gravity      = require "Code.Components.Gravity"
local AnimationSM  = require "Code.Components.AnimStateMachine"

local TMR            = require "Code.Systems.TileMapRenderer"
local SpriteRenderer = require "Code.Systems.SpriteRenderer"
local PhysicsUpdate  = require "Code.Systems.PhysicsUpdate"
local AnimUpdate     = require "Code.Systems.AnimUpdate"

local GameState      = require "Gamestates.GameState"


local PHYSICS_SCALING = 128
local SEARCH_TIME = 2.5
local REPAIR_TIME = 2.5

local Trash = Concord.component(function(c)
  c.isHeld = true
  c.isCaptured = false
end)

local TrashCleaner = Concord.system({
  Transform,
  Physics,
  Trash
})

function TrashCleaner:update(dt)
  for _, e in ipairs(self.pool.objects) do
      local trash = e:get(Trash)
      local body = e:get(Physics).body
      
      if not trash.isHeld then

        (function() 
          for _, contact in ipairs(body:getContacts()) do
            if contact:isTouching() then
              local f0, f1 = contact:getFixtures()
              
              local b0, b1 = f0:getBody(), f1:getBody()
              local fixture = (b0 == body) and f1 or f0
  
              if fixture:isSensor() then
                local ud = fixture:getUserData()
                
                if ud.properties.type == "junkkill" then
                  e:destroy()
                  return
                end
              end
            end
          end
        end)()
        
      end
  end
end

local Repair = { }

local function adjustCollider(verts, dx, dy)
  for i=1,#verts,2 do
    verts[i+0] = verts[i+0] - dx
    verts[i+1] = verts[i+1] - dy
  end
  return verts
end

function Repair:load()
	-- Set world meter size (in pixels)
  love.physics.setMeter(128)

  self.resources = {
    player = love.graphics.newImage("Assets/Sprites/Player.png"),
    trashgraphics = {
       love.graphics.newImage("Assets/Sprites/Trash01.png"),
    },
  }
end

function Repair:initGame()

  local level = STI("Assets/Levels/Level1.lua", { "box2d" })
  level.layers["Walls"].visible = false
  level.layers["Ladders"].visible = false
  level.layers["Objects"].visible = false
  
  self.world = Concord.entity.new()
  self.world:give(TMG, level)
  self.world:give(PhysicsWorld, 9.81 * PHYSICS_SCALING)

  RepairInstance:addEntity(self.world)
  
	-- Prepare collision objects
  level:box2d_init(self.world[PhysicsWorld].world)

  self.player = Concord.entity.new()
  self.player.walkDir = "left"
  self.player:give(Transform, 10 * PHYSICS_SCALING, 14 * PHYSICS_SCALING)
  self.player:give(AnimationSM)
  self.player:give(
    Physics, 
    { 
      type = "dynamic",
      fixedRotation = true,
      gravityScale = 0,
      friction = 0,
    },
    { { type = "polygon", 
        verts = adjustCollider({
          88.00,80.00,
          104.33,60.00,
          139.00,60.00,
          157.00,80.00,
          157.00,219.12,
          133.38,242.00,
          106.00,242.00,
          88.00,223.38,
        }, 128, 128)
      }
    }
  )
  self.player:give(Anim, "animation_sheet_filled", "idle")
  self.player:give(Gravity)
  RepairInstance:addEntity(self.player)

  RepairInstance:addSystem(TrashCleaner(), "update")


  -- RepairInstance:addSystem(GravityUpdater())
  RepairInstance:addSystem(TMR(), "draw")
  RepairInstance:addSystem(AnimUpdate(), "draw")
  RepairInstance:addSystem(SpriteRenderer(), "draw")
  
  -- MUST BE LAST:
  local physA = PhysicsUpdate()
  RepairInstance:addSystem(physA, "update" )
  RepairInstance:addSystem(physA, "draw" )
end

function Repair:exitGame()
  RepairInstance:clear()
end

function Repair:enter(previous, wasSwitched, ...)
  self.currentTrash = nil
end

function Repair:leave()

end

local HotSpots = {
  cockpit = "Cockpit",
  engines = "Engine Turbine",
  shields = "Shield Generator",
  weapons = "Weapons Systems",
  junk = "Junk Pit",
}

function Repair:globalUpdate(dt)
  RepairInstance:emit("update", dt)
end

function Repair:playerUpdate(dt)

  local anyLadder = false
  local hotspot
  local world = self.world[PhysicsWorld].world

  local inputEnabled = true

  if self.isRepairing ~= nil then
    self.isRepairing = self.isRepairing + dt
    if Input:down "action" then
      if self.isRepairing > REPAIR_TIME then
        self.player[AnimationSM]:setValue("isRepairing", false)
        self.player[AnimationSM]:setValue("hasJunk", false)
        self.isRepairing = nil
      end
      inputEnabled = false
    else
      self.player[AnimationSM]:setValue("isRepairing", false)
      self.player[AnimationSM]:setValue("hasJunk", false)
      self.isRepairing = nil
    end
  end

  if self.isSearching ~= nil then
    self.isSearching = self.isSearching + dt
    if Input:down "action" then
      if self.isSearching > SEARCH_TIME then
        self.player[AnimationSM]:setValue("isPickingUp", false)
        self.isSearching = nil

        do
          local playerPos = self.player[Transform]
            
          local idx = math.random(#self.resources.trashgraphics)

          local sprite = self.resources.trashgraphics[idx]
          local tx, ty = sprite:getDimensions()

          local trash = Concord.entity.new()
          trash:give(Transform, playerPos.x + 40, playerPos.y + 40)
          trash:give(Sprite, sprite)
          trash:give(Trash)
          trash:give(
            Physics, 
            {
              type = "dynamic",
            },
            { { type = "polygon", 
                verts = adjustCollider({
                  1.48,9.13,
                  15.65,1.22,
                  30.09,9.09,
                  30.35,28.22,
                  14.74,34.78,
                  1.48,27.00,
                }, tx/2, ty/2)
              }
            }
          )
          RepairInstance:addEntity(trash)
          self.currentTrash = trash
        end
      end
      inputEnabled = false
    else
      self.player[AnimationSM]:setValue("isPickingUp", false)
      self.isSearching = nil
    end
  end

  local body = self.player[Physics].body
  for _, contact in ipairs(body:getContacts()) do
    if contact:isTouching() then
      local f0, f1 = contact:getFixtures()
      
      local b0, b1 = f0:getBody(), f1:getBody()
      local fixture = (b0 == body) and f1 or f0

      if fixture:isSensor() then
        local ud = fixture:getUserData()
        
        anyLadder = anyLadder or (ud.properties.type == "ladder")

        if HotSpots[ud.properties.type] then
          hotspot = ud.properties.type
        end
      end
    end
  end

  self.hotspot = hotspot

  local forceX = 400
  local forceY = 400
  local forceZ = 800

  if not anyLadder then
    body:applyForce(0, 9.81 * PHYSICS_SCALING)
  end

  if self.currentTrash then
    -- wir halten MÜLL!
    local playerPos = self.player[Transform]
    local trashPos = self.currentTrash[Transform]
    
    local body = self.currentTrash[Physics].body

    local tx = playerPos.x + ((self.player.walkDir == "left") and (-20) or -5)
    local ty = playerPos.y - 33

    body:setGravityScale(0)

    trashPos.x = math.lerp(trashPos.x, tx, 0.1)
    trashPos.y = math.lerp(trashPos.y, ty, 0.1)

    local dx, dy = trashPos.x - tx, trashPos.y - ty

    if (dx*dx+dy*dy < 5000) or self.currentTrash[Trash].isCaptured then -- magic value sponsored by print
      if not self.currentTrash[Trash].isCaptured then
        self.currentTrash[Trash].isCaptured = true 
        self.player[AnimationSM]:setValue("hasJunk", true)
      end
      self.player[AnimationSM]:setValue("isPickingUp", false)
    
      if inputEnabled and Input:pressed "action" then

        if self.hotspot and self.hotspot ~= "cockpit" and self.hotspot ~= "junk" then
          self.player[AnimationSM]:setValue("isRepairing", true)
          self.isRepairing = 0
          
          self.currentTrash:destroy()
        else
          body:setGravityScale(1)
          self.player[AnimationSM]:setValue("hasJunk", false)
          self.currentTrash[Trash].isHeld = false
        end
        self.currentTrash = nil
      end
    else
      -- print(dx*dx+dy*dy)
    end

  else
    if inputEnabled and Input:pressed "action" then

      if hotspot then
        if hotspot == "cockpit" then
          GameState:goToShmup()
        elseif hotspot == "junk" then
          self.player[AnimationSM]:setValue("isPickingUp", true)
          self.isSearching = 0.0
        end
      else
        body:applyLinearImpulse(0, -forceZ)
      end
    end
  end

  local vx, vy = body:getLinearVelocity()

  local isClimbing = false
  if anyLadder then
    isClimbing = true
    if inputEnabled and Input:down "up" then
      if vy > -forceY then
        vy = -forceY
      end
    elseif inputEnabled and Input:down "down" then
      if vy <= forceY then
        vy = forceY
      end
    else
      vy = vy * 0.9
    end
  end

  local moving
  if inputEnabled and Input:down "left" then
    body:setLinearVelocity(-forceX, vy)
    moving = true
    self.player.walkDir = "left"
  elseif inputEnabled and Input:down "right" then
    body:setLinearVelocity(forceX, vy)
    moving = true
    self.player.walkDir = "right"
  else
    vx = vx * 0.9
    body:setLinearVelocity(vx, vy)
    moving = false
  end

  self.player[AnimationSM]:setValue("isClimbing", isClimbing)
  self.player[AnimationSM]:setValue("isMoving", moving)
end

function Repair:update(dt)

  Repair:playerUpdate(dt)

end

function Repair:draw()
  RepairInstance:emit("draw")

  love.graphics.print("Current Hotspot: " .. tostring(self.hotspot), 10, 10)

  local trafo = self.player[Transform]

  if self.isRepairing ~= nil or self.isSearching ~= nil then
    local progress
    if self.isRepairing then
      progress = self.isRepairing / REPAIR_TIME
    elseif self.isSearching then
      progress = self.isSearching / SEARCH_TIME
    else
      error("Whaaagh!")
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
      "fill",
      trafo.x - 200,
      trafo.y - 150,
      400,
      25
    )

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle(
      "fill",
      trafo.x - 200 + 1,
      trafo.y - 150 + 1,
      math.floor((400-2) * progress),
      25 - 2
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
      "line",
      trafo.x - 200,
      trafo.y - 150,
      400,
      25
    )
  end

end

return Repair