local PlayerShip = require("Code.Entities.PlayerShip")
local Projectile = require("Code.Entities.Projectile")
local SpriteRenderer = require("Code.Systems.SpriteRenderer")
local ShotTrigger = require("Code.Systems.ShotTrigger")
local Mover = require("Code.Systems.Mover")
local Transform = require("Code.Components.Transform")
local EnemyShooter = require("Code.Entities.EnemyShooter")
local PhysicsUpdate = require("Code.Systems.PhysicsUpdate")
local Hittable = require("Code.Components.Hittable")
local HitHandler = require("Code.Systems.HitHandler")
local PhysicsWorldHaver = require("Code.Entities.PhysicsWorldHaver")
local GameState = require("Gamestates.GameState")


local Shmup = {
    SHIP_SPEED = { x=500, y=700 },
    PLAYFIELD_SIZE = { x=1920, y=1080 },
    ROCKET_SPEED = 1000,
    LASER_SPEED = 5000,
    ROCKET_RATE_FULL = 1,
    ROCKET_RATE_EMPTY = 0.3,
    LASER_RATE_FULL  = 8,
    LASER_RATE_EMPTY = 0.5,
    ROCKET_SPAWNS = {
        { x=0, y=60 },
        { x=0, y=-20 },
    },
    waves = {},
    waveTime = 0,
    active = false,
    time = 0,
}

function Shmup:load()
    ShmupInstance.resources = {
        rocket    = love.graphics.newImage("Assets/Sprites/Rocket.png"),
        laser     = love.graphics.newImage("Assets/Sprites/Laser.png"),
        croissant = love.graphics.newImage("Assets/Sprites/croissant1.png"),
        ship      = love.graphics.newImage("Assets/Images/ShipInMenu.png"),
    }
end

function Shmup:hit(entity)
    local h = entity:get(Hittable)
    if h then 
        h.hit = true
        h.health = h.health - 1
    end
end

function Shmup.shipHit(dmg)
    dmg = dmg * 10
    local hit = love.math.random(3)
    if hit == 1 then
        GameState.health:change("engines", -dmg)
    elseif hit == 2 then
        GameState.health:change("weapons", -dmg)
    elseif hit == 3 then
        if GameState.health.shields > 0 then
            if GameState.health.shields < dmg then
                local tmpDmg = dmg - GameState.health.shields
                GameState.health.shields = 0
                GameState.health:change("overall", -tmpDmg)
            else
                GameState.health.shields = GameState.health.shields - dmg 
            end
        else
            GameState.health:change("overall", -dmg)
        end
    end
end

function Shmup:initGame()
    ShmupInstance:addSystem(ShotTrigger(), "update")
    ShmupInstance:addSystem(Mover(), "update")
    self.pu = PhysicsUpdate()
    ShmupInstance:addSystem(self.pu, "update")
    self.hits = HitHandler()
    self.hits.enemies = 0
    ShmupInstance:addSystem(self.hits, "update")

    local sr = SpriteRenderer()
    sr.layers = {"projectiles", "ships", "damage"}
    ShmupInstance:addSystem(sr, "draw")
    
    ShmupInstance:addEntity(PhysicsWorldHaver(0, function(f0, f1, c)
        local e0, e1 = f0:getUserData(), f1:getUserData()
        if e0.properties.type ~= e1.properties.type then
            local h0, h1 = e0:get(Hittable), e1:get(Hittable)

            local h0h = h0.health
            local h1h = h1.health
            h0.hit = true
            h1.hit = true

            if e0 == self.ship then
                if self.shipHit then self.shipHit(h1.health) end
            else
                h0.health = h0.health - h1.health
            end

            if e1 == self.ship then
                if self.shipHit then self.shipHit(h0.health) end
            else
                h1.health = h1.health - h0h
            end
        end
    end))
    self.ship = PlayerShip(200, self.PLAYFIELD_SIZE.y / 2)
    self.laserTimeout = 0
    self.rocketTimeout = 0
    self.rocketSpawnPoint = 0
    ShmupInstance:addEntity(self.ship)
