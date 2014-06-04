do
  local _base_0 = {
    kTILE_SIZE = 50,
    kLEFT = 1,
    kUP = 2,
    kRIGHT = 3,
    kDOWN = 4
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, x, y, room)
      self.x, self.y, self.room = x, y, room
      self.neighbors = {
        nil,
        nil,
        nil,
        nil
      }
    end,
    __base = _base_0,
    __name = "Tile"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Tile = _class_0
  return _class_0
end
