local Transform = require("Code.Components.Transform")
local Physics = require("Code.Components.Physics")
local Gravity = require("Code.Components.Gravity")

local GravityUpdater = Concord.system({Physics, Transform, Gravity})

function GravityUpdater:init()

end

function GravityUpdater:update(dt)
    local trans, grav
    for _, e in ipairs(self.pool.objects) do
        trans = e:get(Transform)
        grav = e:get(Gravity)
        
        trans.x = trans.x + grav.gx * dt
        trans.y = trans.y + grav.gy * dt
    end
end

return PhysicsUpdate
