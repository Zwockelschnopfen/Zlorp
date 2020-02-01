local TMG          = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local Physics      = require "Code.Components.Physics"
local Sprite       = require "Code.Components.Sprite"
local Transform    = require "Code.Components.Transform"

local TMR            = require "Code.Systems.TileMapRenderer"
local SpriteRenderer = require "Code.Systems.SpriteRenderer"

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

  RepairInstance:addSystem(TMR(), "draw")
  RepairInstance:addSystem(SpriteRenderer(), "draw")


  local player = Concord.entity.new()
  player:give(Transform, 5 * 70, 7 * 70)
  player:give(
    Physics, 
    { x = 5, y = 7, type = "dynamic" },
    { { type = "polygon", 
        verts = { -- 70cm width, 170cm height
        0.0, 0.0,
        0.0, 1.7,
        0.7, 1.7,
        0.7, 0.0
        }
      } 
    }
  )
  player:give(Sprite, self.resources.player)
  RepairInstance:addEntity(player)
end

function Repair:leave()
  RepairInstance:clear()
end

function Repair:update(dt)

end

function Repair:draw()
  RepairInstance:emit("draw")
end

return Repair