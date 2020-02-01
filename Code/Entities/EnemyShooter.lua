local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Shooting = require("Code.Components.Shooting")
local Sprite = require("Code.Components.Sprite")
local Projectile = require("Code.Entities.Projectile")
local Physics = require("Code.Components.Physics")

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
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(170), 2500, 0, 2500))
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(180), 2500, 0, 2500))
    ShmupInstance:addEntity(Projectile(e.projectile, t.x, t.y, math.rad(190), 2500, 0, 2500))
end

return function(img, x0, y0, x1, y1, inTime, stayTime, outTime, interval, projectile)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x0, y0, 0, 1, 1)
        :give(Sprite, img)
        :give(Shooting, inTime, interval, inTime + stayTime, fire)
        :give(Movement, move)
    return table.update(ent, {projectile=projectile, time=0, x0=x0, y0=y0, x1=x1, y1=y1, inTime=inTime, stayTime=stayTime, outTime=outTime})
end