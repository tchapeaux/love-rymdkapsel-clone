export ^

class Star
    new: =>
        @x = love.math.randomNormal(wScr() / 4, wScr() / 2)
        @y = love.math.randomNormal(hScr() / 3, -@x)
        @parallaxFactor = love.math.randomNormal(0.5, 0.5) / 20
        @width = math.ceil(@parallaxFactor * 20 + (math.random(3) - 1))
        @height = math.random(4)
        color_blue = love.math.randomNormal(30, 0)
        @color = {100, 100, 100 + color_blue, 230}

    draw: (o_x, o_y) =>
        love.graphics.setColor(@color)
        draw_x = (@x + o_x * @parallaxFactor) % wScr()
        draw_y = (@y + o_y * @parallaxFactor) % hScr()
        love.graphics.rectangle("fill", draw_x, draw_y, @width, @height)
