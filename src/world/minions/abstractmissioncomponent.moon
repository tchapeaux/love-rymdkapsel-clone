export ^

lume = require "lib/lume/lume"

class AbstractMissionComponent
    missionType: "abstract"

    new: (@spacebase) =>
        @minions = {}

    add: (minion) =>
        -- assign this mission to minion
        -- the following default behavior is provided
        minion.missionType = @missionType
        table.insert(@minions, minion)

    pop: =>
        -- should return the "less useful" minion and remove it from the component

    has_mission: (minion) =>
        -- return true if the minion is currently busy (not idle)

    giveMission: (minion) =>
        -- assign a mission to minion if possible

    getMinions: (idle=true, busy=true) =>
        -- return the corresponding minions
        -- the following default behavior is provided
        returned = {}
        for minion in *@minions
            if (@has_mission(minion) and busy) or (not @has_mission(minion) and idle)
                table.insert(returned, minion)
        return returned

    update: (dt) =>
        for minion in *@minions
            minion\update(dt)
            if not @has_mission(minion)
                -- try to find a mission
                @giveMission(minion)
