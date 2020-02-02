local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")
local Particles = require("Code.Components.Particles")
local KillAfter = require("Code.Components.KillAfter")

return function(scale, x, y)
    scale = scale or 1
    local ent = Concord.entity.new()
    ent
            :give(Transform, x, y, 0, scale, scale)
            :give(Sprite, ShmupInstance.resources.hitSprite, nil, "damage")
            :give(KillAfter, 0.3)
    return ent
end