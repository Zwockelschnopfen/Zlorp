local Physics = require("Code.Components.Physics")

local b = function(a, b, coll)
    local ae = a:getUserData().entity
    local be = b:getUserData().entity
    
    ae:get(Physics).callbacks:emit("beginCollision", be, coll)
    be:get(Physics).callbacks:emit("beginCollision", ae, coll)
end 

local e = function(a, b, coll)
    local ae = a:getUserData().entity
    local be = b:getUserData().entity

    ae:get(Physics).callbacks:emit("endCollision", be, coll)
    be:get(Physics).callbacks:emit("endCollision", ae, coll)
end

return Concord.component(
    function(c, gravity)
        c.world = love.physics.newWorld(0, 0, true)
        c.world:setGravity(0, gravity)
        c.world:setCallbacks(b, e)
    end
)

