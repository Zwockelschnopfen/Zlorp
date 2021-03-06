local Menu = {}
local Highscore = require "Code.Highscore"

local main = {
  {
    text = "Launch",
    target = "game",
  },
  {
    text = "Help",
    target = "help",
  },
  {
    text = "Credits",
    target = "credits",
  },
  {
    text = "Leave",
    target = "exit",
  }
}

function Menu:load()
  self.resources = {
    buttonFont = love.graphics.newFont("Assets/Fonts/earthorbiter.ttf", 77),
    titleFont = love.graphics.newFont("Assets/Fonts/earthorbiterhalf.ttf", 180),
    highscoreFont = love.graphics.newFont("Assets/Fonts/Gobold Light.otf", 40),
    highscoreFontBold = love.graphics.newFont("Assets/Fonts/Gobold Regular.otf", 40),
    ship = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
    acceptSound = love.audio.newSource("Assets/Sounds/select.flac", "static"),
    navigateSound = love.audio.newSource("Assets/Sounds/cursor.flac", "static"),
    credits = {},
  }
  local creditsRaw = assert(love.filesystem.read("Assets/Credits.txt"))
  for line in creditsRaw:gmatch("[^\n]+") do
    table.insert(self.resources.credits, line)
  end
end

function Menu:enter(previous, wasSwitched, ...)
  main.selected = 1
  main[1].dx = 1
  for i=2,#main do
    main[i].dx = 0
  end
  self.state = {
    current = "enter",
    fading = 1.0,      -- [0..1] Versteckt das ganze Menü
    mainHidden = 1.0,  -- [0..1] Versteckt das Hauptmenü nach links
    titleHidden = 0.0, -- [0..1] Schiebt den Title nach oben
    creditsLine = -10.5, -- [0..#] Schiebt die Credits um "x" Zeilen nach oben
    creditsSpeed = 1.0,
  }
  Music.setTrack("menu")
end

function Menu:leave()

end

function Menu:update(_, dt)
  local state = self.state

  if state.current == "enter" then
    state.fading = state.fading - 2.0 * dt
    if state.fading <= 0 then
      state.fading = 0
      state.current = "main"
    end
    return
  end

  if state.current == "main" then
    state.mainHidden = math.max(0.0, state.mainHidden - 3.0 * dt)

    if main.selected > 1 and Input:pressed "up" then
      main.selected = main.selected - 1
      love.audio.play(self.resources.navigateSound)
    end
    if main.selected < #main and Input:pressed "down" then
      main.selected = main.selected + 1 
      love.audio.play(self.resources.navigateSound)
    end
    if Input:pressed "action" then
      state.current = main[main.selected].target
      love.audio.play(self.resources.acceptSound)
    end

    if Input:pressed "back" then
      state.current = "exit"
    end

    return
  else
    state.mainHidden = math.min(1.0, state.mainHidden + 3.0 * dt)
  end

  if state.current == "game" then
    state.titleHidden = math.min(1.0, state.titleHidden + 3.0 * dt)

    if state.mainHidden >= 1.0 and state.titleHidden >= 1.0 then
      return Gamestate.switch(GS.gameplay)
    end

    return
  end
  
  if state.current == "help" then
    
    if Input:pressed "action" or Input:pressed "back" then
      state.current = "main"
      love.audio.play(self.resources.acceptSound)
    end

    return
  end
  
  if state.current == "credits" then

    local targetSpeed = 1.0
    if Input:down "down" then
      targetSpeed = -4
    elseif Input:down "up" then
      targetSpeed = 4
    end

    do
      local delta = math.abs(targetSpeed - state.creditsSpeed)
      local dir = math.sign(targetSpeed - state.creditsSpeed)

      state.creditsSpeed = state.creditsSpeed + math.min(10.0 * dt, delta) * dir
    end
    state.creditsLine = state.creditsLine + state.creditsSpeed * dt

    if state.creditsLine > #self.resources.credits or Input:pressed "action" or Input:pressed "back"  then
      if Input:pressed "action" or Input:pressed "back" then
        love.audio.play(self.resources.acceptSound)
      end
      state.current = "main"
      state.creditsLine = -10.5
    end

    return
  end
  
  if state.current == "exit" then
    Music.setTrack("none")
    state.fading = state.fading + 2.0 * dt
    if state.fading > 2.0 then
      love.event.quit()
    end
    return
  end

  error("Invalid menu target: " .. tostring(state.current))
end

function Menu:draw()
  love.graphics.push()
  love.graphics.origin()

  local t = love.timer.getTime()
  local dt = love.timer.getDelta()

  love.graphics.setFont(self.resources.titleFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    "Zlorp",
    0, 50 - 300 * math.pow(self.state.titleHidden, 2.0),
    VirtualScreen.width,
    "center"
  )

  love.graphics.setFont(self.resources.buttonFont)

  for i=1,#main do
    local btn = main[i]
    if main.selected == i and self.state.current == "main" then
      love.graphics.setColor(1, 0, 0)
      btn.dx = math.min(1, btn.dx + 5 * dt)
    else
      love.graphics.setColor(1, 1, 1)
      btn.dx = math.max(0, btn.dx - 5 * dt)
    end
    love.graphics.print(
      btn.text, 
      10 + math.smoothstep(btn.dx, 0, 1) * (40 + 5 * math.sin(3 * t + 2.2 * i)) - 350 * math.pow(self.state.mainHidden, 2.0),
      1080 + 80 * (i - #main - 1))
  end

  if self.state.current == "main" and #Highscore.list > 0 then

    local hswidth = 600
    local hspadding = 20
    local hstop = VirtualScreen.height - hspadding - 50 * #Highscore.list

    love.graphics.setFont(self.resources.highscoreFontBold)

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf(
      "Highscore:",
      VirtualScreen.width - hswidth - hspadding, 
      hstop - 50,
      hswidth,
      "left"
    )

    love.graphics.setColor(1, 1, 1)
    for i=1,#Highscore.list do
      local e = Highscore.list[i]
      
      local gray = 1 / (0.4*i)
      love.graphics.setColor(gray, gray, gray)

      love.graphics.printf(
        e.name or "noname",
        VirtualScreen.width - hswidth - hspadding, 
        hstop + (50 * (i - 1)),
        hswidth,
        "right"
      )

      love.graphics.printf(
        tostring(e.score),
        VirtualScreen.width - hswidth - hspadding, 
        hstop + (50 * (i - 1)),
        hswidth,
        "left"
      )
        
      love.graphics.setFont(self.resources.highscoreFont)

    end
  end

  do
    local x, y, w, h = 0, 264, VirtualScreen.width, 770

    local lineHeight = 70.0
    local fy = y - lineHeight * self.state.creditsLine

    -- love.graphics.rectangle("line", x, y, w, h)

    for i=1,#self.resources.credits do

      local alphaTop = math.clamp(fy - y, 0.0, lineHeight) / lineHeight
      local alphaBot = math.clamp(y - fy + h - lineHeight, 0.0, lineHeight) / lineHeight
      local alpha = math.min(alphaTop, alphaBot)

      if alpha > 0.0 then

        love.graphics.setColor(1, 1, 1, alpha)

        local line = self.resources.credits[i]

        if line == "--" then
          love.graphics.setLineWidth( 3.0 )
          love.graphics.line(
            x + w / 2 - 300,
            fy + lineHeight / 2,
            x + w / 2 + 300,
            fy + lineHeight / 2
          )
        else
          love.graphics.printf(
            line,
            x, fy,
            w,
            "center"
          )
        end
      end

      fy = fy + lineHeight

      if fy > y + h then
        break
      end

    end

  end


  if self.state.current == "enter" then
    love.graphics.setColor(1, 1, 1, math.smoothstep(self.state.fading, 0.0, 1.0))
    love.graphics.draw(GS.loader.resources.loadingScreen, 0, 0)
  else
    love.graphics.setColor(0, 0, 0, math.smoothstep(self.state.fading, 0.0, 1.0))
    love.graphics.rectangle("fill", 0, 0, VirtualScreen.width, VirtualScreen.height)
  end

  love.graphics.pop()
end

return Menu