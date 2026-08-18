require "OldMan_Config"

local function registerTraits()
    local trait = TraitFactory.addTrait(
        OldMan.Config.traitId,
        getText("UI_trait_OldManElderly"),
        -4,
        getText("UI_trait_OldManElderlyDesc"),
        false,
        false
    )

    -- In vanilla, XP boosts also provide starting levels during character creation.
    trait:addXPBoost(Perks.Cooking, 1)
    trait:addXPBoost(Perks.Woodwork, 1)
    trait:addXPBoost(Perks.Farming, 1)
    trait:addXPBoost(Perks.Doctor, 1)
end

Events.OnGameBoot.Add(registerTraits)
