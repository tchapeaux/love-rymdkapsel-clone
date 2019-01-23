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
        @minionscheduler\create_minion(@spacebase.kBASE_SIZE / 2 - 1, @spacebase.kBASE_SIZE / 2)
        @ui = UI(@)
        @debug_minion = Minion(@spacebase.kBASE_SIZE / 2 - 1, @spacebase.kBASE_SIZE / 2)

    update: (dt) =>
        @view\update(dt)
        @spacebase.mousePosition = @view\screenCoordinateToWorld(love.mouse.getX(), love.mouse.getY())
        @spacebase\update(dt)
        @minionscheduler\update(dt)
        @debug_minion\update(dt)

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

        -- DEBUG MINION path
        if @spacebase.floatingRoom == nil
            if not @ui\isScreenPosInUI(x, y)
                {world_x, world_y} = @view\screenCoordinateToWorld(x, y)
                {tile_x, tile_y} = @spacebase\worldToTile(world_x, world_y)
                if @spacebase\isTile(tile_x, tile_y)
                    minion_coord = @debug_minion\get_tile_coordinates()
                    path = @spacebase\pathFinding minion_coord.x,
                        minion_coord.y,
                        tile_x,
                        tile_y,
                        false
                    if path
                        @debug_minion.path = path

    mousereleased: (x, y, button) =>
        @ui\mousereleased(x, y, button)
