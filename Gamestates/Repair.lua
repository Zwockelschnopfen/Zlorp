local TMG          = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local Physics      = require "Code.Components.Physics"
local Sprite       = require "Code.Components.Sprite"
local Transform    = require "Code.Components.Transform"
local Gravity      = require "Code.Components.Gravity"

local TMR            = require "Code.Systems.TileMapRenderer"
local SpriteRenderer = require "Code.Systems.SpriteRenderer"
local PhysicsUpdate  = require "Code.Systems.PhysicsUpdate"

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
  love.physics.setMeter(70)

  self.resources = {
    player = love.graphics.newImage("Assets/Sprites/Player.png"),
    trashgraphics = {
       love.graphics.newImage("Assets/Sprites/Trash01.png"),
       love.graphics.newImage("Assets/Sprites/Trash02.png"),
       love.graphics.newImage("Assets/Sprites/Trash03.png"),
    },
  }
end

function Repair:initGame()

  local level = STI("Assets/Levels/Test.lua", { "box2d" })
  level.layers["Walls"].visible = false
  level.layers["Ladders"].visible = false
  level.layers["Objects"].visible = false
  
  self.world = Concord.entity.new()
  self.world:give(TMG, level)
  self.world:give(PhysicsWorld, 9.81 * 70, 
    function(f0, f1, c)
      -- beginContact
      local u0, u1 = f0:getUserData(), f1:getUserData()
      if u0 then
          u0.collisionCount = (u0.collisionCount or 0) + 1
      end
      if u1 then
          u1.collisionCount = (u1.collisionCount or 0) + 1
      end
      -- print("begin", f0, f1, c)
    end,
    function(f0, f1, c)
      -- endContact
      local u0, u1 = f0:getUserData(), f1:getUserData()
      if u0 then
          u0.collisionCount = u0.collisionCount - 1
      end
      if u1 then
          u1.collisionCount = u1.collisionCount - 1
      end
      -- print("end", f0, f1, c)
    end
  )

  RepairInstance:addEntity(self.world)
  
	-- Prepare collision objects
  level:box2d_init(self.world[PhysicsWorld].world)

  local playerTall = 70 * 1.7
  local playerFat =  70 * 0.7

  self.player = Concord.entity.new()
  self.player:give(Transform, 5 * 70, 7 * 70)
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
            6.00,0.00,
            43.00,0.00,
            49.00,6.00,
            49.00,113.00,
            43.00,119.00,
            6.00,119.00,
            0.00,113.00,
            0.00,6.00,
        }, playerFat/2, playerTall/2)
      }
    }
  )
  self.player:give(Sprite, self.resources.player)
  self.player:give(Gravity)
  RepairInstance:addEntity(self.player)

  -- RepairInstance:addSystem(GravityUpdater())
  RepairInstance:addSystem(TMR(), "draw")
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

function Repair:update(dt)

  local anyLadder = false
  local hotspot
  local world = self.world[PhysicsWorld].world
  for _, body in pairs(world:getBodies()) do
    for _, fixture in pairs(body:getFixtures()) do
        if fixture:isSensor() then
            local ud = fixture:getUserData()
            if ud and (ud.collisionCount or 0) > 0 then
                anyLadder = anyLadder or (ud.properties.type == "ladder")

                if HotSpots[ud.properties.type] then
                  hotspot = ud.properties.type
                end
            end
        end
    end
  end

  local forceX = 200
  local forceY = 200
  local forceZ = 400

  local body = self.player[Physics].body

  if not anyLadder then
    body:applyForce(0, 9.81 * 70)
  end

  if self.currentTrash then
    -- wir halten MÜLL!
    local playerPos = self.player[Transform]
    local trashPos = self.currentTrash[Transform]
    
    local body = self.currentTrash[Physics].body

    local tx = playerPos.x + 40
    local ty = playerPos.y - 10

    body:applyForce(
      138.12 * (tx - trashPos.x),
      138.12 * (ty - trashPos.y)
    )


  else
    if Input:pressed "action" then

      if hotspot then
        if hotspot == "cockpit" then
          local Gameplay = require "Gamestates.Gameplay"
          Gameplay:goToShmup()
        elseif hotspot == "junk" then
          local playerPos = self.player[Transform]
          
          local idx = math.random(#self.resources.trashgraphics)

          local sprite = self.resources.trashgraphics[idx]
          local tx, ty = sprite:getDimensions()

          local trash = Concord.entity.new()
          trash:give(Transform, playerPos.x + 40, playerPos.y + 40)
          trash:give(Sprite, sprite)
          trash:give(
            Physics, 
            {
              type = "dynamic",
            },
            { { type = "polygon", 
                verts = adjustCollider({
                  1.74,7.61,
                  7.30,2.13,
                  20.09,2.78,
                  20.43,12.13,
                  17.74,20.96,
                  4.22,21.04,
                  3.17,12.87,
                  1.22,11.17,
                }, tx/2, ty/2)
              }
            }
          )
          RepairInstance:addEntity(trash)

          self.currentTrash = trash
        end
      else
        body:applyLinearImpulse(0, -forceZ)
      end
    end
  end

  local vx, vy = body:getLinearVelocity()

  if anyLadder then
    if Input:down "up" then
      if vy > -forceY then
        vy = -forceY
      end
    elseif Input:down "down" then
      if vy <= forceY then
        vy = forceY
      end
    else
      vy = vy * 0.9
    end
  end

  if Input:down "left" then
    body:setLinearVelocity(-forceX, vy)
  elseif Input:down "right" then
    body:setLinearVelocity(forceX, vy)
  else
    vx = vx * 0.9
    body:setLinearVelocity(vx, vy)
  end

end

function Repair:draw()
  RepairInstance:emit("draw")
end

return Repair