export ^

require "tile"
require "shape"
require "rooms/rock"

class Spacebase
    kBASE_SIZE: 100  -- in tile²
    totalSize: ->
        return Spacebase.kBASE_SIZE * Tile.kTILE_SIZE

    new: =>
        @tileGrid = {}
        for i=1, @kBASE_SIZE
            table.insert(@tileGrid, {})
            for j=1, @kBASE_SIZE
                table.insert(@tileGrid[i], nil)
        @rooms = {}
        firstRoom = Rock(randomShape(), {10, 10}, nil)
        @addRoom(firstRoom)

    draw: =>
        for room in *@rooms
            i = room.x - 1
            j = room.y - 1
            love.graphics.push()
            love.graphics.translate(i * Tile.kTILE_SIZE, j * Tile.kTILE_SIZE)
            room\draw()
            love.graphics.pop()
        tileSize = Tile.kTILE_SIZE
        totalSize = Spacebase.totalSize()
        for i=1,@kBASE_SIZE + 1
            i -= 1 -- begins at 0
            love.graphics.line(0, i * tileSize, totalSize, i * tileSize)
            love.graphics.line(i * tileSize, 0, i * tileSize, totalSize)

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
        room = Rock(randomShape(), {i, j}, nil)
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
