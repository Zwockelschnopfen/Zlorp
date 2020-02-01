local TMG = require "Code.Components.TileMapGraphics"
local TMR = require "Code.Systems.TileMapRenderer"

local Repair = {
  
}

function Repair:load()
	-- Set world meter size (in pixels)
  love.physics.setMeter(32)
  
  self.level = STI("Assets/Levels/Prototype.lua", { "box2d" })

	-- Prepare physics world with horizontal and vertical gravity
	local world = love.physics.newWorld(0, 0)

	-- Prepare collision objects
  self.level:box2d_init(world)
  
end

function Repair:enter(previous, wasSwitched, ...)
  local repairShip = Concord.entity.new()
  repairShip:give(TMG, self.level)

  RepairInstance:addEntity(repairShip)

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