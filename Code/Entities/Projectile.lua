local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")

local function move(e, t, dt)
    e.v = math.clamp(e.v + e.accel * dt, -e.vmax, e.vmax)
    t.x = t.x + dt * e.dx * e.v
    t.y = t.y + dt * e.dy * e.v
end

return function(img, x, y, r, v0, accel, vmax, type)
    local dx = math.cos(r)
    local dy = math.sin(r)
    local ent = Concord.entity.new()
    local w, h = img:getDimensions()
    ent
        :give(Transform, x, y, r, 1, 1)
        :give(Sprite, img, nil, "projectiles")
        :give(Movement, move)
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="circle", radius=math.min(w, h) }})
        :give(Hittable, 1)
    return table.update(ent, {collisionCount=0, properties={type=type, subtype="projectile"}, dx=dx, dy=dy, v=v0, accel=accel, vmax=vmax})
end