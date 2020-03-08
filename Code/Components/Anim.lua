local AnimComponent =  Concord.component(
        function(c, fileName, activeAnim)
            local img = love.graphics.newImage("Assets/Anims/" .. fileName .. ".png")
            local configString = love.filesystem.read("Assets/Anims/" .. fileName .. ".lua")
            local status, config = pcall( loadstring("return " .. configString) );
            if not status then
                error("Anim Config '" .. fileName .. ".lua' not formatted correctly!\n" .. config)
            end
            c.img = img
            c.fileName = fileName
            c.t = 0
            c.activeAnim = activeAnim
            c.quads = {}
            c.eventsActive = false
            for i = 1, config.numRow do
                for j = 1, config.numCol do
                    local x = config.px * (j - 1)
                    local y = config.py * (i - 1)
                    table.insert(
                            c.quads, 
                            love.graphics.newQuad(
                                x, 
                                y, 
                                config.px, 
                                config.py, 
                                img:getDimensions()
                            )
                    )
                end
            end

            c.anims = {}
            for name, data in pairs(config.anim) do
                c.anims[name] = {}
                c.anims[name].duration = data[3]
                for i = data[1], data[2] do
                    table.insert(c.anims[name], c.quads[i])
                end
            end

            if activeAnim and c.anims[activeAnim] then
                c.duration = c.anims[activeAnim].duration
            else
                error("Anim created with activeAnim but correlating config does not contain the anim. In " .. fileName .. " for activeAnim " .. activeAnim )
            end
        end
)

function AnimComponent:setActiveAnim(newAnim)
    if not self.anims[newAnim] then
        error("Changing Animation to invalid value in " .. self.fileName .. ".lua. Values supplied is: " .. newAnim)
    end

    if self.activeAnim == newAnim then
        return
    end
    
    self.t = 0
    self.activeAnim = newAnim
    self.duration = self.anims[newAnim].duration
    if self.events and self.events[newAnim] then
        self.eventsActive = true
    else
        self.eventsActive = false
    end
end

function AnimComponent:update(dt)
    self.t = self.t + dt
    
    if self.t >= self.duration then
        self.t = self.t - self.duration
        
        if self.eventsActive then
            for i, event in ipairs(self.events[self.activeAnim]) do
                if self.t - dt < event.t and self.t > event.t then
                    event.f()
                end
            end
        end
    elseif self.eventsActive then
        for i, event in ipairs(self.events[self.activeAnim]) do
            if self.t + self.duration - dt < event.t and self.t + self.duration > event.t then
                event.f()
            end
        end
    end
end

function AnimComponent:addEvent(anim, t, func)
    if not self.events       then self.events = {}       end
    if not self.events[anim] then 
        self.events[anim] = {}

        if self.activeAnim == anim then
            self.eventsActive = true
        end
    end

    table.insert( self.events[anim], {t = t, f = func} )
end

return AnimComponent