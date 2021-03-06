local Sprite = require("Code.Components.Sprite")
local Transform = require("Code.Components.Transform")
local Color = require("Code.Components.Color")
local Particles = require("Code.Components.Particles")
local KillAfter = require("Code.Components.KillAfter")

local SpriteRenderer = Concord.system({
    Sprite, 
    Transform,
}, {"particles", Particles})

function SpriteRenderer:draw()
    local layers = self.layers or {"default"}
    for _, layer in ipairs(layers) do
        for _, e in ipairs(self.particles.objects) do
            local p = e:get(Particles)
            local t = e:get(Transform)
            p:draw(layer, t.x, t.y)
        end
        
        for _, e in ipairs(self.pool.objects) do
            local t = e:get(Transform)
            local s = e:get(Sprite)
            local ka = e:get(KillAfter)
            local w, h = s.img:getDimensions()
            local x, y, r, sx, sy = t:getAbsoluteTransform()
            if e:get(Color) then
                love.graphics.setColor(e:get(Color).rgba)
            end
            
            if s.layer == layer then
                if s.quad then
                    local _, __, w, h = s.quad:getViewport()
                    
                    love.graphics.draw(s.img, s.quad, x, y, r, sx, sy, w/2, h/2)
                else
                    love.graphics.draw(s.img, x, y, r, sx, sy, w/2, h/2)
                end
            end
            
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

return SpriteRenderer