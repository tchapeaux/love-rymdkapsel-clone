export ^

require "rooms/room"

kROCK_COLOR = {100, 100, 100}

class Rock extends Room
    new: (@shape, @origin, @orientation) =>
        super(@shape, @origin, @orientation)
        @color = kROCK_COLOR
