# 06 — Patterns UI & Design System

> Ce document détaille le design system, les patterns d'interface, et les composants visuels du projet.

---

## 🎨 Design System — Tokens

### Palette de Couleurs
```
Primary:     #14D5C2 (turquoise vibrant)    → CTA, bordures, liens
Secondary:   #16786C (vert profond)         → Accents secondaires, focus
Background:  #142933 (bleu nuit)            → Fond principal de toutes les pages
Block:       #1E3B48 (ardoise sombre)       → Cards, surfaces élevées
Text Light:  #F2E6C4 (doré chaud)           → Titres, labels
Text Muted:  #B6C4CC (gris bleuté)          → Textes secondaires, hints
Accent Text: #FAF6E8 (crème)               → Corps de texte
Success:     #4CAF50                        → Confirmations
Error:       #E53935                        → Erreurs
Warning:     #FF9800                        → Alertes
```

### Typographie
| Usage | Police | Poids | Taille |
|-------|--------|-------|--------|
| **Corps** | OpenSans (Google Fonts) | Regular/Bold | Standard |
| **Titres CTA** | Philosopher (Google Fonts) | Bold (700) | 18px |
| **Labels** | OpenSans | Regular | Standard |

### Composants de Base
| Composant | Specs |
|-----------|-------|
| **Bouton primaire** | Background: Primary, Texte: blanc, H: 54px, Border-radius: 28px |
| **Card** | Background: Block (#1E3B48), Border-radius: 16px |
| **Input** | Filled (Block), Border: Primary 1.1px, Border-radius: 16px, Focus: Secondary 1.4px |
| **Scaffold** | Background: #142933, Thème dark Material 3 |

---

## 🌌 Éléments Visuels Mystiques

### `animated_background.dart`
- Gradient animé multi-couche (bleu nuit → turquoise → violet)
- Particules flottantes transparentes
- Utilisé comme fond de l'écran principal (compatibility_wizard)

### `animated_star_field.dart`
- Champ d'étoiles avec scintillement aléatoire
- CustomPainter avec animation continue
- Overlay sur le fond gradient

### `pulsating_orb.dart`
- Orbe lumineuse pulsante au centre
- Animation scale + opacity en boucle
- Symbolise l'énergie mystique / la guidance

---

## 🧩 Patterns d'Interface

### Pattern 1 — Écran d'Achat (Purchase Screen)
```
┌──────────────────────────────┐
│  [←] Titre du Service        │ AppBar
├──────────────────────────────┤
│  🌟 Emoji + Titre Marketing  │ Header
│  Description longue du       │
│  service avec bénéfices      │
├──────────────────────────────┤
│  🔒 AuthRequiredWrapper      │ Login gate
│  ┌──────────────────────┐    │
│  │  Prix: 3 500 XOF     │    │ Prix
│  │  ████████████████████ │    │ CTA Bouton
│  │  "Obtenir mon rapport"│    │
│  └──────────────────────┘    │
├──────────────────────────────┤
│  ⭐ Social Proof Banner      │ Trust
│  "345 personnes ont acheté"  │
│  💬 Testimonial Carousel     │
└──────────────────────────────┘
```

### Pattern 2 — Écran de Rapport (Report Screen)
```
┌──────────────────────────────┐
│  [←] Titre du Rapport        │ AppBar
├──────────────────────────────┤
│  📄 Section 1                │ Markdown
│  Contenu interprétation...   │ rendu
├──────────────────────────────┤
│  📄 Section 2                │
│  Contenu interprétation...   │
├──────────────────────────────┤
│  ...                         │
├──────────────────────────────┤
│  [Retour au menu]            │ NavigationHelper
└──────────────────────────────┘
```

### Pattern 3 — Menu Hamburger
```
┌──────────────────────────────┐
│  [X] Fermer                  │
├──────────────────────────────┤
│  👤 Mon Compte               │ Si connecté
│  🚪 Se déconnecter          │ Si connecté
│  ── OU ──                    │
│  🔑 Se connecter            │ Si non connecté
│  📝 Créer un compte         │ Si non connecté
├──────────────────────────────┤
│  📦 Mes achats              │ → PurchaseHistoryScreen
│  🌟 Nos Services            │ → ServicesCatalogScreen
├──────────────────────────────┤
│  📧 Contacter Growpeak      │ mailto:
│  💬 WhatsApp Growpeak       │ wa.me/
│  📞 Appeler Growpeak        │ tel:
├──────────────────────────────┤
│  🔄 Rafraîchir la page      │ location.reload()
└──────────────────────────────┘
```

### Pattern 4 — Frozen Read Mode (Historique)
- Les écrans de rapport acceptent un paramètre optionnel `StoredReport? frozenReport`
- Si fourni : le rapport est chargé depuis le snapshot JSON, pas recalculé
- Déclenché depuis "Mes Achats" → clic sur un rapport → navigation type-aware

---

## 📱 Responsive & Web

### Considérations actuelles
- Le design est **mobile-first** (Flutter)
- Sur web, l'app utilise un conteneur centré (pas de layout spécifique desktop)
- Les animations fonctionnent via `CustomPainter` et `AnimationController`
- Le rendu web utilise le moteur canvaskit ou html selon la configuration

### Points d'attention pour l'optimisation
- Pas de breakpoints responsive spécifiques
- Les écrans font beaucoup de scroll vertical
- Les images/assets sont dans `assets/images/` et `assets/images/backgrounds/`
- Les polices Google Fonts sont chargées dynamiquement (impact performance)
