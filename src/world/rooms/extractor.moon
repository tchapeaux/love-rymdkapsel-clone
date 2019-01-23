export ^

require "world/items"
require "world/rooms/abstract_producer"

class Extractor extends Producer
    color: {181 / 255, 83 / 255, 131 / 255}
    name: "extractor"
    required_resources: {
        [Energy]: 2
        [Material]: 3
        [Food]: 0
    }
    productionRate: 2 -- seconds (should be 30)
    producedResource: Material

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)

    canProduce: () =>
        -- TODO: check if associated Deposits still has Material in it
        return true and super()

    draw: =>
        -- TODO: draw a line between the extractor and deposit when producing
        super()
