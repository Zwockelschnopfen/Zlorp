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

        local trans = e[Transform]
        if trans then
            physics.bodyData.x = physics.bodyData.x or (trans.x / love.physics.getMeter())
            physics.bodyData.y = physics.bodyData.y or (trans.y / love.physics.getMeter())
        end

        physics.body = love.physics.newBody(world, physics.bodyData.x, physics.bodyData.y, physics.bodyData.type)
        physics.body:setFixedRotation(physics.bodyData.fixedRotation or false)
        physics.body:setGravityScale(physics.bodyData.gravityScale or 1.0)
        local newShape
        for _, shapeDat in ipairs(physics.shapeDataTable) do
            newShape = PhysicsUpdate:createShape(shapeDat)
            local fix = love.physics.newFixture( physics.body, newShape, shapeDat.density)
            if physics.bodyData.friction then
                fix:setFriction(physics.bodyData.friction)
            end
            fix:setUserData(physics.bodyData.userData or {
                collisionCount = 0,
                properties = {
                    type = "body",
                },
            })
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

    if not love.keyboard.isDown("f10") then
        return 
    end

    local we = self.world.objects[1]
    if we then
        local pw = we:get(World).world
        for _, body in pairs(pw:getBodies()) do

            for _, fixture in pairs(body:getFixtures()) do

                if fixture:isSensor() then
                    local ud = fixture:getUserData()
                    if ud  then
                        local ccnt = ud.collisionCount or 0
                        if ccnt > 0 then
                            love.graphics.setColor(0, 0, 1, 0.5)
                        else
                            if ud.properties.type == "ladder" then
                                love.graphics.setColor(1, 1, 0, 0.5)
                            else
                                love.graphics.setColor(0, 1, 0, 0.5)
                            end
                        end
                    end
                else
                    love.graphics.setColor(1, 0, 0, 0.5)
                end

                local shape = fixture:getShape()

                if shape:typeOf("CircleShape") then
                    local cx, cy = body:getWorldPoints(shape:getPoint())
                    love.graphics.circle("fill", cx, cy, shape:getRadius())
                elseif shape:typeOf("PolygonShape") then
                    love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
                else
                    love.graphics.line(body:getWorldPoints(shape:getPoints()))
                end
            end
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
