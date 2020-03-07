local GameState = require "Gamestates.GameState"

local function createBar()
  local t = {
    delayUntil = 0,
  }
  
  function t:draw(x, y, w, h, val, r,g,b, bg)
    
    local t = love.timer.getTime()
    local dt = love.timer.getDelta()
    
    if not self.displayedValue then
      self.displayedValue = val
    end

    bg = bg or 0
    x = x + 40

    love.graphics.setColor(
      math.lerp(0.00, 0.7, bg),
      math.lerp(0.07, 0.0, bg),
      math.lerp(0.15, 0.0, bg)
    )
    love.graphics.rectangle("fill", x, y, w, h)

    local w_actual  = math.floor((w-2) * val)
    local w_display = math.floor((w-2) * self.displayedValue)

    if w_display > w_actual then
      
      love.graphics.setColor(r, g, b)
      love.graphics.rectangle(
        "fill",
        x+1,y+1,
        w_actual,
        h-2
      )
      
      love.graphics.setColor(0.9, 0.1, 0.2)
      love.graphics.rectangle(
        "fill",
        x+1+w_actual,y+1,
        w_display - w_actual,
        h-2
      )
    
    else
      
      love.graphics.setColor(r, g, b)
      love.graphics.rectangle(
        "fill",
        x+1,y+1,
        w_display,
        h-2
      )

      love.graphics.setColor(0.3, 0.9, 0.2)
      love.graphics.rectangle(
        "fill",
        x+1+w_display,y+1,
        w_actual - w_display,
        h-2
      )

    end


    if self.lastValue ~= val then
      self.delayUntil = t + 0.5 -- Delay until start of transition animation
      self.lastValue = val
    elseif t > self.delayUntil then
      self.displayedValue = math.lerpTowards(self.displayedValue, val, 1.0 * dt)
    end
  end

  return t
end

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

function HUDState:reset()
  self.bars = {
    overall = createBar(),
    shields = createBar(),
    weapons = createBar(),
    engines = createBar()
  }
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

  self.bars.overall:draw(10,  10, 250, 30, GameState.health.overall / 100.0, 1, 1, 1, warnBlinker(GameState.health.overall), dt)

  love.graphics.setColor(1,1,1)
  love.graphics.line(10, 50, 300, 50)

  self.bars.shields:draw(10,  60, 250, 30, GameState.health.shields / 100.0, 1, 1, 1, warnBlinker(GameState.health.shields), dt)
  self.bars.weapons:draw(10, 100, 250, 30, GameState.health.weapons / 100.0, 1, 1, 1, warnBlinker(GameState.health.weapons), dt)
  self.bars.engines:draw(10, 140, 250, 30, GameState.health.engines / 100.0, 1, 1, 1, warnBlinker(GameState.health.engines), dt)

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
    local timerY = math.floor(170 * y - 200)

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

  love.graphics.setColor(1,0,1)
  love.graphics.setFont(defaultFont)
  local f = love.graphics.getFont()
  local y = 1
  for i,v in pairs(DebugVars) do
    
    -- love.graphics.print(tostring(i) .. ": " .. tostring(v), 10, VirtualScreen.height - y * f:getHeight())
    
    y = y +1
  end
    

end

return HUDState