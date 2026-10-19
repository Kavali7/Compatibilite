# Reference-Backend — Kbal Compatibilité & Guidance

> ⚠️ **INSTRUCTION OBLIGATOIRE POUR TOUT DÉVELOPPEUR** : Ce document DOIT être mis à jour à chaque modification du schéma backend (ajout/suppression de tables, colonnes, fonctions RPC, triggers, politiques RLS). Dernière mise à jour : **25/02/2026**.

---

## 1. Inventaire des Tables (48 tables)

| # | Table | Colonnes | Catégorie |
|---|-------|----------|-----------|
| 1 | `admins` | 4 | Sécurité |
| 2 | `analytics_events` | 6 | Analytics |
| 3 | `app_config` | 4 | Configuration |
| 4 | `app_settings` | 4 | Configuration |
| 5 | `brick_usage` | 5 | Contenu |
| 6 | `business_cycle_periods` | 16 | Cycles Business |
| 7 | `business_cycle_subscriptions` | 10 | Cycles Business |
| 8 | `canonical_predictions` | 12 | Compatibilité |
| 9 | `content_bricks` | 20 | Contenu |
| 10 | `couple_profiles` | 12 | Compatibilité |
| 11 | `cycle_vie_daily_periods` | 14 | Guide Horaire |
| 12 | `cycle_vie_decision_advice` | 15 | Éclairage Décision |
| 13 | `cycle_vie_decision_types` | 10 | Éclairage Décision |
| 14 | `cycle_vie_purchases` | 13 | Achats Cycles |
| 15 | `cycle_vie_soul_periods` | 19 | Portrait Âme |
| 16 | `daily_guide_purchases` | 8 | Achats Guide |
| 17 | `decision_credit_packs` | 10 | Crédits Décision |
| 18 | `generated_reports` | 20 | Rapports |
| 19 | `health_cycle_periods` | 18 | Cycles Santé |
| 20 | `health_cycle_subscriptions` | 10 | Cycles Santé |
| 21 | `legal_pages` | 8 | Légal |
| 22 | `life_phase_periods` | 11 | Phases Vie |
| 23 | `life_phase_purchases` | 5 | Achats Phases |
| 24 | `lunar_phases` | 13 | Lunaire |
| 25 | `lunar_subscriptions` | 7 | Lunaire |
| 26 | `marketing_prospects` | 8 | Marketing |
| 27 | `numerology_texts` | 8 | Contenu |
| 28 | `payments` | 9 | Paiements |
| 29 | `personal_cycle_periods` | 17 | Cycles Personnels |
| 30 | `personal_cycle_subscriptions` | 11 | Cycles Personnels |
| 31 | `pricing_plans` | 14 | Tarification |
| 32 | `profils` | 5 | Utilisateurs |
| 33 | `purchases` | 11 | Achats |
| 34 | `rapports_partenaires` | 13 | Rapports |
| 35 | `report_sections` | 6 | Configuration |
| 36 | `security_rate_limits` | 4 | Sécurité |
| 37 | `service_catalog` | 10 | Configuration |
| 38 | `sessions_compatibilite` | 25 | Compatibilité |
| 39 | `social_proof_config` | 23 | Marketing |
| 40 | `stored_reports` | 10 | Persistance |
| 41 | `subscriptions` | 7 | Abonnements |
| 42 | `temporal_purchases` | 12 | Prévisions |
| 43 | `text_type_settings` | 7 | Configuration |
| 44 | `user_decision_credits` | 13 | Crédits |
| 45 | `user_decision_usage` | 10 | Crédits |
| 46 | `user_reports` | 4 | Rapports |
| 47 | `users` | 6 | Utilisateurs |
| 48 | `webhook_logs` | 6 | Webhooks |

---

## 2. Structure Détaillée par Catégorie

### 2.1 Configuration & Paramètres

