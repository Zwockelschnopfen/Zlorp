local PlayerShip = require("Code.Entities.PlayerShip")
local RocketShot = require("Code.Entities.RocketShot")
local SpriteRenderer = require("Code.Systems.SpriteRenderer")
local Mover = require("Code.Systems.Mover")
local Transform = require("Code.Components.Transform")
local Shmup = {}

function Shmup:enter(previous, wasSwitched, ...)
    ShmupInstance:addSystem(Mover(), "update")
    ShmupInstance:addSystem(SpriteRenderer(), "draw")
    self.ship = PlayerShip(100, 100)
    self.laserTimeout = 0
    self.rocketTimeout = 0
    self.rocketSpawnPoint = 100
    ShmupInstance:addEntity(self.ship)
end

function Shmup:leave()

end

function Shmup:update(_, dt)
    local x, y = Input:get("move")
    local t = self.ship:get(Transform)

    if x ~= 0 or y ~= 0 then
        t.x = t.x + x * dt * 500
        t.y = t.y + y * dt * 500
    end

    self.laserTimeout = math.max(0, self.laserTimeout - dt)
    self.rocketTimeout = math.max(0, self.rocketTimeout - dt)

    if Input:down("action") then
        if self.rocketTimeout == 0 then
            ShmupInstance:addEntity(RocketShot(t.x, t.y + self.rocketSpawnPoint, 1000, 0))
            self.rocketSpawnPoint = -self.rocketSpawnPoint
            self.rocketTimeout = 1
        end
        if self.laserTimeout == 0 then
            ShmupInstance:addEntity(RocketShot(t.x, t.y, 2000, 0))
            self.laserTimeout = 0.3
        end
    end
    ShmupInstance:emit("update", dt)
end

function Shmup:draw()
    ShmupInstance:emit("draw")
    love.graphics.print(#ShmupInstance.entities.objects .. " entities", 10, 10)
end

return Shmup