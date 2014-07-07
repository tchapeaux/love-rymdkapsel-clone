class MinionScheduler
    -- Handle relationship between a minion and its current target
    missions: {
        idle: "idle"
        engineering: "engineering"
        ["food service"]: "food service"
        construction: "construction"
        research: "research"
        defense: "defense"
    }
    new: (@spacebase, @minions) =>
        @inConstruction = {} -- table of Room
        @minionByMissions = {}
        for mission in *MinionScheduler.missions
            @minionByMissions[mission] = {}
        for minion in *@minions
            table.insert(@minionByMissions[MinionScheduler.missions.idle], minion)

    update: (dt) =>
