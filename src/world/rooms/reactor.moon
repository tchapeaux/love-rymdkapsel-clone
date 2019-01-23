export ^

require "world/items"
require "world/rooms/abstract_producer"

class Reactor extends Producer
    color: {78 / 255, 169 / 255, 160 / 255}
    name: "reactor"
    required_resources: {
        [Energy]: 6
        [Material]: 2
        [Food]: 0
    }
    productionRate: 2 -- seconds (should be 30)
    producedResource: Energy

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0
