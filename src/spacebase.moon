export ^

require "tile"
require "rooms/rock"
require "rooms/corridor"
shapes = require "rooms/shape"

class Spacebase
    kBASE_SIZE: 20  -- in tile²
    totalSize: ->
        return Spacebase.kBASE_SIZE * Tile.kTILE_SIZE

    new: =>
        @tileGrid = {}
        for i=1, @kBASE_SIZE
            table.insert(@tileGrid, {})
            for j=1, @kBASE_SIZE
                table.insert(@tileGrid[i], nil)
        @rooms = {}
        @mousePosition = {0, 0} -- updated by external class
        @floatingRoom = nil

        -- build the first room
        @addRoom(Rock(shapes.dot, {@kBASE_SIZE / 2 - 1, @kBASE_SIZE/2}, 0, true))
        @addRoom(Rock(shapes.dot, {@kBASE_SIZE / 2 + 1, @kBASE_SIZE/2}, 0, true))
        @addRoom(Rock(shapes.dot, {@kBASE_SIZE / 2, @kBASE_SIZE/2 - 1}, 0, true))
        @addRoom(Corridor(shapes.t, {@kBASE_SIZE / 2, @kBASE_SIZE/2}, 1, true))

    update: (dt) =>
        if @floatingRoom
            mx, my = @mousePosition[1], @mousePosition[2]
            -- world position
            {wx, wy} = @screenToTileCoordinates(mx, my)
            @floatingRoom\updatePosition(wx, wy)

    draw: =>
        tileSize = Tile.kTILE_SIZE
        totalSize = Spacebase.totalSize()
        for i=1, @kBASE_SIZE + 1
            love.graphics.setColor(255, 255, 255, 150)
            love.graphics.setLineWidth(1)
            i -= 1 -- begins at 0
            love.graphics.line(0, i * tileSize, totalSize, i * tileSize)
            love.graphics.line(i * tileSize, 0, i * tileSize, totalSize)
        for room in *@rooms
            @drawRoom(room)
        if @floatingRoom
            @drawRoom(@floatingRoom)

    drawRoom: (room) =>
            i = room.x - 1
            j = room.y - 1
            love.graphics.push()
            love.graphics.translate(i * Tile.kTILE_SIZE, j * Tile.kTILE_SIZE)
            room\draw()
            love.graphics.pop()

    placeFloatingRoom: =>
        -- TODO: assert that floating room is valid
        @floatingRoom\finalize()
        @addRoom(@floatingRoom)
        @floatingRoom = nil


    addRoom: (room) =>
        table.insert(@rooms, room)
        for tile in *room.tiles
            @tileGrid[tile.x][tile.y] = tile
        @updateNeighbors()

    screenToTileCoordinates: (x, y) =>
        i = math.ceil(x / Tile.kTILE_SIZE)
        j = math.ceil(y / Tile.kTILE_SIZE)
        return {i, j}

    mousepressed: (x, y, button) =>
        {i, j} = @screenToTileCoordinates(x, y)
        room = Rock(shapes.random(), {i, j}, 1)
        @addRoom(room)

    updateNeighbors: =>
        for i=1,@kBASE_SIZE
            for j=1,@kBASE_SIZE
                tile = @tileGrid[i][j]
                if tile
                    if i < @kBASE_SIZE
                        tile.neighbors[Tile.kRIGHT] = @tileGrid[i + 1][j]
                    if i > 1
                        tile.neighbors[Tile.kLEFT] = @tileGrid[i - 1][j]
                    if j > 1
                        tile.neighbors[Tile.kUP] = @tileGrid[i][j - 1]
                    if j < @kBASE_SIZE
                        tile.neighbors[Tile.kDOWN] = @tileGrid[i][j + 1]
