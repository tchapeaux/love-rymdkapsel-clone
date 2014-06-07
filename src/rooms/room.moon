export ^

require "tile"
shapes  = require "rooms/shape"

class Room
    color: {0, 0, 0} -- should be overridden by children classes
    name: "abstract"
    new: (@shape, origin, @leftTurns, @finalized=false)=>
        -- parameters:
        -- @shape: a Shape
        -- @origin: point (0,0) for @shape
        -- @leftTurns: number of left turns to apply to the shape (orientation)
        -- apply left turns to the shape
        assert @leftTurns <= 3
        for i=1,@leftTurns
            @shape = shapes.turnLeft(@shape)
        @x = origin[1]
        @y = origin[2]
        @tiles = {}
        -- fill up the tile vector
        @constructTiles()

    draw: =>
        love.graphics.setColor(@color)
        -- draw each tile of the shape
        for {ox, oy} in *@shape
            _x = ox * Tile.kTILE_SIZE
            _y = oy * Tile.kTILE_SIZE
            _w = Tile.kTILE_SIZE
            _h = Tile.kTILE_SIZE
            love.graphics.setLineWidth(5)
            fillage = if @finalized then "fill" else "line"
            love.graphics.rectangle(fillage, _x, _y, _w, _h)

    updatePosition: (newX, newY) =>
        @x = newX
        @y = newY
        @tiles = {}
        @constructTiles()

    constructTiles: =>
        for {ox, oy} in *@shape
            tile = Tile(@x + ox, @y + oy, @)
            table.insert(@tiles, tile)

    finalize: =>
        @finalized = true
        -- TODO : find neighbors
