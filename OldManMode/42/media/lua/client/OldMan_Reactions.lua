require "OldMan_Config"
require "OldMan_Phobias"

local MOD_DATA_KEY = "OldManMode"
local runtime = {}

local function containsToken(value, tokens)
    value = string.lower(value or "")
    for _, token in ipairs(tokens or {}) do
        if string.find(value, string.lower(token), 1, true) then return true end
    end
    return false
end

local function containerHasTrigger(container, phobia)
    if not container then return false end
    local items = container:getItems()
    for index = 0, items:size() - 1 do
        if containsToken(items:get(index):getFullType(), phobia.itemTokens) then return true end
    end
    return false
end

local function worldHasVisibleTrigger(player, playerIndex, phobia)
    local cell = getCell()
    local px, py, pz = math.floor(player:getX()), math.floor(player:getY()), player:getZ()
    local radius = OldMan.GetPhobiaValue(phobia, "proximityRadius")
    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local square = cell:getGridSquare(x, y, pz)
            if square and square:isCanSee(playerIndex) then
                local objects = square:getObjects()
                for index = 0, objects:size() - 1 do
                    local sprite = objects:get(index):getSprite()
                    if sprite and containsToken(sprite:getName(), phobia.spriteTokens) then return true end
                end
            end
        end
    end
    return false
end

local function emitWorldSound(player, phobiaId, phobia)
    local radius = OldMan.GetPhobiaValue(phobia, "worldSoundRadius")
    local volume = OldMan.GetPhobiaValue(phobia, "worldSoundVolume")
    if isClient() then
        -- The server resolves radius and volume from its own shared definitions.
        sendClientCommand(player, "OldManMode", "worldSound", { phobia = phobiaId })
    else
        addSound(player, player:getX(), player:getY(), player:getZ(), radius, volume)
    end
end

local function react(player, state, phobia, now)
    local stats = player:getStats()
    stats:setStress(math.min(1, stats:getStress() + OldMan.GetPhobiaValue(phobia, "surpriseStress")))
    stats:setPanic(math.min(100, stats:getPanic() + OldMan.GetPhobiaValue(phobia, "surprisePanic")))
    state.nextReactionHour = now + OldMan.GetPhobiaValue(phobia, "reactionCooldownHours")

    local lines = phobia.speechLines or {}
    if #lines > 0 and (not state.nextSpeechHour or now >= state.nextSpeechHour) then
        player:Say(getText(lines[ZombRand(#lines) + 1]))
        state.nextSpeechHour = now + OldMan.GetPhobiaValue(phobia, "speechCooldownHours")
        emitWorldSound(player, state.phobia, phobia)
    end
end

local function getState(player)
    if not player or not player:HasTrait(OldMan.Config.traitId) then return nil end
    local state = player:getModData()[MOD_DATA_KEY]
    if not state or not state.phobia then return nil end
    local phobia = OldMan.Phobias[state.phobia]
    if not phobia or phobia.enabled == false then return nil end
    return state, phobia
end

local function handleExposure(player, state, phobia, exposureKey, isExposed)
    if not isExposed then
        state[exposureKey] = false
        return
    end

    local stats = player:getStats()
    stats:setStress(math.min(1, stats:getStress() + OldMan.GetPhobiaValue(phobia, "proximityStressPerMinute")))
    local now = getGameTime():getWorldAgeHours()
    if not state[exposureKey] and (not state.nextReactionHour or now >= state.nextReactionHour) then
        react(player, state, phobia, now)
    end
    state[exposureKey] = true
end

local function scanWorld()
    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex)
        local state, phobia = getState(player)
        if state then
            handleExposure(player, state, phobia, "worldExposed",
                worldHasVisibleTrigger(player, playerIndex, phobia))
        end

        local lootPage = getPlayerLoot(playerIndex)
        if not lootPage or not lootPage:getIsVisible() then runtime[playerIndex] = nil end
    end
end

local function scanOpenedContainer(inventoryPage, reason)
    if reason ~= "end" or not inventoryPage or inventoryPage.onCharacter then return end
    local playerIndex = inventoryPage.player
    local player = getSpecificPlayer(playerIndex)
    local state, phobia = getState(player)
    if not state then return end

    local container = inventoryPage.inventoryPane and inventoryPage.inventoryPane.inventory
    if not container or runtime[playerIndex] == container then return end
    runtime[playerIndex] = container
    if containerHasTrigger(container, phobia) then
        local now = getGameTime():getWorldAgeHours()
        if not state.nextReactionHour or now >= state.nextReactionHour then react(player, state, phobia, now) end
    end
end

Events.EveryOneMinute.Add(scanWorld)
Events.OnRefreshInventoryWindowContainers.Add(scanOpenedContainer)
