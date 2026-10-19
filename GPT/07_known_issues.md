# 07 — Problèmes Connus & Dette Technique

> Ce document recense les problèmes identifiés, les zones fragiles et les améliorations nécessaires.

---

## 🔴 Problèmes Critiques

### 1. Zéro conversion malgré la campagne Facebook
- **Contexte** : Campagne publicitaire Facebook sponsorisée de plusieurs jours → aucune vente
- **Hypothèses à investiguer** :
  - Tunnel de conversion trop long ou confus
  - Manque de crédibilité / confiance (preuve sociale insuffisante)
  - Temps de chargement trop lent (Core Web Vitals)
  - Landing page non optimisée pour la conversion
  - Moyens de paiement non familiers pour le marché européen cible
  - SEO insuffisant pour le trafic organique
  - Absence de version multilingue

### 2. Paiement limité au marché africain
- **Problème** : Kkiapay et FedaPay sont des gateways West Africa (Mobile Money, virements XOF)
- **Impact** : Incompatible avec le ciblage Europe (pas de Stripe, PayPal, Apple Pay)
- **Priorité** : 🔴 Bloquant pour la vente en Europe

---

## 🟠 Problèmes Importants

### 3. Pas de responsive desktop
- L'app Flutter est conçue mobile-first
- Sur desktop, le contenu n'est pas optimisé (pas de breakpoints, colonnes fixes)
- Les écrans de 1920px affichent le contenu en pleine largeur ou centré sans adaptation

### 4. SEO limité (Flutter Web)
- Flutter Web génère un canvas unique — contenu inaccessible aux crawlers
- Pas de server-side rendering
- Balises meta limitées dans `index.html`
- Pas de `sitemap.xml` ni `robots.txt` optimisé
- Pas de schema.org structured data

### 5. Performance Flutter Web
- Bundle JS volumineux (~1.7 Mo pour `main.*.js`)
- Google Fonts chargées dynamiquement (blocking render)
- Pas de lazy loading d'écrans
- Pas de code splitting natif dans Flutter Web

### 6. Accessibilité limitée
- Pas d'attributs ARIA spécifiques
- Contraste potentiellement insuffisant sur certains textes (textMuted #B6C4CC sur #142933)
- Navigation clavier non testée
- Pas de support lecteur d'écran

---

## 🟡 Améliorations Souhaitées

### 7. Internationalisation (i18n)
- Actuellement tout en français uniquement
- Aucun système de traduction en place
- Objectif : multilingue (FR, EN, ES, DE, IT minimum)

### 8. Preuve sociale insuffisante
- `social_proof_banner.dart` et `testimonial_carousel.dart` existent mais
- Les données sont-elles remplies ? Sont-elles crédibles ?
- Besoin de vraies données / témoignages

### 9. Tunnel de conversion
- L'utilisateur arrive sur le wizard de compatibilité (écran principal)
- Pas de landing page dédiée pour chaque service
- Pas de page "pourquoi nous choisir" / FAQ
- Pas de page "tarifs" dédiée et claire

### 10. Legal & RGPD
- Pages légales dynamiques (`legal_pages` table) — contenu à vérifier
- Conformité RGPD pour le marché européen à vérifier
- Cookie banner potentiellement manquant
- Consentement des pixels de tracking à gérer

---

## ⚠️ Zones Fragiles du Code

### Navigation
- `NavigationHelper.goToMenu()` est critique — tout `pop()` incorrect cause un écran gris
- Le routeur type-aware dans `PurchaseHistoryService` doit être mis à jour pour chaque nouveau service

### Conditional Imports
- `kkiapay_js_interop.dart` vs `kkiapay_js_interop_stub.dart` — fragile aux changements d'API

### Cache des Services
- `MenuConfigService` : cache 5 min — changements admin pas immédiatement visibles
- `PricingService` : cache en mémoire — nécessite rechargement de page

### interpretations.dart (52 Ko)
- Fichier monolithique très volumineux — difficile à maintenir
- Contient toutes les tables de correspondance — risque d'erreurs de copier/coller

---

## 🐛 Bugs Connus Résolus (Historique)

| Bug | Résolution | Date |
|-----|-----------|------|
| Écran gris après rapport | `NavigationHelper.goToMenu()` au lieu de `pop()` | Résolu |
| PricingService "temporal" not found | Vérification du plan_type dans la table | Résolu |
| HTML meta viewport warning | Correction des attributs | Résolu |
| Secret exposure dans le code | Nettoyage `.env` + git history | Jan 2026 |
