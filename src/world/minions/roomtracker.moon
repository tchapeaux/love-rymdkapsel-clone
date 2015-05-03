export ^

lume = require "lib/lume/lume"

class RoomTracker
    new: (@spacebase, @roomType) =>
        @roomList = {}
        helper.makeWeakTable(@roomList)

    update: (dt) =>
        -- add new rooms
        for room in *@spacebase.rooms
            if room.__class == @roomType
                if lume.find(@roomList, room) == nil
                    table.insert(@roomList, room)
        -- remove deleted rooms
        @roomList = lume.filter(@roomList, (r) -> lume.find(@spacebase.rooms, r) ~= nil)
