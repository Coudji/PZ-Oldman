require "OldMan_Config"
require "OldMan_Phobias"

local MOD_DATA_KEY = "OldManMode"

local function hasElderlyTrait(player)
    return player and player:HasTrait(OldMan.Config.traitId)
end

local function pick(values)
    return values[ZombRand(#values) + 1]
end

local function initialisePlayer(player)
    if not hasElderlyTrait(player) then return end

    local data = player:getModData()
    data[MOD_DATA_KEY] = data[MOD_DATA_KEY] or {}
    local oldManData = data[MOD_DATA_KEY]
    if oldManData.initialised then return end

    oldManData.initialised = true
    oldManData.drinkPreference = pick(OldMan.Personality.drinks)
    oldManData.comfort = pick(OldMan.Personality.comforts)

    local phobiaIds = { "gnomes", "flamingos", "maggots" }
    oldManData.phobia = pick(phobiaIds)

    -- HasTrait prevents duplicate insertion if another mod already granted it.
    if ZombRandFloat(0, 1) < OldMan.Config.randomShortSightedChance
            and not player:HasTrait("ShortSighted") then
        player:getTraits():add("ShortSighted")
        oldManData.shortSightedGranted = true
    end
end

Events.OnCreatePlayer.Add(function(_, player)
    initialisePlayer(player)
end)

Events.OnPlayerUpdate.Add(function(player)
    -- Covers existing saves loaded before this module was installed.
    initialisePlayer(player)
end)
