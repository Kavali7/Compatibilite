# Service 07 : Phases de Vie

## Description

Les "Phases de Vie" divisent l'existence en cycles de 7 ans, chacun avec un thème et des caractéristiques spécifiques influençant le parcours de vie.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Achat unique |
| **Prix** | 5 000 - 8 000 FCFA |
| **Contenu** | Rapport complet + phases passées |

## Les 10 Phases de Vie

| # | Phase | Âge | Thème |
|---|-------|-----|-------|
| 1 | Enfance | 0-7 | Formation de l'identité |
| 2 | Croissance | 7-14 | Socialisation, apprentissage |
| 3 | Adolescence | 14-21 | Quête d'indépendance |
| 4 | Jeune Adulte | 21-28 | Construction de vie |
| 5 | Première Maturité | 28-35 | Stabilisation, famille |
| 6 | Crise du Milieu | 35-42 | Réévaluation |
| 7 | Sagesse Émergente | 42-49 | Transmission |
| 8 | Accomplissement | 49-56 | Récolte des fruits |
| 9 | Sagesse Profonde | 56-63 | Héritage spirituel |
| 10 | Transcendance | 63+ | Paix intérieure |

## Calcul

```dart
int getCurrentLifePhase(DateTime birthdate) {
  int ageYears = DateTime.now().difference(birthdate).inDays ~/ 365;
  return min((ageYears ~/ 7) + 1, 10);
}
```

## Structure

```
07_phases_vie/
├── README.md
├── content/
│   ├── phase_01_enfance.md
│   ├── phase_02_croissance.md
│   ├── phase_03_adolescence.md
│   ├── phase_04_jeune_adulte.md
│   ├── phase_05_maturite_1.md
│   ├── phase_06_maturite_2.md
│   ├── phase_07_maturite_3.md
│   └── phases_08_10.md
└── database/
    ├── migration.sql
    └── seed_content.sql
```

## Contenu par Phase

Chaque rapport inclut :
- **Caractéristiques** de la phase
- **Thème central** et signification
- **Impacts** sur la vie actuelle
- **Points de réflexion**
- **Travail de guérison** suggéré
