export ^

require "tile"
require "rooms/rock"
require "rooms/corridor"
require "rooms/reactor"
require "rooms/extractor"
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

        -- build the first rooms
        startupRooms = {}
        temp_room = Rock(shapes.dot, {@kBASE_SIZE / 2 - 1, @kBASE_SIZE/2}, 0)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Rock(shapes.dot, {@kBASE_SIZE / 2 + 1, @kBASE_SIZE/2}, 0)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Rock(shapes.dot, {@kBASE_SIZE / 2, @kBASE_SIZE/2 - 1}, 0)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Corridor(shapes.t, {@kBASE_SIZE / 2, @kBASE_SIZE/2}, 1)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Reactor(shapes.t, {@kBASE_SIZE / 2 - 1, @kBASE_SIZE/2 + 3}, 1)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Extractor(shapes.o, {@kBASE_SIZE / 2 + 2, @kBASE_SIZE/2 + 2}, 0)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        for room in *startupRooms
            @addRoom(room)

        @crew = {}

    update: (dt) =>
        if @floatingRoom
            mx, my = @mousePosition[1], @mousePosition[2]
            {wx, wy} = @worldToTile(mx, my)
            @floatingRoom\updatePosition(wx, wy)
        for room in *@rooms
            room\update(dt)

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
        -- debug: see neighbors
        if false
            love.graphics.setLineWidth(2)
            love.graphics.setColor({50,50,50})
            neighbors = {Tile.kRIGHT, Tile.kLEFT, Tile.kUP, Tile.kDOWN}
            for i=1,@kBASE_SIZE
                for j=1,@kBASE_SIZE
                    for n in *neighbors
                        if @tileGrid[i][j] and @tileGrid[i][j].neighbors[n]
                            neigh = @tileGrid[i][j].neighbors[n]
                            {x1, y1} = @tileCenterCoordinates(i, j)
                            {x2, y2} = @tileCenterCoordinates(neigh.x, neigh.y)
                            love.graphics.line(x1, y1, x2, y2)


    drawRoom: (room) =>
            i = room.row - 1
            j = room.col - 1
            love.graphics.push()
            love.graphics.translate(i * Tile.kTILE_SIZE, j * Tile.kTILE_SIZE)
            room\draw()
            love.graphics.pop()

    placeFloatingRoom: =>
        -- TODO: assert that floating room is valid
        assert(@floatingRoom)
        @floatingRoom\confirm()
        @addRoom(@floatingRoom)
        @floatingRoom = nil


    addRoom: (room) =>
        table.insert(@rooms, room)
        for tile in *room.tiles
            @tileGrid[tile.row][tile.col] = tile
        @updateNeighbors()

    worldToTile: (x, y) =>
        i = math.ceil(x / Tile.kTILE_SIZE)
        j = math.ceil(y / Tile.kTILE_SIZE)
        return {i, j}

    tileToWorld: (i, j) =>
        x = (i - 1) * Tile.kTILE_SIZE + 0.5 * Tile.kTILE_SIZE
        y = (j - 1) * Tile.kTILE_SIZE + 0.5 * Tile.kTILE_SIZE
        return {x, y}

    getItems: (fromCrew=true, fromRooms=true) =>
        items = {}
        if fromCrew
            for minion in *@crew
                item = minion\getItem()
                if item
                    table.insert(items, item)
        if fromRooms
            for room in *@rooms
                for item in *room\getItems()
                    table.insert(items, item)
        return items

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
