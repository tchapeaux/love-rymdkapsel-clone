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

    getItem: =>
        return @itemCarried

    update: (dt) =>
        -- follow the path set by the MinionScheduler
        if @path and #@path > 0
            -- go towards next point/position in path
            -- print "----"
            -- print lume.serialize(@path), "length", #@path
            {next_x, next_y} = @path[#@path]  -- last tile in path
            nextPosition = Vector(next_x, next_y)
            currPosition = @get_tile_coordinates(false)
            -- print currPosition.x, currPosition.y
            -- print "to"
            -- print nextPosition.x, nextPosition.y
            distanceV = Vector(nextPosition.x - currPosition.x, nextPosition.y - currPosition.y)
            -- print "distance", distanceV.x, distanceV.y
            assert distanceV.x == 0 or distanceV.y == 0
            if distanceV\norm() > 0.01
                -- go towards next tile in path
                newPosition = Vector(currPosition.x, currPosition.y)
                for coord in *{'x', 'y'}
                    distance = distanceV[coord]
                    if distance ~= 0
                        oldDeltaCoord = nextPosition[coord] - newPosition[coord]
                        oldDirection = oldDeltaCoord / math.abs(oldDeltaCoord) -- 1 or -1
                        newPosition[coord] += oldDirection * @kSpeed * dt

                        newDeltaCoord = nextPosition[coord] - newPosition[coord]
                        newDirection = newDeltaCoord / math.abs(newDeltaCoord)
                        if oldDirection ~= newDirection
                            -- we went "too far": snap to desired position
                            -- and pop the position in the path
                            newPosition[coord] = nextPosition[coord]
                @x = newPosition.x * Tile.kTILE_SIZE + 0.5 * Tile.kTILE_SIZE
                @y = newPosition.y * Tile.kTILE_SIZE + 0.5 * Tile.kTILE_SIZE
            else
                -- next tile in path is reached: remove it
                table.remove(@path)
        -- shooting
        if @itemCarried and @itemCarried.__class == Gun
            todo() -- TODO

    get_tile_coordinates: (snap=true) =>
        coord = Vector((@x / Tile.kTILE_SIZE) - 0.5, (@y / Tile.kTILE_SIZE) - 0.5)
        if snap
            coord = Vector(math.floor(coord.x), math.floor(coord.y))
        return coord
