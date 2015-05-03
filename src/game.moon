export ^

require "world/spacebase"
require "gameview"
require "world/minions/scheduler"
require "ui/ui"

class Game
    new: =>
        @spacebase = Spacebase()
        @view = GameView(@)
        @minionscheduler = MinionScheduler(@)
        @minionscheduler\create_minion(@spacebase.kBASE_SIZE / 2, @spacebase.kBASE_SIZE / 2)
        @minionscheduler\assign(@minionscheduler.missionTypes.idle, @minionscheduler.missionTypes.engineering)
        @ui = UI(@)

    update: (dt) =>
        @view\update(dt)
        @spacebase.mousePosition = @view\coordinatesInWorld(love.mouse.getX(), love.mouse.getY())
        @spacebase\update(dt)
        @minionscheduler\update(dt)

    draw: =>
        @view\draw()
        love.graphics.origin()
        @ui\draw()

    keyreleased: (key) =>
        switch(key)
            when "p"
                @view\keyreleased(key)
            when "escape"
                love.event.quit()

    mousepressed: (x, y, button) =>
        @ui\mousepressed(x, y, button)
