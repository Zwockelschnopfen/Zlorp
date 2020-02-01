local PhysicsWorld = require("Code.Components.PhysicsWorld")
return function(gravity, beginContact, endContact)
    return Concord.entity.new():give(PhysicsWorld, gravity, beginContact, endContact)
end