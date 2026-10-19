# 01 — Vue d'ensemble du Projet Kbal

## 🏢 Présentation

**Kbal Compatibilité & Guidance** est une application multi-plateforme (iOS, Android, **Web**) de **guidance numérologique** commercialisant 11 services basés sur l'analyse kabbalistique des dates de naissance.

- **Site web** : https://growpeak-agence.com/
- **Entreprise** : Growpeak Agence
- **Marché cible** : Europe (objectif d'internationalisation multilingue)
- **Domaine** : Numérologie, compatibilité amoureuse, guidance spirituelle

---

## 🏗️ Stack Technique

| Couche | Technologie | Détails |
|--------|------------|---------|
| **Frontend User** | Flutter (Dart) SDK ^3.9.2 | dossier `compatibilite_app/` |
| **Frontend Admin** | React + Vite + TypeScript | dossier `Admin/` |
| **Backend BDD** | Supabase (PostgreSQL + Auth + RLS) | Cloud |
| **Fonctions serveur** | RPC PostgreSQL (SECURITY DEFINER) | Logique dans la BDD |
| **Paiement** | Kkiapay (Mobile Money) + FedaPay (Popup) | West Africa → conversion EUR prévue |
| **Hosting Frontend** | Firebase Hosting | growpeak-agence.com |
| **DNS** | o2switch | Config A/CNAME vers Firebase |
| **Analytics** | Meta Pixel, TikTok Pixel, GA4 | via Tracking Pixels admin |

### Dépendances Flutter clés
- `supabase_flutter: ^2.5.6` — Backend
- `google_fonts: ^6.2.1` — Typographie (OpenSans, Philosopher)
- `kkiapay_flutter_sdk: ^1.3.4` — Paiement mobile
- `flutter_markdown: ^0.7.7+1` — Rendu des rapports
- `intl_phone_field: ^3.2.0` — Saisie téléphone international
- `provider: ^6.1.2` — State management
- `flutter_dotenv: ^5.1.0` — Variables d'environnement

---

## 🎨 Design System

| Token | Valeur | Usage |
|-------|--------|-------|
| **Primary** | `#14D5C2` (turquoise) | CTA, bordures, accents |
| **Secondary** | `#16786C` (vert foncé) | Éléments secondaires |
| **Background** | `#142933` (bleu nuit) | Fond principal |
| **Block** | `#1E3B48` (ardoise) | Cards, surfaces |
| **Text Light** | `#F2E6C4` (doré) | Titres |
| **Text Muted** | `#B6C4CC` (gris) | Textes secondaires |
| **Accent Text** | `#FAF6E8` (crème) | Corps de texte |

- **Thème** : Dark mystique (Material 3, `ThemeData.dark`)
- **Polices** : OpenSans (body), Philosopher (boutons/titres)
- **Boutons** : Arrondi 28px, hauteur 54px, primary color

---

## 🎯 Les 11 Services Commercialisés

| # | Service | Modèle Économique | Cible |
|---|---------|-------------------|-------|
| 00 | Compatibilité Couple | Achat unique / Gratuit (aimant) | Acquisition |
| 00b | Prévisions Temporelles | Pay-per-period (Jour/Mois/Année) | Récurrence |
| 01 | Portrait de l'Âme | Achat unique (11 sections) | Profondeur |
| 02 | Cycle Personnel | Abonnement annuel (7×52 jours) | Récurrence |
| 03 | Cycle Business | Abonnement annuel | Pro |
| 04 | Cycle Santé | Abonnement annuel + disclaimer | Bien-être |
| 05 | Guide Horaire | Pay-per-day (7 créneaux) | Quotidien |
| 06 | Éclairage Décision | Crédits (20 types × 7 périodes) | À la demande |
| 07 | Phases de Vie | Achat unique (10 phases × 7 ans) | Long terme |
| 08 | Timing Lunaire | Abonnement mensuel (8 phases) | Astrologie |

---

## 📁 Architecture des Répertoires

```
Compatibilite/
├── Admin/                          # Admin Panel (React/Vite/TS)
│   └── src/
│       ├── pages/                  # 37 pages admin
│       ├── components/             # 5 composants réutilisables
│       ├── hooks/                  # 2 hooks personnalisés
│       ├── router.tsx              # 29 routes
│       └── styles.css              # Styles globaux
├── compatibilite_app/              # App Flutter
│   ├── lib/
│   │   ├── screens/                # 30+ écrans (wizard, achats, rapports)
│   │   ├── services/               # 31+ services métier
│   │   ├── models/                 # 7 modèles de données
│   │   ├── widgets/                # 13 composants réutilisables
│   │   ├── core/                   # Routes, constantes, navigation
│   │   ├── theme/                  # Design system
│   │   └── main.dart               # Point d'entrée
│   ├── web/
│   │   └── index.html              # Config web, pixels, PWA
│   ├── pubspec.yaml                # Dépendances
│   └── firebase.json               # Config hosting
├── AmeSoeur/                       # Contenus âme-sœur
├── cartography/                    # Outils de cartographie
└── notes/                          # Documentation interne
```

---

## 🔧 Architecture Logicielle — Patterns Clés

### Philosophie "Thick Database"
La logique métier (calculs numériques, scores) réside dans les RPC PostgreSQL coté serveur, PAS dans le client Flutter.

### Singleton Services
Tous les services Dart utilisent un pattern singleton : `AuthService.instance`, `PricingService.instance`, etc.

### Configuration Multi-Fallback
Les variables d'env suivent 3 niveaux : `--dart-define` → `window.flutterConfig` → `.env`

### Menu Dynamique
Le menu hamburger est généré dynamiquement depuis `app_settings.menu_config` via `MenuConfigService` avec cache de 5 minutes.

### Auth Gating
Les écrans d'achat exigent l'authentification via `AuthRequiredWrapper`. Si non connecté, redirection vers `LoginPage` → retour auto.

### Navigation Guards
Tous les rapports utilisent `NavigationHelper.goToMenu()` (pas de `Navigator.pop()`) pour éviter les écrans gris.