#### `app_settings` (PK: `key`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| key | text | NO | — |
| value | jsonb | NO | — |
| description | text | YES | — |
| updated_at | timestamptz | YES | now() |

#### `app_config` (PK: `key`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| key | text | NO | — |
| value | jsonb | NO | — |
| description | text | YES | — |
| updated_at | timestamptz | YES | now() |

#### `service_catalog` (PK: `id` — text)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | text | NO | — |
| name | text | NO | — |
| emoji | text | NO | '⭐' |
| advantages | text[] | NO | '{}' |
| plan_type | text | YES | — |
| screen_route | text | NO | — |
| enabled | boolean | NO | true |
| display_order | integer | NO | 0 |
| created_at | timestamptz | NO | now() |
| updated_at | timestamptz | NO | now() |

#### `pricing_plans` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| plan_type | text | NO | — |
| name | text | NO | — |
| price_fcfa | integer | NO | — |
| duration_days | integer | YES | — |
| is_active | boolean | YES | true |
| created_at | timestamptz | YES | now() |
| description | text | YES | — |
| currency | text | NO | 'FCFA' |
| display_order | integer | YES | 0 |
| updated_at | timestamptz | NO | now() |
| decision_credits_included | integer | YES | 0 |
| features | jsonb | YES | '[]' |
| badge_text | text | YES | — |

#### `report_sections` (PK: `code`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| code | text | NO | — |
| label_fr | text | NO | — |
| is_active | boolean | YES | true |
| display_order | integer | YES | — |
| periode | text | YES | — |
| description | text | YES | — |

#### `text_type_settings` (PK: `type`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| type | text | NO | — |
| label_display | text | NO | — |
| is_active | boolean | YES | true |
| display_order | integer | YES | 0 |
| hide_number | boolean | YES | true |
| created_at / updated_at | timestamptz | YES | now() |

---

### 2.2 Utilisateurs & Sécurité

#### `users` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| email | text | NO | — |
| password_hash | text | NO | — |
| name | text | YES | — |
| created_at | timestamptz | YES | now() |
| last_login | timestamptz | YES | — |

#### `profils` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | — |
| email | text | YES | — |
| telephone | text | YES | — |
| created_at / updated_at | timestamptz | NO | now() |

#### `admins` (PK: `id`, FK → auth.users)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | — |
| email | text | YES | — |
| is_active | boolean | NO | true |
| created_at | timestamptz | NO | now() |

> Contrainte UNIQUE sur `email`.

#### `security_rate_limits` (PK: `ip_or_user`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| ip_or_user | text | NO | — |
| attempt_count | integer | YES | 1 |
| last_attempt | timestamptz | YES | now() |
| blocked_until | timestamptz | YES | — |

---

### 2.3 Service 01 — Compatibilité

#### `sessions_compatibilite` (PK: `id` — 25 colonnes)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| user_id | uuid | YES | — |
| client_token | text | NO | gen_random_uuid() |
| created_at | timestamptz | NO | now() |
| partenaire_a_nom / partenaire_b_nom | text | NO | — |
| partenaire_a_naissance / partenaire_b_naissance | date | NO | — |
| statut_relation | text | YES | — |
| date_rencontre | date | YES | — |
| duree_relation | text | YES | — |
| defis | text[] | NO | '{}' |
| notifications | boolean | NO | false |
| email_contact / telephone_contact | text | YES | — |
| nombre_couple / nombre_couple_jour | smallint | NO | — |
| genere_le | timestamptz | NO | — |
| statut_paiement | text | NO | 'pending' |
| fournisseur_paiement | text | YES | — |
| reference_paiement | text | YES | — |
| montant_centimes | integer | YES | — |
| devise | text | NO | 'EUR' |
| paye_le | timestamptz | YES | — |
| metadata | jsonb | NO | '{}' |

