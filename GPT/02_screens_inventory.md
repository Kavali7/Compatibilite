# 02 — Inventaire Complet des Écrans

> Ce document décrit chaque écran de l'application Flutter, son rôle, sa navigation, et les données qu'il affiche.

---

## 🏠 Écran Principal & Navigation

### `compatibility_wizard.dart` (123 Ko — écran principal)
- **Rôle** : Page d'accueil / Wizard de compatibilité couple
- **Contenu** : Formulaire de saisie des dates de naissance (2 personnes), animation mystique, call-to-action principal
- **Navigation** : Point d'entrée (`/`). Mène vers les résultats ou le paiement
- **Composants** : `AnimatedBackground`, `AnimatedStarField`, `PulsatingOrb`
- **État** : Données saisies maintenues en mémoire pendant la session

### `services_catalog_screen.dart` (12 Ko)
- **Rôle** : Page "Nos Services" — catalogue unifié de tous les services
- **Contenu** : Grille de cartes avec emoji, nom, description, prix de chaque service
- **Navigation** : Menu hamburger → "🌟 Nos Services". Chaque carte mène au purchase screen du service
- **Données** : `service_catalog` (Supabase) + `pricing_plans` + `MenuConfigService`
- **Logique** : Vérifie via `_isServiceEnabled()` quels services afficher

### `dynamic_menu_builder.dart` (6 Ko)
- **Rôle** : Constructeur du menu hamburger dynamique
- **Contenu** : Entrées conditionnelles (Mon Compte, Se connecter/déconnecter, Mes achats, Nos Services, Contact, Rafraîchir)
- **Logique** : Menu construit depuis `MenuConfigService` (cache 5min de `app_settings.menu_config`)

---

## 🔐 Authentification

### `auth/login_page.dart`
- **Rôle** : Connexion (email + mot de passe)
- **Retour** : `true` si connexion réussie (utilisé par les écrans appelants)

### `auth/simple_signup_screen.dart`
- **Rôle** : Inscription rapide
- **Champs** : Email, mot de passe, confirmation, téléphone (intl_phone_field)
- **Retour** : `true` si inscription réussie

---

## 💑 Service 00 — Compatibilité Couple

