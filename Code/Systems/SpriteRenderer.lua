local Sprite = require("Code.Components.Sprite")
local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")

local SpriteRenderer = Concord.system({
    Sprite, 
    Transform,
})

function SpriteRenderer:draw()
    local layers = self.layers or {"default"}
    for _, layer in ipairs(layers) do
        for _, e in ipairs(self.pool.objects) do
            local t = e:get(Transform)
            local s = e:get(Sprite)
            local w, h = s.img:getDimensions()

            if s.layer == layer then
                if s.quad then
                    local _, __, w, h = s.quad:getViewport()
                    love.graphics.draw(s.img, s.quad, t.x, t.y, t.r, t.sx, t.sy, w/2, h/2)
                else
                    love.graphics.draw(s.img, t.x, t.y, t.r, t.sx, t.sy, w/2, h/2)
                end
            end
        end
    end
end

return SpriteRenderer