local Transform = require("Code.Components.Transform")
local Anim = require("Code.Components.Anim")
local Sprite = require("Code.Components.Sprite")
local Physics = require("Code.Components.Physics")
local Hittable = require("Code.Components.Hittable")
local Particles = require("Code.Components.Particles")

spriteSize = 256

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
                --[[{
                    img = love.graphics.newImage("Assets/Particles/TestStar.png"),
                    layer = "damage",
                    ox = -160, 
                    oy = -10,
                    particleConfig = {
                        setEmissionRate = { 1000 },
                        setColors = {0, 0, 1, 0.1, 1, 1, 0, 0.25, 1, 1, 1, 0.5, 0, 0, 0, 0},
                        setParticleLifetime = {0.1},
                        setEmitterLifetime = {-1},
                        setEmissionArea = {"uniform", 0, 10},
                        setSpeed = {-50, -100},
                        setSizeVariation = {1}
                    }
                },]]
                {
                    img = love.graphics.newImage("Assets/Particles/smoke.png"),
                    layer = "default",
                    ox = -160,
                    oy = -10,
                    particleConfig = {
                        setEmissionRate = { 20 },
                        setEmitterLifetime = { -1 },
                        setColors = { 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0.3, 1, 1, 1, 0 },
                        setParticleLifetime = {0.5},
                        setEmissionArea = {"uniform", 10, 10},
                        setSizes = { 0.2 },
                        setSpeed = {-100, -500},
                    }
                }
                --[[{
                    img = love.graphics.newImage("Assets/Particles/particle_shmup_sprites.png"),
                    layer = "damage",
                    ox = 200,
                    oy = -200,
                    particleConfig = {
                        setEmissionRate = { 1 },
                        setColors = {1, 1, 1, 1},
                        setQuads = { love.graphics.newQuad( 0, spriteSize, spriteSize, spriteSize, 2048,  2048), 
                                     love.graphics.newQuad( spriteSize, spriteSize, spriteSize, spriteSize, 2048,  2048), 
                                     love.graphics.newQuad( spriteSize * 2, spriteSize, spriteSize, spriteSize, 2048,  2048),
                                     love.graphics.newQuad( spriteSize * 3, spriteSize, spriteSize, spriteSize, 2048,  2048),
                                     love.graphics.newQuad( spriteSize * 4, spriteSize, spriteSize, spriteSize, 2048,  2048),
                                     love.graphics.newQuad( spriteSize * 5, spriteSize, spriteSize, spriteSize, 2048,  2048)
                        },
                        setParticleLifetime = {0.3},
                        setEmitterLifetime = {-1},
                        setSpin = {1, 4},
                        setOffset = { spriteSize / 2, spriteSize / 2 }
                    }
                },
                {
                    img = love.graphics.newImage("Assets/Particles/particle_shmup_sprites.png"),
                    layer = "damage",
                    ox = 400,
                    oy = -200,
                    particleConfig = {
                        setEmissionRate = { 1 },
                        setColors = {1, 1, 1, 1},
                        setQuads = { love.graphics.newQuad( 0, spriteSize * 2, spriteSize, spriteSize, 2048,  2048) },
                        setParticleLifetime = {2},
                        setEmitterLifetime = {-1},
                        setSpeed = {-50, -100},
                        setRotation = { 0 },
                        setSpin = { 2, 7 },
                        setSizes = { 0 },
                        setOffset = { spriteSize / 2, spriteSize / 2 }
                    }
                }]]
            }
        )
    return table.update(ent, {collisionCount=0, properties={type="good", subtype="ship"}})
end