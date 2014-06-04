require("tile")
require("shape")
require("rooms/rock")
do
  local _base_0 = {
    kBASE_SIZE = 100,
    totalSize = function()
      return Spacebase.kBASE_SIZE * Tile.kTILE_SIZE
    end,
    draw = function(self)
      local _list_0 = self.rooms
      for _index_0 = 1, #_list_0 do
        local room = _list_0[_index_0]
        local i = room.x - 1
        local j = room.y - 1
        love.graphics.push()
        love.graphics.translate(i * Tile.kTILE_SIZE, j * Tile.kTILE_SIZE)
        room:draw()
        love.graphics.pop()
      end
      local tileSize = Tile.kTILE_SIZE
      local totalSize = Spacebase.totalSize()
      for i = 1, self.kBASE_SIZE + 1 do
        i = i - 1
        love.graphics.line(0, i * tileSize, totalSize, i * tileSize)
        love.graphics.line(i * tileSize, 0, i * tileSize, totalSize)
      end
    end,
    addRoom = function(self, room)
      table.insert(self.rooms, room)
      local _list_0 = room.tiles
      for _index_0 = 1, #_list_0 do
        local tile = _list_0[_index_0]
        self.tileGrid[tile.x][tile.y] = tile
      end
      return self:updateNeighbors()
    end,
    screenToTileCoordinates = function(self, x, y)
      local i = math.ceil(x / Tile.kTILE_SIZE)
      local j = math.ceil(y / Tile.kTILE_SIZE)
      return {
        i,
        j
      }
    end,
    mousepressed = function(self, x, y, button)
      print(x, y)
      local i, j
      do
        local _obj_0 = self:screenToTileCoordinates(x, y)
        i, j = _obj_0[1], _obj_0[2]
      end
      local room = Rock(randomShape(), {
        i,
        j
      }, nil)
      return self:addRoom(room)
    end,
    updateNeighbors = function(self)
      for i = 1, self.kBASE_SIZE do
        for j = 1, self.kBASE_SIZE do
          local tile = self.tileGrid[i][j]
          if tile then
            if i < self.kBASE_SIZE then
              tile.neighbors[Tile.kRIGHT] = self.tileGrid[i + 1][j]
            end
            if i > 1 then
              tile.neighbors[Tile.kLEFT] = self.tileGrid[i - 1][j]
            end
            if j > 1 then
              tile.neighbors[Tile.kUP] = self.tileGrid[i][j - 1]
            end
            if j < self.kBASE_SIZE then
              tile.neighbors[Tile.kDOWN] = self.tileGrid[i][j + 1]
            end
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.tileGrid = { }
      for i = 1, self.kBASE_SIZE do
        table.insert(self.tileGrid, { })
        for j = 1, self.kBASE_SIZE do
          table.insert(self.tileGrid[i], nil)
        end
      end
      self.rooms = { }
      local firstRoom = Rock(randomShape(), {
        10,
        10
      }, nil)
      return self:addRoom(firstRoom)
    end,
    __base = _base_0,
    __name = "Spacebase"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Spacebase = _class_0
  return _class_0
end
