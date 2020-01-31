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

local resources
local state

function Menu:load()
  resources = {
    buttonFont = love.graphics.newFont("Assets/Fonts/earthorbiter.ttf", 77),
    titleFont = love.graphics.newFont("Assets/Fonts/earthorbiterhalf.ttf", 180),
    ship = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
    acceptSound = love.audio.newSource("Assets/Sounds/select.flac", "static"),
    navigateSound = love.audio.newSource("Assets/Sounds/cursor.flac", "static"),
  }
end

function Menu:enter(previous, wasSwitched, ...)
  main.selected = 1
  main[1].dx = 1
  for i=2,#main do
    main[i].dx = 0
  end
  state = {
    current = "main",
    fading = 0.0
  }
end

function Menu:leave()

end

function Menu:update(_, dt)

  if state.current == "main" then
    if main.selected > 1 and Input:pressed "up" then
      main.selected = main.selected - 1
      love.audio.play(resources.navigateSound)
    end
    if main.selected < #main and Input:pressed "down" then
      main.selected = main.selected + 1 
      love.audio.play(resources.navigateSound)
    end
    if Input:pressed "action" then
      state.current = main[main.selected].target
      love.audio.play(resources.acceptSound)
    end
  elseif state.current == "game" then
    
  elseif state.current == "help" then
    
  elseif state.current == "credits" then
    
  elseif state.current == "exit" then
    state.fading = state.fading + 2.0 * dt
    if state.fading > 2.0 then
      love.event.quit()
    end
  else
    error("Invalid menu target: " .. tostring(state.current))
  end

end

function Menu:draw()
  local t = love.timer.getTime()
  local dt = love.timer.getDelta()

  love.graphics.setFont(resources.titleFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    "Zlorp",
    0, 50,
    1920,
    "center"
  )

  love.graphics.setFont(resources.buttonFont)

  for i=1,#main do
    local btn = main[i]
    if main.selected == i then
      love.graphics.setColor(1, 0, 0)
      btn.dx = math.min(1, btn.dx + 5 * dt)
    else
      love.graphics.setColor(1, 1, 1)
      btn.dx = math.max(0, btn.dx - 5 * dt)
    end
    love.graphics.print(
      btn.text, 
      10 + math.smoothstep(btn.dx, 0, 1) * (40 + 5 * math.sin(3 * t + 2.2 * i)),
      1080 + 80 * (i - #main - 1))
  end

  love.graphics.setColor(0, 0, 0, math.smoothstep(state.fading, 0.0, 1.0))
  love.graphics.rectangle("fill", 0, 0, 1920, 1080)

end

return Menu