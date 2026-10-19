# 04 — Schéma Backend (Supabase/PostgreSQL)

> Ce document résume les connaissances actuelles sur le backend. Il sera complété par le fichier `Reference-Backend.md` après exécution des requêtes SQL.

---

## 🏗️ Philosophie Architecturale

### "Thick Database"
- La logique métier (calculs, scoring, validations) est dans les **fonctions RPC PostgreSQL**
- Le client Flutter est un consommateur de données, pas un calculateur
- Les opérations sensibles utilisent **SECURITY DEFINER** pour bypasser RLS en toute sécurité

### Row Level Security (RLS)
- **Activé sur toutes les tables** contenant des données utilisateur
- **Principe** : Un utilisateur ne voit que SES propres données
- **Exceptions** : Les tables de configuration (read-only pour authenticated)

---

## 📋 Tables Principales Connues

### Tables de Configuration
| Table | Rôle | Accès |
|-------|------|-------|
| `app_settings` | Config globale (clé/valeur) : menu, contact, features flags | Read: public |
| `pricing_plans` | Plans tarifaires par service (type, montant, devise, période) | Read: authenticated |
| `service_catalog` | Catalogue marketing (nom, emoji, description, CTA, display_order) | Read: public |
| `legal_pages` | Pages légales (CGV, confidentialité) en Markdown | Read: public |

### Tables Utilisateurs
| Table | Rôle | Accès |
|-------|------|-------|
| `auth.users` | Utilisateurs Supabase Auth (gérée par Supabase) | Admin |
| `users` (public) | Profils publics liés aux auth.users | Owner RLS |

### Tables Métier
| Table | Rôle | Accès |
|-------|------|-------|
| `payments` | Registre de tous les paiements | Owner RLS |
| `couple_profiles` | Données des couples (dates, noms) | Owner RLS |
| `generated_reports` | Rapports générés (résultats des calculs) | Owner RLS |
| `stored_reports` | Snapshots JSON figés des rapports (frozen mode) | Owner RLS |
| `user_credits` | Solde de crédits par utilisateur (Service 06) | Owner RLS |

### Tables de Contenu
| Table | Rôle |
|-------|------|
| `interpretations` | Textes d'interprétation numérologique |
| `content_bricks` | Blocs de contenu réutilisables |
| `canonical_predictions` | Prédictions canoniques |
| `report_sections` | Définition des sections de rapport |
| `soul_periods` | Contenus périodes de l'âme |
| `personal_cycle_periods` | Contenus cycles personnels |
| `business_cycle_periods` | Contenus cycles business |
| `health_cycle_periods` | Contenus cycles santé |
| `daily_periods` | Contenus guide horaire |
| `decision_types` | Types de décision (Service 06) |
| `decision_advice` | Conseils par type × période |
| `life_phases` | Contenus phases de vie |
| `lunar_phases` | Contenus timing lunaire |

### Tables Marketing
| Table | Rôle |
|-------|------|
| `promo_codes` | Codes promotionnels |
| `prospects` | Leads capturés |
| `sessions` | Sessions de navigation |
| `social_proof_config` | Configuration preuve sociale (bannières, témoignages) |

---

## ⚙️ Fonctions RPC Connues

| Fonction | Rôle | Sécurité |
|----------|------|----------|
| `fn_insert_payment` | Enregistre un paiement validé | SECURITY DEFINER |
| `fn_calculate_compatibility` | Calcul de compatibilité couple | SECURITY DEFINER |
| `fn_generate_report` | Génère un rapport complet | SECURITY DEFINER |
| `fn_store_report` | Stocke un snapshot de rapport | SECURITY DEFINER |
| `fn_get_user_credits` | Récupère le solde de crédits | SECURITY DEFINER |
| `fn_deduct_credit` | Déduit un crédit après utilisation | SECURITY DEFINER |

---

## 🔐 Modèle de Sécurité

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│ Client Web  │────▶│ Supabase RLS │────▶│ PostgreSQL  │
│ (anon key)  │     │ (filtrage)   │     │ (données)   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                    ┌──────┴──────┐
                    │ RPC SECURITY│
                    │  DEFINER    │
                    │ (bypass RLS)│
                    └─────────────┘
```

- **anon** : Lecture des tables publiques (app_settings, service_catalog, legal_pages)
- **authenticated** : Lecture/écriture de SES propres données (via RLS)
- **service_role** : Accès total (utilisé UNIQUEMENT côté serveur)
- **RPC SECURITY DEFINER** : Exécute avec les droits du créateur, pas de l'appelant
