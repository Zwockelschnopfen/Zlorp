local Anim = require("Code.Components.Anim")
local Transform = require("Code.Components.Transform")
local KillAfter = require("Code.Components.KillAfter")

return function( x, y, sx, sy, parent )
    local e = Concord.entity.new()
    e:give(Transform, x or 0, y or 0, 0, sx or 1, sy or 1, parent)
    e:give(Anim, "particle_shmup_sprites", "boom")
    e:give(KillAfter, e:get(Anim).duration)
    
    return e
end