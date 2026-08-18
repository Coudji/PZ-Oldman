OldMan = OldMan or {}

OldMan.Config = {
    traitId = "OldManMode_Elderly",
    reactionCooldownHours = 0.20,
    speechCooldownHours = 0.50,
    serverSoundCooldownHours = 0.01,
    worldSoundRadius = 18,
    worldSoundVolume = 25,
    proximityRadius = 4,
    surpriseStress = 0.08,
    surprisePanic = 2,
    proximityStressPerMinute = 0.004,
}

OldMan.PersonalityOptions = {
    drinkPreferences = { "coffee", "tea", "both" },
    comfortFoods = { "chocolate", "candy", "biscuits", "soup" },
    favoriteActivities = { "fishing", "gardening", "tinkering", "reading" },
}

function OldMan.GetPhobiaValue(phobia, key)
    local value = phobia[key]
    if value ~= nil then return value end
    return OldMan.Config[key]
end
