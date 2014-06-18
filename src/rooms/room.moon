export ^

require "tile"
shapes  = require "rooms/shape"

class Room
    states: { -- is there a simpler way to represent states?
        "floating": "floating"
        "construction": "construction"
        "finished": "finished"
    }
    color: {0, 0, 0} -- should be overridden by children classes
    name: "abstract"
    required_energy: 0
    required_resources: 0
    required_food: 0

    new: (@shape, origin, @leftTurns)=>
        -- parameters:
        -- @shape: a Shape
        -- @origin: point (0,0) for @shape
        -- @leftTurns: number of left turns to apply to the shape (orientation)
        -- apply left turns to the shape
        @state = @states.floating
        assert @leftTurns <= 3
        for i=1,@leftTurns
            @shape = shapes.turnLeft(@shape)
        @x = origin[1]
        @y = origin[2]
        -- fill up the tile vector
        @tiles = {}
        @constructTiles()
        -- materials
        @current_energy = 0
        @current_resources = 0
        @current_food = 0

    constructTiles: =>
        for {ox, oy} in *@shape
            tile = Tile(@x + ox, @y + oy, @)
            table.insert(@tiles, tile)

    draw: =>
        -- draw each tile of the shape
        outline = @state == @states.floating
        fillage = if @state == @states.finished then "fill" else "line"
        w = Tile.kTILE_SIZE
        h = Tile.kTILE_SIZE
        m = Tile.kTILE_SIZE / 10 -- margin
        for {ox, oy} in *@shape
            x = ox * Tile.kTILE_SIZE
            y = oy * Tile.kTILE_SIZE
            love.graphics.setLineWidth(5)
            love.graphics.setColor(@color)
            love.graphics.rectangle(fillage, x + m, y + m, w - 2 * m, h - 2 * m)
            if outline
                love.graphics.setColor(255, 255, 255, 100)
                love.graphics.rectangle("line", x, y, w, h)

    updatePosition: (newX, newY) =>
        @x = newX
        @y = newY
        @tiles = {}
        @constructTiles()

    confirm: =>
        assert @state == @states.floating
        @state = @states.construction
        -- TODO : find neighbors?

    has_all_materials: =>
        energy_ok = @current_energy == @required_energy
        resources_ok = @current_resources == @required_resources
        food_ok = @current_food == @required_food
        return energy_ok and resources_ok and food_ok

    build: (force=false) =>
        assert @state == @states.construction
        unless force
            assert @has_all_materials()
        @state = @states.finished

