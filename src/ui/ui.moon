export ^

require "rooms/rock"
require "rooms/corridor"
require "ui/button"
shapes = require "rooms/shape"

class UI
    -- todo? separate roomPlacer and crewScheduler?
    new: (@spacebase) =>
        @roomTypes = {Rock, Corridor}
        @nextShapes = {}
        @hRatio = 0.1 -- space taken on screen
        -- fill with random shapes
        for i=1,4
            table.insert(@nextShapes, shapes.random())

        @roomButtons = {}
        @selectedRoomType = nil
        @currentLeftTurns = 0
        offset = 1/6 * wScr()
        width = 70
        margin_w = 10
        margin_h = 0
        for i, room in ipairs(@roomTypes)
            i -= 1 -- starts at 0
            x = offset + i * width + i * margin_w
            y = margin_h
            w = width
            h = @hRatio * hScr()
            butt = Button(x, y, w, h, room)
            table.insert(@roomButtons, butt)

    draw: =>
        w, h = wScr(), hScr()
        love.graphics.setColor(0,0,0, 100)
        love.graphics.rectangle("fill", 0, 0, w, @hRatio * h)
        love.graphics.rectangle("fill", 0, (1 - @hRatio) * h, w, @hRatio * h)

        -- buttons
        for i, butt in ipairs(@roomButtons)
            butt\draw(i == @selectedRoomType)

    isInside: (x, y) =>
        return y < @hRatio * hScr() or y > (1 - @hRatio) * hScr()

    nextShape: =>
        return @nextShapes[#@nextShapes]

    updateShapes: =>
        table.remove(@nextShapes, 1)
        table.insert(@nextShapes, shapes.random())

    selectedRoom: =>
        return @roomTypes[@selectedRoomType](@nextShape(), {0, 0}, @currentLeftTurns)

    selectNewRoomType: (n) =>
        @selectedRoomType = n
        @spacebase.floatingRoom = @selectedRoom()

    unselectRoomType: =>
        @selectedRoomType = nil
        @spacebase.floatingRoom = nil

    turnSelectedRoom: =>
        @currentLeftTurns += 1
        @currentLeftTurns %= 4
        @spacebase.floatingRoom = @selectedRoom()

    placeRoom: =>
        @spacebase\placeFloatingRoom()
        @selectedRoomType = nil
        @updateShapes()


    mousepressed: (x, y, button) =>
        switch button
            when "l"
                if @selectedRoomType ~= nil
                    @placeRoom()
                for i, butt in ipairs(@roomButtons)
                    if butt\isInside(x, y)
                        @selectNewRoomType(i)
            when "r"
                @turnSelectedRoom()

