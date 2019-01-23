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
    color: {66 / 255, 145 / 255, 135 / 255}

class Material extends Item
    color: {243 / 255, 127 / 255, 183 / 255}

class Sludge extends Item
    color: {87 / 255, 119 / 255, 32 / 255}

class Food extends Item
    color: {159 / 255, 112 / 255, 19 / 255}

class Gun extends Item
    color: {0, 0, 0}

class ResearchEquipment extends Item
    color: {1, 1, 1}
