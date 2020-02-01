io.stdout:setvbuf("no")

function dump(table)  -- for quick debugging
    for k, v in pairs(table) do
        print(k, v)
    end
    return table
end

function update(table, updates)
    for k, v in pairs(updates) do
        table[k] = v
    end
    return table
end

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
}

GS = {
    menu = require("Gamestates.Menu"),
    loader = require("Gamestates.Loader"),
    gameplay = require("Gamestates.Gameplay"),
}

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

function love.load()
    love.mouse.setVisible(false)
    GS.loader:load()
    GS.loader.targetState = "gameplay" -- uncomment to make default behaviour
    Gamestate.switch(GS.loader)
end

function love.keypressed( key, scancode, isrepeat )
    if key == "escape" then
        love.event.quit( 0 )
    end

    Gamestate:keypressed(key, scancode, isrepeat)
end

function love.update(dt)

    Music.update(dt)

    Input:update()
    Gamestate:update(dt)
end

function love.draw()
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