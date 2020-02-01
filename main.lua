io.stdout:setvbuf("no")

require "Lib.FancyPantsMath"

STI = require("Lib.sti")
GlobalGuard = require("Lib.GlobalGuard")
Gamestate = require("Lib.Gamestate")
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

Camera = {
    x = 0,
    y = 0,
    rotation = 0,
    zoom = 1.0,
}

GS = {
    menu = require("Gamestates.Menu"),
    loader = require("Gamestates.Loader"),
    repair = require("Gamestates.Repair"),
    shmup = require("Gamestates.Shmup")
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

function love.load()
    love.mouse.setVisible(false)
    GS.loader:load()
    GS.loader.targetState = "repair" -- uncomment to make default behaviour
    Gamestate.switch(GS.loader)
end

function love.keypressed( key, scancode, isrepeat )
    if key == "escape" then
        love.event.quit( 0 )
    end

    Gamestate:keypressed(key, scancode, isrepeat)
end

function love.update(dt)

    Camera.x = love.mouse.getX() - love.graphics.getWidth()/2
    Camera.y = love.mouse.getY() - love.graphics.getHeight()/2

    local zoom = 1.0
    if love.keyboard.isDown "e" then
        zoom = 2.0
    elseif love.keyboard.isDown "q" then
        zoom = 0.5
    end
    Camera.zoom = math.lerp(Camera.zoom, zoom, 0.1)
    
    if love.keyboard.isDown "1" then
        Camera.rotation = Camera.rotation - dt
    elseif love.keyboard.isDown "3" then
        Camera.rotation = Camera.rotation + dt
    end

    Input:update()
    Gamestate:update(dt)
end

function love.draw()
    love.graphics.origin()
    BackgroundInstance:emit("draw")

    love.graphics.origin()

    love.graphics.push()

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.scale(Camera.zoom)
    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(VirtualScreen.width/2, VirtualScreen.height/2)
    love.graphics.rotate(Camera.rotation)
    love.graphics.translate(-VirtualScreen.width/2, -VirtualScreen.height/2)

    love.graphics.translate(Camera.x, Camera.y)
    
    Gamestate:draw()
    
    love.graphics.pop()

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