# Service 02 : Cycle Annuel Personnel

## Description

Le "Cycle Annuel Personnel" divise l'année en 7 périodes de 52 jours basées sur la date de naissance. Chaque période a des caractéristiques spécifiques pour la planification personnelle.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Abonnement annuel |
| **Prix suggéré** | 5 000 - 10 000 FCFA/an |
| **Contenu** | 7 rapports de période + calendrier personnalisé |
| **Renouvellement** | Automatique chaque année |

## Logique de Calcul

### Calcul du Début de Cycle

Le cycle personnel commence à la date d'anniversaire de l'utilisateur.

```dart
DateTime getCycleStart(DateTime birthdate, int year) {
  return DateTime(year, birthdate.month, birthdate.day);
}
```

### Durée des Périodes

Chaque période dure **52 jours** (environ 7,5 semaines).

| Période | Jours après anniversaire |
|---------|--------------------------|
| 1 | Jour 1 - 52 |
| 2 | Jour 53 - 104 |
| 3 | Jour 105 - 156 |
| 4 | Jour 157 - 208 |
| 5 | Jour 209 - 260 |
| 6 | Jour 261 - 312 |
| 7 | Jour 313 - 365 |

### Calcul de la Période Actuelle

```dart
int getCurrentPeriod(DateTime birthdate, DateTime currentDate) {
  // Trouver le dernier anniversaire
  DateTime lastBirthday = DateTime(currentDate.year, birthdate.month, birthdate.day);
  if (lastBirthday.isAfter(currentDate)) {
    lastBirthday = DateTime(currentDate.year - 1, birthdate.month, birthdate.day);
  }
  
  // Calculer les jours depuis l'anniversaire
  int daysSinceBirthday = currentDate.difference(lastBirthday).inDays;
  
  // Déterminer la période (1-7)
  return (daysSinceBirthday ~/ 52) + 1;
}
```

## Structure du Dossier

```
02_cycle_personnel/
├── README.md                 # Ce fichier
├── content/                  # Les 7 périodes
│   ├── periode_1.md          # Période de Nouveau Départ
│   ├── periode_2.md          # Période de Construction
│   ├── periode_3.md          # Période d'Expansion
│   ├── periode_4.md          # Période de Stabilisation
│   ├── periode_5.md          # Période de Réflexion
│   ├── periode_6.md          # Période de Transformation
│   └── periode_7.md          # Période de Récolte
├── database/
│   ├── migration.sql         # Création de la table
│   └── seed_content.sql      # Insertion des 7 périodes
├── admin/
│   └── admin_guide.md        # Guide pour le panel admin
└── flutter/
    └── implementation_guide.md  # Guide d'implémentation Flutter
```

## Les 7 Périodes

| # | Nom | Thème Principal | Durée |
|---|-----|-----------------|-------|
| 1 | Nouveau Départ | Initiation, énergie nouvelle | 52 jours |
| 2 | Construction | Travail, fondations | 52 jours |
| 3 | Expansion | Croissance, opportunités | 52 jours |
| 4 | Stabilisation | Consolidation, équilibre | 52 jours |
| 5 | Réflexion | Introspection, ajustements | 52 jours |
| 6 | Transformation | Changement, renouveau | 52 jours |
| 7 | Récolte | Bilan, préparation | 52 jours |

## Contenu par Période

Chaque période contient :
- **Thème général** (~200 mots)
- **Domaines favorables** (liste)
- **Domaines à éviter** (liste)
- **Conseils pratiques** (5-7 points)
- **Affirmation du mois** (phrase inspirante)
- **Dates clés** (calculées dynamiquement)

## Étapes d'Implémentation

### 1. Base de Données
1. Exécuter `database/migration.sql`
2. Exécuter `database/seed_content.sql`

### 2. Panel Admin
1. Suivre `admin/admin_guide.md`

### 3. Application Flutter
1. Suivre `flutter/implementation_guide.md`

## Fonctionnalités Spéciales

### Calendrier Interactif
- Vue mensuelle avec couleurs par période
- Notifications de changement de période
- Rappels personnalisés

### Rapport Annuel
- PDF téléchargeable avec toutes les périodes
- Partage social

**Volume total** : ~7 000 mots (7 périodes × 1 000 mots)
