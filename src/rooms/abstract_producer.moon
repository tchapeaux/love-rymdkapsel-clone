export ^

require "tile"
require "rooms/room"

class Producer extends Room
    color: {0,0,0}
    name: "abstract producer"
    required_resources: {
        [Energy]: 0
        [Material]: 0
        [Food]: 0
    }
    -- child classes must define the following class variables
    -- and also the canProduce method below
    productionRate: 2 -- seconds (should be 30)
    producedResource: nil -- should be a subclass of Item

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0

    canProduce: =>
        -- may be overwritten by children class
        return @state == @states.finished and @currentResourceCounter() < #@tiles

    currentResourceCounter: =>
        items = @getItems()
        for item in *items
            assert item.__class == @producedResource
        return #items

    produceResource: =>
        for tile in *@tiles
            if tile.itemContained == nil
                tile.itemContained = @producedResource()
                return
        assert false, "Called produceResource with no available tile"

    update: (dt) =>
        super(dt)
        if @canProduce()
            if @productionCounter >= @productionRate
                @produceResource()
                @productionCounter = 0
            else
                @productionCounter += dt

    draw: =>
        super()
        if @state == @states.finished
            if @productionCounter < @productionRate and @productionCounter > 0
                tSize = Tile.kTILE_SIZE
                x = tSize / 5
                y = tSize / 4
                w = tSize / 8
                h = tSize / 2
                if (kDEBUG)
                    love.graphics.setColor(0,0,0)
                    love.graphics.printf("#{@productionCounter}", 2 * x, y, tSize)
                love.graphics.setColor(0, 0, 0, 100)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(255, 255, 255)
                loadingFactor = @productionCounter / @productionRate
                love.graphics.rectangle("fill", x, y, w, h * loadingFactor)
