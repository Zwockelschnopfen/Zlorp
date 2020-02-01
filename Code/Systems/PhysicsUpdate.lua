local Transform = require("Code.Components.Transform")
local Physics = require("Code.Components.Physics")
local World = require("Code.Components.PhysicsWorld")

local PhysicsUpdate = Concord.system({Physics, Transform}, {"world", World})

function PhysicsUpdate:init()
    
end

function PhysicsUpdate:entityAdded(e)
    local we = self.world.objects[1]
    
    if not we then
        error("PhysicsUpdateSystem: Entity added while no physics world exists!")
    end
    
    local world = we:get(World).world
    local physics = e:get(Physics)

    if physics then
        physics.body = love.physics.newBody(world, physics.bodyData.x, physics.bodyData.y, physics.bodyData.type)
        physics.body:setFixedRotation(physics.bodyData.fixedRotation or false)
        local newShape
        for _, shapeDat in ipairs(physics.shapeDataTable) do
            newShape = PhysicsUpdate:createShape(shapeDat)
            love.physics.newFixture( physics.body, newShape, shapeDat.density)
        end
    end 
end

function PhysicsUpdate:update(dt)
    local we = self.world.objects[1]
    if we then
        local transform, physics
        for _, e in ipairs(self.pool.objects) do
            transform = e:get(Transform)
            physics = e:get(Physics)
            
            physics.body:setX(transform.x)
            physics.body:setY(transform.y)
        end
        
        local world = we[World]
        world.world:update(dt)

        for _, e in ipairs(self.pool.objects) do
            transform = e:get(Transform)
            physics = e:get(Physics)

            transform.x = physics.body:getX()
            transform.y = physics.body:getY()
            transform.r = physics.body:getAngle()
        end
    end
end

function PhysicsUpdate:draw()
    local transform
    for _, e in ipairs(self.pool.objects) do
        transform = e:get(Transform)
        if transform then
            love.graphics.circle("fill", transform.x, transform.y, 5)
        end
    end 
end


function PhysicsUpdate:createShape(shapeDat)
    if shapeDat.type == "circle" then
        return love.physics.newCircleShape(shapeDat.radius)
    elseif shapeDat.type == "polygon" then
        return love.physics.newPolygonShape(shapeDat.verts)
    end
end

return PhysicsUpdate
