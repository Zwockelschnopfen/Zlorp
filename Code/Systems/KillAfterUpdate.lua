local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Hittable = require("Code.Components.Hittable")
local KillAfter = require("Code.Components.KillAfter")
local HitEffect = require("Code.Entities.HitEffect")

local HitHandler = Concord.system({
    KillAfter
})



function HitHandler:update(dt)
    for _, e in ipairs(self.pool.objects) do
        local ka = e:get(KillAfter)
        ka.t = ka.t + dt
        if ka.t > ka.duration then
           e:destroy() 
        end
    end
end

return HitHandler