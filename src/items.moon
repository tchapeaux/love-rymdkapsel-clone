export ^

class Item
-- used for things on the map that minions can pick up
    color: {0, 0, 0}

class Energy extends Item
    color: {66, 145, 135}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Material extends Item
    color: {243, 127, 183}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Sludge extends Item
    color: {87, 119, 32}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Food extends Item
    color: {159, 112, 19}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class Gun extends Item
    color: {0, 0, 0}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)

class ResearchEquipment extends Item
    color: {255, 255, 255}
    draw: =>
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)
