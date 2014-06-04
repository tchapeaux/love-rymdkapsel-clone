export ^

class Tile
    kTILE_SIZE: 50   -- in px²
    kLEFT: 1
    kUP: 2
    kRIGHT: 3
    kDOWN: 4
    new: (@x, @y, @room) =>
        @neighbors = {nil, nil, nil, nil}
