local Event = require("Lib.Event")

local function b(otherEntity, coll)
    print("Begin Collision", otherEntity)
end

local function e(otherEntity, coll)
    print("End Collision", otherEntity)
end

return Concord.component(
        function(c, bodyData, shapeDataTable)
            c.bodyData = bodyData
            c.shapeDataTable = shapeDataTable
            c.callbacks = Event.new()
            c.callbacks:register("beginCollision", b)
            c.callbacks:register("endCollision", e)
        end
)

--[[
    example data:
        bodyData = { x = 5, y = 5, type = "dynamic" }
        shapeDataTable = { { type = "circle", radius = 10 }, { type = "polygon", verts = {0, 0, 0, 1, 1, 1, 1, 0 } } }
]]