#### `couple_profiles` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| user_id | uuid | NO | — |
| user_firstname / partner_firstname | text | NO | — |
| user_birthdate / partner_birthdate | date | NO | — |
| user_gender / partner_gender | enum sexe_personne | NO | 'non_precise' |
| relationship_start_date | date | YES | — |
| payment_id | uuid | YES | — |
| created_at / updated_at | timestamptz | NO | now() |

#### `rapports_partenaires` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| session_id | uuid | NO | — (FK) |
| role_partenaire / nom_partenaire | text | NO | — |
| chemin_vie | smallint | NO | — |
| nombre_nom / nombre_kabbale / nombre_intime | smallint | NO | — |
| nombre_personnalite / nombre_heredite | smallint | NO | — |
| annee_personnelle / mois_personnel / jour_personnel | smallint | NO | — |

---

### 2.4 Contenu & Interprétations

#### `numerology_texts` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| type | text | NO | — |
| number | smallint | NO | — |
| locale | text | NO | 'fr' |
| title | text | YES | — |
| body | text | NO | — |
| segment | text | YES | — |
| updated_at | timestamptz | NO | now() |

#### `canonical_predictions` (PK: `id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| periode | enum periode_rapport | NO | — |
| numero | smallint | NO | — |
| titre / contenu_md | text | NO | — |
| contenu_sha256 | text | YES | — |
| source_document | text | NO | 'Rapports couple.pdf' |
| verrouille | boolean | NO | true |
| langue | text | NO | 'fr' |
| version | smallint | NO | 1 |
| created_at / updated_at | timestamptz | NO | now() |

> Contrainte UNIQUE sur `(periode, numero, langue)`.

#### `content_bricks` (PK: `id` — 20 colonnes)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| bloc | smallint | NO | — |
| periode | enum periode_contenu | NO | 'jour' |
| type_brique | text | NO | — |
| numero_cible | smallint | NO | — |
| numero_base / numero_maitre | smallint | YES | — |
| etat_relationnel | enum etat_relationnel | NO | 'indifferent' |
| statut_utilisateur | enum statut_utilisateur | NO | 'indifferent' |
| ton | enum ton_redaction | NO | 'direct_doux' |
| modele_texte | text | NO | — |
| jours_refroidissement | integer | NO | 21 |
| poids | numeric | NO | 1.0 |
| actif | boolean | NO | true |
| cle_choix | integer | NO | random() |
| tags | text[] | NO | '{}' |
| langue | text | NO | 'fr' |
| version | smallint | NO | 1 |
| created_at / updated_at | timestamptz | NO | now() |

#### `brick_usage` (PK composite: `user_id`, `brick_id`)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| user_id | uuid | NO | — |
| brick_id | uuid | NO | — (FK → content_bricks) |
| dernier_usage | date | NO | — |
| dernier_report_id | uuid | YES | — |
| updated_at | timestamptz | NO | now() |

---

### 2.5 Service 01bis — Portrait de l'Âme

#### `cycle_vie_soul_periods` (PK: `id` — 19 colonnes)
| Colonne | Type | Nullable | Default |
|---------|------|----------|---------|
| id | uuid | NO | gen_random_uuid() |
| period_number | integer | NO | — |
| polarity | char(1) | NO | — |
| date_start / date_end | text | NO | — |
| identite_cosmique / introduction | text | NO | — |
| heritage_cosmique / coeur_etre | text | NO | — |
| forces_naturelles / defis_transcender | text | NO | — |
| vocations_ideales / affinites_geographiques | text | NO | — |
| vigilance_sante / conseils_epanouissement | text | NO | — |
| message_cosmique | text | NO | — |
| is_active | boolean | YES | true |
| created_at / updated_at | timestamptz | YES | now() |

---

### 2.6 Services 02-04 — Cycles (Personnel, Business, Santé)

