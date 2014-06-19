export ^

require "items"
require "rooms/abstract_producer"

class Kitchen extends Producer
    color: {224, 161, 28}
    name: "kitchen"
    required_resources: {
        [Energy]: 3
        [Material]: 2
        [Food]: 3
    }
    productionRate: 2 -- seconds (should be 30)
    producedResource: Food

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)

    canProduce: () =>
        items = @getItems()
        for item in *items
            if item.__class == Sludge
                return true
        return false

    produceResource: =>
        for tile in *@tiles
            if tile.itemContained ~= nil and tile.itemContained.__class == Sludge
                tile.itemContained = @producedResource()
                return
        assert false, "Called produceResource with no tile with Sludge"
