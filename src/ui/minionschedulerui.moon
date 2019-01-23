export ^

lume = require "lib/lume/lume"

require "world/minions/idlecomponent"
require "world/minions/engineeringcomponent"
-- require "world/minions/dummy_engineeringcomponent"
-- require "world/minions/foodservicecomponent"
-- require "world/minions/constructioncomponent"
-- require "world/minions/researchcomponent"
-- require "world/minions/defensecomponent"

class MinionSchedulerUI
    new: (minionscheduler) =>
        @scheduler = minionscheduler
        @hRatio = 0.1

        @missionButtons = {}
        @selectedMissionType = nil

        buttons_offset = 1/6 * wScr()
        buttons_width = 80
        buttons_margin_w = 10
        buttons_margin_h = 0

        for i, comp in ipairs(@scheduler.missionComponents)
            i -= 1 -- starts at 0
            x = buttons_offset + i * buttons_width + i * buttons_margin_w
            y = (1 - @hRatio) * hScr() + buttons_margin_h
            w = buttons_width
            h = @hRatio * hScr()
            color = {255, 255, 255} -- white
            butt = Button(x, y, w, h, comp.missionType, color)
            table.insert(@missionButtons, butt)

    draw: =>
        w, h = wScr(), hScr()
        love.graphics.setColor(0,0,0,150 / 255)
        love.graphics.rectangle("fill", 0, (1 - @hRatio) * h, w, @hRatio * h)

        -- buttons
        for i, butt in ipairs(@missionButtons)
            selected = (i == @selectedMissionType)
            butt\draw(selected)
            -- display corresponding number of minions
            love.graphics.setColor(1,1,1,1)
            comp_type = @scheduler.missionComponents[i].missionType
            comp = @scheduler.components[comp_type]
            nb_minions = #comp\getMinions()
            love.graphics.printf("#{nb_minions}", butt.x, butt.y, butt.w, "center")

    mousepressed: (x, y, button) =>
        if button == 1
            for i, butt in ipairs(@missionButtons)
                if butt\isInside(x, y)
                    print("selecting", butt.text)
                    @selectedMissionType = i

    mousereleased: (x, y, button) =>
        if button == 1 and @selectedMissionType ~= nil
            for i, butt in ipairs(@missionButtons)
                if butt\isInside(x, y)
                    @scheduler\assign(@missionButtons[@selectedMissionType].text, butt.text)
            @selectedMissionType = nil
