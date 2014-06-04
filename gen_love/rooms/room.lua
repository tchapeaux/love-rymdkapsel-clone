require("tile")
do
  local _base_0 = {
    draw = function(self)
      love.graphics.setColor(self.color)
      local _list_0 = self.shape
      for _index_0 = 1, #_list_0 do
        local _des_0 = _list_0[_index_0]
        local ox, oy
        ox, oy = _des_0[1], _des_0[2]
        local x = ox * Tile.kTILE_SIZE
        local y = oy * Tile.kTILE_SIZE
        local w = Tile.kTILE_SIZE
        local h = Tile.kTILE_SIZE
        love.graphics.rectangle("fill", x, y, w, h)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, shape, origin, orientation)
      self.shape, self.origin, self.orientation = shape, origin, orientation
      self.tiles = { }
      self.x = origin[1]
      self.y = origin[2]
      local _list_0 = self.shape
      for _index_0 = 1, #_list_0 do
        local _des_0 = _list_0[_index_0]
        local ox, oy
        ox, oy = _des_0[1], _des_0[2]
        local tile = Tile(self.x + ox, self.y + oy, self)
        table.insert(self.tiles, tile)
      end
      self.color = nil
    end,
    __base = _base_0,
    __name = "Room"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Room = _class_0
  return _class_0
end
