export ^

require "world/minions/abstractmissioncomponent"

class IdleComponent extends AbstractMissionComponent
    missionType: "idle"

    pop: =>
        if #@minions > 0
            return table.remove(@minions)
        return nil

    has_mission: (minion) =>
        return false

    giveMission: (minion) =>
        return
