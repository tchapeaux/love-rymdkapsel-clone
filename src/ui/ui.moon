export ^

require "ui/roomplacer"
require "ui/minionschedulerui"

class UI
    -- todo? separate roomPlacer and crewScheduler?
    new: (@game) =>
        @roomPlacer = RoomPlacer(@game.spacebase)
        -- @minionScheduler = MinionSchedulerUI(@spacebase.minionscheduler)

    draw: =>
        @roomPlacer\draw()

    mousepressed: (x, y, button) =>
        @roomPlacer\mousepressed(x, y, button)
