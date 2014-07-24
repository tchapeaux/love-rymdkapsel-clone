export ^

class Button
    font: love.graphics.newFont("res/fonts/Ubuntu/Ubuntu-RI.ttf", 15)

    new: (@x, @y, @w, @h, @text, @color) =>

    draw: (is_selected) =>
        love.graphics.setFont(@font)
        love.graphics.setColor(@color)
        love.graphics.printf(@text, @x, @y + @h / 2, @w, "center")
        if is_selected
            love.graphics.setColor(100, 100, 120, 50)
            love.graphics.rectangle("fill", @x, @y, @w, @h)

    isInside: (x, y) =>
        return @x < x and x < @x + @w and @y < y and y < @y + @h
