export ^

require "ui/roomplacer"
require "ui/minionschedulerui"

class UI
    new: (@game) =>
        @roomPlacer = RoomPlacer(@game.spacebase)
        @minionScheduler = MinionSchedulerUI(@game.spacebase.minionscheduler)

    draw: =>
        @roomPlacer\draw()
        @minionScheduler\draw()

    isScreenPosInUI: (x, y) =>
        w, h = wScr(), hScr()
        return y < h * @roomPlacer.hRatio or y > h * (1 - @minionScheduler.hRatio)

    mousepressed: (x, y, button) =>
        @roomPlacer\mousepressed(x, y, button)
        @minionScheduler\mousepressed(x, y, button)
