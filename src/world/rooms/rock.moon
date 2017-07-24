export ^

require "world/rooms/room"

class Rock extends Room
    color: {59, 62, 67}
    name: "rock"
    walkable: false
    required_resources: {
        [Energy]: 0
        [Material]: 0
        [Food]: 0
    }
