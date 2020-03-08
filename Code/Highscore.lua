local Highscore = {
  list = {
    { name = "xq", score = "9001" },
    { name = "dojoe", score = "9000" },
    { name = "kaomau", score = "8999" },
    { name = "SagaMusix", score = "8998" },
    { name = "Celine", score = "8997" },
    { name = "long", score = "8996" },
    { name = "Hoodini", score = "8995" },
  },
}



function Highscore:loadDataset()
  local success, iter = pcall(love.filesystem.lines, "highscores.lst")
  if success then
    self.list = { }
    for line in iter do
      local score, name line:match("^(%d+),(.*)")
      table.insert(self.list, {
        name = name,
        score = tonumber(score)
      })
    end
  end
  table.sort(self.list, function(l,r) 
    return l.score > r.score
  end)
end

function Highscore:saveDataset()
  for i,v in ipairs(self.list) do

  end
end

function Highscore:reset()
    self.currentScore = 0
end

function Highscore:add(p)
  self.currentScore = self.currentScore + p
end

function Highscore:save(name)
  table.insert(self.list, {
    name = name or "unknown",
    score = self.currentScore or error("")
  })
  self:saveDataset()
end

return Highscore