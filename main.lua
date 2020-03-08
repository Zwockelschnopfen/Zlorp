io.stdout:setvbuf("no")

require "Lib.FancyPantsTables"
require "Lib.FancyPantsMath"

STI = require("Lib.sti")
GlobalGuard = require("Lib.GlobalGuard")
Gamestate = require("Lib.Gamestate")
Music = require "Code.Music"
local Baton = require("Lib.Baton")

Input = Baton.new {
    controls = {
        left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:x', 'button:a', 'key:return'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}

Concord = require("Lib.Concord")
Concord.init()

HUDInstance = Concord.instance()
RepairInstance = Concord.instance()
ShmupInstance = Concord.instance()
BackgroundInstance = Concord.instance()

-- Virtual screen size
VirtualScreen = {
    width = 1920,
    height = 1080,
    aspect = 1920.0 / 1080.0
}

GS = {
    menu = require("Gamestates.Menu"),
    loader = require("Gamestates.Loader"),
    gameplay = require("Gamestates.Gameplay"),
    gameover = require("Gamestates.GameOver"),
}

defaultFont = love.graphics.newFont(40)

DebugVars = {}

function debugPrint(val)
    local cache = { }  
  
    local function printItem(indent,x)
      if cache[x] then
        io.write("<backreference>")
      else
        local t = type(x)
        if t == "table" then
          cache[t] = true
          io.write("{\n")
          for k,v in pairs(x) do
            io.write(indent.."\t", '[')
            printItem("", k)
            io.write('] = ')
            printItem(indent.."\t", v)
            io.write(',\n')
          end
          io.write(indent, "}")
        elseif t == "string" then
          io.write('"', x, '"')
        else
          io.write(tostring(x))
        end
      end
    end
  
    printItem("", val)
    io.write("\n")
  
  end

GlobalGuard.enableGuard()

GS.loader:addCallback(function()
    local Starfield = require "Code.Components.Starfield"
    local Background = require "Code.Systems.Background"

    local sfe = Concord.entity.new()
    sfe:give(Starfield)

    BackgroundInstance:addSystem(Background(), "draw")
    BackgroundInstance:addEntity(sfe)
end)

GS.loader:addCallback(Music.load)

GS.loader:addCallback(function()
    local Highscore = require "Code.Highscore"
    Highscore:loadDataset()
end)

function love.load()
    love.mouse.setVisible(false)
    GS.loader:load()
    -- GS.loader.targetState = "gameplay" -- uncomment to make default behaviour
    Gamestate.switch(GS.loader)
end

function love.keypressed( key, scancode, isrepeat )
    -- if key == "escape" then
    --     love.event.quit( 0 )
    -- end

    Gamestate:keypressed(key, scancode, isrepeat)
end

function love.update(dt)

    Music.update(dt)

    Input:update()
    Gamestate:update(dt)
end

function love.draw()
    love.graphics.setFont(defaultFont)
    love.graphics.origin()
    BackgroundInstance:emit("draw")
    
    Gamestate:draw()
end

function love.keyreleased(...)      Gamestate:keyreleased(...)end
function love.mousemoved(...)       Gamestate:mousemoved(...) end
function love.mousepressed(...)     Gamestate:mousepressed(...) end
function love.mousereleased(...)    Gamestate:mousereleased(...) end
function love.lowmemory(...)        Gamestate:lowmemory(...) end
function love.quit(...)             Gamestate:quit(...) end
function love.focus(...)            Gamestate:focus(...) end
function love.mousefocus(...)       Gamestate.mousefocus(...) end
function love.resize(...)           Gamestate.resize(...) end
function love.visible(...)          Gamestate.visible(...) end
function love.textinput(...)        Gamestate.textinput(...) end
function love.wheelmoved(...)       Gamestate.wheelmoved(...) end
function love.gamepadaxis(...)      Gamestate.gamepadaxis(...) end
function love.gamepadpressed(...)   Gamestate.gamepadpressed(...) end
function love.gamepadreleased(...)  Gamestate.gamepadreleased(...) end
function love.joystickadded(...)    Gamestate.joystickadded(...) end
function love.joystickaxis(...)     Gamestate.joystickaxis(...) end
function love.joystickhat(...)      Gamestate.joystickhat(...) end
function love.joystickpressed(...)  Gamestate.joystickpressed(...) end
function love.joystickreleased(...) Gamestate.joystickreleased(...) end
function love.joystickremoved(...)  Gamestate.joystickremoved(...) end
function love.touchmoved(...)       Gamestate.touchmoved(...) end
function love.touchpressed(...)     Gamestate.touchpressed(...) end
function love.touchreleased(...)    Gamestate.touchreleased(...) end