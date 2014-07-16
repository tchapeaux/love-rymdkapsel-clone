export ^

require "world/minions/abstractmissioncomponent"

class IdleComponent extends AbstractMissionComponent
    missionType: "idle"

    pop: =>
        if #@idleMinions > 0
            return table.remove(@idleMinions)
        return nil

    has_mission: (minion) =>
        return false

    giveMission: (minion) =>
        return

    getMinionCount: =>
        return #@idleMinions
