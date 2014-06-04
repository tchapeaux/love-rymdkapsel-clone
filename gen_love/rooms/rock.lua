require("rooms/room")
local kROCK_COLOR = {
  100,
  100,
  100
}
do
  local _parent_0 = Room
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, shape, origin, orientation)
      self.shape, self.origin, self.orientation = shape, origin, orientation
      _parent_0.__init(self, self.shape, self.origin, self.orientation)
      self.color = kROCK_COLOR
    end,
    __base = _base_0,
    __name = "Rock",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Rock = _class_0
  return _class_0
end
