export ^

require "world/items"
require "world/rooms/abstract_producer"

class Quarters extends Producer
    color: {211 / 255, 107 / 255, 37 / 255}
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
