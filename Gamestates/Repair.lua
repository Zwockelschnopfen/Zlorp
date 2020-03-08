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
local SoundFX        = require "Code.SoundFX"

local Highscore = require "Code.Highscore"
local Balancing = require "Code.Balancing"

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
                  trash.isDestroyed = true
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
    keyElements = {
      default = {
        shields = love.graphics.newImage("Assets/Images/Shield_Asset.png"),
        cockpit = love.graphics.newImage("Assets/Images/Cockpit_Asset.png"),
        weapons = love.graphics.newImage("Assets/Images/Weapon_Asset.png"),
        engines = love.graphics.newImage("Assets/Images/Engine_Asset.png"),
        trash   = love.graphics.newImage("Assets/Images/Trash_Asset.png"),
      },
      highlight = {
        shields = love.graphics.newImage("Assets/Images/Shield_Asset_Glow.png"),
        cockpit = love.graphics.newImage("Assets/Images/Cockpit_Asset_Glow.png"),
        weapons = love.graphics.newImage("Assets/Images/Weapon_Asset_Glow.png"),
        engines = love.graphics.newImage("Assets/Images/Engine_Asset_Glow.png"),
        trash   = love.graphics.newImage("Assets/Images/Trash_Asset_Glow.png"),
      },
    }
  }
  self.sounds = {
    junkGrab = SoundFX("Assets/Sounds/junk_grab", 4),
    junkPickup = SoundFX("Assets/Sounds/junk_pickup", 1),
    junkDrop = SoundFX("Assets/Sounds/junk_drop", 4),
    enterCockpit = SoundFX("Assets/Sounds/cockpit_enter", 1),
    ladder = SoundFX("Assets/Sounds/ladder", 6, true),
    repair = SoundFX("Assets/Sounds/repair", 1),
    repairDone = SoundFX("Assets/Sounds/repair_done", 1),
    ladder = SoundFX("Assets/Sounds/ladder", 6, true),
  }
end

function Repair:initGame()

  self.level = STI("Assets/Levels/Level1.lua", { "box2d" })
  self.level.layers["Walls"].visible = false
  self.level.layers["Ladders"].visible = false
  self.level.layers["Objects"].visible = false

  self.camera = {
    x = 0,
    y = 0,
    width = 3000,
    bounds = {
      left = 0,
      top = 0,
      right = 4606,
      bottom = 2558,
    },
    verticalHardZone = 350,
    horizontalHardZone = 250,
    
    verticalSoftZone = 250,
    horizontalSoftZone = 750,

    verticalSoftAdjustment = 800,
    horizontalSoftAdjustment = 650,
  }
  self.camera.height = self.camera.width / VirtualScreen.aspect

  function self.camera:update(cx, cy)

    local dt = love.timer.getDelta()
    
    local w_hard = (self.width/2 - self.horizontalHardZone)
    local h_hard = (self.height/2 - self.verticalHardZone)
    
    local w_soft = (self.width/2 - self.horizontalHardZone - self.horizontalSoftZone)
    local h_soft = (self.height/2 - self.verticalHardZone - self.verticalSoftZone)

    do -- soft camera boundaries

      if cx > self.x + w_soft then
        local p = math.clamp(cx - (self.x + w_soft), 0, self.horizontalSoftZone) / self.horizontalSoftZone
        self.x = self.x + self.horizontalSoftAdjustment * p * dt
      end
      
      if cx < self.x - w_soft then
        local p = math.clamp((self.x - w_soft) - cx, 0, self.horizontalSoftZone) / self.horizontalSoftZone
        self.x = self.x - self.horizontalSoftAdjustment * p * dt
      end

      if cy > self.y + h_soft then
        local p = math.clamp(cy - (self.y + h_soft), 0, self.verticalSoftZone) / self.verticalSoftZone
        self.y = self.y + self.verticalSoftAdjustment * p * dt
      end
      
      if cy < self.y - h_soft then
        local p = math.clamp((self.y - h_soft) - cy, 0, self.verticalSoftZone) / self.verticalSoftZone
        self.y = self.y - self.verticalSoftAdjustment * p * dt
      end

    end

    do -- hard camera boundaries

      if cx > self.x + w_hard then 
        self.x = cx - w_hard
      end
      if cx < self.x - w_hard then 
        self.x = cx + w_hard
      end
      if cy > self.y + h_hard then 
        self.y = cy - h_hard
      end
      if cy < self.y - h_hard then 
        self.y = cy + h_hard
      end
    end

    self.x = math.clamp(self.x,
      self.bounds.left + self.width/2 + self.horizontalHardZone,
      self.bounds.right - self.width/2 - self.horizontalHardZone
    )

    self.y = math.clamp(self.y,
      self.bounds.top + self.height/2 + self.verticalHardZone,
      self.bounds.bottom - self.height/2 - self.verticalHardZone
    )

  end

  self.highlights = {
    engines = false,
    shields = false,
    cockpit = false,
    weapons = false,
    trash = false,
  }

  self.world = Concord.entity.new()
  self.world:give(TMG, self.level)
  self.world:give(PhysicsWorld, 9.81 * PHYSICS_SCALING)

  RepairInstance:addEntity(self.world)
  
	-- Prepare collision objects
  self.level:box2d_init(self.world[PhysicsWorld].world)

  self.player = Concord.entity.new()
  self.player.walkDir = "left"
  self.player.isClimbing = false
  self.player.cockpitLocked = false
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
end

