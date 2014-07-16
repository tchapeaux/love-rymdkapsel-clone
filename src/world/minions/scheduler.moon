export ^

require "world/minions/idlecomponent"
require "world/minions/engineeringcomponent"
require "world/minions/foodservicecomponent"
require "world/minions/constructioncomponent"
require "world/minions/researchcomponent"
require "world/minions/defensecomponent"

class MinionScheduler
    -- Set minion targets at each frame
    missionTypes: {
        idle: IdleComponent.missionType
        engineering: EngineeringComponent.missionType
        foodservice: FoodServiceComponent.missionType
        construction: ConstructionComponent.missionType
        research: ResearchComponent.missionType
        defense: DefenseComponent.missionType
    }
    new: (@spacebase, @minions) =>
        @components = {}
        @components[@missionTypes.idle] = IdleComponent(@spacebase)
        @components[@missionTypes.engineering] = EngineeringComponent(@spacebase)
        @components[@missionTypes.foodservice] = FoodServiceComponent(@spacebase)
        @components[@missionTypes.construction] = ConstructionComponent(@spacebase)
        @components[@missionTypes.research] = ResearchComponent(@spacebase)
        @components[@missionTypes.defense] = DefenseComponent(@spacebase)
        for minion in *@minions
            @assign(minion, @missionTypes.idle)

    assign: (fromMissionType, toMissionType) =>
        minion = @components[fromMissionType]\pop()
        @components[toMissionType]\add(minion)

    update: (dt) =>
        for comp in *@components
            comp\update(dt)