### `compatibility_wizard.dart` (partagé avec accueil)
- Saisie dates → calcul → résultats
- Peut être gratuit (aimant d'acquisition) ou payant

---

## 🔮 Service 00b — Prévisions Temporelles

### `temporal_purchase_screen.dart`
- **Rôle** : Achat de prévisions (jour, mois, année)
- **Données** : Sélection période, calcul prix via `PricingService`, paiement

### `temporal_report_screen.dart`
- **Rôle** : Affichage du rapport temporel généré
- **Frozen mode** : Accepte `StoredReport?` pour l'historique

---

## 🌟 Service 01 — Portrait de l'Âme

### `soul_portrait_purchase_screen.dart`
- **Rôle** : Achat du portrait de l'âme
- **Contenu** : Description des 11 sections, prix, CTA
- **Auth** : Exige connexion

### `soul_portrait_screen.dart`
- **Rôle** : Rapport complet (11 sections, 1000+ mots)
- **Frozen mode** : ✅ Accepte `StoredReport?`

---

## 🔄 Service 02 — Cycle Personnel

### `cycles_vie_purchase_screen.dart`
- **Rôle** : Achat abonnement cycle personnel annuel
- **Contenu** : 7 périodes × 52 jours, prix annuel

### `cycles_vie_report_screen.dart`
- **Rôle** : Rapport cycle personnel (période active + conseils)
- **Taille** : 41 Ko — le plus gros écran de rapport
- **Frozen mode** : ✅

### `cycles_vie_home_screen.dart`
- **Rôle** : Page d'accueil de la suite Cycles de Vie
- **Contenu** : Navigation vers les sous-services (Personnel, Business, Santé)

---

## 💼 Service 03 — Cycle Business

### `business_cycle_purchase_screen.dart`
- **Rôle** : Achat abonnement cycle business annuel

### `business_cycle_report_screen.dart`
- **Rôle** : Rapport cycle business
- **Frozen mode** : ✅

---

## 🏥 Service 04 — Cycle Santé

### `health_cycle_purchase_screen.dart`
- **Rôle** : Achat abonnement cycle santé + disclaimer médical obligatoire

### `health_cycle_report_screen.dart`
- **Rôle** : Rapport cycle santé
- **Frozen mode** : ✅

---

## ⏰ Service 05 — Guide Horaire

### `daily_guide_purchase_screen.dart`
- **Rôle** : Achat du guide journalier (7 créneaux horaires)

### `daily_guide_report_screen.dart`
- **Rôle** : Rapport guide horaire (créneau par créneau)
- **Frozen mode** : ✅

---

## 🎯 Service 06 — Éclairage Décision

### `decision_advice_purchase_screen.dart` (40 Ko)
- **Rôle** : Achat de crédits de décision
- **Logique** : Packs de crédits via `CreditPackService`

### `decision_advice_screen.dart` (47 Ko)
- **Rôle** : Interface de conseil de décision (20 types × 7 périodes = 140 conseils)
- **Taille** : Le plus gros écran d'interaction

---

## 🌊 Service 07 — Phases de Vie

### `life_phase_purchase_screen.dart`
- **Rôle** : Achat des phases de vie (10 phases × 7 ans)

### `life_phase_report_screen.dart`
- **Rôle** : Rapport phases de vie

---

## 🌙 Service 08 — Timing Lunaire

### `lunar_timing_purchase_screen.dart`
- **Rôle** : Achat abonnement timing lunaire mensuel

### `lunar_timing_report_screen.dart`
- **Rôle** : Rapport 8 phases lunaires
- **Frozen mode** : ✅

---

## 📦 Historique & Compte

### `purchase_history_screen.dart`
- **Rôle** : "Mes Achats" — historique V2 unifié de tous les achats
- **Contenu** : Liste des rapports stockés, navigation vers le rapport original en mode frozen
- **Architecture** : `PurchaseHistoryService` → `stored_reports` table
- **Navigation** : Type-aware native router pour rediriger vers le bon écran de rapport

### `account/account_screen.dart`
- **Rôle** : Page Mon Compte (infos utilisateur, email, déconnexion)

---

## 📄 Pages Légales & Utilitaires

### `legal_page.dart` / `dynamic_legal_page.dart`
- **Rôle** : Affichage des pages légales (CGV, politique de confidentialité, mentions légales)
- **Source** : Table `legal_pages` via `LegalRepository`

### `payment_callback_screen.dart`
- **Rôle** : Gestion des retours de paiement (succès/échec)
- **Navigation** : Automatique après callback Kkiapay/FedaPay

---

## 🧩 Widgets Réutilisables (13 composants)

| Widget | Rôle |
|--------|------|
| `animated_background.dart` | Fond animé mystique (gradient + particules) |
| `animated_star_field.dart` | Champ d'étoiles scintillantes |
| `auth_required_wrapper.dart` | Guard : exige connexion avant affichage |
| `credit_pack_purchase_modal.dart` | Modal d'achat de packs de crédits |
| `hamburger_menu_overlay.dart` | Overlay du menu hamburger |
| `popularity_badge.dart` | Badge "Populaire" / "Nouveau" sur les services |
| `pulsating_orb.dart` | Orbe animée pulsante (effet mystique) |
| `selectable_card.dart` | Carte interactive sélectionnable |
| `service_catalog_card.dart` | Carte de service dans le catalogue |
| `social_proof_banner.dart` | Bannière de preuve sociale ("X personnes ont acheté") |
| `temporal_report_card.dart` | Carte de rapport temporel |
| `testimonial_carousel.dart` | Carrousel de témoignages clients |
| `widgets.dart` | Barrel export |
