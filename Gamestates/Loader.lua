local Loader = {
    callbacks = {}
}

function Loader:addCallback(cb)
    table.insert(self.callbacks, cb)
end

function Loader:load()
    self.resources = {
        loadingScreen = love.graphics
            .newImage("Assets/Images/LoadingScreen.png")
    }
end

function Loader:enter(previous, wasSwitched, ...) self.wasDrawn = false end

function Loader:leave() end

function Loader:update(dt)
    if self.wasDrawn then

        for i, state in pairs(GS) do
            if state.load then
                state:load()
            end 
        end

        for i, cb in ipairs(self.callbacks) do
            cb()
        end

        return Gamestate.switch(GS.menu)
    end
end

function Loader:draw()
    love.graphics.reset()
    love.graphics.draw(self.resources.loadingScreen, 0, 0)

    self.wasDrawn = true

end

return Loader
