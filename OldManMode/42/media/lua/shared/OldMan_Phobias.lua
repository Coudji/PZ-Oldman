OldMan = OldMan or {}

-- Tokens are conservative, case-insensitive fragments rather than invented full
-- item/sprite IDs. Empty trigger lists are intentional until the B42 catalogue
-- provides an identifier that can be verified in game.
OldMan.Phobias = {
    gnomes = {
        enabled = true,
        weight = 3,
        itemTokens = { "gnome" },
        spriteTokens = { "gnome" },
        speechLines = { "UI_OldMan_Phobia_Gnome_1", "UI_OldMan_Phobia_Gnome_2", "UI_OldMan_Phobia_Gnome_3" },
        worldSoundRadius = 20,
    },
    flamingos = {
        enabled = true,
        weight = 2,
        itemTokens = { "flamingo" },
        spriteTokens = { "flamingo" },
        speechLines = { "UI_OldMan_Phobia_Flamingo_1", "UI_OldMan_Phobia_Flamingo_2" },
    },
    maggots = {
        enabled = true,
        weight = 3,
        itemTokens = { "maggot" },
        spriteTokens = {},
        speechLines = { "UI_OldMan_Phobia_Maggot_1", "UI_OldMan_Phobia_Maggot_2" },
        proximityRadius = 2,
        surpriseStress = 0.10,
    },
    frogs = {
        enabled = true,
        weight = 2,
        itemTokens = { "frog" },
        spriteTokens = {},
        animalTokens = {},
        speechLines = { "UI_OldMan_Phobia_Frog_1", "UI_OldMan_Phobia_Frog_2" },
    },
    rats = {
        enabled = true,
        weight = 2,
        itemTokens = { "rat", "mouse" },
        spriteTokens = {},
        animalTokens = {},
        speechLines = { "UI_OldMan_Phobia_Rat_1", "UI_OldMan_Phobia_Rat_2" },
    },
    insects = {
        enabled = true,
        weight = 2,
        itemTokens = { "worm", "maggot" },
        spriteTokens = {},
        speechLines = { "UI_OldMan_Phobia_Insect_1", "UI_OldMan_Phobia_Insect_2" },
    },
    mannequins = {
        enabled = true,
        weight = 1,
        itemTokens = { "mannequin" },
        spriteTokens = { "mannequin" },
        speechLines = { "UI_OldMan_Phobia_Mannequin_1", "UI_OldMan_Phobia_Mannequin_2" },
    },
    dolls = {
        enabled = true,
        weight = 1,
        itemTokens = { "doll" },
        spriteTokens = { "doll" },
        speechLines = { "UI_OldMan_Phobia_Doll_1", "UI_OldMan_Phobia_Doll_2" },
    },
}

function OldMan.GetEnabledPhobias()
    local result = {}
    for id, phobia in pairs(OldMan.Phobias) do
        local weight = math.max(0, math.floor(phobia.weight or 1))
        if phobia.enabled ~= false and weight > 0 then
            table.insert(result, { id = id, definition = phobia, weight = weight })
        end
    end
    table.sort(result, function(a, b) return a.id < b.id end)
    return result
end
