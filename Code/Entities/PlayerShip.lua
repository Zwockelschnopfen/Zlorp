local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")

return function(x, y)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, 0, 1, 1)
        :give(Sprite, ShmupInstance.resources.ship, nil, "ships")
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="circle", radius=200 }})
        :give(Hittable, 10000)
    return table.update(ent, {collisionCount=0, properties={type="good", subtype="ship"}})
end