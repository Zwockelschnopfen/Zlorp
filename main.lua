io.stdout:setvbuf("no")

GlobalGuard = require("Lib.GlobalGuard")
Gamestate = require("Lib.Gamestate")
Baton = require("Lib.Baton")
Concord = require("Lib.Concord")
Concord.init()

GS = {}
GS.default = require("Gamestates.default")

GlobalGuard.enableGuard()

function love.load()
    
    Gamestate.switch(GS.default)
end

function love.keypressed( key, scancode, isrepeat )
    if key == "escape" then
        love.event.quit( 0 )
    end

    Gamestate:keypressed(key, scancode, isrepeat)
end

function love.update(dt)            Gamestate:update(dt) end
function love.draw()                Gamestate:draw() end
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