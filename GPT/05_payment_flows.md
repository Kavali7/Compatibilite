# 05 — Flux de Paiement

> Ce document détaille les intégrations de paiement (Kkiapay, FedaPay) et le flux complet d'un achat.

---

## 🔄 Flux Général d'Achat

```
1. Sélection du service (ServicesCatalogScreen ou menu)
         │
2. Écran d'achat (purchase_screen) → affiche prix, description, CTA
         │
3. AuthRequiredWrapper → Connexion/Inscription si nécessaire
         │
4. Choix gateway : Kkiapay (Mobile Money) ou FedaPay (Carte/Popup)
         │
5. Fenêtre de paiement (SDK natif ou JS Interop)
         │
6. Callback succès → transaction_id reçu
         │
7. Appel RPC fn_insert_payment(userId, planType, amount, transactionId)
         │
8. Génération du rapport (RPC ou client)
         │
9. Stockage snapshot → stored_reports (anti-doublon)
         │
10. Navigation vers l'écran de rapport
         │
11. NavigationHelper.goToMenu() pour sortir (pas de pop)
```

---

## 💰 Gateway 1 — Kkiapay (Mobile Money)

### Plateformes supportées
- **Web** : JS Interop (`kkiapay_js_interop.dart`)
- **Mobile** : SDK Flutter (`kkiapay_flutter_sdk`)
- **Résolution** : Conditional Import (`kkiapay_js_interop_stub.dart` pour mobile)

### Flux technique (Web)
1. Injection du script `https://cdn.kkiapay.me/k.js` dans le DOM
2. Ouverture du widget Kkiapay : `openKkiapayWidget(amount, name, phone)`
3. L'utilisateur choisit son moyen (MTN, Moov, Wave, etc.)
4. Callback JavaScript `addSuccessListener(callback)` → `transactionId`
5. Vérification côté serveur via API Kkiapay
6. Insertion paiement via RPC

### Configuration
- **Clé publique** : Variable d'env `KKIAPAY_PUBLIC_KEY`
- **Sandbox** : Mode test avec clé sandbox séparée
- **Devises** : XOF (Franc CFA) principalement

---

## 💳 Gateway 2 — FedaPay (Carte bancaire / Popup)

### Flux technique
1. Création transaction via API FedaPay (`POST /transactions`)
2. Récupération URL de paiement
3. Ouverture popup navigateur vers l'URL FedaPay
4. **Polling** : Vérification périodique du statut de la transaction
5. Statut `approved` → insertion paiement via RPC
6. Timeout ou `declined` → affichage erreur

### Configuration
- **Clé publique** : `FEDAPAY_PUBLIC_KEY`
- **Clé secrète** : `FEDAPAY_SECRET_KEY` (pour création transaction)
- **Mode** : Sandbox / Live
- **Devises** : XOF

### Particularités FedaPay
- Mécanisme de **polling** car pas de webhook fiable côté client web
- Timeout de 5 minutes par défaut
- Retry automatique toutes les 3 secondes pendant le polling

---

## 🛡️ Sécurité des Paiements

| Aspect | Implémentation |
|--------|---------------|
| **Insertion** | Via RPC `fn_insert_payment` (SECURITY DEFINER) — pas d'INSERT direct |
| **Vérification** | Transaction ID vérifié avant insertion |
| **Anti-doublon** | Vérification `transaction_id` unique dans `payments` |
| **Données sensibles** | Clés API dans `.env`, jamais dans le code source |
| **RLS** | Chaque utilisateur ne voit que ses propres paiements |

---

## 💱 Tarification

### Gestion des prix
- **Source** : Table `pricing_plans` (editable via Admin Panel)
- **Champs** : `plan_type`, `amount`, `currency`, `period`, `is_active`
- **Service** : `PricingService.instance.getPlanByType(type)`
- **Affichage** : `CurrencyService.formatPrice(amount, currency)`

### Types de plans
| plan_type | Modèle |
|-----------|--------|
| `compatibility` | One-time |
| `temporal_day` / `temporal_month` / `temporal_year` | Pay-per-period |
| `soul_portrait` | One-time |
| `personal_cycle` | Annual subscription |
| `business_cycle` | Annual subscription |
| `health_cycle` | Annual subscription |
| `daily_guide` | Pay-per-day |
| `decision_credits_*` | Credit packs |
| `life_phases` | One-time |
| `lunar_timing` | Monthly subscription |

---

## 🎁 Stratégie Bonus

### Logique
- **Déclencheur** : Achat d'une compatibilité couple
- **Bonus** : Prévisions temporelles gratuites incluses
- **Service** : `BonusService.checkBonus(userId, purchaseType)`
- **Condition** : Vérifie si l'utilisateur n'a pas déjà reçu le bonus
