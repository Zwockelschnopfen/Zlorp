local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Sprite = require("Code.Components.Sprite")

local Mover = Concord.system({
    Movement, 
    Transform,
    Sprite,
})

function Mover:update(dt)
    for _, e in ipairs(self.pool.objects) do
        local t = e:get(Transform)
        local m = e:get(Movement)
        local w, h = e:get(Sprite).img:getDimensions()
        local r = math.max(w, h)

        m.behavior(e, t, dt)
        if t.x < -100-r or t.x > 2020 + r or t.y < -100-r or t.y > 1180 + r then
            e:destroy()
        end
    end
end

return Mover