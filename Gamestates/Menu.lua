local Menu = {}

local main = {
  {
    x = 0,
    y = 0,
    text = "Launch",
    target = "game",
  },
  { 
    x = 0,
    y = 0,
    text = "Help",
    target = "help",
  },
  {
    x = 0,
    y = 0,
    text = "Credits",
    target = "credits",
  },
  {
    x = 0,
    y = 0,
    text = "Leave",
    target = "exit",
  }
}

local state = {
}

local resources

function Menu:load()
  resources = {
    ship = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
  }
end

function Menu:enter(previous, wasSwitched, ...)

end

function Menu:leave()

end

function Menu:update(dt)

end

function Menu:draw()

  love.graphics.print("Hello, World!", 10, 10)

end

return Menu