do
  local _base_0 = {
    update = function(self, dt)
      self.offset_x = math.max(self.min_off, self.offset_x)
      self.offset_x = math.min(self.max_off, self.offset_x)
      self.offset_y = math.max(self.min_off, self.offset_y)
      self.offset_y = math.min(self.max_off, self.offset_y)
      self.zoom = math.max(self.min_zoom, self.zoom)
      self.zoom = math.min(self.max_zoom, self.zoom)
    end,
    draw = function(self)
      self.canvas:clear()
      love.graphics.setCanvas(self.canvas)
      self.spacebase:draw()
      love.graphics.setCanvas()
      love.graphics.translate(self.offset_x * self.zoom, self.offset_y * self.zoom)
      love.graphics.scale(self.zoom, self.zoom)
      return love.graphics.draw(self.canvas)
    end,
    keyreleased = function(self, key)
      local _exp_0 = (key)
      if "down" == _exp_0 then
        return flux.to(self, 0.5, {
          offset_y = self.offset_y - 50 * self.zoom
        })
      elseif "up" == _exp_0 then
        return flux.to(self, 0.5, {
          offset_y = self.offset_y + 50 * self.zoom
        })
      elseif "left" == _exp_0 then
        return flux.to(self, 0.5, {
          offset_x = self.offset_x + 50 * self.zoom
        })
      elseif "right" == _exp_0 then
        return flux.to(self, 0.5, {
          offset_x = self.offset_x - 50 * self.zoom
        })
      elseif "i" == _exp_0 then
        return flux.to(self, 0.5, {
          zoom = self.zoom * 1.1
        })
      elseif "o" == _exp_0 then
        return flux.to(self, 0.5, {
          zoom = self.zoom / 1.1
        })
      end
    end,
    coordinatesInWorld = function(self, x, y)
      x = x / self.zoom
      y = y / self.zoom
      x = x - self.offset_x
      y = y - self.offset_y
      print("offzoom", self.offset_x, self.offset_y, self.zoom)
      return {
        x,
        y
      }
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, spacebase)
      self.spacebase = spacebase
      local spacebaseSize = self.spacebase.totalSize()
      self.canvas = love.graphics.newCanvas(spacebaseSize, spacebaseSize)
      self.offset_x = 0
      self.offset_y = 0
      self.zoom = 1
      self.max_off = 0
      self.min_off = -spacebaseSize
      self.max_zoom = 2
      self.min_zoom = .5
    end,
    __base = _base_0,
    __name = "View"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  View = _class_0
  return _class_0
end
