local Pos = require("Code.Example.Component.Pos")
local CircleData = require("Code.Example.Component.CircleData")

local CircleDrawer = Concord.system({
    Pos,
    CircleData
})

function CircleDrawer:init()

end

---@param e Entity
function CircleDrawer:entityAdded(e)

end

function CircleDrawer:draw()
    for _, e in ipairs(self.pool.objects) do
        local p = e:get(Pos)
        local cd = e:get(CircleData)
        
        love.graphics.circle(cd.mode, p.x, p.y, cd.radius)
    end
end

return CircleDrawer