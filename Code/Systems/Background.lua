local Starfield = require "Code.Components.Starfield"

local Background = Concord.system({Starfield})

function Background:init()
    local pimage = love.graphics.newImage("Assets/Particles/TestStar.png")

    self.background = love.graphics.newImage("Assets/Images/SpaceBackground.png")
    self.backgroundShift = 0

    self.psystems = { }

    for i=1,5 do

        local psystem = love.graphics.newParticleSystem(pimage, 1000)

        psystem:setParticleLifetime(100, 100) -- Particles live at least 2s and at most 5s.
        psystem:setEmissionRate(10)
        psystem:setEmissionArea("uniform", 0, 1080, 0, false)
        psystem:setSizeVariation(1)
        psystem:setSizes(0.15)
        psystem:setLinearAcceleration(0, 0, 0, 0) -- Random movement in all directions.
        psystem:setDirection(math.pi)
        psystem:setSpeed( 50 * i, 50 * i )
        -- psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
        psystem:setColors(i/5,i/5,i/5, 1.0)

        -- preheat (10 second):
        for j=1,i*100 do
            psystem:update(0.1)
        end

        self.psystems[i] = psystem;
    end
end

function Background:draw()
    local dt = love.timer.getDelta()

    self.backgroundShift = self.backgroundShift - 25 * dt
    if self.backgroundShift <= -1920 then
        self.backgroundShift = self.backgroundShift + 1920
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.background, math.floor(self.backgroundShift), 0)
    love.graphics.draw(self.background, math.floor(self.backgroundShift + 1920), 0)

    love.graphics.setColor(1, 1, 1)
    for i=1,5 do
        self.psystems[i]:update(dt)
        love.graphics.draw(self.psystems[i], 1920, 0)
    end


end

return Background
