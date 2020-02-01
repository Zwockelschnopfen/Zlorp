return Concord.component(
        function(c, bodyData, shapeDataTable)
            c.bodyData = bodyData
            c.shapeDataTable = shapeDataTable
        end
)

--[[
    example data:
        bodyData = { x = 5, y = 5, type = "dynamic" }
        shapeDataTable = { { type = "circle", radius = 10 }, { type = "polygon", verts = {0, 0, 0, 1, 1, 1, 1, 0 } } }
]]