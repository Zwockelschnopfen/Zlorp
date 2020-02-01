
local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local Gameplay = { }

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
  self.mode = "repair"
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
  
  Shmup:draw()


  Repair:draw()

  love.graphics.push()
  love.graphics.origin()

  -- DRAW HUD HERE

  love.graphics.pop()

end

return Gameplay