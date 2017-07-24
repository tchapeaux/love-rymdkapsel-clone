export ^

require "world/tile"
require "world/rooms/rock"
require "world/rooms/corridor"
require "world/rooms/reactor"
require "world/rooms/extractor"
shapes = require "world/rooms/shape"

lume = require "lib/lume/lume"

class Spacebase
    -- Encapsulate the world grid and the Room structure
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
        @tileBelowMouse = nil  -- DEBUG

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
        temp_room = Reactor(shapes.t, {@kBASE_SIZE / 2 - 1, @kBASE_SIZE/2 + 2}, 1)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        temp_room = Extractor(shapes.o, {@kBASE_SIZE / 2 + 2, @kBASE_SIZE/2 + 2}, 0)
        temp_room\confirm()
        temp_room\build(true)
        table.insert(startupRooms, temp_room)
        for room in *startupRooms
            @addRoom(room)

    update: (dt) =>
        if @floatingRoom
            mx, my = @mousePosition[1], @mousePosition[2]
            {wx, wy} = @worldToTile(mx, my)
            @floatingRoom\updatePosition(wx, wy)
        for room in *@rooms
            room\update(dt)
        {mouseTile_x, mouseTile_y} = @worldToTile(@mousePosition[1], @mousePosition[2])
        @tileBelowMouse = @tileGrid[mouseTile_x][mouseTile_y]

    draw: =>
        tileSize = Tile.kTILE_SIZE
        totalSize = Spacebase.totalSize()
        if kDEBUG -- show grid
            for i=1, @kBASE_SIZE + 1
                love.graphics.setColor(255, 255, 255, 150)
                love.graphics.setLineWidth(1)
                i -= 1 -- begins at 0
                love.graphics.line(0, i * tileSize, totalSize, i * tileSize)
                love.graphics.line(i * tileSize, 0, i * tileSize, totalSize)
        for room in *@rooms
            @drawRoom(room)
        @drawPath(game.debug_minion.path)
        if @floatingRoom
            @drawRoom(@floatingRoom)
        if kDEBUG
            -- display neighbours
            love.graphics.setLineWidth(2)
            love.graphics.setColor({50,50,50})
            neighbors = {Tile.kRIGHT, Tile.kLEFT, Tile.kUP, Tile.kDOWN}
            for i=1,@kBASE_SIZE
                for j=1,@kBASE_SIZE
                    for n in *neighbors
                        if @tileGrid[i][j] and @tileGrid[i][j].neighbors[n]
                            neigh = @tileGrid[i][j].neighbors[n]
                            {x1, y1} = @tileToWorld(i, j)
                            {x2, y2} = @tileToWorld(neigh.row, neigh.col)
                            love.graphics.line(x1, y1, x2, y2)

    drawRoom: (room) =>
        i = room.row - 1
        j = room.col - 1
        love.graphics.push()
        love.graphics.translate(i * Tile.kTILE_SIZE, j * Tile.kTILE_SIZE)
        room\draw()
        love.graphics.pop()


    drawPath: (path) =>
        size = #path
        for i = 1, size - 1
            {row, col} = path[i]
            {row2, col2} = path[i + 1]
            {x, y} = @tileToWorld(row, col)
            {x2, y2} = @tileToWorld(row2, col2)
            love.graphics.setColor(255, 0, 0)
            love.graphics.line(x, y, x2, y2)

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

    isTile: (tile_x, tile_y, walkable_only=false) =>
        -- Return True if (tile_x, tile_y is occupied by a tile)
        -- if walkable is true, return True only for walkable tiles
        tile = @tileGrid[tile_x][tile_y]
        if tile == nil
            return false
        if walkable_only
            return tile.walkable
        return true

    getItems: () =>
        items = {}
        for room in *@rooms
            for item in *room\getItems()
                table.insert(items, item)
        return items

    updateNeighbors: =>
        -- TODO: refactor by iterating over @rooms (more efficient probably)
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

    pathFinding: (row1, col1, row2, col2, acceptSameRoom=false) =>
        -- Return a path (as a table of {row, col} coordinate) between two tiles
        -- Currently use Breadth-First Search (TODO: improve efficiency?)
        -- ie we iterate over a tile_queue, adding the neighbor of each tile to
        -- the queue and skipping over marked (already visited) ones, until we
        -- reach the end tile
        -- @param row1, col1: start tile of path
        -- @param row2, col2: end tile of path
        -- @param acceptSameRoom: if true, may return a path not ending at the end tile, but in the same room
        -- TODO: unit testing
        assert @tileGrid[row1][col1] ~= nil and @tileGrid[row2][col2] ~= nil, "pathFinding: start or end tile is nil"
        -- print "PathFinding", row1, col1, row2, col2
        endRoom = @tileGrid[row2][col2].room
        row, col = row1, col1
        tile_queue = {}
        marked = {} -- the mark is the previous coordinate in the path
        in_marked = (r, c) -> return marked[r] ~= nil and marked[r][c] ~= nil
        mark_tile = (r, c, prevCoor) ->
            if marked[r] == nil then marked[r] = {}
            marked[r][c] = prevCoor
        while row ~= row2 or col ~= col2
            -- print "current", row, col, "tilequeue is ", lume.serialize(tile_queue)
            -- print "tile_queue", lume.serialize(tile_queue)
            assert @tileGrid[row][col] ~= nil, "pathfinding: invalid state (current tile is nil)"
            tile = @tileGrid[row][col]
            -- special condition for acceptSameRoom
            if acceptSameRoom and tile.room == endRoom
                break
            for neigh in *tile.neighbors
                if neigh and not in_marked(neigh.row, neigh.col)
                    -- print "exploring", neigh.row, neigh.col, "from", row, col
                    mark_tile(neigh.row, neigh.col, {tile.row, tile.col})
                    table.insert(tile_queue, {neigh.row, neigh.col})
            if #tile_queue == 0
                return nil -- no path found
            nextTile = table.remove(tile_queue, 1)
            row, col = nextTile[1], nextTile[2]
        if acceptSameRoom
            assert @tileGrid[row][col].room == endRoom, "pathfinding: search returned a wrong tile. Searched: (#{row}, #{col}), got: (#{row2}, #{col2})}\n#{lume.serialize(marked)}"
        else
            assert row == row2 and col == col2, "pathfinding: search returned a wrong tile. Searched: (#{row}, #{col}), got: (#{row2}, #{col2})"
        -- retrace path back using marks
        path = {}
        table.insert(path, {row, col})
        loopCounter = 0
        while row ~= row1 or col ~= col1
            loopCounter += 1
            assert loopCounter <= @kBASE_SIZE * @kBASE_SIZE, "Pathfinding: infinite cycle in marks"
            assert @tileGrid[row][col] ~= nil
            {row, col} = marked[row][col]
            table.insert(path, {row, col})
        --print "return path", lume.serialize(path)
        return path


