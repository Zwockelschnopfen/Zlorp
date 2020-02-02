return function(prefix, count, looping)
  local sfx = { }

  for i=1,count do
    local src = love.audio.newSource(string.format("%s%d.flac", prefix, i), "static")
    src:setLooping(looping or false)
    table.insert(sfx, src)
  end

  function sfx:play()
    -- TODO: THIS IS A FUCKING MEMORY LEAK
    -- 20 Minuten zur Abgabe rechtfertigen das!
    love.audio.play(self[math.random(#self)]:clone())
  end

  return sfx
end