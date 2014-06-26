export ^

require "world/spacebase"

class World
    -- Encapsulate the world logic (data and non-User-behavior)
    new: =>
        @spacebase = Spacebase()
        @minions = {}
        @minionScheduler = MinionScheduler(@spacebase, @minions)

    update: (dt) =>
        @spacebase\update(dt)
        for minion in *@minions
            minion\update(dt)
        @minionScheduler\update(dt)

    getItems: (fromMinions=true, fromRooms=true) =>
        items = {}
        if fromMinions
            for minion in *@minions
                item = minion\getItem()
                if item
                    table.insert(items, item)
        if fromRooms
            for item in *@spacebase.getItems()
                table.insert(items, item)
        return items
