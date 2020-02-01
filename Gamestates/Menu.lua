local Menu = {}

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
    return
  else
    state.mainHidden = math.min(1.0, state.mainHidden + 3.0 * dt)
  end

  if state.current == "game" then
    state.titleHidden = math.min(1.0, state.titleHidden + 3.0 * dt)


    return
  end
  
  if state.current == "help" then
    
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

      state.creditsSpeed = state.creditsSpeed + math.min(5.0 * dt, delta) * dir

    end
    state.creditsLine = state.creditsLine + state.creditsSpeed * dt

    if state.creditsLine > #self.resources.credits or Input:pressed "action" then
      state.current = "main"
      state.creditsLine = -10.5
    end

    return
  end
  
  if state.current == "exit" then
    state.fading = state.fading + 2.0 * dt
    if state.fading > 2.0 then
      love.event.quit()
    end
    return
  end

  error("Invalid menu target: " .. tostring(state.current))
end

function Menu:draw()
  local t = love.timer.getTime()
  local dt = love.timer.getDelta()

  love.graphics.setFont(self.resources.titleFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    "Zlorp",
    0, 50 - 300 * math.pow(self.state.titleHidden, 2.0),
    1920,
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

  do
    local x, y, w, h = 0, 264, 1920, 770

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
    love.graphics.rectangle("fill", 0, 0, 1920, 1080)
  end

end

return Menu