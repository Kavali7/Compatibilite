-- Migration: Add service_key column and per-service popularity badges
-- Execute this in the Supabase SQL Editor AFTER migration_social_proof.sql

-- 1. Add service_key column (nullable, for linking badges to specific services)
ALTER TABLE public.social_proof_config
ADD COLUMN IF NOT EXISTS service_key text;

-- 2. Update the existing global badge to have no service_key (it stays as the fallback)
-- (no change needed — existing badge has service_key = NULL by default)

-- 3. Insert per-service popularity badges
-- Each service gets its own badge with a realistic counter
-- The total banner at the top will sum all these counters

INSERT INTO public.social_proof_config (
  proof_type, target_screen, enabled, display_order, region,
  badge_text, badge_counter, badge_counter_label, service_key
) VALUES
  -- Service: Compatibilité Couple (le plus populaire, gratuit)
  ('badge', 'catalog', true, 10, 'all',
   '🔥 Populaire', 1247, 'consultations', 'compatibilite_couple'),

  -- Service: Prévisions Temporelles
  ('badge', 'catalog', true, 11, 'all',
   '📈 Tendance', 389, 'analyses', 'previsions_temporelles'),

  -- Service: Guidance Quotidienne
  ('badge', 'catalog', true, 12, 'all',
   '⭐ Recommandé', 312, 'consultations', 'guidance_quotidienne'),

  -- Service: Mois Décrypté
  ('badge', 'catalog', true, 13, 'all',
   '📊 Populaire', 278, 'analyses', 'mois_decrypte'),

  -- Service: Avenir Année
  ('badge', 'catalog', true, 14, 'all',
   '🏆 Best-seller', 198, 'rapports', 'avenir_annee'),

  -- Service: Portrait de l'Âme
  ('badge', 'catalog', true, 15, 'all',
   '✨ Coup de cœur', 156, 'portraits', 'portrait_ame'),

  -- Service: Cycle Personnel
  ('badge', 'catalog', true, 16, 'all',
   '📅 Populaire', 134, 'abonnements', 'cycle_personnel'),

  -- Service: Cycle Business
  ('badge', 'catalog', true, 17, 'all',
   '💼 Pro', 89, 'analyses', 'cycle_business'),

  -- Service: Cycle Santé
  ('badge', 'catalog', true, 18, 'all',
   '💚 Bien-être', 67, 'suivis', 'cycle_sante'),

  -- Service: Guide Horaire
  ('badge', 'catalog', true, 19, 'all',
   '⏰ Utile', 98, 'consultations', 'guide_horaire'),

  -- Service: Éclairage Décision
  ('badge', 'catalog', true, 20, 'all',
   '💡 Pratique', 112, 'décisions', 'eclairage_decision'),

  -- Service: Phases de Vie
  ('badge', 'catalog', true, 21, 'all',
   '🛤️ Découverte', 45, 'rapports', 'phases_vie'),

  -- Service: Timing Lunaire
  ('badge', 'catalog', true, 22, 'all',
   '🌙 Nouveau', 34, 'abonnements', 'timing_lunaire');

-- 4. Optionally disable the old global badge (since we now have per-service ones)
-- The global badge had no service_key and showed "2 847 analyses cette semaine"
-- The banner will now sum all per-service counters instead
-- UPDATE public.social_proof_config
-- SET enabled = false
-- WHERE proof_type = 'badge' AND service_key IS NULL;

-- Verify: total should be ~3,159 (sum of all per-service counters)
SELECT 'Total badge counter sum:', SUM(badge_counter)
FROM public.social_proof_config
WHERE proof_type = 'badge' AND service_key IS NOT NULL AND enabled = true;
