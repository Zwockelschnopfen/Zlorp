local TMG          = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local Physics      = require "Code.Components.Physics"
local Sprite       = require "Code.Components.Sprite"
local Transform    = require "Code.Components.Transform"
local Gravity      = require "Code.Components.Gravity"

local TMR            = require "Code.Systems.TileMapRenderer"
local SpriteRenderer = require "Code.Systems.SpriteRenderer"
local PhysicsUpdate  = require "Code.Systems.PhysicsUpdate"
local GravityUpdater = require "Code.Systems.GravityUpdater"

local Repair = { }

function Repair:load()
	-- Set world meter size (in pixels)
  love.physics.setMeter(70)

  self.resources = {
    player = love.graphics.newImage("Assets/Sprites/Player.png")
  }
end

function Repair:enter(previous, wasSwitched, ...)

  local level = STI("Assets/Levels/Test.lua", { "box2d" })
  level.layers["Walls"].visible = false
  level.layers["Ladders"].visible = false
  level.layers["Objects"].visible = false
  
  self.world = Concord.entity.new()
  self.world:give(TMG, level)
  self.world:give(PhysicsWorld)

  RepairInstance:addEntity(self.world)
  
	-- Prepare collision objects
  level:box2d_init(self.world[PhysicsWorld].world)

  local playerTall = 70 * 1.7
  local playerFat =  70 *0.7

  self.player = Concord.entity.new()
  self.player:give(Transform, 5 * 70, 7 * 70)
  self.player:give(
    Physics, 
    { 
      x = 5, 
      y = 7, 
      type = "dynamic", 
      fixedRotation = true,
      gravityScale = 0,
    },
    { { type = "polygon", 
        verts = { -- 70cm width, 170cm height
        --[[-playerFat/2, -playerTall/2,
        -playerFat/2,  playerTall/2,
         playerFat/2,  playerTall/2,
         playerFat/2, -playerTall/2]]
          6.00-playerFat/2,0.00-playerTall/2,
          43.00-playerFat/2,0.00-playerTall/2,
          49.00-playerFat/2,6.00-playerTall/2,
          49.00-playerFat/2,113.00-playerTall/2,
          43.00-playerFat/2,119.00-playerTall/2,
          6.00-playerFat/2,119.00-playerTall/2,
          0.00-playerFat/2,113.00-playerTall/2,
          0.00-playerFat/2,6.00-playerTall/2,
        }
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

function Repair:leave()
  RepairInstance:clear()
end

local HotSpots = {
  cockpit = "Cockpit",
  engines = "Engine Turbine",
  shields = "Shield Generator",
  weapons = "Weapons Systems",
  junk = "Junk Pit",
}

function Repair:update(_, dt)

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

  print("hotspot", hotspot)

  local forceX = 200
  local forceY = 200
  local forceZ = 400

  local body = self.player[Physics].body

  if not anyLadder then
    body:applyForce(0, 9.81 * 70)
  end
  if Input:pressed "action" then
    body:applyLinearImpulse(0, -forceZ)
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

  RepairInstance:emit("update", dt)
end

function Repair:draw()
  RepairInstance:emit("draw")
end

return Repair