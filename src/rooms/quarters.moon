export ^

require "items"
require "rooms/abstract_producer"

class Quarters extends Producer
    color: {211, 107, 37}
    name: "quarters"
    required_resources: {
        [Energy]: 4
        [Material]: 6
        [Food]: 4
    }
    productionRate: 2 -- seconds (should be 30)
    producedResource: Minion

    new: (@shape, origin, @leftTurns)=>
        super(@shape, origin, @leftTurns)
        @productionCounter = 0

    -- TODO

    canProduce: =>

    produceResource: =>
        super()
        -- TODO: add new minion to spacebase crew