#### `personal_cycle_periods` (PK: `id` — 17 colonnes)
| Colonne | Type |
|---------|------|
| period_number | integer |
| period_name / theme_central | text |
| day_start / day_end | integer |
| energie_periode / description_theme | text |
| domaines_favorables / domaines_eviter | jsonb |
| conseils | text[] |
| affirmation / influence_decisions / enseignement | text |
| is_active | boolean |

#### `personal_cycle_subscriptions` (PK: `id` — 11 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — (FK → auth.users) |
| user_birthdate | date | — |
| user_firstname | text | — |
| start_date | date | CURRENT_DATE |
| end_date | date | CURRENT_DATE + 1 year |
| payment_id | uuid | — |
| status | varchar(20) | 'active' |
| auto_renew | boolean | false |

> CHECK constraint sur status: `active`, `expired`, `cancelled`.

#### `business_cycle_periods` (PK: `id` — 16 colonnes)
Similaire à personal_cycle mais avec :
- `focus_strategique`, `energie_business`, `fenetre_strategique` (jsonb)
- `actions_recommandees`, `risques_eviter`, `decisions_favorables`, `decisions_defavorables` (text[])
- `indicateurs_cles` (jsonb), `astuce_strategique` (text)

> CHECK constraint: `period_number BETWEEN 1 AND 7`. UNIQUE sur period_number.

#### `business_cycle_subscriptions` (PK: `id` — 10 colonnes)
Similaire mais avec `company_name` (text) et `reference_date` (date).

#### `health_cycle_periods` (PK: `id` — 18 colonnes)
Similaire mais avec :
- `etat_energetique`, `repos_sommeil`, `affirmation_bien_etre`, `enseignement` (text)
- `points_vigilance`, `activites_recommandees`, `activites_moderer` (text[])
- `alimentation_privilegier`, `alimentation_eviter`, `conseils_pratiques` (text[])
- `avertissement` — default: "Ce conseil ne remplace pas un avis médical professionnel."

#### `health_cycle_subscriptions` (PK: `id` — 10 colonnes)
Similaire avec `user_name`, `birth_date`, `start_date`, `end_date`.

---

### 2.7 Service 05 — Guide Horaire

#### `cycle_vie_daily_periods` (PK: `id` — 14 colonnes)
| Colonne | Type | Nullable |
|---------|------|----------|
| period_letter | char(1) | NO |
| weekday_number | integer | YES |
| period_name / keyword / description | text | NO |
| activities_favorables / activities_eviter | text | YES |
| color_code | varchar(7) | YES |
| icon_name | varchar(50) | YES |
| energy_level | varchar(20) | YES |
| is_active | boolean | YES (default true) |

#### `daily_guide_purchases` (PK: `id` — 8 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — |
| payment_id | uuid | — |
| purchase_date | timestamptz | now() |
| target_date | date | — |
| status | varchar(20) | 'active' |

---

### 2.8 Service 06 — Éclairage Décision

#### `cycle_vie_decision_types` (PK: `id` — 10 colonnes)
| Colonne | Type |
|---------|------|
| code | varchar(50) |
| label | varchar(100) |
| category | varchar(50) |
| description / detailed_description | text |
| icon | varchar(50) |
| display_order | integer (default 0) |
| is_active | boolean (default true) |

#### `cycle_vie_decision_advice` (PK: `id` — 15 colonnes)
| Colonne | Type |
|---------|------|
| decision_type_id | uuid (FK → cycle_vie_decision_types) |
| cycle_type | varchar(20) — default 'personal' |
| period_number | integer |
| favorability_score | integer |
| cosmic_context / advice_text | text |
| recommended_actions / warnings | text |
| pitfalls_to_avoid / optimal_timing | text |
| alternatives_suggestion / closing_message | text |

#### `decision_credit_packs` (PK: `id` — 10 colonnes)
| Colonne | Type |
|---------|------|
| name | text |
| description | text |
| credits_count | integer |
| price_fcfa | integer |
| discount_percent | integer (default 0) |
| display_order | integer (default 0) |
| is_active | boolean (default true) |

