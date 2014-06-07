io.stdout\setvbuf'no'

export wScr, hScr
wScr = love.graphics.getWidth
hScr = love.graphics.getHeight

require "spacebase"
require "view"
require "ui/ui"
export flux = require "lib/flux/flux"

love.load = ->
    assert love.graphics.isSupported("canvas", "npot"), "Your graphic card is not supported, sorry!"
    export spacebase = Spacebase()
    export view = View(spacebase)
    export ui = UI(spacebase)

love.draw = ->
    view\draw()
    love.graphics.origin()
    ui\draw()

love.update = (dt) ->
    flux.update(dt)
    view\update(dt)
    spacebase.mousePosition = view\coordinatesInWorld(love.mouse.getX(), love.mouse.getY())
    spacebase\update(dt)

love.keyreleased = (key) ->
    switch(key)
        when "p"
            view\keyreleased(key)
        when "escape"
            love.event.quit()

love.mousepressed = (x, y, button) ->
    ui\mousepressed(x, y, button)
