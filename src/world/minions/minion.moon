export ^

require "world/tile"
require "world/vector"
lume = require "lib/lume/lume"

class Minion
    kSpeed: 1 -- tile/s
    kMaxLife: 100

    new: (tile_x, tile_y) =>
        @x = Tile.kTILE_SIZE * tile_x + Tile.kTILE_SIZE / 2
        @y = Tile.kTILE_SIZE * tile_y + Tile.kTILE_SIZE / 2
        @missionState = nil
        @itemCarried = nil
        @path = {}
        @idling = true
        @life = Minion.kMaxLife

    draw: =>
        width = 5
        height = 20
        love.graphics.setColor(255, 255, 255)

        if @idling
            -- guy lying down: width and height are reversed
            love.graphics.rectangle("fill", 0, -width / 2, height, width)
        else
            love.graphics.rectangle("fill", -width / 2, -height / 2, width, height)

        -- draw carried item
        item = @getItem()
        if item
            love.graphics.translate(width / 2, 0)
            item\draw()

        if kDEBUG
            -- draw path
            currPos = @get_tile_coordinates(false)
            for i, cell in ipairs(@path)
                {next_x, next_y} = cell

                origin = @get_tile_coordinates(false)
                love.graphics.line(currPos.x - origin.x, currPos.y - origin.y, next_x - currPos.x, next_y - currPos.y)
                currPos = Vector(next_x, next_y)

    getItem: =>
        return @itemCarried

    update: (dt) =>
        -- follow the path set by the MinionScheduler
        if @path and #@path > 0
            -- go towards next point/position in path
            -- print "----"
            -- print lume.serialize(@path), "length", #@path
            {next_x, next_y} = @path[#@path]  -- last tile in path
            {nextPosition_x, nextPosition_y} = game.spacebase\tileToWorld(next_x, next_y)
            nextPosition = Vector(nextPosition_x, nextPosition_y)
            currPosition = Vector(@x, @y)
            -- print currPosition.x, currPosition.y
            -- print "to"
            -- print nextPosition.x, nextPosition.y
            distanceV = Vector(nextPosition.x - currPosition.x, nextPosition.y - currPosition.y)
            assert distanceV.x == 0 or distanceV.y == 0
            if distanceV\norm() > 0
                -- go towards next tile in path
                newPosition = Vector(currPosition.x, currPosition.y)
                for coord in *{'x', 'y'}
                    distance = distanceV[coord]
                    if distance ~= 0
                        prevDeltaCoord = nextPosition[coord] - newPosition[coord]
                        prevDirection = prevDeltaCoord / math.abs(prevDeltaCoord) -- 1 or -1
                        assert prevDirection == 1 or prevDirection == -1

                        newPosition[coord] += prevDirection * @kSpeed * Tile.kTILE_SIZE * dt

                        newDeltaCoord = nextPosition[coord] - newPosition[coord]
                        newDirection = newDeltaCoord / math.abs(newDeltaCoord)
                        if prevDirection ~= newDirection
                            -- we went "too far": snap to desired position
                            -- and pop the position in the path
                            newPosition[coord] = nextPosition[coord]
                @x = newPosition.x
                @y = newPosition.y
            else
                -- next tile in path is reached: remove it
                table.remove(@path)
        -- shooting
        if @itemCarried and @itemCarried.__class == Gun
            todo() -- TODO

    get_tile_coordinates: =>
        tile_coord = game.spacebase\worldToTile(@x, @y)
        return Vector(tile_coord[1], tile_coord[2])
