export ^

require "tile"

class Room
    new: (@shape, @origin, @leftTurns)=>
        -- parameters:
        -- - @shape: a Shape
        -- - @origin: point (0,0) for @shape
        -- - @leftTurns: number of left turns to apply to the shape
        @tiles = {}
        @x = origin[1]
        @y = origin[2]
        for i=1,@leftTurns
            @shape = turnShapeLeft(@shape)
        for {ox, oy} in *@shape
            tile = Tile(@x + ox, @y + oy, @)
            table.insert(@tiles, tile)
        @color = nil -- to be defined by children class

    draw: =>
        love.graphics.setColor(@color)
        for {ox, oy} in *@shape
            x = ox * Tile.kTILE_SIZE
            y = oy * Tile.kTILE_SIZE
            w = Tile.kTILE_SIZE
            h = Tile.kTILE_SIZE
            love.graphics.rectangle("fill", x, y, w, h)
