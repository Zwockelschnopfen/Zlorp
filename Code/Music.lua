local Music = {
  isLoaded = false,
  currentTrack = "menu", -- starts with menu as soon as we update our loading loop
  gameIntensity = 1,
}

function Music.setIntensity(intens) -- 1 … 5
  Music.gameIntensity = math.floor(intens or 1) or 1
  if Music.gameIntensity < 1 then
    Music.gameIntensity = 1
  elseif Music.gameIntensity > 5 then
    Music.gameIntensity = 5
  end
end

function Music.load()
  Music.tracks = {
    menu = love.audio.newSource("Assets/Music/menu.flac", "stream"),
    ingame = {
      love.sound.newDecoder('Assets/Music/_1.flac', 2048),
      love.sound.newDecoder('Assets/Music/_2.flac', 2048),
      love.sound.newDecoder('Assets/Music/_3.flac', 2048),
      love.sound.newDecoder('Assets/Music/_4.flac', 2048),
      love.sound.newDecoder('Assets/Music/_5.flac', 2048),
    },
  }
  Music.volume = {
    menu = 1.0,
    game = 0.0,
  }

  local decoder = Music.tracks.ingame[1]
  Music.gameTrackPlayer = love.audio.newQueueableSource(
    decoder:getSampleRate(), 
    decoder:getBitDepth(), 
    decoder:getChannelCount(), 
    8
  )

  Music.currentDecoder = Music.tracks.ingame[1]

  Music.tracks.menu:setVolume(0)
  Music.gameTrackPlayer:setVolume(0)

  Music.tracks.menu:setLooping(true)
  love.audio.play(Music.tracks.menu)

  Music.isLoaded = true
end

function Music.setTrack(track) -- none, menu, game

  Music.currentTrack = track or "none"
  if Music.currentTrack == "game" then
    Music.gameIntensity = 5 -- we start in battle mode
  end

end

function Music.update(dt)

  if not Music.isLoaded then
    return 
  end

  if love.keyboard.isDown("1") then
    Music.gameIntensity = 1
  elseif love.keyboard.isDown("2") then
    Music.gameIntensity = 2
  elseif love.keyboard.isDown("3") then
    Music.gameIntensity = 3
  elseif love.keyboard.isDown("4") then
    Music.gameIntensity = 4
  elseif love.keyboard.isDown("5") then
    Music.gameIntensity = 5
  end

  if love.keyboard.isDown("i") then
    Music.setTrack("none")
  elseif love.keyboard.isDown("o") then
    Music.setTrack("menu")
  elseif love.keyboard.isDown("p") then
    Music.setTrack("game")
  end
    
  while Music.gameTrackPlayer:getFreeBufferCount() > 0 do
    local buf = Music.currentDecoder:decode()
    if not buf then
      Music.currentDecoder:seek(0)
      Music.currentDecoder = Music.tracks.ingame[Music.gameIntensity]
      assert(Music.currentDecoder, tostring(Music.gameIntensity))
      buf = Music.currentDecoder:decode()
      assert(buf)

      if Music.gameIntensity < 4 then
        Music.gameIntensity = Music.gameIntensity + 1
      end
    end
    Music.gameTrackPlayer:queue(buf)

    if not Music.gameTrackPlayer:isPlaying() then
      love.audio.play(Music.gameTrackPlayer)
    end
  end

  if Music.currentTrack == "game" then
    Music.volume.game = math.min(1.0, Music.volume.game + dt)
  else
    Music.volume.game = math.max(0.0, Music.volume.game - dt)
  end

  if Music.currentTrack == "menu" then
    Music.volume.menu = math.min(1.0, Music.volume.menu + dt)
  else
    Music.volume.menu = math.max(0.0, Music.volume.menu - dt)
  end

  Music.tracks.menu:setVolume(Music.volume.menu)
  Music.gameTrackPlayer:setVolume(Music.volume.game)

end

return Music