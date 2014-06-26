export ^

class Item
-- used for things on the map that minions can pick up
    color: {0, 0, 0}
    draw: =>
        love.graphics.setLineWidth(2)
        love.graphics.setColor(@color)
        love.graphics.rectangle("fill", -5, -5, 10, 10)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", -5, -5, 10, 10)

class Energy extends Item
    color: {66, 145, 135}

class Material extends Item
    color: {243, 127, 183}

class Sludge extends Item
    color: {87, 119, 32}

class Food extends Item
    color: {159, 112, 19}

class Gun extends Item
    color: {0, 0, 0}

class ResearchEquipment extends Item
    color: {255, 255, 255}
