local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Shooting = require("Code.Components.Shooting")
local Sprite = require("Code.Components.Sprite")
local Projectile = require("Code.Entities.Projectile")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")


local function move(e, t, dt)
    e.time = e.time + dt
    local f = math.smoothstep(e.time / e.inTime, 0, 1) - math.smoothstep((e.time - e.inTime - e.stayTime) / e.outTime, 0, 1)
    t.x = math.lerp(e.x0, e.x1, f)
    t.y = math.lerp(e.y0, e.y1, f)
    if e.time > e.inTime + e.stayTime + e.outTime then
        e:destroy()
    end
end

local function fire(e, t)
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(170), 0.1, 2500, 0, 2500, "bad"))
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(180), 0.1, 2500, 0, 2500, "bad"))
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(190), 0.1, 2500, 0, 2500, "bad"))
end

return function(img, x0, y0, x1, y1, inTime, stayTime, outTime, interval, projectile)
    local w, h = img:getDimensions()
    local ent = Concord.entity.new()
    local scale = 0.2
    ent
        :give(Transform, x0, y0, 0, scale, scale)
        :give(Sprite, img, nil, "ships")
        :give(Shooting, inTime, interval, inTime + stayTime, fire)
        :give(Movement, move)
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="circle", radius=math.min(w, h) * scale / 2 }})
        :give(Hittable, 3, true)
        
    return table.update(ent, {collisionCount=0, properties={type="bad", subtype="ship"}, projectile=projectile, time=0, x0=x0, y0=y0, x1=x1, y1=y1, inTime=inTime, stayTime=stayTime, outTime=outTime})
end