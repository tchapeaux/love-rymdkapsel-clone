export ^

class View
    new: (@spacebase) =>
        spacebaseSize = @spacebase.totalSize()
        @canvas = love.graphics.newCanvas(spacebaseSize, spacebaseSize)
        @offset_x = 0
        @offset_y = 0
        @zoom = 1

        @max_off = 0
        @min_off = -spacebaseSize
        @max_zoom = 2
        @min_zoom = .5

    update: (dt) =>
        @offset_x = math.max(@min_off, @offset_x)
        @offset_x = math.min(@max_off, @offset_x)
        @offset_y = math.max(@min_off, @offset_y)
        @offset_y = math.min(@max_off, @offset_y)
        @zoom = math.max(@min_zoom, @zoom)
        @zoom = math.min(@max_zoom, @zoom)

    draw: =>
        @canvas\clear()
        love.graphics.setCanvas(@canvas)
        @spacebase\draw()
        love.graphics.setCanvas()
        love.graphics.translate(@offset_x * @zoom, @offset_y * @zoom)
        love.graphics.scale(@zoom, @zoom)
        love.graphics.draw(@canvas)

    keyreleased: (key) =>
        switch(key)
            when "down"
                flux.to(@, 0.5, {offset_y: @offset_y - 50 * @zoom})
            when "up"
                flux.to(@, 0.5, {offset_y: @offset_y + 50 * @zoom})
            when "left"
                flux.to(@, 0.5, {offset_x: @offset_x + 50 * @zoom})
            when "right"
                flux.to(@, 0.5, {offset_x: @offset_x - 50 * @zoom})
            when "i"
                flux.to(@, 0.5, {zoom: @zoom * 1.1})
            when "o"
                flux.to(@, 0.5, {zoom: @zoom / 1.1})

    coordinatesInWorld: (x, y) =>
        x /= @zoom
        y /= @zoom
        x -= @offset_x
        y -= @offset_y
        return {x, y}
