export ^

lume = require "lib/lume/lume"

class RoomTracker
    new: (@spacebase, @roomType) =>
        @roomList = {}
        -- two following tables keep track of each room change for each frame
        @roomsAdded = {}
        @roomsRemoved = {}
        helper.makeWeakTable(@roomList)
        helper.makeWeakTable(@roomsAdded)
        helper.makeWeakTable(@roomsRemoved)

    update: (dt) =>
        -- reset room added/removed
        @roomsAdded = {}
        @roomsRemoved = {}
        -- add new rooms
        for room in *@spacebase.rooms
            if room.__class == @roomType
                if lume.find(@roomList, room) == nil
                    table.insert(@roomList, room)
                    table.insert(@roomsAdded, room)
        -- remove deleted rooms
        newRoomList = lume.filter(@roomList, (r) -> lume.find(@spacebase.rooms, r) ~= nil)
        @roomsRemoved = lume.filter(@roomList, (r) -> lume.find(newRoomList, r) == nil)
        @roomList = newRoomList
