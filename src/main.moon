io.stdout\setvbuf'no'

export wScr, hScr
wScr = love.graphics.getWidth
hScr = love.graphics.getHeight

require "game"
export flux = require "lib/flux/flux"

export kDEBUG = false

love.load = ->
    assert love.graphics.isSupported("canvas", "npot"), "Your graphic card is not supported, sorry!"
    export game = Game()

love.draw = ->
    game\draw()
    if kDEBUG
        love.graphics.origin()
        love.graphics.printf(love.timer.getFPS(), 0, 0, wScr(), "right")

love.update = (dt) ->
    flux.update(dt)
    game\update(dt)

love.keyreleased = (key) ->
    if key == "p"
        kDEBUG = not kDEBUG
    game\keyreleased(key)

love.mousepressed = (x, y, button) ->
    game\mousepressed(x, y, button)
