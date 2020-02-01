local Transform = require("Code.Components.Transform")

local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local Gameplay = {}


local Camera = {
  x = 0,
  y = 0,
  rotation = 0,
  zoom = 1.0,
}

function Gameplay:load()
  Repair:load()
  Shmup:load()
end

function Gameplay:enter()
  
  Repair:initGame()
  Shmup:initGame()

  Shmup:enter()
  self.mode = "shmup"

end

function Gameplay:leave()

  Repair:exitGame()
  Shmup:exitGame()

end

function Gameplay:goToShmup()
  if self.mode == "shmup" then
    return
  end
  Repair:leave()
  Shmup:enter()
  self.mode = "shmup"
end

function Gameplay:goToRepair()
  if self.mode == "repair" then
    return
  end
  Shmup:leave()
  Repair:enter()
  self.mode = "repair"
end

function Gameplay:update(_, dt)

  if love.keyboard.isDown("f1") then
    self:goToShmup()
  elseif love.keyboard.isDown("f2") then
    self:goToRepair()
  end

  if self.mode == "shmup" then
    Shmup:update(dt)
  else
    Repair:update(dt)
  end

  Repair:globalUpdate(dt)
  Shmup:globalUpdate(dt)

end

function Gameplay:draw()
  local shipPos = Shmup.ship[Transform]
  local sx, sy, z
  
  if self.mode == "shmup" then
    sx, sy = 0, 0
    z = 1.0
  else
    sx, sy = shipPos.x-VirtualScreen.width/2, shipPos.y-VirtualScreen.height/2
    z = 3.0
  end

  Camera.x = math.lerp(Camera.x, sx, 0.1)
  Camera.y = math.lerp(Camera.y, sy, 0.1)
  Camera.zoom = math.lerp(Camera.zoom, z, 0.1)

  love.graphics.origin()

  love.graphics.push()

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.scale(Camera.zoom)
    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.rotate(Camera.rotation)
    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(-Camera.x, -Camera.y)
    
    Shmup:draw()

    love.graphics.push()

      -- fit "repair screen" into space trip

      love.graphics.translate(shipPos.x, shipPos.y)
      love.graphics.scale(0.1)

      Repair:draw()

    love.graphics.pop()

  love.graphics.pop()

  love.graphics.push()
  love.graphics.origin()

  -- DRAW HUD HERE

  love.graphics.pop()

end

return Gameplay