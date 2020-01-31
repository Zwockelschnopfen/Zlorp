local DefaultState = {}
local CircleRender = require("Code.Example.System.CircleRender")
local Circle = require("Code.Example.Entity.Circle")

DefaultState.Instance = nil

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