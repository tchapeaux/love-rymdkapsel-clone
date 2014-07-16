export ^

class roomTracker
    new: (@spacebase, @roomType) =>
        roomList = {}
        meta = {}
        meta.__mode == "kv"
        setmetatable(roomList, meta)

    update: (dt) =>
        -- add new rooms
        for room in *@spacebase.rooms
            if room.__class == @roomType
                if lume.find(@roomList, room) == nil
                    table.insert(@roomList, room)
        -- remove deleted rooms
        index_to_remove = {}
        for index, reactor in *@roomList
            if lume.find(@spacebase.rooms, reactor) == nil
                table.insert(index_to_remove, index)
        for index in *index_to_remove
            room = table.remove(@roomList, index)