#### `user_decision_credits` (PK: `id` — 13 colonnes)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| cycle_vie_purchase_id / purchase_id | uuid |
| credits_initial / credits_remaining | integer |
| source_type | text |
| source_id | uuid |
| expires_at | timestamptz |
| notified_7d / notified_1d | boolean (default false) |

#### `user_decision_usage` (PK: `id` — 10 colonnes)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| credit_id | uuid |
| cycle_vie_purchase_id / purchase_id | uuid |
| decision_type_id | uuid (FK → cycle_vie_decision_types) |
| cycle_type | text |
| period_number | integer |
| target_date | date |

---

### 2.9 Service 07 — Phases de Vie

#### `life_phase_periods` (PK: `id` — 11 colonnes)
| Colonne | Type |
|---------|------|
| phase_number | integer |
| phase_name / theme | text |
| age_start / age_end | integer |
| full_content | text (default '') |
| impacts / questions_reflection / travail_guerison | text[] |
| is_active | boolean (default true) |

#### `life_phase_purchases` (PK: `id` — 5 colonnes)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| user_birthdate | date |
| purchase_date | timestamp (default now()) |
| payment_id | uuid |

---

### 2.10 Service 08 — Timing Lunaire

#### `lunar_phases` (PK: `id` — 13 colonnes)
| Colonne | Type |
|---------|------|
| phase_number | integer |
| phase_name / phase_key / theme | text |
| energy_type | text |
| full_content | text (default '') |
| activities_favorables / activities_eviter | text[] |
| conseil | text |
| duration_days | integer (default 3) |
| is_active | boolean (default true) |

#### `lunar_subscriptions` (PK: `id` — 7 colonnes)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| start_date / end_date | date |
| payment_id | uuid |
| status | varchar(20) — default 'active' |

---

### 2.11 Paiements & Achats

#### `payments` (PK: `id` — 9 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| id | uuid | gen_random_uuid() |
| user_id | uuid | — |
| session_id | uuid | — |
| transaction_id | text | — |
| amount_fcfa | integer | — |
| payment_method | text | — |
| status | text | 'pending' |
| plan_type | text | — |
| created_at | timestamptz | now() |

#### `purchases` (PK: `id` — 11 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — |
| product_type | text | — |
| period_date | date | — |
| payment_provider | text | — |
| transaction_id | text | — |
| amount_fcfa | integer | — |
| status | text | 'pending' |
| metadata | jsonb | '{}' |

#### `temporal_purchases` (PK: `id` — 12 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — |
| purchase_type | text | — |
| start_date / end_date | date | — |
| bonus_year / bonus_month / bonus_day | boolean | false |
| amount_fcfa | integer | — |
| payment_status | text | 'pending' |
| transaction_id | text | — |

#### `cycle_vie_purchases` (PK: `id` — 13 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — |
| payment_id | uuid | — |
| service_type | varchar(50) | — |
| user_birthdate | date | — |
| user_firstname | text | — |
| consultation_date | date | — |
| decision_type_id | uuid | — |
| decision_detail | text | — |
| report_data | jsonb | — |
| status | varchar(20) | 'completed' |
| expires_at | timestamptz | — |

#### `subscriptions` (PK: `id` — 7 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id / plan_id | uuid | — |
| starts_at | timestamptz | now() |
| expires_at | timestamptz | — |
| is_active | boolean | true |
| payment_id | uuid | — |

---

### 2.12 Rapports & Persistance

#### `generated_reports` (PK: `id` — 20 colonnes)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| couple_profile_id | uuid |
| periode | enum periode_rapport |
| date_reference | date |
| numero_couple / numero_annee / numero_mois / numero_jour | smallint |
| etat_rel | enum etat_relationnel (default 'indifferent') |
| seed | text |
| canonical_prediction_id | uuid |
| bloc0_titre / bloc0_contenu_md | text |
| bloc1_contenu / bloc2_contenu / bloc3_contenu | text |
| briques_utilisees | uuid[] |
| contexte | jsonb |

