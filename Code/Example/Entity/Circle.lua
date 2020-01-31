local Pos = require("Code.Example.Component.Pos")
local CircleData = require("Code.Example.Component.CircleData")

return function(x, y, radius, mode)
    x = x or 100
    y = y or 100
    radius = radius or 50
    mode = mode or "fill"
    
    local newCircle = Concord.entity.new()
    newCircle
            :give(Pos, x, y)
            :give(CircleData, mode, radius)
    
    return newCircle
end