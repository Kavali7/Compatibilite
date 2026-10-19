# 09 — Admin Panel (React)

> Résumé concis du panneau d'administration, ses pages et fonctionnalités.

---

## 🏗️ Stack Technique

| Élément | Technologie |
|---------|------------|
| **Framework** | React 18 |
| **Build** | Vite |
| **Langage** | TypeScript |
| **Routing** | react-router-dom v6 (createBrowserRouter) |
| **Backend** | Supabase Client JS |
| **Styles** | CSS pur (styles.css — 36 Ko) |

---

## 📁 Structure

```
Admin/src/
├── App.tsx              # Root component
├── main.tsx             # Entry point (ReactDOM)
├── router.tsx           # 29 routes définies
├── supabaseClient.ts    # Initialisation Supabase
├── types.ts             # Types TypeScript partagés
├── styles.css           # Styles globaux (36 Ko)
├── components/          # 5 composants réutilisables (Layout, etc.)
├── hooks/               # 2 hooks personnalisés
├── data/                # 1 fichier de données statiques
└── pages/               # 37 pages admin
    ├── [11 pages racine]
    ├── compatibilite/   # 11 pages
    ├── cycles/          # 14 pages
    └── legal/           # 1 page
```

---

## 📋 Pages Administratives

### Pages Racine (Globales)

| Page | Fichier | Rôle |
|------|---------|------|
| **Dashboard** | `Dashboard.tsx` (18 Ko) | Tableau de bord : statistiques, KPI, activité récente |
| **Utilisateurs** | `Users.tsx` (27 Ko) | CRUD des utilisateurs, rôles, recherche |
| **Paiements** | `Payments.tsx` (13 Ko) | Historique des paiements, filtrage, statuts |
| **Réglages** | `Settings.tsx` (37 Ko) | Configuration globale (app_settings), menu config, contacts |
| **Tracking Pixels** | `TrackingPixels.tsx` (18 Ko) | Config Meta Pixel, TikTok Pixel, GA4 |
| **Admin Users** | `AdminUsers.tsx` (21 Ko) | Gestion des comptes admin |
| **Subscriptions** | `Subscriptions.tsx` (19 Ko) | Gestion des abonnements actifs |
| **Tarification Unifiée** | `UnifiedPricing.tsx` (21 Ko) | Édition de tous les pricing_plans |
| **Config Rapports** | `ReportsConfig.tsx` (21 Ko) | Configuration des sections de rapport |
| **Catalogue Services** | `ServiceCatalogEditor.tsx` (20 Ko) | Édition du service_catalog (noms, descriptions, emojis, CTA) |
| **Preuve Sociale** | `SocialProofEditor.tsx` (27 Ko) | Édition bannières/témoignages |

### Pages Compatibilité (`/compatibilite/*`)

| Page | Rôle |
|------|------|
| `Interpretations.tsx` | CRUD des textes d'interprétation numérologique |
| `ContentBricks.tsx` | Blocs de contenu réutilisables |
| `CanonicalPredictions.tsx` | Prédictions canoniques |
| `Pricing.tsx` | Tarification spécifique compatibilité |
| `Promos.tsx` | Codes promo et promotions |
| `ReportSections.tsx` | Configuration des sections de rapport |
| `Prospects.tsx` | Leads et prospects capturés |
| `Sessions.tsx` | Sessions de navigation des utilisateurs |
| `TextTypeSettings.tsx` | Configuration des types de texte |
| `TemporalPurchases.tsx` | Achats de prévisions temporelles |

### Pages Cycles de Vie (`/cycles/*`)

| Page | Rôle |
|------|------|
| `SoulPeriods.tsx` | Contenus des périodes de l'âme |
| `PersonalCyclePeriods.tsx` | Contenus des cycles personnels |
| `BusinessCyclePeriods.tsx` | Contenus des cycles business |
| `HealthCyclePeriods.tsx` | Contenus des cycles santé |
| `DailyPeriods.tsx` | Contenus du guide horaire |
| `DecisionTypes.tsx` | Types de décision (Service 06) |
| `DecisionAdvice.tsx` | Conseils par type de décision |
| `LifePhases.tsx` | Contenus des phases de vie |
| `LunarPhases.tsx` | Contenus des phases lunaires |
| `CyclesPricing.tsx` | Tarification des cycles |
| `CyclesPurchases.tsx` | Achats de services cycles |
| `CreditPacks.tsx` | Configuration des packs de crédits |
| `UserCredits.tsx` | Solde crédits par utilisateur |

---

## 🔑 Fonctionnalités Clés de l'Admin

### Configuration dynamique (Settings)
- **Menu Config** : Activer/désactiver chaque entrée du menu hamburger
- **Contact Info** : Email, WhatsApp, téléphone de l'entreprise
- **Feature Flags** : Activer/désactiver des fonctionnalités globalement

### Gestion de contenu
- Tous les textes d'interprétation sont modifiables en temps réel
- Les tarifs sont modifiables sans redéploiement
- Le catalogue de services est géré dynamiquement

### Tracking & Analytics
- Configuration des IDs de pixels (Meta, TikTok, GA4)
- Pas de code de tracking dans le code source — tout dans `app_settings`

---

## 🌐 Accès Admin
- URL séparée de l'app principale
- Authentification Supabase (même backend)
- Pas de rôles admin distincts dans le code — confiance côté Supabase RLS
