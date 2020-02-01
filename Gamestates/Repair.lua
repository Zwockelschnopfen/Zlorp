local TMG = require "Code.Components.TileMapGraphics"
local PhysicsWorld = require "Code.Components.PhysicsWorld"
local TMR = require "Code.Systems.TileMapRenderer"

local Repair = {
  
}

function Repair:load()
	-- Set world meter size (in pixels)
  love.physics.setMeter(70)
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