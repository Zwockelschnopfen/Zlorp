local PlayerShip = require("Code.Entities.PlayerShip")
local Projectile = require("Code.Entities.Projectile")
local SpriteRenderer = require("Code.Systems.SpriteRenderer")
local ShotTrigger = require("Code.Systems.ShotTrigger")
local Mover = require("Code.Systems.Mover")
local Transform = require("Code.Components.Transform")
local EnemyShooter = require("Code.Entities.EnemyShooter")

local Shmup = {
    SHIP_SPEED = { x=500, y=700 },
    PLAYFIELD_SIZE = { x=1920, y=1080 },
    ROCKET_SPEED = 1000,
    LASER_SPEED = 5000,
    ROCKET_RATE = 1,
    LASER_RATE  = 0.25,
    ROCKET_SPAWNS = {
        { x=0, y=100 },
        { x=0, y=-100 },
    },
    waves = {},
    waveTime = 0,
}

function Shmup:load()
    self.resources = {
        rocket = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
        laser  = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
    }
end

function Shmup:enter(previous, wasSwitched, ...)
    ShmupInstance:addSystem(ShotTrigger(), "update")
    ShmupInstance:addSystem(Mover(), "update")
    ShmupInstance:addSystem(SpriteRenderer(), "draw")
    self.ship = PlayerShip(200, self.PLAYFIELD_SIZE.y / 2)
    self.laserTimeout = 0
    self.rocketTimeout = 0
    self.rocketSpawnPoint = 0
    ShmupInstance:addEntity(self.ship)
end

function Shmup:leave()

end

function Shmup:wave1(t0)
    for i = 0, 4 do
        self.waves[t0 + i * 0.3] = EnemyShooter(self.resources.rocket, 2020, 300 + 100*i, 1600 - 100*i, 100 + 200*i, 0.5, 2, 0.5, 0.5, self.resources.rocket)
    end
end

function Shmup:initWaves()
    self.waves = {}
    self.waveTime = 0
    self:wave1(2)
end

function Shmup:updateWaves(dt)
    self.waveTime = self.waveTime + dt
    for t, entity in pairs(self.waves) do
        if self.waveTime >= t then
            ShmupInstance:addEntity(entity)
            self.waves[t] = nil
        end
    end
end

function Shmup:update(_, dt)
    self:updateWaves(dt)

    local x, y = Input:get("move")
    local t = self.ship:get(Transform)

    if x ~= 0 or y ~= 0 then
        t.x = math.clamp(t.x + x * dt * self.SHIP_SPEED.x, 100, self.PLAYFIELD_SIZE.x - 100)
        t.y = math.clamp(t.y + y * dt * self.SHIP_SPEED.y, 100, self.PLAYFIELD_SIZE.y - 100)
    end

    self.laserTimeout = math.max(0, self.laserTimeout - dt)
    self.rocketTimeout = math.max(0, self.rocketTimeout - dt)

    if Input:down("action") then
        if self.rocketTimeout == 0 then
            local spawn = self.ROCKET_SPAWNS[1+self.rocketSpawnPoint]
            ShmupInstance:addEntity(Projectile(self.resources.rocket, t.x + spawn.x, t.y + spawn.y, 0, -300, 3500, 10000))
            self.rocketSpawnPoint = (self.rocketSpawnPoint + 1) % #self.ROCKET_SPAWNS
            self.rocketTimeout = self.ROCKET_RATE
        end
        if self.laserTimeout == 0 then
            ShmupInstance:addEntity(Projectile(self.resources.laser, t.x, t.y, 0, self.LASER_SPEED, 0, self.LASER_SPEED))
            self.laserTimeout = self.LASER_RATE
        end
        self:initWaves()
    end
    ShmupInstance:emit("update", dt)
end

function Shmup:draw()
    ShmupInstance:emit("draw")
    love.graphics.print(#ShmupInstance.entities.objects .. " entities", 10, 10)
end

return Shmup