function Repair:initSystems()
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
  local localJunk
  local world = self.world[PhysicsWorld].world

  local inputEnabled = true

  if self.isRepairing ~= nil then
    self.isRepairing = self.isRepairing + dt
    if Input:down "action" then
      if self.isRepairing > REPAIR_TIME then
        local hpup = math.random(15, 40) 

        GameState.health[self.repairTarget] = math.min(100, GameState.health[self.repairTarget] + hpup)

        self.player[AnimationSM]:setValue("isRepairing", false)
        self.player[AnimationSM]:setValue("hasJunk", false)
        self.isRepairing = nil

        if self.repairTarget == "engines" then
          Highscore:add(Balancing.scores.repairEngines)
        elseif self.repairTarget == "weapons" then
          Highscore:add(Balancing.scores.repairWeapons)
        elseif self.repairTarget == "shields" then
          Highscore:add(Balancing.scores.repairShields)
        end

        self.sounds.repairDone:play()
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
        
        Highscore:add(Balancing.scores.gatherTrash)

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
              },
              {
                type = "circle",
                radius = 50,
                sensor = true,
              }
            }
          )
          RepairInstance:addEntity(trash)
          self.currentTrash = trash
          self.sounds.junkPickup:play()
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

        if ud.entity and ud.entity[Trash] then
          localJunk = ud.entity
        end
        
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

  if self.currentTrash and self.currentTrash[Trash].isDestroyed then
    self.currentTrash = nil
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

        if self.hotspot == "engines" or self.hotspot == "shields" or self.hotspot == "weapons" then
          self.player[AnimationSM]:setValue("isRepairing", true)
          self.isRepairing = 0
          self.repairTarget = self.hotspot
          self.sounds.repair:play()
          self.currentTrash:destroy()
        else
          body:setGravityScale(1)
          self.player[AnimationSM]:setValue("hasJunk", false)
          self.currentTrash[Trash].isHeld = false
          self.sounds.junkDrop:play()
        end
        self.currentTrash = nil
      end
    else
      -- print(dx*dx+dy*dy)
    end

  else
    if inputEnabled and Input:pressed "action" then
      if hotspot == "cockpit" then
        if not self.player.cockpitLocked then
          self.sounds.enterCockpit:play()
          GameState:goToShmup()
        end
        self.player.cockpitLocked = true
      elseif hotspot == "junk" then
        self.player[AnimationSM]:setValue("isPickingUp", true)
        self.isSearching = 0.0
        self.sounds.junkGrab:play()
      elseif localJunk then
        self.currentTrash = localJunk
        self.sounds.junkPickup:play()
      else
        -- Enable/Disable jump here
        -- body:applyLinearImpulse(0, -forceZ)
      end
    end
    if hotspot ~= "cockpit" then
      self.player.cockpitLocked = false
    end
  end

  local vx, vy = body:getLinearVelocity()

  if anyLadder then
    if inputEnabled and Input:down "up" then
      if vy > -forceY then
        vy = -forceY
      end
      self.player.isClimbing = true
    elseif inputEnabled and Input:down "down" then
      if vy <= forceY then
        vy = forceY
      end
      self.player.isClimbing = true
    else
      vy = vy * 0.9
    end
  else
    self.player.isClimbing = false
  end

  local moving
  if inputEnabled and Input:down "left" then
    body:setLinearVelocity(-forceX, vy)
    moving = true
    self.player.walkDir = "left"
    self.player[Transform].sx = -1
  elseif inputEnabled and Input:down "right" then
    body:setLinearVelocity(forceX, vy)
    moving = true
    self.player.walkDir = "right"
    self.player[Transform].sx = 1
  else
    vx = vx * 0.9
    body:setLinearVelocity(vx, vy)
    moving = false
  end

  self.player[AnimationSM]:setValue("isClimbing", self.player.isClimbing)
  self.player[AnimationSM]:setValue("isMoving", moving)

  -- Update glow to game state
  if self.isRepairing then
    self.highlights = {
      engines = false,
      shields = false,
      cockpit = false,
      weapons = false,
      trash = false,
    }
    self.highlights[self.repairTarget] = true
  elseif self.isSearching then
    self.highlights = {
      engines = false,
      shields = false,
      cockpit = false,
      weapons = false,
      trash = true,
    }
  elseif self.currentTrash then
    self.highlights = {
      engines = true,
      shields = true,
      cockpit = false,
      weapons = true,
      trash = false,
    }
  else
    self.highlights = {
      engines = false,
      shields = false,
      cockpit = true,
      weapons = false,
      trash = true,
    }
  end

  self.camera:update(
    self.player[Transform].x,
    self.player[Transform].y
  )
