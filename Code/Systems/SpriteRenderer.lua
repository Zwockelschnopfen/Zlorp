local Sprite = require("Code.Components.Sprite")
local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")

local SpriteRenderer = Concord.system({
    Sprite, 
    Transform,
})

function SpriteRenderer:draw()
    for _, e in ipairs(self.pool.objects) do
        local t = e:get(Transform)
        local s = e:get(Sprite)

        if s.quad then
            love.graphics.draw(s.img, s.quad, t.x, t.y, t.r, t.sx, t.sy)
        else
            love.graphics.draw(s.img, t.x, t.y, t.r, t.sx, t.sy)
        end
    end
end

return SpriteRenderer