local Transform = require("Code.Components.Transform")

local SoundFX = require "Code.SoundFX"
local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local Highscore = require "Code.Highscore"
local Balancing = require "Code.Balancing"

local HUD = require "Gamestates.HUD"
local GameState = require "Gamestates.GameState"
local canvas

local Gameplay = {
}

local Camera = {
  x = 0,
  y = 0,
  rotation = 0,
  zoom = 1.0,
}



function Gameplay:load()
  canvas = love.graphics.newCanvas()
  Repair:load()
  Shmup:load()
  HUD:load()

  self.sounds = {
    zoomIn = love.audio.newSource("Assets/Sounds/zoom_in.flac", "static"),
    zoomOut = love.audio.newSource("Assets/Sounds/zoom_out.flac", "static"),
    ai = SoundFX("Assets/Sounds/AI/ai", 6),
  }

  Repair:initSystems()
  Shmup:initSystems()
end

function Gameplay:enter()

  self.cameraShake = nil
  
  Highscore:reset()

  HUD:reset()

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

  -- Wenn die ruhige Phase vorbei ist,
  -- neue Angriffsphase starten
  Music.onStageChange = function(stage)
    if stage == 1 then
      Shmup:initWaves()
    elseif stage == 2 then
      if GameState.health.overall <= 0 then
        Music.endEverything()
        Gamestate.switch(GS.gameover)
      else
        Highscore:add(Balancing.scores.surviveWave)
        GameState:goToRepair()
        GameState.timeRemaining = 60
      end
    elseif stage == 5 then
      self.sounds.ai:play()
    end
  end

  Shmup.battleDoneCallback = function()
    Music.endBattleStage()
  end

  -- TODO: Nach dem Intro erste angriffswelle starten
  Shmup:initWaves()
end

function Gameplay:leave()

  Repair:exitGame()
  Shmup:exitGame()

  Music.onStageChange = nil
  Music.onCalmPhaseDoneCallback = nil

end


function Gameplay:keypressed(_, key, scancode, isRepeat )
  if key == "f5" then
    self:shakeCamera(1.0)
  elseif key == "f6" then
    for k,v in pairs(Repair.highlights) do
      Repair.highlights[k] = math.random(2) > 1
    end
  elseif key == "f8" then
    GameState.health:change("overall", math.random(0, 40))
    GameState.health:change("shields", math.random(0, 40))
    GameState.health:change("weapons", math.random(0, 40))
    GameState.health:change("engines", math.random(0, 40))
  elseif key == "f7" then
    GameState.health:change("overall", -math.random(0, 40))
    GameState.health:change("shields", -math.random(0, 40))
    GameState.health:change("weapons", -math.random(0, 40))
    GameState.health:change("engines", -math.random(0, 40))
  end
end

function Gameplay:update(_, dt)

  if Input:pressed "back" then
    Gamestate.switch(GS.menu)
    return
  end 

  if love.keyboard.isDown("f1") then
    GameState:goToShmup()
  elseif love.keyboard.isDown("f2") then
    GameState:goToRepair()
  end


  GameState.timeRemaining = GameState.timeRemaining - dt

  if GameState.mode ~= self.currentMode then

    if GameState.mode == "shmup" then
      Repair:leave()
      Shmup:enter()
      love.audio.play(self.sounds.zoomOut)
    else
      Shmup:leave()
      Repair:enter()
      love.audio.play(self.sounds.zoomIn)
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

  DebugVars.highscore = Highscore.currentScore or "failure"
end

-- Shakes the camera.
-- strength = 1.0 is a "medium strength impact"
function Gameplay:shakeCamera(strength)
  self.cameraShake = self.cameraShake or {
    strength = 0,
    time = 0,
  }
  self.cameraShake.strength = self.cameraShake.strength + strength
  if self.cameraShake.strength > 3.0 then
    self.cameraShake.strength = 3.0
  end
end


function Gameplay:draw()
  local dt = love.timer.getDelta()
  local shipPos = Shmup.ship[Transform]

  do -- camera tweening between zoomed in/out
    if self.currentMode == "shmup" then
      self.cameraTween = math.max(0.0, self.cameraTween - dt)
    else
      self.cameraTween = math.min(1.0, self.cameraTween + dt)
    end

    local repairWidth = 150 -- Width of the full "object"

    local repairX, repairY = shipPos.x + 28, shipPos.y + 29
    repairX = repairX + repairWidth * (Repair.camera.x / (Repair.camera.bounds.right - Repair.camera.bounds.left) - 0.5)
    repairY = repairY + repairWidth * (Repair.camera.y / (Repair.camera.bounds.bottom - Repair.camera.bounds.top) - 0.5) / VirtualScreen.aspect

    local targetZoom = 20.0 -- 12.5

    local tween = math.smoothstep(self.cameraTween)
    Camera.x = math.lerp(0, repairX - VirtualScreen.width / 2, tween)
    Camera.y = math.lerp(0, repairY - VirtualScreen.height / 2, tween)
    Camera.zoom = math.lerp(1.0, targetZoom, math.smoothstep(math.pow(self.cameraTween, 4)))
  end

  love.graphics.origin()

  if self.cameraShake then

    local str = math.abspow(self.cameraShake.strength / 3.0, 1.4)

    love.graphics.translate(math.floor(
      15 * str * math.abspow(math.sin(1.3 * self.cameraShake.time), 1.6)
    ),math.floor(
      10 * str * math.abspow(math.sin(1.4 * self.cameraShake.time), 1.4)
    ))

  end

  love.graphics.push()

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.scale(Camera.zoom)
    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.rotate(Camera.rotation)

    if self.cameraShake then

      local str = math.smoothstep(math.pow(math.max(0, self.cameraShake.strength - 0.5), 1.6), 0.0, 2.0)

      love.graphics.rotate(0.025 * math.smoothstep(self.cameraTween) * str * math.abspow(math.sin(self.cameraShake.time), 2.4))

    end

    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(-Camera.x, -Camera.y)
    
    Shmup:draw()

    if self.cameraTween > 0 then

      love.graphics.push()
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        -- fit "repair screen" into space trip

        love.graphics.translate(shipPos.x, shipPos.y)
        love.graphics.translate(-46, -12)
        love.graphics.scale(0.032)
        
        Repair:draw()
        
        love.graphics.push()
        love.graphics.origin()

        love.graphics.setCanvas()
        love.graphics.setColor(1, 1, 1, math.smoothstep(self.cameraTween))
        love.graphics.draw(canvas)
        love.graphics.pop()
        

      love.graphics.pop()
    end

  love.graphics.pop()

  love.graphics.push()
  love.graphics.origin()

  HUD:draw()

  love.graphics.pop()

  if self.cameraShake then

    local vel = 1.6 * math.pow(0.45 * self.cameraShake.strength, 0.6)

    self.cameraShake.time = self.cameraShake.time + 30.0 * vel * dt
    self.cameraShake.strength = self.cameraShake.strength * 0.98
    self.cameraShake.strength = math.lerpTowards(self.cameraShake.strength, 0, 0.85 * dt)
  
  end

end

return Gameplay
