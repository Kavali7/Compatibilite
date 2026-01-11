-- ============================================================
-- SCRIPT DE RÉPARATION : ACCÈS PRIX (Problème 2 FCFA)
-- Objectif : Forcer la visibilité des prix pour tout le monde
-- ============================================================

BEGIN;

-- 1. Vérifier et insérer les plans s'ils manquent
-- (Si la table est vide, l'app affiche 0 ou fallbacks)
INSERT INTO public.pricing_plans (plan_type, name, price_fcfa, duration_days, is_active)
VALUES 
  ('consultation', 'Rapport unique', 500, NULL, true),
  ('subscription', 'Abonnement mensuel', 10000, 30, true)
ON CONFLICT DO NOTHING;

-- 2. Réinitialiser la sécurité RLS sur pricing_plans
ALTER TABLE public.pricing_plans ENABLE ROW LEVEL SECURITY;

-- Supprimer les anciennes politiques potentiellement bloquantes
DROP POLICY IF EXISTS "Allow public read on pricing_plans" ON public.pricing_plans;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.pricing_plans;
DROP POLICY IF EXISTS "Lecture publique pricing" ON public.pricing_plans;

-- Créer une politique CLAIRE et NETTE : Tout le monde peut lire
CREATE POLICY "Public Read Pricing"
ON public.pricing_plans
FOR SELECT
USING (true); -- Pas de condition compliquée, juste "OUI"

-- 3. Accorder les droits au niveau Postgres (Grant)
-- Parfois le rôle 'anon' n'a même pas le droit 'SELECT' de base
GRANT SELECT ON public.pricing_plans TO anon;
GRANT SELECT ON public.pricing_plans TO authenticated;
GRANT SELECT ON public.pricing_plans TO service_role;

COMMIT;

-- Petit message de confirmation
DO $$
BEGIN
  RAISE NOTICE '✅ RÉPARATION TERMINÉE : Les plans devraient être visibles (500 FCFA).';
END $$;
