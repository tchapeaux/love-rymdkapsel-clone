export ^

require "rooms/room"

kCORRIDOR_COLOR = {200, 100, 100}

class Corridor extends Room
    new: (@shape, @origin, @orientation) =>
        super(@shape, @origin, @orientation)
        @color = kCORRIDOR_COLOR
