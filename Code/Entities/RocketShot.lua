local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Sprite = require("Code.Components.Sprite")

function move(m, t, dt)
    t.x = t.x + dt * m.dx
    t.y = t.y + dt * m.dy
end

return function(x, y, dx, dy)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, 0, 1, 1)
        :give(Sprite, assert(love.graphics.newImage("Assets/Images/ShipInMenu.png")))
        :give(Movement, move, {dx=dx, dy=dy})
    return ent
end