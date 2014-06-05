export ^

require "star"

class View
    new: (@spacebase) =>
        spacebaseSize = @spacebase.totalSize()
        @canvas = love.graphics.newCanvas(spacebaseSize, spacebaseSize)
        @offset_center_x = -spacebaseSize / 2
        @offset_center_y = -spacebaseSize / 2
        @zoom = 1

        @offset_speed = 500  -- px/s
        @zoom_rate = 0.5
        @max_offset = spacebaseSize
        @min_offset = 0
        @max_zoom = 2
        @min_zoom = .5

        @starField = {}
        number_of_stars = 1000
        for i=1,number_of_stars
            table.insert(@starField, Star())

    update: (dt) =>
        if love.keyboard.isDown("down")
            @offset_center_y -= @offset_speed * dt
        if love.keyboard.isDown("up")
            @offset_center_y += @offset_speed * dt
        if love.keyboard.isDown("right")
            @offset_center_x -= @offset_speed * dt
        if love.keyboard.isDown("left")
            @offset_center_x += @offset_speed * dt
        if love.keyboard.isDown("i")
            @zoom += @zoom * @zoom_rate * dt
        if love.keyboard.isDown("o")
            @zoom -= @zoom * @zoom_rate * dt
        -- @offset_center_x = math.max(@min_offset, @offset_center_x)
        -- @offset_center_x = math.min(@max_offset, @offset_center_x)
        -- @offset_center_y = math.max(@min_offset, @offset_center_y)
        -- @offset_center_y = math.min(@max_offset, @offset_center_y)
        -- @zoom = math.max(@min_zoom, @zoom)
        -- @zoom = math.min(@max_zoom, @zoom)

    draw: =>
        @draw_starfield()
        @draw_spacebase()
        -- @draw_ui()

    draw_starfield: =>
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, wScr(), hScr())
        for star in *@starField
            star\draw(@offset_center_x, @offset_center_y)

    draw_ui: =>
        love.graphics.origin()
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, wScr(), hScr() / 20)
        love.graphics.rectangle("fill", 0, 19 * hScr() / 20, wScr(), hScr() / 20)
        love.graphics.setColor(255,255,255)
        love.graphics.line(0, hScr() / 20, wScr(), hScr() / 20)
        love.graphics.line(0, 19 * hScr() / 20, wScr(), 19 * hScr() / 20)
        -- TODO

    draw_spacebase: =>
        w, h = wScr(), hScr()
        @canvas\clear(0, 0, 0, 0) -- clear to transparent
        love.graphics.setCanvas(@canvas)
        @spacebase\draw()
        love.graphics.setCanvas()
        love.graphics.scale(@zoom, @zoom)
        translate_x = @offset_center_x + w / (2 * @zoom)
        translate_y = @offset_center_y + h / (2 * @zoom)
        love.graphics.translate(translate_x, translate_y)
        -- love.graphics.scale(1, 0.5)
        -- love.graphics.rotate(math.pi/4)
        -- love.graphics.circle("fill", 0, 0, 10)
        love.graphics.draw(@canvas)


    keyreleased: (key) =>
        switch(key)
            when("p")
                print(@offset_center_x, @offset_center_y, @spacebase\totalSize())

    coordinatesInWorld: (x, y) =>
        print(x,y)
        x /= @zoom
        y /= @zoom
        x -= @offset_center_x + wScr() / (2 * @zoom)
        y -= @offset_center_y + hScr() / (2 * @zoom)
        print(x,y)
        return {x, y}