#### `stored_reports` (PK: `id` — 10 colonnes)
| Colonne | Type | Default |
|---------|------|---------|
| user_id | uuid | — |
| payment_id | uuid | — |
| service_type | text | — |
| report_data | jsonb | — |
| service_label | text | '' |
| metadata | jsonb | '{}' |
| upsert_key | text | — |
| created_at / updated_at | timestamptz | now() |

#### `user_reports` (PK: `id`)
| Colonne | Type |
|---------|------|
| user_id | uuid |
| session_id | uuid |
| purchased_at | timestamptz (default now()) |

---

### 2.13 Marketing & Analytics

#### `marketing_prospects` (PK: `id`)
| Colonne | Type | Default |
|---------|------|---------|
| email / phone | text | — |
| source | text | 'app' |
| last_action | text | — |
| status | text | 'to_contact' |
| captured_at / updated_at | timestamptz | now() |

#### `social_proof_config` (PK: `id` — 23 colonnes)
| Colonne | Type |
|---------|------|
| proof_type | text |
| target_screen / region / service_key | text |
| enabled | boolean |
| display_order | integer |
| first_names / last_initials / message_templates / time_labels | text[] |
| show_duration_ms | integer (default 4000) |
| pause_min_ms / pause_max_ms | integer |
| badge_text / badge_counter_label | text |
| badge_counter | integer |
| testimonial_name / testimonial_text / testimonial_photo_url | text |
| testimonial_rating | integer (default 5) |

#### `analytics_events` (PK: `id`)
| Colonne | Type |
|---------|------|
| session_id / user_id | uuid |
| event_type | text |
| metadata | jsonb (default '{}') |

#### `webhook_logs` (PK: `id`)
| Colonne | Type |
|---------|------|
| provider | text |
| event_type / transaction_id | text |
| payload | jsonb |
| processed_at | timestamptz |

---

### 2.14 Légal

#### `legal_pages` (PK: `id`)
| Colonne | Type | Default |
|---------|------|---------|
| slug / title / content | text | — |
| is_active | boolean | true |
| display_order | integer | 0 |

---

## 3. Enums Personnalisés (Types USER-DEFINED)

| Enum | Valeurs attendues |
|------|-------------------|
| `periode_rapport` | jour, mois, annee |
| `periode_contenu` | jour, mois, annee (default 'jour') |
| `etat_relationnel` | indifferent, couple, celibataire ... |
| `statut_utilisateur` | indifferent, nouveau, regulier ... |
| `ton_redaction` | direct_doux, ... |
| `sexe_personne` | non_precise, homme, femme |

> Note : Les valeurs exactes des enums sont dans les résultats de la requête 9.

---

## 4. Relations (Foreign Keys)

| Source Table | Colonne | → Table Cible | Colonne Cible |
|-------------|---------|---------------|---------------|
| admins | id | auth.users | id |
| brick_usage | brick_id | content_bricks | id |
| business_cycle_subscriptions | user_id | auth.users | id |
| couple_profiles | user_id | auth.users | id |
| cycle_vie_decision_advice | decision_type_id | cycle_vie_decision_types | id |
| personal_cycle_subscriptions | user_id | auth.users | id |
| health_cycle_subscriptions | user_id | auth.users | id |
| rapports_partenaires | session_id | sessions_compatibilite | id |
| user_decision_credits | user_id | auth.users | id |
| user_decision_usage | user_id | auth.users | id |
| user_decision_usage | credit_id | user_decision_credits | id |
| user_decision_usage | decision_type_id | cycle_vie_decision_types | id |

---

## 5. Principes de Sécurité

