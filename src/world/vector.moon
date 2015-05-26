export ^

class Vector
    new: (@x, @y) =>

    dist: (otherV, squared=false) =>
        dx = @x - otherV.x
        dy = @y - otherV.y
        dist_sq = dx * dx + dy * dy
        return if squared then dist_sq else math.sqrt(dist_sq)

    norm: =>
        return @dist(Vector(0, 0))
