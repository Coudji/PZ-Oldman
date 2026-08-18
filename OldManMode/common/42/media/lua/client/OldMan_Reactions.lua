require "OldMan_Config"
require "OldMan_Phobias"

local MOD_DATA_KEY = "OldManMode"

local function containsToken(value, tokens)
    value = string.lower(value or "")
    for _, token in ipairs(tokens) do
        if string.find(value, token, 1, true) then return true end
    end
    return false
end

local function inventoryHasTrigger(player, phobia)
    local items = player:getInventory():getItems()
    for index = 0, items:size() - 1 do
        if containsToken(items:get(index):getFullType(), phobia.itemTokens) then return true end
    end
    return false
end

local function worldHasTrigger(player, phobia)
    local cell = getCell()
    local px, py, pz = math.floor(player:getX()), math.floor(player:getY()), player:getZ()
    local radius = OldMan.Config.proximityRadius
    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local square = cell:getGridSquare(x, y, pz)
            if square then
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

local function react(player, state, phobia, now)
    local stats = player:getStats()
    stats:setStress(math.min(1, stats:getStress() + OldMan.Config.surpriseStress))
    state.nextReactionHour = now + OldMan.Config.reactionCooldownHours

    if not state.nextSpeechHour or now >= state.nextSpeechHour then
        player:Say(phobia.lines[ZombRand(#phobia.lines) + 1])
        state.nextSpeechHour = now + OldMan.Config.speechCooldownHours
        addSound(player, player:getX(), player:getY(), player:getZ(),
            OldMan.Config.worldSoundRadius, OldMan.Config.worldSoundVolume)
    end
end

local function scanPlayer(player)
    if not player or not player:HasTrait(OldMan.Config.traitId) then return end
    local state = player:getModData()[MOD_DATA_KEY]
    if not state or not state.phobia then return end
    local phobia = OldMan.Phobias[state.phobia]
    if not phobia then return end

    local exposed = inventoryHasTrigger(player, phobia) or worldHasTrigger(player, phobia)
    if not exposed then
        state.wasExposed = false
        return
    end

    local stats = player:getStats()
    stats:setStress(math.min(1, stats:getStress() + OldMan.Config.proximityStressPerScan))
    local now = getGameTime():getWorldAgeHours()
    if not state.wasExposed and (not state.nextReactionHour or now >= state.nextReactionHour) then
        react(player, state, phobia, now)
    end
    state.wasExposed = true
end

Events.EveryOneMinute.Add(function()
    for playerIndex = 0, getNumActivePlayers() - 1 do
        scanPlayer(getSpecificPlayer(playerIndex))
    end
end)