end
  
function Shmup:exitGame()
    ShmupInstance:clear()
end

function Shmup:enter(previous, wasSwitched, ...)

end

function Shmup:leave()

end

function Shmup:wave1(t0)
    for i = 0, 4 do
        self.waves[t0 + i * 0.3] = EnemyShooter(ShmupInstance.resources.croissant, 2020, 300 + 100*i, 1600 - 100*i, 100 + 200*i, 0.5, 2, 0.5, 0.5, ShmupInstance.resources.rocket)
    end
end

function Shmup:initWaves()
    self.waves = {}
    self.waveTime = 0
    self.active = true
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
    if self.active and not next(self.waves) and (self.hits.enemies == 0) then
        self.active = false
        if self.battleDoneCallback then
            self.battleDoneCallback()
        end
    end
end

function Shmup:globalUpdate(dt)
    if love.keyboard.isDown("g") then
        return
    end

    self:updateWaves(dt)
    
    ShmupInstance:emit("update", dt)

    self.time = self.time + dt
end

function math.tri(x)
    local x = x % 4
    if x >= 2 then
        return x - 1
    else
        return 3 - x
    end
end

function Shmup:update(dt)

    local x, y = Input:get("move")
    local t = self.ship:get(Transform)

    if x ~= 0 or y ~= 0 then
        t.x = math.clamp(t.x + x * dt * self.SHIP_SPEED.x, 100, self.PLAYFIELD_SIZE.x - 100)
        t.y = math.clamp(t.y + y * dt * self.SHIP_SPEED.y, 100, self.PLAYFIELD_SIZE.y - 100)
    end

    self.laserTimeout = math.max(0, self.laserTimeout - dt)
    self.rocketTimeout = math.max(0, self.rocketTimeout - dt)

    if Input:down("action") then
        if self.rocketTimeout == 0 and GameState.health.weapons > 10 then
            local spawn = self.ROCKET_SPAWNS[1+self.rocketSpawnPoint]
            local accel = GameState.health.weapons * 3500 / 100
            ShmupInstance:addEntity(Projectile(ShmupInstance.resources.rocket, t.x + spawn.x, t.y + spawn.y, 0, 0.1, -300, accel, 10000, 600 * math.max(50 - GameState.health.weapons, 0) / 50, "good"))
            self.rocketSpawnPoint = (self.rocketSpawnPoint + 1) % #self.ROCKET_SPAWNS
            self.rocketTimeout = 1 / (self.ROCKET_RATE_FULL - (self.ROCKET_RATE_FULL - self.ROCKET_RATE_EMPTY) * (100 - GameState.health.weapons) / 100)
        end
        if self.laserTimeout == 0 and GameState.health.weapons > 0 then
            local laserWobble = 15 * (100 - GameState.health.weapons)/100
            local laserDir = math.rad(math.sin(self.time * 2) * laserWobble + math.random(-1, 1) * laserWobble / 2) 
            ShmupInstance:addEntity(Projectile(ShmupInstance.resources.laser, t.x + 220*0.3, t.y - 80*0.3, laserDir, 0.3, self.LASER_SPEED, 0, self.LASER_SPEED, 0, "good"))
            self.laserTimeout = 1 / (self.LASER_RATE_FULL - (self.LASER_RATE_FULL - self.LASER_RATE_EMPTY) * (100 - GameState.health.weapons) / 100)
        end
    end
end

function Shmup:draw()
    ShmupInstance:emit("draw")
    love.graphics.print(#ShmupInstance.entities.objects .. " entities", 10, 100)
    love.graphics.print(#self.waves .. " ships left in waves", 10, 140)
    love.graphics.print(self.ship:get(Hittable).health .. " health left", 10, 180)
    love.graphics.print(self.hits.enemies .. " -> " .. (next(self.waves) and "WAEV!!!1" or "bored") .. " -> " .. (self.active and "active" or "passive"), 10, 220)
    self.pu:draw()
end

return Shmup