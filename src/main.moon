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

love.update = (dt) ->
    flux.update(dt)
    game\update(dt)

love.keyreleased = (key) ->
    game\keyreleased(key)

love.mousepressed = (x, y, button) ->
    game\mousepressed(x, y, button)
