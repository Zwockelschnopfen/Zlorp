local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")

local function move(e, t, dt)
    e.r = e.r + math.rad(math.random(-e.random, e.random)*dt)
    t.r = e.r
    local dx = math.cos(e.r)
    local dy = math.sin(e.r)
    e.v = math.clamp(e.v + e.accel * dt, -e.vmax, e.vmax)
    t.x = t.x + dt * dx * e.v
    t.y = t.y + dt * dy * e.v
end

return function(img, x, y, r, s, v0, accel, vmax, random, type)
    local ent = Concord.entity.new()
    local w, h = img:getDimensions()
    ent
        :give(Transform, x, y, r, s, s)
        :give(Sprite, img, nil, "projectiles")
        :give(Movement, move)
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="circle", radius=math.min(w, h)*s/2 }})
        :give(Hittable, 1)
    return table.update(ent, {collisionCount=0, properties={type=type, subtype="projectile"}, r=r, v=v0, accel=accel, vmax=vmax, random=random})
end