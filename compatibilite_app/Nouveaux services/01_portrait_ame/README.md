# Service 01 : Portrait de l'Âme

## Description

Le "Portrait de l'Âme" est un service de personnalité basé sur la date de naissance. Il révèle l'essence profonde de l'utilisateur selon les 14 profils cosmiques définis par H. Spencer Lewis.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Achat unique |
| **Prix suggéré** | 2 500 - 5 000 FCFA |
| **Contenu** | 1 rapport personnalisé (~1 000 mots) |
| **Calcul** | Automatique basé sur date de naissance |

## Logique de Calcul

### Détermination de la Période (1-7)

```
Période = ((Jour de naissance + Mois de naissance) % 7) + 1
```

Ou alternativement, basé sur les plages de dates :

| Période | Dates |
|---------|-------|
| 1 | 22 mars - 12 mai |
| 2 | 12 mai - 3 juillet |
| 3 | 4 juillet - 24 août |
| 4 | 25 août - 15 octobre |
| 5 | 16 octobre - 7 décembre |
| 6 | 8 décembre - 29 janvier |
| 7 | 30 janvier - 22 mars |

### Détermination de la Polarité (A ou B)

```dart
String polarity = (birthYear % 2 == 0) ? 'A' : 'B';
```

- **Année paire** → Polarité A
- **Année impaire** → Polarité B

### Exemple

- Né le 15 avril 1990 → Période 1, Polarité A → Profil "1A"
- Né le 25 mai 1991 → Période 2, Polarité B → Profil "2B"

## Structure du Dossier

```
01_portrait_ame/
├── README.md                 # Ce fichier
├── content/                  # Les 14 profils
│   ├── periode_1A.md
│   ├── periode_1B.md
│   └── ... (14 fichiers)
├── database/
│   ├── migration.sql         # Création de la table
│   └── seed_content.sql      # Insertion des 14 profils
├── admin/
│   └── admin_guide.md        # Guide pour le panel admin
└── flutter/
    └── implementation_guide.md  # Guide d'implémentation Flutter
```

## Étapes d'Implémentation

### 1. Base de Données (Supabase)
1. Exécuter `database/migration.sql`
2. Exécuter `database/seed_content.sql`

### 2. Panel Admin (React)
1. Suivre `admin/admin_guide.md`
2. Créer la page de gestion des profils

### 3. Application Flutter
1. Suivre `flutter/implementation_guide.md`
2. Créer le service et l'écran de rapport

## Contenu Inclus

14 profils uniques, chacun contenant :
- Identité Cosmique (titre personnalisé)
- Héritage Cosmique (origines spirituelles)
- Essence Profonde (caractère central)
- Forces Naturelles (4 forces)
- Défis à Transcender
- Vocations Idéales
- Affinités Géographiques
- Points de Vigilance Santé
- Conseils d'Épanouissement
- Message Cosmique Final

**Volume total** : ~14 000 mots
