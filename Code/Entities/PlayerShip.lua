local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")

return function(x, y)
    local hitbox = {}
    local scale = 0.3
    for i, coord in ipairs({ 230,-50, 390,110, 90,180, -260,150, -396,-40, -320,-120 }) do
        table.insert(hitbox, coord * scale)
    end
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, 0, scale, scale)
        :give(Sprite, ShmupInstance.resources.ship, nil, "ships")
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="polygon", verts=hitbox }})
        :give(Hittable, 10000)
    return table.update(ent, {collisionCount=0, properties={type="good", subtype="ship"}})
end