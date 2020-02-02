local GameState = require "Gamestates.GameState"

local HUDState = {
  visible = false
}

function HUDState:load()
  self.resources = {
    panelLeft = love.graphics.newImage("Assets/Images/HudLeft.png"),
    panelRight = love.graphics.newImage("Assets/Images/HudRight.png"),
    timerFont = love.graphics.newFont("Assets/Fonts/Digital Dismay.otf", 60),
  }
  self.timerVisible = 0
end

local function Bar(x, y, w, h, val, r,g,b, bg)

  bg = bg or 0


  x = x + 40

  love.graphics.setColor(
    math.lerp(0.00, 0.7, bg),
    math.lerp(0.07, 0.0, bg),
    math.lerp(0.15, 0.0, bg)
  )
  love.graphics.rectangle("fill", x, y, w, h)

  love.graphics.setColor(r, g, b)
  love.graphics.rectangle(
    "fill",
    x+1,y+1,
    math.floor((w-2) * val),
    h-2
  )
  
  -- love.graphics.setColor(0.9, 0.9, 0.9)
  -- love.graphics.rectangle("line", x, y, w, h)

end

function HUDState:draw()
  
  local t = love.timer.getTime()
  local dt = love.timer.getDelta()

  local function warnBlinker(val)
    if val < 25 then
      return math.smoothstep( 0.5 + 0.5 * math.sin((5.0 + 0.1 * (25 - val)) * t), 0, 1)
    else
      return 0
    end
  end

  Bar(10,  10, 250, 30, GameState.health.overall / 100.0, 1, 1, 1, warnBlinker(GameState.health.overall))

  love.graphics.setColor(1,1,1)
  love.graphics.line(10, 50, 300, 50)

  Bar(10,  60, 250, 30, GameState.health.engines / 100.0, 1, 1, 1, warnBlinker(GameState.health.engines))
  Bar(10, 100, 250, 30, GameState.health.shields / 100.0, 1, 1, 1, warnBlinker(GameState.health.shields))
  Bar(10, 140, 250, 30, GameState.health.weapons / 100.0, 1, 1, 1, warnBlinker(GameState.health.weapons))

  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.resources.panelLeft, 0, 0)

  if GameState.mode == "repair" then 
    self.timerVisible = math.min(1, self.timerVisible + dt)
  else
    self.timerVisible = math.max(0, self.timerVisible - dt)
  end

  if self.timerVisible > 0.0 then
    local tt = 2.0 * math.smoothstep(self.timerVisible)
    local y = 0.5 * ( tt - (tt-1.0) * (tt-1.0) + 1.0 )

    local timerPos = VirtualScreen.width - 280
    local timerY = math.floor(180 * y - 200)

    DebugVars.y = y
    DebugVars.timerY = timerY

    love.graphics.draw(
      self.resources.panelRight,
      timerPos,
      timerY)

      love.graphics.setColor(0.7,0.74,0.94)

    local totalSeconds = math.floor(GameState.timeRemaining)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = math.floor(totalSeconds % 60)
    if totalSeconds < 0 then
      minutes = 0
      seconds = 0
      if (love.timer.getTime() % 1.0) > 0.5 then
        love.graphics.setColor(0.8, 0.0, 0.0)
      end
    end
  

    love.graphics.setFont(self.resources.timerFont)
    love.graphics.printf(
      string.format("%02d:%02d", minutes, seconds),
      timerPos + 13,
      timerY + 123,
      180,
      "center")
  end

  DebugVars.currentTrack = Music.currentTrack
  DebugVars.currentStage = Music.currentStage
  DebugVars.wantedStage = Music.wantedStage
  DebugVars.timerVisible = self.timerVisible

  love.graphics.setColor(1,0,1)
  love.graphics.setFont(defaultFont)
  local f = love.graphics.getFont()
  local y = 1
  for i,v in pairs(DebugVars) do
    love.graphics.print(tostring(i) .. ": " .. tostring(v), 10, VirtualScreen.height - y * f:getHeight())
    y = y +1
  end
    

end

return HUDState