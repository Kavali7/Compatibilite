# Service 08 : Timing Lunaire

## Description

Le "Timing Lunaire" utilise les 8 phases de la Lune pour optimiser les activités et décisions quotidiennes selon les énergies cosmiques.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Abonnement mensuel |
| **Prix** | 1 000 - 2 000 FCFA/mois |
| **Contenu** | Calendrier lunaire + conseils quotidiens |

## Les 8 Phases Lunaires

| # | Phase | Durée | Énergie | Thème |
|---|-------|-------|---------|-------|
| 1 | Nouvelle Lune | ~3j | Initiation | Intentions, nouveaux départs |
| 2 | Premier Croissant | ~3j | Action | Impulsion, premiers pas |
| 3 | Premier Quartier | ~3j | Décision | Engagement, choix |
| 4 | Gibbeuse Croissante | ~3j | Patience | Ajustements, préparation |
| 5 | Pleine Lune | ~3j | Culmination | Récolte, célébration |
| 6 | Gibbeuse Décroissante | ~3j | Partage | Gratitude, transmission |
| 7 | Dernier Quartier | ~3j | Libération | Lâcher-prise, pardon |
| 8 | Dernier Croissant | ~3j | Repos | Introspection, préparation |

## Calcul de Phase

Le cycle lunaire dure environ 29.53 jours. La fonction SQL `fn_get_lunar_phase()` calcule la phase actuelle basée sur une Nouvelle Lune de référence.

```sql
SELECT fn_get_lunar_phase(CURRENT_DATE) AS current_phase;
```

## Structure

```
08_timing_lunaire/
├── README.md
├── content/
│   ├── phase_1_nouvelle_lune.md
│   ├── phases_2_4_croissantes.md
│   ├── phase_5_pleine_lune.md
│   └── phases_6_8_decroissantes.md
└── database/
    ├── migration.sql
    └── seed_content.sql
```

## Note Technique

Pour une précision astronomique en production, considérez l'intégration d'une API lunaire comme [Astronomy API](https://astronomyapi.com/).
