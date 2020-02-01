local TMG          = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local Physics      = require "Code.Components.Physics"
local Sprite       = require "Code.Components.Sprite"
local Transform    = require "Code.Components.Transform"

local TMR            = require "Code.Systems.TileMapRenderer"
local SpriteRenderer = require "Code.Systems.SpriteRenderer"
local PhysicsUpdate  = require "Code.Systems.PhysicsUpdate"

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
  
  local repairShip = Concord.entity.new()
  repairShip:give(TMG, level)
  repairShip:give(PhysicsWorld)

  RepairInstance:addEntity(repairShip)
  
	-- Prepare collision objects
  level:box2d_init(repairShip[PhysicsWorld].world)

  local playerTall = 70 * 1.7
  local playerFat =  70 *0.7

  self.player = Concord.entity.new()
  self.player:give(Transform, 5 * 70, 7 * 70)
  self.player:give(
    Physics, 
    { x = 5, y = 7, type = "dynamic", fixedRotation=true },
    { { type = "polygon", 
        verts = { -- 70cm width, 170cm height
        -playerFat/2, -playerTall/2,
        -playerFat/2,  playerTall/2,
         playerFat/2,  playerTall/2,
         playerFat/2, -playerTall/2
        }
      }
    }
  )
  self.player:give(Sprite, self.resources.player)
  RepairInstance:addEntity(self.player)


  
  
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

function Repair:update(_, dt)

  local force = 75
  if Input:pressed "up" then
    self.player[Physics].body:applyLinearImpulse(0, -force)
  end
  if Input:pressed "down" then
    self.player[Physics].body:applyLinearImpulse(0, force)
  end
  if Input:pressed "left" then
    self.player[Physics].body:applyLinearImpulse(-force, 0)
  end
  if Input:pressed "right" then
    self.player[Physics].body:applyLinearImpulse(force, 0)
  end

  RepairInstance:emit("update", dt)
end

function Repair:draw()
  RepairInstance:emit("draw")
end

return Repair