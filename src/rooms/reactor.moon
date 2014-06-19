export ^

require "tile"
require "rooms/room"

class Reactor extends Room
    color: {78, 169, 160}
    name: "reactor"
    required_resources: {
        [Energy]: 6
        [Material]: 2
        [Food]: 0
    }
    productionRate: 30 -- seconds

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0

    currentEnergyCounter: =>
        items = @getItems()
        for item in *items
            assert item.__class == Energy
        return #items

    produceEnergy: =>
        for tile in *@tiles
            if tile.itemContained == nil
                tile.itemContained = Energy()
                return
        assert false, "Called produceEnergy with no available tile"

    update: (dt) =>
        super(dt)
        if currentEnergyCounter() < #@tiles
            if @productionCounter >= @productionRate
                @produceEnergy()
                @productionCounter = 0
            else
                @productionCounter += dt

    draw: =>
        super()
        if @state == @states.finished
            if @productionCounter < @productionRate or @productionCounter > 0
                x = Tile.kTILE_SIZE / 4
                y = Tile.kTILE_SIZE / 4
                w = Tile.kTILE_SIZE / 2
                h = Tile.kTILE_SIZE / 2
                love.graphics.setColor(55, 119, 112)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(255, 255, 255)
                loadingFactor = @productionCounter / @productionRate
                love.graphics.rectangle("fill", x, y, w, h * loadingFactor)
