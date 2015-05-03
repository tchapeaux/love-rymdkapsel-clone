export ^

require "world/tile"
require "world/vector"

class Minion
    kSpeed: 100 -- px/s^2
    kMaxLife: 100

    new: (@x, @y) =>
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
            {next_x, next_y} = @path[1]
            nextPosition = Vector(next_x, next_y)
            distanceV = Vector(nextPosition.x - @x, nextPosition.y - @y)
            assert distanceV.x == 0 or distanceV.y == 0
            newPosition = Vector(@x, @y)
            for coord in *{'x', 'y'}
                distance = distanceV[coord]
                if distance == 0
                    direction = distance / math.abs(distance) -- 1 or -1
                    newPosition[coord] += @kSpeed * dt
                    newDistance = newPosition[coord] - nextPosition[coord]
                    newDirection = newDistance / math.abs(newDistance)
                    if direction ~= newDirection
                        -- we went "too far": snap to desired position
                        -- and pop the position in the path
                        newPosition[coord] = nextPosition[coord]
                        table.remove(@path, 1)
        -- shooting
        if @itemCarried and @itemCarried.__class == Gun
            todo() -- TODO
