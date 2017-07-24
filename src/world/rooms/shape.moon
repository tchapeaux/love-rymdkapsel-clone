-- shapes description
-- each shape is an array of block "coordinates" (x,y), which are offset from the shape origin

dotShape = {
    {0, 0}
}

iShape = {
    {0, 0},
    {0, 1},
    {0, 2},
    {0, 3}
}

oShape = {
    {0, 0},
    {0, 1},
    {1, 1},
    {1, 0}
}

tShape = {
    {0, 0},
    {1, 0},
    {1, 1},
    {2, 0}
}

jShape = {
    {0, 0},
    {0, 1},
    {1, 0},
    {2, 0}
}

lShape = {
    {0, 0},
    {1, 0},
    {2, 0},
    {2, 1}
}

sShape = {
    {0, 0},
    {1, 0},
    {1, 1},
    {2, 1}
}

zShape = {
    {0, 0},
    {1, 0},
    {1, -1},
    {2, -1}
}

randomShape = ->
    shapes = {
        iShape, oShape, tShape, jShape, lShape, sShape, zShape
    }
    return shapes[math.random(#shapes)]

turnShapeLeft = (shape) ->
    newShape = {}
    for {x, y} in *shape
        newX, newY = -y, x
        table.insert(newShape, {newX, newY})
    return newShape

{
    dot: dotShape
    i: iShape
    o: oShape
    t: tShape
    j: jShape
    l: lShape
    s: sShape
    z: zShape
    random: randomShape
    turnLeft: turnShapeLeft
}
