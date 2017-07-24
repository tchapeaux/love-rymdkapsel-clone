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
    missionTypes: {
        idle: IdleComponent.missionType
        engineering: EngineeringComponent.missionType
        -- foodservice: FoodServiceComponent.missionType
        -- construction: ConstructionComponent.missionType
        -- research: ResearchComponent.missionType
        -- defense: DefenseComponent.missionType
    }
    new: (@game) =>
        @components = {}
        @components[@missionTypes.idle] = IdleComponent(@game.spacebase)
        @components[@missionTypes.engineering] = EngineeringComponent(@game.spacebase)
        -- @components[@missionTypes.foodservice] = FoodServiceComponent(@game.spacebase)
        -- @components[@missionTypes.construction] = ConstructionComponent(@game.spacebase)
        -- @components[@missionTypes.research] = ResearchComponent(@game.spacebase)
        -- @components[@missionTypes.defense] = DefenseComponent(@game.spacebase)

    create_minion: (x, y) =>
        new_minion = Minion(x, y)
        @components[@missionTypes.idle]\add(new_minion)

    assign: (fromMissionType, toMissionType) =>
        if @components[fromMissionType] == nil
            error("Call scheduler\\assign with unknown mission type #{fromMissionType}")
        if @components[toMissionType] == nil
            error("Call scheduler\\assign with unknown mission type #{toMissionType}")
        minion = @components[fromMissionType]\pop()
        @components[toMissionType]\add(minion)

    update: (dt) =>
        -- DEBUG disable for debugging pathfinding
        -- for name, component in pairs(@components)
        --    component\update(dt)

    get_all_minions: =>
        all_minions = {}
        for _, component in pairs(@components)
            for minion in *component\getMinions()
                table.insert(all_minions, minion)
        return all_minions
