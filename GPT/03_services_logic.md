# 03 — Logique des Services (Dart)

> Ce document détaille chaque service Dart, ses méthodes publiques, dépendances, et flux de données.

---

## 🔧 Services d'Infrastructure

### `supabase_manager.dart` — Connexion Supabase
- **Pattern** : Singleton (`SupabaseManager.instance`)
- **Init** : Appel dans `main()` — initialise `Supabase.initialize(url, anonKey)`
- **Accès** : `SupabaseManager.instance.client` → `SupabaseClient`

### `env_config.dart` — Variables d'environnement
- **Pattern** : Singleton (`EnvConfig.instance`)
- **Triple fallback** :
  1. `--dart-define` (compile-time)
  2. `window.flutterConfig` (web runtime)
  3. `.env` via `flutter_dotenv`
- **Clés gérées** : `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `KKIAPAY_PUBLIC_KEY`, `FEDAPAY_PUBLIC_KEY`, `FEDAPAY_SECRET_KEY`

### `auth_service.dart` — Authentification
- **Pattern** : Singleton
- **Méthodes** :
  - `signIn(email, password)` → Supabase Auth
  - `signUp(email, password, phone?)` → Inscription + profil public
  - `signOut()` → Déconnexion
  - `isLoggedIn` → bool
  - `currentUser` → `User?`
  - `currentUserId` → `String?`
- **Events** : Stream `onAuthStateChange`

### `app_settings_service.dart` — Configuration dynamique
- **Pattern** : Singleton avec cache
- **Source** : Table `app_settings` → clé/valeur
- **Configs** : `contactEmail`, `contactWhatsApp`, `menuConfig`, `legalPages`
- **Méthodes** : `loadSettings()`, `getValue(key)`, `refreshSettings()`

### `analytics_service.dart` — Tracking
- **Pattern** : Singleton
- **Méthodes** : `trackEvent(name, params)`, `trackPurchase(amount, service)`, `trackPageView(screenName)`
- **Providers** : Meta Pixel, TikTok Pixel, GA4 (via JS Interop)

---

## 💳 Services de Paiement (7 fichiers dans `services/payment/`)

### `kkiapay_service.dart` — Kkiapay (Mobile Money)
- **Web** : JS Interop (`kkiapay_js_interop.dart`) — injection script dans le DOM
- **Mobile** : SDK Flutter natif (`kkiapay_flutter_sdk`)
- **Conditional Import** : `kkiapay_js_interop.dart` (web) / `kkiapay_js_interop_stub.dart` (mobile)
- **Flux** : `openKkiapay(amount, name, phone)` → callback `onSuccess(transactionId)` → `fn_insert_payment` RPC

### `payment_service.dart` — Orchestrateur paiement
- **Rôle** : Coordonne Kkiapay/FedaPay selon la config
- **Méthodes** :
  - `processPayment(planType, amount, userId)` → résultat
  - `verifyPayment(transactionId)` → statut
- **Post-paiement** : Appel RPC → stockage rapport → navigation

### `pricing_service.dart` — Tarification
- **Pattern** : Singleton avec cache
- **Source** : Table `pricing_plans`
- **Méthodes** :
  - `loadPlans()` → toutes les tarifs
  - `getPlanByType(type)` → plan spécifique
  - `getPrice(planType, period?)` → montant
  - `getCurrencySymbol()` → symbole devise
- **Cache** : En mémoire, rechargé à chaque session

---

## 🔢 Services de Calcul Numérologique

### `interpretations.dart` (52 Ko — le plus gros service)
- **Rôle** : Toutes les interprétations numériques (textes, calculs, scoring)
- **Contenu** : Tables de correspondance nombre → interprétation pour chaque service
- **Calculs** : Réduction numérologique, nombres maîtres (11, 22, 33), chemins de vie

### `compatibility_repository.dart`
- **Rôle** : Appel RPC Supabase pour les calculs de compatibilité
- **Méthodes** : `calculateCompatibility(date1, date2)` → score + rapport

---

## 📊 Services de Contenu (par service)

### `cycles_vie_service.dart` (27 Ko)
- **Pattern** : Singleton
- **Rôle** : Gestion complète des cycles de vie (Personnel, Business, Santé)
- **Méthodes** :
  - `loadCycleData(userId, birthDate)` → données cycle
  - `getCurrentPeriod(birthDate)` → période active
  - `getInterpretation(period, context)` → texte
  - `storeCycleReport(userId, data)` → sauvegarde
  - `hasActiveSubscription(userId)` → vérification abonnement

### `business_cycle_service.dart` / `health_cycle_service.dart` (12-13 Ko chacun)
- **Rôle** : Sous-services spécialisés pour cycles business et santé
- **Structure** : Comme `cycles_vie_service` mais avec contenus spécialisés

### `daily_guide_service.dart` (12 Ko)
- **Rôle** : Guide horaire journalier (7 créneaux)
- **Méthodes** : `loadDailyGuide(birthDate, date)`, `getTimeSlotAdvice(slot)`

### `decision_credit_service.dart` (10 Ko)
- **Rôle** : Gestion des crédits pour le service Éclairage Décision
- **Méthodes** : `getUserCredits(userId)`, `deductCredit(userId)`, `purchaseCredits(userId, pack)`

### `life_phase_service.dart` (7 Ko)
- **Rôle** : Phases de vie (10 phases × 7 ans chacune)
- **Méthodes** : `loadLifePhases(birthDate)`, `getCurrentPhase(birthDate)`

### `lunar_timing_service.dart` (taille estimée ~8 Ko)
- **Rôle** : Timing lunaire (8 phases)
- **Méthodes** : `loadLunarPhases(date)`, `getCurrentLunarPhase()`

### `soul_portrait_service.dart`
- **Rôle** : Portrait de l'âme (11 sections)
- **Méthodes** : `generatePortrait(birthDate)`, `getSectionContent(sectionId)`

---

## 📦 Services de Persistance

### `stored_report_service.dart`
- **Rôle** : CRUD pour les rapports stockés (frozen snapshots)
- **Méthodes** :
  - `storeReport(userId, serviceType, reportData)` → insertion
  - `hasStoredReport(userId, serviceType, identifier)` → anti-doublon
  - `getUserReports(userId)` → liste des rapports
  - `getReportById(reportId)` → rapport spécifique

### `purchase_history_service.dart`
- **Rôle** : Historique d'achats V2 unifié
- **Méthodes** :
  - `loadPurchaseHistory(userId)` → tous les achats
  - `navigateToReport(context, storedReport)` → routeur type-aware natif

---

## 🧩 Services Utilitaires

### `bonus_service.dart` (9 Ko)
- **Rôle** : Stratégie bonus — achat compatibilité = prévisions temporelles gratuites
- **Méthodes** : `checkBonus(userId, purchaseType)`, `applyBonus(userId)`

### `currency_service.dart` (3.5 Ko)
- **Rôle** : Conversion devises, symboles, formatage prix
- **Méthodes** : `formatPrice(amount, currency)`, `convertToEUR(amount, fromCurrency)`

### `menu_config_service.dart`
- **Pattern** : Singleton avec cache 5 minutes
- **Source** : `app_settings.menu_config`
- **Rôle** : Configuration dynamique du menu hamburger
- **Méthodes** : `getMenuConfig()` → `Map<String, MenuItemConfig>`

### `legal_repository.dart`
- **Rôle** : Récupération des pages légales depuis Supabase
- **Méthodes** : `getLegalPage(slug)` → contenu Markdown

### `service_catalog_service.dart`
- **Rôle** : Chargement du catalogue de services depuis `service_catalog` table
- **Méthodes** : `loadCatalog()` → liste des services avec descriptions, prix, emojis
