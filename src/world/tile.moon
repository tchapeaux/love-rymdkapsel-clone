export ^

class Tile
    kTILE_SIZE: 100   -- in px
    kLEFT: 1
    kUP: 2
    kRIGHT: 3
    kDOWN: 4
    new: (@row, @col, @room) =>
        @walkable = @room.walkable
        @neighbors = {nil, nil, nil, nil}
        @itemContained = nil
