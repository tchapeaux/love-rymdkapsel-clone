export ^

require "world/minions/minion"
require "world/minions/idlecomponent"
require "world/minions/engineeringcomponent"
require "world/minions/dummy_engineeringcomponent"
-- require "world/minions/foodservicecomponent"
-- require "world/minions/constructioncomponent"
-- require "world/minions/researchcomponent"
-- require "world/minions/defensecomponent"

class MinionScheduler
    -- Set minion targets at each frame
    missionComponents: {
        IdleComponent,
        EngineeringComponent,
        FoodServiceComponent,
        ConstructionComponent,
        ResearchComponent,
        DefenseComponent
    }

    new: (@game) =>
        @components = {}
        for comp in *@missionComponents
            @components[comp.missionType] = comp(@game.spacebase)

    create_minion: (x, y) =>
        new_minion = Minion(x, y)
        @components[IdleComponent.missionType]\add(new_minion)

    assign: (fromMissionType, toMissionType) =>
        if @components[fromMissionType] == nil
            error("Call scheduler\\assign with unknown mission type #{fromMissionType}")
        if @components[toMissionType] == nil
            error("Call scheduler\\assign with unknown mission type #{toMissionType}")
        minion = @components[fromMissionType]\pop()
        assert minion ~= nil
        minion.missionState = nil
        minion.path = {}
        @components[toMissionType]\add(minion)

    update: (dt) =>
        for name, component in pairs(@components)
            component\update(dt)

    get_all_minions: =>
        all_minions = {}
        for _, component in pairs(@components)
            for minion in *component\getMinions()
                table.insert(all_minions, minion)
        return all_minions
