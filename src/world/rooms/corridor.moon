export ^

require "world/rooms/room"


class Corridor extends Room
    color: {129, 101, 91}
    name: "corridor"
    required_resources: {
        [Energy]: 1
        [Material]: 1
        [Food]: 0
    }
