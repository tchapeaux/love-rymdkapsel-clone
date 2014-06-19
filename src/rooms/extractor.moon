export ^

require "items"
require "rooms/abstract_producer"

class Extractor extends Producer
    color: {181, 83, 131}
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

    update: (dt) =>
        -- TODO: check if associated Deposits still has Material in it
        super(dt)

    draw: =>
        -- TODO: draw a line between the extractor and deposit
        super()
