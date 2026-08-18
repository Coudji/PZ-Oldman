# Audit ciblé — Project Zomboid Build 42

Audit effectué contre le Lua vanilla **B42.20.2** archivé par la communauté et
les JavaDocs exposées par The Indie Stone. « Statique » signifie uniquement que
le point d'API et la syntaxe ont été inspectés : aucune ligne du tableau ne doit
être interprétée comme un test dans le jeu.

| Feature | Status | API utilisée / auditée | Solo | Hosted co-op | Dedicated | Risque | Notes |
|---|---|---|---|---|---|---|---|
| Layout versionné | IMPLÉMENTÉ, STATIQUE | `42/mod.info`, `42/media` | Non testé | Non testé | Non testé | Faible | Aucun faux emboîtement `common/42`; installation locale et Workshop documentées. |
| Trait Vieillard | IMPLÉMENTÉ, STATIQUE | `TraitFactory.addTrait`, `Events.OnGameBoot` | Non testé | Non testé | Non testé | Moyen | Coût `-4`; affichage et disponibilité à confirmer dans l'écran de création B42. |
| Compétences initiales | IMPLÉMENTÉ, STATIQUE | `Trait:addXPBoost`, `Perks.Cooking/Woodwork/Farming/Doctor` | Non testé | Non testé | Non testé | Moyen | Les symboles de perks sont présents en B42; les niveaux réellement accordés restent à mesurer en jeu. |
| Personnalité persistante | IMPLÉMENTÉ, STATIQUE | `OnCreatePlayer`, `IsoPlayer:getModData` | Non testé | Non testé | Non testé | Moyen | Initialisation idempotente, migration du champ `comfort`, schéma v2. |
| Myopie aléatoire | REPORTÉ | mutation de `getTraits()` auditée | N/A | N/A | N/A | Élevé | La mutation client-side a été supprimée : aucune autorité/réplication sûre n'a été confirmée pour création, reconnexion et serveur dédié. |
| Phobies data-driven | IMPLÉMENTÉ, STATIQUE | tables Lua, sélection pondérée | Non testé | Non testé | Non testé | Faible | Ajouter une définition activée suffit à la rendre sélectionnable; toutes les options ont des valeurs globales de repli. |
| Visibilité des objets monde | IMPLÉMENTÉ, STATIQUE | `IsoGridSquare:isCanSee(playerIndex)` | Non testé | Non testé | Non testé | Moyen | Scan court une fois par minute; les cases hors champ/ligne de vue ne sont plus traitées. |
| Découverte en conteneur | IMPLÉMENTÉ, STATIQUE | `OnRefreshInventoryWindowContainers(page, "end")`, `page.inventoryPane.inventory` | Non testé | Non testé | Non testé | Moyen | Hook vanilla ciblé, sans modifier `ISInventoryPage`; une réaction maximum par changement de conteneur et cooldown global. |
| Animaux phobiques | REPORTÉ | classes animales examinées, aucun hook retenu | N/A | N/A | N/A | Moyen | Les champs `animalTokens` sont réservés mais ne sont pas consommés tant qu'un parcours léger et fiable n'est pas confirmé. |
| Stress et panique | IMPLÉMENTÉ, STATIQUE | `Stats:get/setStress`, `Stats:get/setPanic` | Non testé | Non testé | Non testé | Moyen | Effet local borné; synchronisation des stats à valider en coop. |
| Parole | IMPLÉMENTÉ, STATIQUE | `IsoPlayer:Say`, `getText` | Non testé | Non testé | Non testé | Moyen | Toutes les répliques passent par EN/FR; visibilité pour les autres clients à tester. |
| Stimulus zombie | IMPLÉMENTÉ, STATIQUE | `sendClientCommand`, `OnClientCommand`, `addSound` | Non testé | Non testé | Non testé | Élevé | En MP le serveur recalcule la position et les paramètres depuis ses propres données, puis limite la fréquence; réaction zombie à valider en jeu. |
| Café/thé | REPORTÉ | `ISEatFoodAction`, callback item `OnEat` | N/A | N/A | N/A | Moyen | B42 n'expose pas d'événement global de consommation; modifier la timed action ou les items vanilla serait invasif. |
| Comfort food | REPORTÉ | même audit que café/thé | N/A | N/A | N/A | Moyen | Préférence persistée, effet volontairement absent jusqu'à un hook global propre. |
| Phobie des poules | REPORTÉ | identification animale | N/A | N/A | N/A | Moyen | Aucun matcher n'est inventé. |
| Caps, fractures, fuite, visée, sac, narcolepsie, legacy, zombies custom | BACKLOG | non implémenté | N/A | N/A | N/A | Élevé/Unsafe | Explicitement hors périmètre de cette passe. |

## Catalogue et déclencheurs

Les fragments textuels existants (`gnome`, `frog`, `rat`, etc.) sont des
matchers conservateurs et insensibles à la casse, pas des identifiants complets
présentés comme officiels. Les listes vides sont intentionnelles. Avant une
publication, un test en B42 doit inventorier les `fullType` et noms de sprites
réels, puis remplacer ou compléter ces fragments par les identifiants observés.

## Bruit et modèle réseau

En solo, le client local appelle directement `addSound`. En multijoueur, il
envoie uniquement une demande : le serveur valide le trait, applique un
cooldown, ignore toute position ou intensité provenant du client, résout rayon
et volume depuis les définitions partagées,
puis appelle `addSound` à la position serveur du joueur. Cette architecture
évite de faire confiance au client, mais reste **non testée dans le jeu**.

## Sources d'audit

- JavaDocs The Indie Stone : `IsoGridSquare.isCanSee(int)`, `Stats`,
  `LuaManager.GlobalObject.addSound` et `sendClientCommand`.
- Lua vanilla B42.20.2, miroir
  `Project-Zomboid-Community-Modding/ProjectZomboid-Vanilla-Lua`, notamment
  `ISInventoryPage.lua` et `ISEatFoodAction.lua`.
- Documentation d'événements générée par `demiurgeQuantified/PZEventDoc`, pour
  les signatures de `OnCreatePlayer`, `OnClientCommand` et
  `OnRefreshInventoryWindowContainers`.
