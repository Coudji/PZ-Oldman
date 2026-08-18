OldMan = OldMan or {}

-- Matchers are deliberately data-only. Exact full types/sprites can be added as
-- Build 42's item catalogue evolves without touching the reaction engine.
OldMan.Phobias = {
    gnomes = {
        itemTokens = { "gnome" },
        spriteTokens = { "gnome" },
        lines = {
            "Bordel, encore un de ces trucs !",
            "Qui achete ca, serieusement ?!",
            "Enleve-moi cette saloperie de la !",
        },
    },
    flamingos = {
        itemTokens = { "flamingo" },
        spriteTokens = { "flamingo" },
        lines = { "Pas ce maudit flamant rose !", "C'est pas une couleur naturelle !" },
    },
    maggots = {
        itemTokens = { "maggot", "maggots" },
        spriteTokens = {},
        lines = { "Referme ca !", "Ca grouille la-dedans !" },
    },
}
