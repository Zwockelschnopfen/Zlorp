local Transform = require("Code.Components.Transform")

local SoundFX = require "Code.SoundFX"
local Shmup = require "Gamestates.Shmup"
local Repair = require "Gamestates.Repair"

local Highscore = require "Code.Highscore"
local Balancing = require "Code.Balancing"

local HUD = require "Gamestates.HUD"
local GameState = require "Gamestates.GameState"
local Gameplay = require "Gamestates.Gameplay"

local GameOver = {
}

function GameOver:load()
  self.resources = {
    
  }
end

function GameOver:enter()
  
end

function GameOver:leave()

end


function GameOver:textinput(_, text )
  print(text)
end

function GameOver:update(_, dt)

  Gameplay:draw(dt)

  if Input:down "action" then
    Gamestate.switch(GS.menu)
  end

end


function GameOver:draw()

  -- Gameplay:draw()

end 

return GameOver