export ^

require "world/minions/missionstate"
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
            if @has_mission(minion) and #minion.path == 0
                assert minion.missionState ~= nil
                -- construct path for minion
                minion_coord = minion\get_tile_coordinates()
                print "construct new path (length of path is", #minion.path, ")"
                minion.path = @spacebase\pathFinding minion_coord.x, minion_coord.y,
                    minion.missionState.currentObjectiveTile[1],
                    minion.missionState.currentObjectiveTile[2],
                    true
            else
                -- try to find a mission
                @giveMission(minion)

