local GameState = require "Gamestates.GameState"

local HUDState = {
  visible = false
}

function HUDState:load()
  self.resources = {
    icons = {
      health = love.graphics.newImage("Assets/Images/IconHealth.png"),
      engines = love.graphics.newImage("Assets/Images/IconEngines.png"),
      weapons = love.graphics.newImage("Assets/Images/IconWeapons.png"),
      shields = love.graphics.newImage("Assets/Images/IconShields.png"),
    },
    timerFont = love.graphics.newFont("Assets/Fonts/Digital Dismay.otf", 80),
  }
end

local function Bar(x, y, w, h, val, r,g,b, bg, icon)

  bg = bg or 0

  love.graphics.setColor(1,1,1)
  love.graphics.draw(icon, x, y)

  x = x + 40

  love.graphics.setColor(
    math.lerp(0.3, 0.7, bg),
    math.lerp(0.3, 0.0, bg),
    math.lerp(0.3, 0.0, bg)
  )
  love.graphics.rectangle("fill", x, y, w, h)

  love.graphics.setColor(r, g, b)
  love.graphics.rectangle(
    "fill",
    x+1,y+1,
    math.floor((w-2) * val),
    h-2
  )
  
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.rectangle("line", x, y, w, h)

end

function HUDState:draw()
  
  local t = love.timer.getTime()

  local function warnBlinker(val)
    if val < 25 then
      return math.smoothstep( 0.5 + 0.5 * math.sin((5.0 + 0.1 * (25 - val)) * t), 0, 1)
    else
      return 0
    end
  end

  love.graphics.setColor(0.2,0.2,0.2)
  love.graphics.rectangle("fill", 0, 0, 310, 180)

  Bar(10,  10, 250, 30, GameState.health.overall / 100.0, 1, 1, 1, warnBlinker(GameState.health.overall), self.resources.icons.health)

  love.graphics.setColor(1,1,1)
  love.graphics.line(10, 50, 300, 50)

  Bar(10,  60, 250, 30, GameState.health.engines / 100.0, 1, 1, 1, warnBlinker(GameState.health.engines), self.resources.icons.engines)
  Bar(10, 100, 250, 30, GameState.health.shields / 100.0, 1, 1, 1, warnBlinker(GameState.health.shields), self.resources.icons.shields)
  Bar(10, 140, 250, 30, GameState.health.weapons / 100.0, 1, 1, 1, warnBlinker(GameState.health.weapons), self.resources.icons.weapons)

  if GameState.mode == "repair" then 
    local timerPos = VirtualScreen.width - 200

    love.graphics.setColor(0.325,0.722,0.481)
    love.graphics.rectangle("fill", timerPos, 0, 200, 100)

    love.graphics.setColor(0.05,0.05,0.05)

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
      timerPos,
      10,
      200,
      "center")
  end
end

return HUDState