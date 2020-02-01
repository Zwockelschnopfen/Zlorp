local Transform = require("Code.Components.Transform")
local Shooting = require("Code.Components.Shooting")

local ShotTrigger = Concord.system({
    Shooting, 
    Transform,
})

function ShotTrigger:update(dt)
    for _, e in ipairs(self.pool.objects) do
        local t = e:get(Transform)
        local s = e:get(Shooting)

        local oldTime = s.time - s.first
        s.time = s.time + dt
        local newTime = s.time - s.first
        local nextBoundary = math.ceil(oldTime / s.interval) * s.interval

        if s.time >= s.first and s.time < s.last and oldTime < nextBoundary and newTime >= nextBoundary then
            s.fire(e, t)
        end
    end
end

return ShotTrigger