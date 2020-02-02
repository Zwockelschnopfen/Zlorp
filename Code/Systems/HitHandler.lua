local Transform = require("Code.Components.Transform")
local Movement = require("Code.Components.Movement")
local Hittable = require("Code.Components.Hittable")
local Sprite = require("Code.Components.Sprite")
local HitEffect = require("Code.Entities.HitEffect")

local HitHandler = Concord.system({
    Transform,
    Hittable,
})



function HitHandler:update(dt)
    self.enemies = 0
    for _, e in ipairs(self.pool.objects) do
        local t = e:get(Transform)
        local h = e:get(Hittable)
        if h.enemy then
            self.enemies = self.enemies + 1
        end
        if h.hit then
            if h.health <= 0 then
                e:destroy()
                ShmupInstance:addEntity(HitEffect(0.2, h.hit[1], h.hit[2]))
            else
                ShmupInstance:addEntity(HitEffect(0.2, h.hit[1], h.hit[2]))
            end
        end
    end
end

return HitHandler