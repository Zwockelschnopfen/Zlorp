local Sprite = require("Code.Components.Sprite")
local Anim = require("Code.Components.Anim")
local ASM = require("Code.Components.AnimStateMachine")

local AnimUpdate = Concord.system({Anim})

function AnimUpdate:init()

end

function AnimUpdate:update(dt)

end

function AnimUpdate:entityAdded(e)
    if not e:get(Sprite) then
        local a = e:get(Anim)
        e:give(Sprite, a.img)
    end
end

function AnimUpdate:draw()
    local dt = love.timer.getDelta()
    local sprite, anim, asm
    for _, e in ipairs(self.pool.objects) do
        sprite = e:get(Sprite)
        anim = e:get(Anim)
        asm = e:get(ASM)
        
        if asm and asm.isDirty then
            asm:update(anim, dt)
        end
        anim:update(dt)
        local animQuads = anim.anims[anim.activeAnim]
        local quadNum = math.floor(anim.t / anim.duration * #animQuads) + 1
        sprite.quad = animQuads[quadNum]
        --love.graphics.rectangle("fill", 0, 0, 500, 500)
        --love.graphics.draw(sprite.img, animQuads[quadNum], 100, 100)
    end
end

return AnimUpdate
