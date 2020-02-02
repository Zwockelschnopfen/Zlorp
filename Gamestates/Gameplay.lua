local Transform = require("Code.Components.Transform")

local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local HUD = require "Gamestates.HUD"
local GameState = require "Gamestates.GameState"

local Gameplay = {
}

local Camera = {
  x = 0,
  y = 0,
  rotation = 0,
  zoom = 1.0,
}

function Gameplay:load()
  Repair:load()
  Shmup:load()
  HUD:load()
end

function Gameplay:enter()
  
  GameState:reset()
  Gameplay.cameraTween = 0.0

  Repair:initGame()
  Shmup:initGame()

  self.currentMode = GameState.mode
  if GameState.mode == "shmup" then
    Shmup:enter()
  else
    Repair:enter()
  end
  
  Music.setTrack("game")
  Music.setIntensity(1)
end

function Gameplay:leave()

  Repair:exitGame()
  Shmup:exitGame()

end

function Gameplay:update(_, dt)

  GameState.timeRemaining = GameState.timeRemaining + dt

  if love.keyboard.isDown("f1") then
    GameState:goToShmup()
  elseif love.keyboard.isDown("f2") then
    GameState:goToRepair()
  end

  if GameState.mode ~= self.currentMode then

    if GameState.mode == "shmup" then
      Repair:leave()
      Shmup:enter()
    else
      Shmup:leave()
      Repair:enter()
    end

    self.currentMode = GameState.mode
  end

  if self.currentMode == "shmup" then
    Shmup:update(dt)
  else
    Repair:update(dt)
  end

  Repair:globalUpdate(dt)
  Shmup:globalUpdate(dt)
end

function Gameplay:draw()
  local dt = love.timer.getDelta()
  local shipPos = Shmup.ship[Transform]

  do -- camera tweening between zoomed in/out
    if self.currentMode == "shmup" then
      self.cameraTween = math.min(1.0, self.cameraTween - dt)
    else
      self.cameraTween = math.max(0.0, self.cameraTween + dt)
    end

    local tween = math.smoothstep(self.cameraTween, 0.0, 1.0)
    Camera.x = math.lerp(0, shipPos.x + 90 - VirtualScreen.width / 2, tween)
    Camera.y = math.lerp(0, shipPos.y + 103 - VirtualScreen.height / 2, tween)
    Camera.zoom = math.lerp(1.0, 4.15, tween)
  end

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

    if self.cameraTween > 0 then

      love.graphics.push()
        local canvas = love.graphics.newCanvas()
        love.graphics.setCanvas(canvas)
      
        -- fit "repair screen" into space trip

        love.graphics.translate(shipPos.x, shipPos.y)
        love.graphics.translate(-140, -25)
        love.graphics.scale(0.10)
        
        Repair:draw()
        
        love.graphics.setCanvas()
        love.graphics.setColor(1, 1, 1, self.cameraTween)
        love.graphics.draw(canvas)
        
      love.graphics.pop()
    end

  love.graphics.pop()

  love.graphics.push()
  love.graphics.origin()

  HUD:draw()

  love.graphics.pop()

end

return Gameplay