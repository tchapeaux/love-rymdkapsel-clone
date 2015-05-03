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
        @reactorToMinion = {} -- key: reactor; value: minion
        helper.makeWeakTable(@reactorToMinion)

    update: (dt) =>
        @reactorTracker\update(dt)
        super(dt)

    pop: =>
        if #@idleMinions > 0
            -- if some minions are idle: pop one of them
            return table.remove(@idleMinions)
        else
            -- if all minions are busy: pop one at random
            -- TODO: prioritize minions not carrying items
            for reactor, minion in pairs(@reactorToMinion)
                -- we arbitrarily return the first minion
                @reactorToMinion[reactor] = nil
                return minion

    has_mission: (minion) =>
        for reactor, busyminion in pairs(@reactorToMinion)
            if busyminion == minion
                return true
        return false

    giveMission: (minion) =>
        -- TODO: find closer reactor
        -- TODO: balance minions between reactors
        for reactor in *@reactorTracker
            if @reactorToMinion[reactor] == nil
                @reactorToMinion[reactor] = minion
                minion.missionState = MinionMissionState(reactor.origin, false, @)

    getMinionCount: =>
        idleCount = #@idleMinions
        busyCount = 0
        for room, minion in @reactorToMinion
            busyCount += 1

    updateReactorRooms: =>
        -- add new reactors
        for room in *@spacebase.rooms
            if room.__class == Reactor
                if lume.find(@reactorRoomList, room) == nil
                    table.insert(@reactorRoomList, room)
        -- remove deleted reactors
        index_to_remove = {}
        for index, reactor in *@reactorRoomList
            if lume.find(@spacebase.rooms, reactor) == nil
                table.insert(index_to_remove, index)
        for index in *index_to_remove
            reactor = table.remove(@reactorRoomList, index)
            @reactorToMinion[reactor] = nil
