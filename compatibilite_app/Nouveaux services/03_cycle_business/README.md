# Service 03 : Cycle de Votre Entreprise

## Description

Le "Cycle Business" applique les mêmes 7 périodes de 52 jours au domaine professionnel et entrepreneurial. Basé sur la date de création de l'entreprise (ou date d'anniversaire du dirigeant).

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Abonnement annuel |
| **Prix suggéré** | 15 000 - 25 000 FCFA/an |
| **Cible** | Entrepreneurs, dirigeants, freelances |
| **Contenu** | 7 rapports stratégiques + calendrier business |

## Logique de Calcul

### Date de Référence

Deux options pour le cycle business :
1. **Date de création de l'entreprise** (recommandé)
2. **Date d'anniversaire du dirigeant** (si entreprise unipersonnelle)

### Calcul Identique au Cycle Personnel

```dart
int getCurrentBusinessPeriod(DateTime referenceDate, DateTime today) {
  DateTime lastAnniversary = DateTime(today.year, referenceDate.month, referenceDate.day);
  if (lastAnniversary.isAfter(today)) {
    lastAnniversary = DateTime(today.year - 1, referenceDate.month, referenceDate.day);
  }
  int daysSince = today.difference(lastAnniversary).inDays;
  return (daysSince ~/ 52) + 1;
}
```

## Les 7 Périodes Business

| # | Nom | Focus Stratégique |
|---|-----|-------------------|
| 1 | Lancement | Nouveaux produits, marchés, partenariats |
| 2 | Consolidation | Processus, équipe, fondations |
| 3 | Croissance | Marketing, ventes, expansion |
| 4 | Optimisation | Efficacité, rentabilité, équilibre |
| 5 | Analyse | Stratégie, positionnement, ajustements |
| 6 | Restructuration | Changements, pivots, renouveau |
| 7 | Bilan | Résultats, planification, préparation |

## Structure du Dossier

```
03_cycle_business/
├── README.md
├── content/
│   ├── periode_1_lancement.md
│   ├── periode_2_consolidation.md
│   ├── periode_3_croissance.md
│   ├── periode_4_optimisation.md
│   ├── periode_5_analyse.md
│   ├── periode_6_restructuration.md
│   └── periode_7_bilan.md
├── database/
│   ├── migration.sql
│   └── seed_content.sql
├── admin/
│   └── admin_guide.md
└── flutter/
    └── implementation_guide.md
```

## Contenu par Période Business

Chaque période contient :
- **Focus stratégique** (~300 mots)
- **Actions recommandées** (5-7 points)
- **Risques à éviter** (liste)
- **Indicateurs clés** à surveiller
- **Décisions favorables** (types de décisions)
- **Astuce du mois** (conseil pratique)

## Différences avec le Cycle Personnel

| Aspect | Cycle Personnel | Cycle Business |
|--------|-----------------|----------------|
| Focus | Vie personnelle | Entreprise |
| Ton | Spirituel/Mystique | Professionnel/Stratégique |
| Conseils | Développement personnel | Actions business |
| KPIs | Bien-être | Croissance, rentabilité |

## Volume de Contenu

~7 000 mots (7 × 1 000 mots par période)
