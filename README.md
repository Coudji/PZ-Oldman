# Old Man Mode / Mode Vieillard

Prototype Build 42 pour jouer un survivant qui sait exactement quoi faire, mais
dont les genoux ne sont pas d'accord.

## Prototype actuel

- trait maître **Vieillard / Senior Citizen** ;
- savoir-faire de départ (cuisine, menuiserie, agriculture et premiers soins) ;
- personnalité persistante et migrable tirée une seule fois par personnage ;
- phobies pondérées et data-driven, avec réglages locaux facultatifs ;
- objets du monde filtrés par la visibilité vanilla et conteneurs fouillés ;
- surprise, légère panique, stress, répliques traduites et bruit autoritaire côté serveur ;
- configuration centralisée, sans patch global des classes vanilla.

Le détail des choix d'API, des limites et de la feuille de route se trouve dans
[`docs/BUILD42_AUDIT.md`](docs/BUILD42_AUDIT.md).

## Installation

Copier le dossier `OldManMode` dans `~/Zomboid/mods/` (Linux),
`%UserProfile%/Zomboid/mods/` (Windows) ou le dossier `Zomboid/mods/`
équivalent, puis activer **Old Man Mode**. Le manifeste chargé par Build 42 est
alors `Zomboid/mods/OldManMode/42/mod.info`.

Pour un paquet Workshop, le même dossier se place sous
`Contents/mods/OldManMode/`. Le répertoire `common/` est réservé aux ressources
réellement partagées entre plusieurs versions ; ce prototype exclusivement B42
n'en crée pas.

## Développement

Le prototype ne dépend d'aucune bibliothèque Lua tierce. Une vérification
**statique** peut être lancée avec :

```sh
./scripts/check.sh
```

Cette commande ne lance pas Project Zomboid et ne constitue donc pas un test en
jeu, en coop hébergée ou sur serveur dédié.
