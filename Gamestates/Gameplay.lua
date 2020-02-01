
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

end

function Gameplay:leave()

  Repair:exitGame()
  Shmup:exitGame()

end

function Gameplay:update(_, dt)

  if love.keyboard.isDown("f1") then
    self.mode = "shmup"
  elseif love.keyboard.isDown("f2") then
    self.mode = "repair"
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