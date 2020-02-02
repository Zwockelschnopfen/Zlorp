local GameState = {

}

function GameState:reset()
  self.health = {
    overall = 100,
    engines = 40,
    shields = 50,
    weapons = 20,
  }
  function self.health:change(what, val)
    self[what] = math.clamp(self[what] + val, 0, 100)
  end
  self.level = 1
  self.mode = "shmup"
  self.timeRemaining = 0
end

function GameState:goToShmup()
  self.mode = "shmup"
end

function GameState:goToRepair()
  self.mode = "repair"
  self.level = self.level + 1
end

return GameState
