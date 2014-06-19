export ^

class Item
-- used for things on the map that minions can pick up

class Energy extends Item
    draw: =>
        love.graphics.setColor(66, 145, 135)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Material extends Item
    draw: =>
        love.graphics.setColor(243, 127, 183)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Fudge extends Item -- not sure of the name? pre-food stuff
    draw: =>
        love.graphics.setColor(87, 119, 32)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Food extends Item
    draw: =>
        love.graphics.setColor(159, 112, 19)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Gun extends Item
    draw: =>
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", -5, -5, 10, 10)
