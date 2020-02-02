local GameState = {

}

function GameState:reset()
  self.health = {
    overall = 100,
    engines = 40,
    shields = 50,
    weapons = 20
  }
  self.mode = "shmup"
  self.timeRemaining = 0
end

function GameState:goToShmup()
  Music.setIntensity(5)
  self.mode = "shmup"
end

function GameState:goToRepair()
  self.timeRemaining = 60
  Music.setIntensity(1)
  self.mode = "repair"
end

return GameState
