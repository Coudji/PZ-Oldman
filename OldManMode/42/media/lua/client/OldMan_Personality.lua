require "OldMan_Config"
require "OldMan_Phobias"

local MOD_DATA_KEY = "OldManMode"
local SCHEMA_VERSION = 2

local function pick(values)
    return values[ZombRand(#values) + 1]
end

local function pickWeightedPhobia()
    local phobias = OldMan.GetEnabledPhobias()
    local totalWeight = 0
    for _, entry in ipairs(phobias) do totalWeight = totalWeight + entry.weight end
    if totalWeight == 0 then return nil end

    local roll = ZombRand(totalWeight)
    for _, entry in ipairs(phobias) do
        if roll < entry.weight then return entry.id end
        roll = roll - entry.weight
    end
    return phobias[#phobias].id
end

local function initialisePlayer(_, player)
    if not player or not player:HasTrait(OldMan.Config.traitId) then return end

    local root = player:getModData()
    root[MOD_DATA_KEY] = root[MOD_DATA_KEY] or {}
    local data = root[MOD_DATA_KEY]

    -- Migrate the prototype's old field without rerolling an existing character.
    data.comfortFood = data.comfortFood or data.comfort
    data.comfort = nil
    data.drinkPreference = data.drinkPreference or pick(OldMan.PersonalityOptions.drinkPreferences)
    data.comfortFood = data.comfortFood or pick(OldMan.PersonalityOptions.comfortFoods)
    data.favoriteActivity = data.favoriteActivity or pick(OldMan.PersonalityOptions.favoriteActivities)
    data.hiddenPreferences = data.hiddenPreferences or {}
    data.phobia = data.phobia or pickWeightedPhobia()
    data.schemaVersion = SCHEMA_VERSION
end

Events.OnCreatePlayer.Add(initialisePlayer)
