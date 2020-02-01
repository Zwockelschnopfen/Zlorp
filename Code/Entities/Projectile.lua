local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Sprite = require("Code.Components.Sprite")

local function move(e, t, dt)
    e.v = math.clamp(e.v + e.accel * dt, -e.vmax, e.vmax)
    t.x = t.x + dt * e.dx * e.v
    t.y = t.y + dt * e.dy * e.v
end

return function(img, x, y, r, v0, accel, vmax)
    local dx = math.cos(r)
    local dy = math.sin(r)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, r, 1, 1)
        :give(Sprite, img)
        :give(Movement, move)
    return update(ent, {dx=dx, dy=dy, v=v0, accel=accel, vmax=vmax})
end