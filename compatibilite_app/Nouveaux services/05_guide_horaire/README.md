# Service 05 : Guide Horaire du Jour

## Description

Le "Guide Horaire" divise chaque jour en 7 micro-périodes pour optimiser les activités quotidiennes.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Pay-per-day ou packs |
| **Prix** | 500 FCFA/jour ou 2 500 FCFA/semaine |
| **Contenu** | 7 créneaux optimisés par jour |

## Les 7 Micro-Périodes Quotidiennes

| # | Créneau | Heures (exemple) | Énergie |
|---|---------|------------------|---------|
| 1 | Aube | 5h-8h | Initiation, méditation |
| 2 | Matin | 8h-11h | Travail intense, concentration |
| 3 | Midi | 11h-14h | Communication, réunions |
| 4 | Après-midi 1 | 14h-17h | Créativité, projets |
| 5 | Après-midi 2 | 17h-20h | Réflexion, bilan |
| 6 | Soir | 20h-23h | Détente, relations |
| 7 | Nuit | 23h-5h | Repos, régénération |

## Calcul Personnalisé

Les heures exactes dépendent de :
- Période personnelle actuelle (1-7)
- Jour de la semaine
- Profil Soul de l'utilisateur

## Structure

```
05_guide_horaire/
├── README.md
├── content/
│   ├── creneau_1_aube.md
│   ├── creneau_2_matin.md
│   ├── creneau_3_midi.md
│   ├── creneau_4_apres_midi_1.md
│   ├── creneau_5_apres_midi_2.md
│   ├── creneau_6_soir.md
│   └── creneau_7_nuit.md
├── database/
│   ├── migration.sql
│   └── seed_content.sql
├── admin/
│   └── admin_guide.md
└── flutter/
    └── implementation_guide.md
```

## Note

Ce service nécessite une intégration avec les services 01 (Portrait) et 02 (Cycle Personnel) pour la personnalisation complète.
