export ^

class MinionSchedulerUI
    new: (minionscheduler) =>
        @scheduler = minionscheduler
        @hRatio = 0.1

    draw: =>
        w, h = wScr(), hScr()
        love.graphics.setColor(0,0,0, 100)
        love.graphics.rectangle("fill", 0, (1 - @hRatio) * h, w, @hRatio * h)

    mousepressed: (x, y, button) =>

