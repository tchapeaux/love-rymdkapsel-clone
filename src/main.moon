io.stdout\setvbuf'no'

export wScr, hScr
wScr = love.graphics.getWidth
hScr = love.graphics.getHeight

require "game"
export flux = require "lib/flux/flux"
export helper = require "helper"

export kDEBUG = false

--collectgarbage("stop") -- DEBUG DEBUG REMOVE ME

love.load = ->
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

love.mousereleased = (x, y, button) ->
    game\mousereleased(x, y, button)
