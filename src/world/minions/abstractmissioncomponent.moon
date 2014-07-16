export ^

lume = require "lib/lume/lume"

class AbstractMissionComponent
    missionType: "abstract"

    -- ABSTRACT METHODS
    -- To be defined by children class

    pop: =>
        -- should return the "less useful" minion and remove it from the component

    has_mission: (minion) =>
        -- return true if the minion is currently busy (not idle)

    giveMission: (minion) =>
        -- assign a mission to minion if possible

    getMinionCount: =>
        -- return the number of minions with this mission assigned

    -- CONCRETE METHODS

    makeWeak: (table, key=true, value=false) ->
        meta = getmetatable(table)
        if meta == nil
            meta = {}
        meta.__mode == ""
        if key
            meta.__mode ..= "k"
        if value
            meta.__mode ..= "v"
        setmetatable(table, meta)

    new: (@spacebase) =>
        @idleMinions = {}
        @makeWeak(@idleMinions)

    update: (dt) =>
        newIdleTable = {}
        @makeWeak(newIdleTable)
        for minion in *@idleMinions
            giveMission(minion)
            if not has_mission(minion)
                table.insert(newIdleTable, minion)
        @idleMinions = newIdleTable

    add: (minion) =>
        minion.missionType = @missionType
        table.insert(@idleMinions, minion)
