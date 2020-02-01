local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")

return function(x, y)
    local ent = Concord.entity.new()
    ent
        :give(Transform, x, y, 0, 1, 1)
        :give(Sprite, assert(love.graphics.newImage("Assets/Images/ShipInMenu.png")))
    return ent
end