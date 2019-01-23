export ^

require "world/items"
require "world/rooms/abstract_producer"

class Gardens extends Producer
    color: {124 / 255, 168 / 255, 46 / 255}
    name: "gardens"
    required_resources: {
        [Energy]: 3
        [Material]: 1
        [Food]: 1
    }
    productionRate: 2 -- seconds (should be 30)
    producedResource: Sludge

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0
