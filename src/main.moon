io.stdout\setvbuf'no'

export wScr, hScr
wScr = love.graphics.getWidth
hScr = love.graphics.getHeight

require "spacebase"
require "view"
export flux = require "lib/flux/flux"

love.load = ->
    assert love.graphics.isSupported("canvas", "npot"), "Your graphic card is not supported, sorry!"
    export spacebase = Spacebase()
    export view = View(spacebase)

love.draw = ->
    view\draw()

love.update = (dt) ->
    flux.update(dt)
    view\update(dt)

love.keyreleased = (key) ->
    switch(key)
        when "p"
            view\keyreleased(key)
        when "escape"
            love.event.quit()

love.mousepressed = (x, y, button) ->
    {mx, my} = view\coordinatesInWorld(x, y)
    spacebase\mousepressed(mx, my, button)
