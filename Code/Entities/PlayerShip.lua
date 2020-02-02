local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")
local Particles = require("Code.Components.Particles")

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
        :give(Particles,
            {
                {
                    img = love.graphics.newImage("Assets/Particles/TestStar.png"),
                    layer = "damage",
                    ox = -160, 
                    oy = -10,
                    particleConfig = {
                        setEmissionRate = { 1000 },
                        setColors = {0, 0, 1, 0.2, 1, 1, 0, 0.5, 1, 1, 1, 1, 0, 0, 0, 0},
                        setParticleLifetime = {0.5},
                        setEmitterLifetime = {-1},
                        setEmissionArea = {"uniform", 0, 10},
                        setSpeed = {-50, -100},
                        setSizeVariation = {1}
                    }
                }
            }
        )
    return table.update(ent, {collisionCount=0, properties={type="good", subtype="ship"}})
end