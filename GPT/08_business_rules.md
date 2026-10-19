# 08 — Règles Métier

> Ce document recense toutes les règles métier que le GPT DOIT connaître pour éviter des recommandations contradictoires.

---

## 🔢 Numérologie Kabbalistique

### Calculs fondamentaux
- **Réduction** : Somme des chiffres de la date de naissance, réduite à un chiffre (1-9)
- **Nombres maîtres** : 11, 22, 33 ne sont JAMAIS réduits
- **Chemin de vie** : Nombre obtenu par réduction de la date de naissance complète
- **Compatibilité** : Comparaison des chemins de vie des deux personnes + matrice de compatibilité

### Contenu des interprétations
- Textes rédigés par des experts en numérologie
- Stockés dans la base de données (tables de contenu)
- JAMAIS générés par IA côté client
- Modifiables uniquement depuis l'Admin Panel

---

## 💰 Règles de Tarification

### Modèles économiques
| Service | Modèle | Règle |
|---------|--------|-------|
| Compatibilité | One-time / Gratuit | Aimant d'acquisition — peut être gratuit en promo |
| Prévisions | Pay-per-period | Prix différent pour jour/mois/année |
| Portrait Âme | One-time | Achat unique, rapport permanent |
| Cycles (2,3,4) | Annuel | Abonnement renouvelable |
| Guide Horaire | Pay-per-day | Valide 24h |
| Décision | Crédits | Packs de crédits, 1 crédit = 1 consultation |
| Phases Vie | One-time | Achat unique, 10 phases |
| Lunaire | Mensuel | Abonnement renouvelable |

### Gestion des prix
- Tous les prix sont dans `pricing_plans` (Supabase)
- Modifiables en temps réel depuis l'Admin Panel (page `UnifiedPricing`)
- Le client Flutter les charge au démarrage et les cache
- **RÈGLE** : Ne JAMAIS hardcoder un prix dans le code Flutter

---

## 🎁 Règles de Bonus

### Bonus Compatibilité → Prévisions
- **Déclencheur** : Premier achat d'une analyse de compatibilité couple
- **Bonus accordé** : Prévisions temporelles gratuites (1 période)
- **Condition** : L'utilisateur n'a pas déjà reçu ce bonus
- **Vérification** : `BonusService.checkBonus(userId, 'compatibility')`

---

## 🔒 Règles d'Accès

### Auth Gating
- **Écrans d'achat** : Authentification OBLIGATOIRE avant paiement
- **Écrans de consultation** (wizard, catalogue) : PAS de connexion requise
- **Widget** : `AuthRequiredWrapper` encapsule les zones protégées
- **Flow** : Non connecté → `LoginPage` → succès → retour à l'écran d'achat

### RLS (Backend)
- Un utilisateur ne voit que SES données (paiements, rapports, profils)
- Les tables de configuration sont en lecture publique
- Les opérations sensibles passent par des RPC SECURITY DEFINER

---

## 📦 Règles de Persistance

### Stored Reports (Frozen Snapshots)
- **RÈGLE** : Tout rapport acheté DOIT être stocké comme snapshot JSON figé
- **Anti-doublon** : `hasStoredReport()` vérifie avant chaque stockage
- **Accès** : Depuis "Mes Achats" → navigation type-aware vers le bon écran
- **Immutabilité** : Un rapport stocké ne change JAMAIS (même si le contenu source est mis à jour)

### Purchase History V2
- Architecture unifiée : tous les services dans la même liste
- Navigation via routeur type-aware : chaque type de rapport → son écran natif
- Pas de webview, pas d'iframe — toujours l'écran Flutter natif

---

## 📋 Règles du Menu Dynamique

### Configuration
- **Source** : `app_settings.menu_config` (JSON dans Supabase)
- **Admin** : Modifiable depuis l'Admin Panel (page `Settings`)
- **Cache** : 5 minutes côté client Flutter
- **Défaut** : Si un item n'est pas dans la config, il est **activé par défaut**

### Items contrôlables
| ID Menu | Label | Contrôlable |
|---------|-------|-------------|
| `se_connecter` | Se connecter | ✅ |
| `creer_compte` | Créer un compte | ✅ |
| `se_deconnecter` | Se déconnecter | ✅ |
| `mes_achats` | Mes achats | ✅ |
| `services_catalog` | 🌟 Nos Services | ✅ |
| `contacter` | Contacter Growpeak Agence | ✅ |
| `whatsapp` | WhatsApp Growpeak Agence | ✅ |
| `appeler` | Appeler Growpeak Agence | ✅ |
| Rafraîchir | 🔄 Rafraîchir la page | ❌ (toujours visible) |

---

## 🏥 Disclaimer Médical

### Service 04 — Cycle Santé
- **OBLIGATOIRE** : Afficher un disclaimer médical légal AVANT tout rapport
- **Contenu** : "Ce rapport ne remplace en aucun cas un avis médical professionnel..."
- **Position** : En haut de l'écran d'achat ET en haut du rapport

---

## 📊 Règles des Services par Cycle

### Cycle Personnel (Service 02)
- 7 périodes de 52 jours chacune dans l'année
- Commence à la date d'anniversaire de l'utilisateur
- Interprétation différente pour chaque période

### Cycle Business (Service 03)
- Même structure que le cycle personnel
- Interprétations orientées carrière/business

### Cycle Santé (Service 04)
- Même structure que le cycle personnel
- Interprétations orientées bien-être/santé + disclaimer

### Guide Horaire (Service 05)
- 7 créneaux horaires dans la journée
- Chaque créneau a une énergie numérologique différente
- Valable uniquement pour la date choisie

### Éclairage Décision (Service 06)
- 20 types de décision (amour, argent, carrière, etc.)
- 7 périodes temporelles par type
- 1 crédit = 1 consultation = 1 type × 1 période
- Total théorique : 140 combinaisons possibles

### Phases de Vie (Service 07)
- 10 phases de 7 ans chacune (0-7, 7-14, 14-21, ..., 63-70)
- Chaque phase a une signification numérologique
- Achat unique = accès permanent aux 10 phases

### Timing Lunaire (Service 08)
- 8 phases lunaires : Nouvelle Lune, Premier Croissant, Premier Quartier, Gibbeuse Croissante, Pleine Lune, Gibbeuse Décroissante, Dernier Quartier, Dernier Croissant
- Interprétation numérologique pour chaque phase
- Abonnement mensuel