end

function Repair:update(dt)

  Repair:playerUpdate(dt)

end

function Repair:draw()

  -- Update map layers to correct image if the element is currently highlighted or not.
  for key, enabled in pairs(self.highlights) do
    local tex
    if enabled then
      tex = self.resources.keyElements.highlight[key]
    else
      tex = self.resources.keyElements.default[key]
    end
    self.level.layers[key].image = tex
  end

  love.graphics.push()

  -- love.graphics.scale(
  --   (self.camera.bounds.right - self.camera.bounds.left) / self.camera.width
  -- )
  -- love.graphics.translate(
  --   -(self.camera.x - self.camera.width/2),
  --   -(self.camera.y - self.camera.height/2)
  -- )

  RepairInstance:emit("draw")

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

  if love.keyboard.isDown("5") then

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
      "line",
      self.camera.bounds.left, self.camera.bounds.top,
      self.camera.bounds.right - self.camera.bounds.left, self.camera.bounds.bottom - self.camera.bounds.top
    )

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle(
      "line",
      self.camera.x - self.camera.width/2,
      self.camera.y - self.camera.height/2,
      self.camera.width,
      self.camera.height
    )
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle(
      "line",
      self.camera.x - self.camera.width/2 + self.camera.horizontalHardZone,
      self.camera.y - self.camera.height/2 + self.camera.verticalHardZone,
      self.camera.width - 2*self.camera.horizontalHardZone,
      self.camera.height - 2*self.camera.verticalHardZone
    )
    
    love.graphics.setColor(0, 1, 1)
    love.graphics.rectangle(
      "line",
      self.camera.x - self.camera.width/2 + self.camera.horizontalHardZone + self.camera.horizontalSoftZone,
      self.camera.y - self.camera.height/2 + self.camera.verticalHardZone + self.camera.verticalSoftZone,
      self.camera.width - 2*self.camera.horizontalHardZone - 2*self.camera.horizontalSoftZone,
      self.camera.height - 2*self.camera.verticalHardZone - 2*self.camera.verticalSoftZone
    )
  end

  love.graphics.pop()

end

return Repair