local DefaultState = {}

DefaultState.Instance = nil
DefaultState.Input = nil

function DefaultState:enter(previous, wasSwitched, ...)
    print("Entered default state!")
end

function DefaultState:leave()

end

function DefaultState:update(dt)

end

function DefaultState:draw()

end

function DefaultState:mousepressed(x, y, button, istouch, presses)

end

function DefaultState:mousereleased(x, y, button, istouch, presses)

end

return DefaultState