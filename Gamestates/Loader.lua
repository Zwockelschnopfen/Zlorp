local Loader = {}

local resources
local wasDrawn

function Loader:load()
  resources = {
    loadingScreen = love.graphics.newImage("Assets/Images/LoadingScreen.png"),
  }
end

function Loader:enter(previous, wasSwitched, ...)
  wasDrawn = false
end

function Loader:leave()

end

function Loader:update(dt)
  if wasDrawn then

    for i,state in pairs(GS) do
      if state.load then 
        state:load()
      end
    end

    return Gamestate.switch(GS.menu)
  end 
end

function Loader:draw()
  love.graphics.reset()
  love.graphics.draw(
    resources.loadingScreen,
    0, 0
  )

  wasDrawn = true

end

return Loader