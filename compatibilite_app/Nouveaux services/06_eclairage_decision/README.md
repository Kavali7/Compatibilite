# Service 06 : Éclairage Décision

## Description

Le service "Éclairage Décision" conseille les utilisateurs sur le moment optimal pour prendre des décisions importantes de vie, basé sur leur période personnelle actuelle.

## Modèle Commercial

| Élément | Valeur |
|---------|--------|
| **Type** | Crédits de décision |
| **Prix** | 1 000 - 2 000 FCFA par consultation |
| **Contenu** | Conseil personnalisé par type de décision |

## Les 20 Types de Décision

### Immobilier (3 types)
- Location / Immobilier
- Achat Immobilier  
- Déménagement

### Finance (5 types)
- Achat Véhicule
- Achat Important
- Demande de Financement
- Recherche d'Argent
- Investissement

### Juridique (1 type)
- Signature de Contrat

### Business (2 types)
- Lancement Business
- Partenariat / Association

### Carrière (3 types)
- Entretien d'Embauche
- Demande de Promotion
- Démission / Changement

### Personnel (3 types)
- Voyage
- Mariage / Engagement
- Début de Relation

### Santé (2 types)
- Opération Médicale
- Début de Traitement

### Autre (1 type)
- Autre Décision Importante

## Contenu Généré

**Total : 140 conseils** (20 types × 7 périodes)

Chaque conseil inclut :
- **Score de favorabilité** (1-5)
- **Texte de conseil** détaillé (~100 mots)
- **Avertissements** si applicable
- **Alternatives** suggérées si période défavorable

## Structure

```
06_eclairage_decision/
├── README.md
└── database/
    ├── seed_decision_advice_complet.sql (63 conseils)
    └── seed_decision_advice_complet_2.sql (77 conseils)
```

## Utilisation des Scripts

```sql
-- Exécuter dans l'ordre :
\i seed_decision_advice_complet.sql
\i seed_decision_advice_complet_2.sql
```

## Intégration Existante

Ce service utilise les tables existantes :
- `cycle_vie_decision_types` - Types de décision
- `cycle_vie_decision_advice` - Conseils par période
- `cycle_vie_decision_credits` - Crédits utilisateur
- `cycle_vie_decision_consultations` - Historique
