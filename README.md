# Old Man Mode / Mode Vieillard

Prototype Build 42 pour jouer un survivant qui sait exactement quoi faire, mais
dont les genoux ne sont pas d'accord.

## Prototype actuel

- trait maître **Vieillard / Senior Citizen** ;
- savoir-faire de départ (cuisine, menuiserie, agriculture et premiers soins) ;
- personnalité persistante tirée une seule fois par personnage ;
- phobies data-driven des nains de jardin, flamants roses et asticots ;
- surprise, stress de proximité, répliques et bruit réel avec cooldowns ;
- configuration centralisée, sans patch global des classes vanilla.

Le détail des choix d'API, des limites et de la feuille de route se trouve dans
[`docs/BUILD42_AUDIT.md`](docs/BUILD42_AUDIT.md).

## Installation

Copier `OldManMode` dans le dossier `Zomboid/mods`, puis activer **Old Man
Mode**. Le dossier `common/` et son sous-dossier versionné `42/` suivent le
format de mod de Build 42.

## Développement

Le prototype ne dépend d'aucune bibliothèque Lua tierce. Une vérification
statique peut être lancée avec :

```sh
./scripts/check.sh
```
