export ^

class Star
    new: =>
        -- TODO: weighted repartition (more natural)
        @x = love.math.randomNormal(wScr() / 4, wScr() / 2)
        @y = love.math.randomNormal(hScr() / 3, -@x)
        @parallaxFactor = (math.random() + 0.5) / 20
        @size = love.math.randomNormal(1, 1)
        color_blue = love.math.randomNormal(30, 0)
        @color = {100, 100, 100 + color_blue, 230}

    draw: (o_x, o_y) =>
        love.graphics.setColor(@color)
        draw_x = (@x + o_x * @parallaxFactor) % wScr()
        draw_y = (@y + o_y * @parallaxFactor) % hScr()
        love.graphics.circle("fill", draw_x, draw_y, @size)
