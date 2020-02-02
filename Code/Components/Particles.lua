local Particles = Concord.component(
        function(c, particleDatas)
            local highestLayer = 0
            c.layers = {}
            
            for i, particleData in ipairs(particleDatas) do
                if not c.layers[particleData.layer] then
                    c.layers[particleData.layer] = {}
                    c.layers[particleData.layer].systems = {}
                    c.layers[particleData.layer].offset = {x = particleData.ox or 0, y = particleData.oy or 0}
                end
                table.insert( c.layers[particleData.layer].systems, 1, love.graphics.newParticleSystem(particleData.img) )
                for setting, vals in pairs(particleData.particleConfig) do
                    local ps = c.layers[particleData.layer].systems[1]
                    ps[setting](ps, unpack(vals))
                end
            end
            
        end
)

--[[

EXAMPLE:
--------

particleDatas = {
    {
        img = love.graphics.newImage("Dein Bild!"),
        layer = 3,
        particleConfig = {
            setEmissionRate = { rate },
            setColors = {r1, g1, b1, a1, r2, g2, b2, a2, r3, g3, b3, a3} 
        }
    }
}
]]

function Particles:draw(layerIndex, x, y)
    x = x or 0
    y = y or 0
    if self.layers[layerIndex] then
        for k, ps in ipairs(self.layers[layerIndex].systems) do
            ps:update(love.timer.getDelta())
            ps:setPosition(x + self.layers[layerIndex].offset.x, y + self.layers[layerIndex].offset.y)
            love.graphics.draw(ps)
        end
    end
end

return Particles