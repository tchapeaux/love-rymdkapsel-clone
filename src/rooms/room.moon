export ^

require "tile"

class Room
    new: (@shape, @origin, @orientation)=>
        @tiles = {}
        @x = origin[1]
        @y = origin[2]
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
