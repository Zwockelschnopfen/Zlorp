local Starfield = require "Code.Components.Starfield"

local Background = Concord.system({Starfield})

function Background:init()
    local pimage = love.graphics.newImage("Assets/Particles/TestStar.png")
    self.psystem = love.graphics.newParticleSystem(pimage, 1000)


	self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(5)
	self.psystem:setSizeVariation(1)
	self.psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
	self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
end

function Background:draw()
    print("hi")
    local dt = love.timer.getDelta()

	self.psystem:update(dt)

    love.graphics.print("dafuq?!", 10, 10)
    love.graphics.draw(self.psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

end

return Background
