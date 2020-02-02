local GameState = {

}

function GameState:reset()
  self.health = {
    engines = 10,
    shields = 50,
    weapons = 100
  }
  self.mode = "shmup"
end

function GameState:goToShmup()
  self.mode = "shmup"
end

function GameState:goToRepair()
  self.mode = "repair"
end

return GameState
