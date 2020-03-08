-- Concept:
-- 
-- init--.
--       |------------------------------------------.
--       v                                          |
--                                                  |
--  |    1    |    2    |   3   |   4   |   5   |   |
--  | Battle  | Calmdown| calm  | calm  | alarm | --'

local Music = {
  isLoaded = false,
  currentTrack = "menu", -- starts with menu as soon as we update our loading loop
  currentStage = 1,
  wantedStage = 1,
  onCalmPhaseDoneCallback = nil, -- callback
  onStageChange = nil, -- callback(stage)
}

function Music.getStage() -- 1 … 5
  return Music.currentStage
end

function Music.endBattleStage()
  Music.wantedStage = 2
end

function Music.endEverything()
  Music.wantedStage = 6
end

function Music.load()
  Music.tracks = {
    menu = love.audio.newSource("Assets/Music/menu.flac", "stream"),
    ingame = {
      intro = love.sound.newDecoder('Assets/Music/battle-intro-01.flac', 2048),
      { -- battle
        love.sound.newDecoder('Assets/Music/battle-01.flac', 2048),
        love.sound.newDecoder('Assets/Music/battle-02.flac', 2048),
        love.sound.newDecoder('Assets/Music/battle-03.flac', 2048),
        love.sound.newDecoder('Assets/Music/battle-04.flac', 2048),
      },
      { -- calmdown
        love.sound.newDecoder('Assets/Music/calmdown-01.flac', 2048),
        love.sound.newDecoder('Assets/Music/calmdown-02.flac', 2048),
      },
      { -- calm
        love.sound.newDecoder('Assets/Music/calm-01.flac', 2048),
        love.sound.newDecoder('Assets/Music/calm-02.flac', 2048),
        love.sound.newDecoder('Assets/Music/calm-03.flac', 2048),
      },
      { -- alarm
        love.sound.newDecoder('Assets/Music/calmdown-01.flac', 2048),
        love.sound.newDecoder('Assets/Music/calmdown-02.flac', 2048),
      },
      { -- game over
        love.sound.newDecoder('Assets/Music/gameover.flac', 2048),
      }
    },
  }
  Music.stagePools = {
    1, 2, 3, 3, 4, 5
  }
  function Music.stagePools:getForStage(stage)
    local poolidx = Music.stagePools[stage]
    local pool = Music.tracks.ingame[poolidx]
    local idx = math.random(#pool)
    -- print(poolidx, pool, idx)
    return pool[idx]
  end
  Music.volume = {
    menu = 1.0,
    game = 0.0,
  }

  local decoder = Music.stagePools:getForStage(1) -- sample one random file
  Music.gameTrackPlayer = love.audio.newQueueableSource(
    decoder:getSampleRate(), 
    decoder:getBitDepth(), 
    decoder:getChannelCount(), 
    8
  )

  Music.currentDecoder = Music.tracks.ingame.intro

  Music.tracks.menu:setVolume(0)
  Music.gameTrackPlayer:setVolume(0)

  Music.tracks.menu:setLooping(true)
  love.audio.play(Music.tracks.menu)

  Music.isLoaded = true
end

function Music.setTrack(track) -- none, menu, game

  Music.currentTrack = track or "none"
  if Music.currentTrack == "game" then
    Music.currentStage = 1 -- we start in battle mode
    Music.currentDecoder = Music.tracks.ingame.intro
    Music.currentDecoder:seek(0)
  end

end

function Music.update(dt)

  if not Music.isLoaded then
    return
  end
    
  while Music.gameTrackPlayer:getFreeBufferCount() > 0 do
    local buf = Music.currentDecoder:decode()
    if not buf then
      if Music.currentStage ~= Music.wantedStage then
        if Music.onStageChange then
          Music.onStageChange(Music.wantedStage, Music.currentStage)
        end
      end

      if Music.currentStage == 6 then
        -- Game over has now follow up
        Music.setTrack("none")

      else

        Music.currentStage = Music.wantedStage

        Music.currentDecoder:seek(0)
        Music.currentDecoder = Music.stagePools:getForStage(Music.currentStage)
        assert(Music.currentDecoder, tostring(Music.gameIntensity))
        buf = Music.currentDecoder:decode()
        assert(buf)

        if Music.currentStage > 1 then
          local nextState = Music.currentStage + 1
          if nextState > 5 then
            Music.wantedStage = 1
            
            if Music.onCalmPhaseDoneCallback then
              Music.onCalmPhaseDoneCallback()
            else
              -- print("GO TO BATTLE MODE!")
            end
          else
            Music.wantedStage = nextState
          end
        end
      end
    end

    if buf then
      Music.gameTrackPlayer:queue(buf)
    else
      break
    end

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

  Music.tracks.menu:setVolume(0.5 * Music.volume.menu)
  Music.gameTrackPlayer:setVolume(0.5 * Music.volume.game)

end

return Music