io.stdout:setvbuf('no')
wScr = love.graphics.getWidth
hScr = love.graphics.getHeight
require("spacebase")
require("view")
flux = require("lib/flux/flux")
love.load = function()
  assert(love.graphics.isSupported("canvas", "npot"), "Your graphic card is not supported, sorry!")
  spacebase = Spacebase()
  view = View(spacebase)
end
love.draw = function()
  return view:draw()
end
love.update = function(dt)
  flux.update(dt)
  return view:update(dt)
end
love.keyreleased = function(key)
  local _exp_0 = (key)
  if "up" == _exp_0 or "down" == _exp_0 or "left" == _exp_0 or "right" == _exp_0 or "i" == _exp_0 or "o" == _exp_0 then
    return view:keyreleased(key)
  elseif "escape" == _exp_0 then
    return love.event.quit()
  end
end
love.mousepressed = function(x, y, button)
  local mx, my
  do
    local _obj_0 = view:coordinatesInWorld(x, y)
    mx, my = _obj_0[1], _obj_0[2]
  end
  return spacebase:mousepressed(mx, my, button)
end
