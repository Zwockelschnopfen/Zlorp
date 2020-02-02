local GameState = {

}

function GameState:reset()
  self.health = {
    overall = 100,
    engines = 10,
    shields = 50,
    weapons = 100
  }
  self.mode = "shmup"
  self.timeRemaining = 0
end

function GameState:goToShmup()
  Music.setIntensity(5)
  self.mode = "shmup"
end

function GameState:goToRepair()
  Music.setIntensity(1)
  self.mode = "repair"
end

return GameState
