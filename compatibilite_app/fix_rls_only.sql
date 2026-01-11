-- ============================================================
-- SCRIPT DE RÉPARATION CIBLÉ : UNIQUEMENT LES PERMISSIONS (RLS)
-- Ne touche PAS à vos données/prix existants.
-- ============================================================

BEGIN;

-- 1. S'assurer que le système de sécurité est actif
ALTER TABLE public.pricing_plans ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer les anciennes règles qui pourraient bloquer
DROP POLICY IF EXISTS "Allow public read on pricing_plans" ON public.pricing_plans;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.pricing_plans;
DROP POLICY IF EXISTS "Lecture publique pricing" ON public.pricing_plans;
DROP POLICY IF EXISTS "Public Read Pricing" ON public.pricing_plans;

-- 3. Créer la règle ULTIME pour que l'app mobile puisse lire
-- On autorise SELECT pour : anon (visiteur), authenticated (connecté), service_role (serveur)
CREATE POLICY "Public Read Pricing"
ON public.pricing_plans
FOR SELECT
TO public
USING (true);

-- 4. Accorder les permissions SQL de base (souvent la cause cachée)
GRANT SELECT ON public.pricing_plans TO anon;
GRANT SELECT ON public.pricing_plans TO authenticated;
GRANT SELECT ON public.pricing_plans TO service_role;

COMMIT;

DO $$
BEGIN
  RAISE NOTICE '✅ PERMISSIONS RÉPARÉES. L''application devrait maintenant voir vos VRAIS prix.';
END $$;