### RLS (Row Level Security)
- **Activé sur toutes les tables utilisateur** : payments, purchases, stored_reports, couple_profiles, subscriptions, etc.
- **Tables de configuration** : lecture publique (anon + authenticated)
- **Politique type** : `auth.uid() = user_id` pour les opérations SELECT/INSERT/UPDATE

### Fonctions SECURITY DEFINER
- Opérations sensibles (création de comptes, vérification d'accès) passent par des RPC `SECURITY DEFINER`
- Ces fonctions s'exécutent avec les droits du propriétaire, indépendamment du RLS

### Rate Limiting
- Table `security_rate_limits` pour limiter les tentatives abusives
- Stocke IP/user, compteur de tentatives, et timestamp de blocage

---

## 6. Patterns Architecturaux Backend

### Thick Database
- Logique métier dans la base (triggers, RPC)
- Le client Flutter est "thin" — appelle les RPC et lit les résultats
- Validation côté serveur dans les fonctions RPC

### Immutabilité des Rapports
- `stored_reports.report_data` est un snapshot JSON figé
- `upsert_key` pour déduplication
- Une fois stocké, le rapport ne change jamais

### Gestion des Abonnements
- Pattern uniforme : `start_date`, `end_date`, `status` ('active'/'expired'/'cancelled')
- Vérification d'expiration côté client ET côté serveur

### Devise
- Prix en FCFA (integer) pour éviter les erreurs d'arrondi
- `sessions_compatibilite.devise` = 'EUR' — legacy / futur multi-devise

---

## 7. Données Réelles — État des Paiements (25/02/2026)

### Statistiques globales
- **20 paiements** enregistrés (tous `status = success`)
- **2 utilisateurs distincts** ayant effectué des paiements
- **Période d'activité** : 25 janvier — 30 janvier 2026

### Répartition par type de plan

| plan_type | Nb transactions | Total FCFA | Montants |
|-----------|-----------------|------------|----------|
| `consultation` (compatibilité) | 9 | 1 071 | 1–755 FCFA |
| `temporel_jour` | 10 | 136 | 5–101 FCFA |
| `temporel_mois` | 1 | 101 | 101 FCFA |

### Répartition par méthode de paiement

| Méthode | Nb transactions | Total FCFA |
|---------|-----------------|------------|
| **Kkiapay** | 14 | 803 |
| **FedaPay** | 6 | 505 |

### Observations importantes pour le GPT
1. **Volume très faible** — Seulement 20 transactions en production, principalement des tests
2. **Montants test** — La majorité des paiements sont à 1-5 FCFA (montants de test)
3. **1 seul vrai paiement** — 755 FCFA par un utilisateur différent (`efcb618a...`) le 30/01/2026
4. **Aucune vente depuis le 30/01** — ~1 mois sans activité commerciale
5. **Aucun paiement pour les cycles** — Services 02-08 jamais achetés en production
6. **100% mobile money/Afrique** — Aucune transaction Stripe/PayPal (non intégré)
7. **Devise FCFA uniquement** — Malgré le champ `devise = 'EUR'` dans sessions_compatibilite

### Dernier paiement (le plus récent)
```
ID: 87100002-ebdc-4848-901f-7c8e2ea992dd
Date: 2026-01-30 06:41:35 UTC
Plan: consultation
Montant: 755 FCFA
Méthode: Kkiapay
Statut: success
```

---

## 8. Notes de Volumétrie

Les données actuelles montrent :
- **48 tables** dans le schéma public
- Les tables de contenu (periods, bricks, predictions) contiennent les données de référence
- Les tables transactionnelles (payments, purchases, stored_reports) contiennent les données utilisateurs
- **Activité commerciale quasi nulle** — confirme le besoin d'optimisation du tunnel de conversion

---

> ⚠️ **RAPPEL** : Ce document doit être mis à jour à chaque modification du schéma. Utilisez les requêtes du fichier `backend_queries.sql` pour régénérer les informations.
