export ^

require "tile"
require "items"
shapes  = require "rooms/shape"

class Room
    states: {
        floating: "floating"
        construction: "construction"
        finished: "finished"
    }
    color: {0, 0, 0} -- should be overridden by children classes
    name: "abstract"
    required_resources: {
        [Energy]: 0
        [Material]: 0
        [Food]: 0
    }

    new: (@shape, origin, @leftTurns)=>
        -- parameters:
        -- @shape: a Shape
        -- @origin: point (0,0) for @shape
        -- @leftTurns: number of left turns to apply to the shape (orientation)
        -- apply left turns to the shape
        @state = @states.floating
        @current_resources = {
            [Energy]: 0
            [Material]: 0
            [Food]: 0
        }
        assert @leftTurns <= 3
        for i=1,@leftTurns
            @shape = shapes.turnLeft(@shape)
        @row = origin[1]
        @col = origin[2]
        -- fill up the tile vector
        @tiles = {}
        @constructTiles()

    constructTiles: =>
        for {offset_row, offset_col} in *@shape
            tile = Tile(@row + offset_row, @col + offset_col, @)
            table.insert(@tiles, tile)

    draw: =>
        outline = @state == @states.floating
        fillage = if @state == @states.finished then "fill" else "line"
        w = Tile.kTILE_SIZE
        h = Tile.kTILE_SIZE
        m = Tile.kTILE_SIZE / 10 -- margin
        for tile in *@tiles
            offset_row = tile.row - @row
            offset_col = tile.col - @col
            x = offset_row * Tile.kTILE_SIZE
            y = offset_col * Tile.kTILE_SIZE
            love.graphics.setLineWidth(5)
            love.graphics.setColor(@color)
            love.graphics.rectangle(fillage, x + m, y + m, w - 2 * m, h - 2 * m)
            if outline
                love.graphics.setColor(255, 255, 255, 100)
                love.graphics.rectangle("line", x, y, w, h)
            -- if tile.itemContained
            --     love.graphics.push()
            --     love.graphics.translate(w / 2, h / 2)
            --     tile.itemContained\draw()
            --     love.graphics.pop()

    updatePosition: (newRow, newCol) =>
        @row = newRow
        @col = newCol
        @tiles = {}
        @constructTiles()

    confirm: =>
        assert @state == @states.floating
        @state = @states.construction
        -- TODO : find neighbors?

    has_all_resources: =>
        ok = true
        for res in *{Energy, Material, Food}
            ok and= @required_resources[res] == @current_resources[res]
        return ok

    getItems: =>
        items = {}
        for tile in *@tiles
            if tile.itemContained
                table.insert(items, tile.itemContained)
        return items


    build: (force=false) =>
        assert @state == @states.construction
        unless force
            assert @has_all_resources()
        @state = @states.finished
