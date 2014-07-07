-- Inspired by the state pattern (e.g. http://gameprogrammingpatterns.com/state.html)
-- MinionMission is the "root" class
-- three abstract mission "types":
--     - GoThere: Go in a given type of room (engineering)
--     - Accumulate: Put resources in a given room (construction, food service)
--     - GoFetch: Take hold of a given type of object (research, defense)

export ^

require "world/rooms/room"
require "world/rooms/corridor"
require "world/rooms/reactor"
require "world/items"

randomChoiceFilter = (set, filterFunction=->true) ->
    -- return a random element of set such that filterFunction(elem) == true
    trueElements = {}
    for elem in *set
        if filterFunction(elem) == true
            table.insert(trueElements, elem)
    chosen = nil
    if #trueElements > 0
        choice = math.random(#trueElements)
        chosen = trueElements[choice]
    return chosen

class MinionMission
    new: =>
    update: (dt) => return
    findTarget: (spacebase) => return
    checkTarget: (spacebase) => return -- check if the current target is still valid
    isIdle: => return true

class MissionSlack extends MinionMission
    isIdle: => return true

class GoThereMission extends MinionMission
    roomType: Room
    new: =>
        @targetRoom = nil -- instance of Room
    findTarget: (spacebase) =>
        filterFct = (room) -> room.__class == @roomType
        @targetRoom = randomChoiceFilter(spacebase.rooms, filterFct)
    checkTarget: (spacebase) =>
        if @targetRoom == nil then return true
        for room in spacebase.rooms
            if room == @targetRoom then return true
        return false
    isIdle: =>
        return @targetRoom == nil

class EngineeringMission extends GoThereMission
    roomType: Reactor
    speedUpFactor: 2 -- Factor at which the Minion makes the Reactor go faster
    update: (dt) =>
        if @targetRoom\canProduce()
            @roomType.productionCounter += dt * (speedUpFactor - 1)
    isIdle: =>
        return @targetRoom == nil or not @targetRoom\canProduce()

class AccumulateMission extends MinionMission
    targetRoomCondition: (room) -> return true
    getTargetItemType: => return nil
    findItemTile: (spacebase, objectType) =>
        tilesCandidate = {}
        for room in spacebase.rooms
            if room.__class ~= Corridor
                for tile in room.tiles
                    item = tile.itemContained
                    if item and item.__class == objectType
                        table.insert(tiles.candidate)
        return randomChoiceFilter(tilesCandidate)

    new: =>
        @targetItemTile = nil -- the tile containing the target item
        @targetItemType = nil
        @targetRoom = nil -- the room where the target item must be placed
        @itemCarried = nil

    checkTarget: (spacebase) =>
        checkRoom = @targetRoom and targetRoomCondition(@targetRoom)
        if checkRoom == false
            return false
        item = targetItemTile.itemContained
        resType = @targetItemType
        checkItem = targetItemTile
        checkItem and= item and item.__class == @targetItemType
        checkItem and= @targetRoom.current_resources[resType] < @targetRoomCondition.required_resources[resType]
        return checkItem

    findTarget: (spacebase) =>
        if @targetRoom == nil
            @targetRoom = randomChoiceFilter(spacebase.rooms, filterFct)
        if @targetItemTile == nil and @targetRoom ~= nil
            objectType = @getTargetItemType()
            if objectType
                @targetItemTile = @findItemTile(objectType)

class ConstructionMission extends AccumulateMission
    targetRoomCondition: (room) -> room.state == Room.states.construction
    getTargetItemType: =>
        filterFct = (res) ->
            cur = @targetRoom.current_resources[res]
            req = @targetRoom.required_resources[res]
            return cur < req
        return randomChoiceFilter({Energy, Material, Food}, filterFct)

class FoodMission extends AccumulateMission
    subMissionTypes = {
        idle: "idle"
        sludgeToFood: "sludgeToKitchens"
        foodToQuarters: "foodToQuarters"
    }
    new: =>
        @subMission = @subMissionTypes.idle
    update: (dt) =>
        if @subMission = @subMissionTypes.idle
            @findNewSubMission()
    targetRoomCondition: (room) ->
        switch @subMission
            when @subMissionTypes.sludgeToKitchens
                return @room.__class == Kitchen
            when @subMissionTypes.foodToQuarters
                return @room.__class == Quarters
            when @subMissionTypes.idle
                return false
    getTargetItemType: =>
        switch @subMission
            when @subMissionTypes.sludgeToKitchens
                return @room.__class == Kitchen
            when @subMissionTypes.foodToQuarters
                return @room.__class == Quarters
            when @subMissionTypes.idle
                return nil

class GoFetchMission extends MinionMission
    itemType: Item
    update: (dt) => return
    findTarget: (spacebase) => return
    checkTarget: (spacebase) => return
    isIdle: => return true

class DefenseMission extends GoFetchMission
    itemType: Gun
    setNewTargets: (spacebase) =>
        return

class ResearchMission extends GoFetchMission
    itemType: ResearchEquipment
    setNewTargets: (spacebase) =>
        return
