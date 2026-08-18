# Audit initial — Project Zomboid Build 42

Cet audit est volontairement conservateur : le prototype n'utilise que des
points d'extension vanilla largement établis et garde les mécaniques ambiguës
hors du code. Il devra être validé en jeu sur la version 42 ciblée avant une
publication Workshop.

| Fonctionnalité | Faisabilité | API vanilla possible | Risque MP | Complexité | Recommandation |
|---|---|---|---|---|---|
| Trait Vieillard | EASY | `TraitFactory`, `Events.OnGameBoot` | Faible | Faible | **Prototype** |
| Compétences initiales | EASY | `Trait:addXPBoost`, `Perks` | Faible | Faible | **Prototype** |
| Personnalité aléatoire persistante | EASY | `IsoPlayer:getModData`, `OnCreatePlayer` | Faible | Faible | **Prototype** |
| Phobie item/sprite | MODERATE | inventaire, carrés/objets, `EveryOneMinute` | Faible, effet local | Moyen | **Prototype prudent** |
| Stress, parole et bruit de phobie | MODERATE | `Stats`, `IsoPlayer:Say`, `addSound` | Moyen | Moyen | **Prototype; tester MP** |
| Café/thé consommé | MODERATE | événement de consommation à confirmer | Moyen | Moyen | Auditer les timed actions B42 |
| Petits plaisirs | MODERATE | événement de consommation à confirmer | Moyen | Moyen | Après le rituel matinal |
| Toux / ronflement | MODERATE | état sommeil/essoufflement + son monde | Élevé | Moyen | Autorité serveur à concevoir |
| Caps physiques | HARD | aucun cap de perk public confirmé | Élevé | Élevé | Ne pas simuler par retrait d'XP |
| Escalade / fractures | HARD | timed actions et blessures à confirmer | Élevé | Élevé | Pas de monkey-patch global |
| Tremblement de visée | HARD | pipeline de visée B42 à auditer | Élevé | Élevé | Reporter |
| Mouvement forcé de phobie | UNSAFE | contrôle joueur / commandes réseau | Très élevé | Élevé | Ne pas faire au prototype |
| Sac pondéré comme arme | HARD | callbacks de combat et conteneur | Élevé | Élevé | Prototype isolé ultérieur |
| Legacy events dynamiques | HARD | génération bâtiment/zombie/objets | Élevé | Très élevé | Vertical slice séparée |
| Zombie vieillard custom | HARD | outfit + variables zombie | Élevé | Très élevé | Après stabilisation B42 |

## Choix du premier jalon

Le premier jalon retient quatre briques indépendantes : trait maître,
savoir-faire initial, personnalité sauvegardée et phobie simple. Les réactions
n'interrompent jamais une action et ne déplacent jamais le joueur. Le scan est
limité à quelques cases et ne tourne qu'une fois par minute de jeu.

## Limites connues

- Les tokens d'items et de sprites devront être complétés depuis le catalogue de
  la version exacte de Build 42 utilisée pour les essais.
- L'ajout aléatoire de `ShortSighted` est sauvegardé dans les `modData`, mais la
  mutation de traits après la création doit être validée côté serveur dédié.
- `addSound` crée un stimulus pour le monde ; l'audibilité client et l'autorité
  serveur doivent être testées avant d'annoncer une compatibilité multijoueur.
- Le prototype ne prétend pas encore gérer les conteneurs ouverts : il réagit à
  l'inventaire du joueur et aux sprites proches, sans patcher l'interface vanilla.
