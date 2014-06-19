export ^

require "tile"
require "rooms/room"
require "rooms/abstract_producer"

class Reactor extends Room
    color: {78, 169, 160}
    name: "reactor"
    required_resources: {
        [Energy]: 6
        [Material]: 2
        [Food]: 0
    }
    productionRate: 2 -- seconds (should be 30)

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0
