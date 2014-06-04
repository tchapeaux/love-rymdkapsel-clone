lgm_path = "./"
local LGM = require("lgm")
do
  local e1 = LGM.Entity(0, 0)
  local e2 = LGM.Entity(3, 5)
  assert((e1:distanceTo(e2)) == math.sqrt(3 * 3 + 5 * 5), "distance Test Failed: " .. tostring(e1:distanceTo(e2)))
  e1 = LGM.Entity(10, 10)
  e2 = LGM.Entity(10, 15)
  assert((e1:distanceTo(e2)) == 5, "distance Test Failed: " .. tostring(e1:distanceTo(e2)) .. " != 5")
end
do
  local e1 = LGM.Entity(5, 2)
  local e2 = LGM.Entity(-3, 10)
  assert((e1:distanceTo(e2)) == math.sqrt(8 * 8 + 8 * 8))
end
do
  local es = LGM.EntitySet()
  local e1 = LGM.Entity(1, 1)
  local e2 = LGM.Entity(225, 130)
  local e3 = LGM.Entity(-300, -103)
  local closest, d = e1:getClosestOf(es:as_list())
  assert(closest == nil and d == nil)
  es:add(LGM.Entity(50, 25))
  es:add(LGM.Entity(200, 150))
  es:add(LGM.Entity(-140, 20))
  es:add(LGM.Entity(53, -12))
  es:add(LGM.Entity(0, 0))
  es:add(e3)
  closest, d = e1:getClosestOf(es:as_list())
  assert(closest:getX() == 0 and closest:getY() == 0 and d == math.sqrt(2), tostring(closest))
  closest, d = e2:getClosestOf(es:as_list())
  assert(closest:getX() == 200 and closest:getY() == 150, tostring(closest))
  local e = es:find(e3.id)
  assert(e == e3)
end
do
  local v1 = LGM.Vector(10, 0)
  local v2 = LGM.Vector(0, 10)
  assert((v1:angleWith(v2)) == math.pi / 2, "vector test failed, " .. tostring(v1:angleWith(v2)) .. " != math.pi / 2 (" .. tostring(math.pi / 2) .. ")")
end
do
  local v1 = LGM.Vector(10, 0)
  local v2 = LGM.Vector(5, 5)
  assert((v2:angle()) == -math.pi / 4, "angle is " .. tostring(v2:angle()) .. " not " .. tostring(math.pi / 4))
  assert((v1:angleWith(v2)) == math.pi / 4)
end
do
  local v1 = LGM.Vector(5, 5)
  local v2 = LGM.Vector(-5, 5)
  assert((v1:angleWith(v2)) == math.pi / 2, tostring(v1:angleWith(v2)))
end
do
  local v1 = LGM.Vector(1, 1)
  local v2 = LGM.Vector(200, 0)
  assert((v1:angleWith(v2)) == -1 * math.pi / 4)
end
do
  local v1 = LGM.Vector(1, 1)
  local v2 = v1:scalarProduct(2)
  assert((v2.x == 2 and v2.y == 2), tostring(v2))
end
do
  local v1 = LGM.Vector(0, 20)
  local v2 = v1:scalarProduct(-1.5)
  assert((v2.x == 0 and v2.y == -30), tostring(v2))
end
do
  local v1 = LGM.Vector(180, 243)
  local v2 = v1:scalarProduct(5.25)
  assert((v2.x == 945 and v2.y == 1275.75), tostring(v2))
end
do
  local v1 = LGM.Vector(0, 0)
  local v2 = v1:scalarProduct(4)
  assert((v2.x == 0 and v2.y == 0), tostring(v2))
end
do
  local v1 = LGM.Vector(0, 10)
  local v2 = LGM.Vector(0, 20)
  assert((v1:dotProduct(v2)) == 200)
end
do
  local v1 = LGM.Vector(0, 430)
  local v2 = LGM.Vector(242, 0)
  assert((v1:dotProduct(v2)) == 0)
end
do
  local v1 = LGM.Vector(24, -58)
  local v2 = LGM.Vector(-7, 24)
  assert((v1:dotProduct(v2)) == -1560)
end
do
  local v1 = LGM.Vector(1, 0)
  local v2 = LGM.Vector(5, 0)
  assert((v1:crossProduct(v2)) == 0)
end
do
  local v1 = LGM.Vector(2, 0)
  local v2 = LGM.Vector(0, -8)
  assert((v1:crossProduct(v2)) == -16)
end
do
  local v1 = LGM.Vector(1, 0)
  local v2 = LGM.Vector(0, 1)
  assert(v1:isLeftTurn(v2))
end
do
  local v1 = LGM.Vector(5, 5)
  local v2 = LGM.Vector(7, -2)
  assert(not v1:isLeftTurn(v2))
end
do
  local v1 = LGM.Vector(7, 12)
  local v2 = LGM.Vector(14, 24)
  assert(v1:isLeftTurn(v2))
  assert(not v1:isLeftTurn(v2, true))
end
do
  local seg1 = LGM.Segment(LGM.Vector(-1, 0), LGM.Vector(1, 0))
  local seg2 = LGM.Segment(LGM.Vector(0, -1), LGM.Vector(0, 1))
  assert(seg1:intersect(seg2), "LGM.Segment Intersection failed")
end
do
  local seg1 = LGM.Segment(LGM.Vector(3, 10), LGM.Vector(17, 56))
  local seg2 = LGM.Segment(LGM.Vector(0, -1), LGM.Vector(-12, 207))
  assert(not seg1:intersect(seg2), "LGM.Segment Intersection failed")
end
do
  local seg1 = LGM.Segment(LGM.Vector(15, 50), LGM.Vector(30, 50))
  local seg2 = LGM.Segment(LGM.Vector(20, 50), LGM.Vector(20, 100))
  assert(seg1:intersect(seg2), "LGM.Segment Intersection failed")
end
do
  local seg1 = LGM.Segment(LGM.Vector(-200, -200), LGM.Vector(700, 700))
  local seg2 = LGM.Segment(LGM.Vector(-0.5, 0), LGM.Vector(0.5, 0))
  assert(seg1:intersect(seg2), "LGM.Segment Intersection failed")
end
do
  local seg1 = LGM.Segment(LGM.Vector(759.57696131902, 50), LGM.Vector(762.97327651903, 50))
  local seg2 = LGM.Segment(LGM.Vector(760, 40), LGM.Vector(760, 560))
  assert(seg1:intersect(seg2), "LGM.Segment Intersection failed")
end
do
  assert(LGM.base.is_nan(0 / 0))
  assert(LGM.base.is_nan(-0 / 0))
  assert(LGM.base.is_nan((-1) ^ .5))
  assert(not LGM.base.is_nan(1))
  assert(not LGM.base.is_nan(0))
  assert(not LGM.base.is_nan(false))
end
return print("All tests have passed!")
