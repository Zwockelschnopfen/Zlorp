local TMG = require "Code.Components.TileMapGraphics"
local TMR = Concord.system({TMG})

function TMR:init()
    
end

function TMR:draw()

  for _, entity in ipairs(self.pool.objects) do

    local graphics = entity[TMG]

    love.graphics.reset()
    love.graphics.setColor(1, 1, 1)
    graphics.map:draw()
    
    love.graphics.setColor(1, 0, 0)
	  graphics.map:box2d_draw()

  end

end

return TMR
