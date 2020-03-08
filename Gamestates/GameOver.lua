local Transform = require("Code.Components.Transform")

local SoundFX = require "Code.SoundFX"
local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local Highscore = require "Code.Highscore"
local Balancing = require "Code.Balancing"

local HUD = require "Gamestates.HUD"
local GameState = require "Gamestates.GameState"
local Gameplay = require "Gamestates.Gameplay"

local Explosion      = require("Code.Entities.Xplosion")
local AnimUpdate     = require "Code.Systems.AnimUpdate"
local SpriteRenderer = require("Code.Systems.SpriteRenderer")
local KillAfterUpdate = require("Code.Systems.KillAfterUpdate")

local GameOver = {
}

function GameOver:load()
  self.resources = {
    textures = {
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_01.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_02.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_03.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_04.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_05.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_06.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_07.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_08.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_09.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_10.png"),
      love.graphics.newImage("Assets/Images/Scrap/game_over_asset_11.png"),
    }
  }
  
  GameOverInstance:addSystem(AnimUpdate(), "draw")
  GameOverInstance:addSystem(KillAfterUpdate(), "update")
  local sr = SpriteRenderer()
  sr.layers = {"default", "projectiles", "ships", "damage"}
  GameOverInstance:addSystem(sr, "draw")
end

function GameOver:enter()

  GameOverInstance:clear()

  self.crashsite = { }
  self.timer = 0

end

function GameOver:leave()

end


function GameOver:textinput(_, text )
  print(text)
end

function GameOver:update(_, dt)

  if self.timer > 1.0 then

    local i = #self.crashsite + 1

    if i < #self.resources.textures then
      local cs = {
        image = self.resources.textures[i],
        rotation = math.random() * 2.0 * math.pi,
        x = VirtualScreen.width * math.random(),
        y = VirtualScreen.height * math.random(),
        vx = 100 * math.abspow((2.0 * math.random() - 1.0), 2.0),
        vy = 100 * math.abspow((2.0 * math.random() - 1.0), 2.0),
        vr = 0.8 * math.abspow((2.0 * math.random() - 1.0), 2.0),
      }
      self.crashsite[i] = cs

      local scale = math.max(cs.image:getWidth(), cs.image:getHeight()) / 128

      GameOverInstance:addEntity( Explosion( cs.x,  cs.y, scale,  scale, nil) )
    end

    self.timer = self.timer - 1.0
  end


  self.timer = self.timer + dt

  if Input:pressed "back" then
    Gamestate.switch(GS.menu)
  end

  for i,sprite in ipairs(self.crashsite) do

    sprite.x = sprite.x + sprite.vx * dt
    sprite.y = sprite.y + sprite.vy * dt
    sprite.rotation = sprite.rotation + sprite.vr * dt

    if sprite.x < -250 then
      sprite.x = sprite.x + VirtualScreen.width + 500
    end
    if sprite.x > VirtualScreen.width+250 then
      sprite.x = sprite.x - VirtualScreen.width - 500
    end

    if sprite.y < -250 then
      sprite.y = sprite.y + VirtualScreen.height + 500
    end
    if sprite.y > VirtualScreen.height+250 then
      sprite.y = sprite.y - VirtualScreen.height - 500
    end

  end

  GameOverInstance:emit("update", dt)

end


function GameOver:draw()

  Gameplay:draw()

  love.graphics.setColor(1, 1, 1)
  for i,sprite in ipairs(self.crashsite) do

    love.graphics.draw(
      sprite.image,
      sprite.x,
      sprite.y,
      sprite.rotation,
      1.0, 1.0,
      sprite.image:getWidth() / 2,
      sprite.image:getHeight() / 2
    )

  end

  love.graphics.setColor(1, 1, 1)
  GameOverInstance:emit("draw")

end 

return GameOver