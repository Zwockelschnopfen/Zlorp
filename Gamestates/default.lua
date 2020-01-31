local DefaultState = {}
local CircleRender = require("Code.Example.System.CircleRender")
local Circle = require("Code.Example.Entity.Circle")

DefaultState.Instance = nil
DefaultState.Input = Baton.new {
    controls = {
        left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:x', 'button:a'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}

function DefaultState:enter(previous, wasSwitched, ...)
    print("Entered default state!")
    
    self.Instance = Concord.instance()
    self.Instance:addSystem(CircleRender(), "draw")
    self.Instance:addEntity(Circle(200, 200, 50, "fill"))
    self.Instance:addEntity(Circle(400, 400, 50, "line"))
end

function DefaultState:leave()

end

function DefaultState:update(dt)
    self.Input:update()
    
    local x, y = self.Input:get("move")
    if self.Input:pressed("action") then
        print("Action!")
    end
end

function DefaultState:draw()
   self.Instance:emit("draw") 
end

function DefaultState:mousepressed(x, y, button, istouch, presses)

end

function DefaultState:mousereleased(x, y, button, istouch, presses)
    
end

return DefaultState