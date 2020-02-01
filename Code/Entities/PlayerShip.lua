local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local PhysicsWorld = require("Code.Components.PhysicsWorld")

return function(x, y)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, 0, 1, 1)
        :give(Sprite, assert(love.graphics.newImage("Assets/Images/ShipInMenu.png")))
        :give(Physics, {x=5, y=5, type="dynamic", userData=ent, sensor=true}, {{ type="circle", radius=200 }})
    return table.update(ent, {collisionCount=0, properties={type="ship"}})
end