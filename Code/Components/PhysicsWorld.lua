return Concord.component(
    function(c, gravity, beginContact, endContact)
        c.world = love.physics.newWorld(0, 0, true)
        c.world:setGravity(0, gravity)
        c.world:setCallbacks(beginContact, endContact)
    end
)
