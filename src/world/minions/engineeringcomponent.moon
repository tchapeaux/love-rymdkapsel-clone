export ^

require "world/minions/abstractmissioncomponent"
require "world/minions/roomtracker"
require "world/rooms/reactor"
lume = require "lib/lume/lume"

class EngineeringComponent extends AbstractMissionComponent
    missionType: "engineering"

    new: (spacebase) =>
        super(spacebase)
        @reactorTracker = RoomTracker(@spacebase, Reactor)
        @reactorToMinions = {} -- key: reactor; value: list of minions
        helper.makeWeakTable(@reactorToMinions)

    update: (dt) =>
        super(dt)
        @reactorTracker\update(dt)
        for room in *@reactorTracker.roomsAdded
            @reactorToMinions[room] = {}
            helper.makeWeakTable(@reactorToMinions[room])
        for room in *@reactorTracker.roomsRemoved
            @reactorToMinions[room] = nil

    pop: =>
        if #@minions == 0
            print("WARN -- Popping a minion from an empty component")
            return nil

        idle_minions = @getIdleMinions()
        popped_minion = nil
        if #idle_minions > 0
            -- if some minions are idle: pop one of them
            popped_minion = table.remove(idle_minions)
        else
            -- if all minions are busy: pop one at random
            -- TODO: prioritize minions not carrying items
            popped_minion = table.remove(@minions)

        -- cleanup
        @minions = lume.filter(@minions, (m) -> m ~= popped_minion)
        for reactor, minion in pairs(@reactorToMinions)
            @reactorToMinions[reactor] = lume.filter(@reactorToMinions[reactor], (m) -> m ~= popped_minion)
        print "removed minion bis", popped_minion
        return popped_minion

    has_mission: (minion) =>
        for reactor, minions in pairs(@reactorToMinions)
            for m in *minions
                if m == minion
                    return true
        return false

    giveMission: (minion) =>
        -- TODO: find closer reactor
        -- TODO: balance minions between reactors
        -- for now --> choose a random reactor
        reactors = @reactorTracker.roomList
        if #reactors > 0
            random_idx = love.math.random(#reactors)
            reactor = reactors[random_idx]
            table.insert(@reactorToMinions[reactor], minion)
            room_origin = {reactor.row, reactor.col}
            minion.missionState = MinionMissionState(room_origin, false, @)

    getMinionCount: =>
        idleCount = #@idleMinions
        busyCount = 0
        for room, minions in @reactorToMinions
            busyCount += #minions
        return idleCount + busyCount
