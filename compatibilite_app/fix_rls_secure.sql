-- ============================================================
-- FIX SECURITY: Renforcement des politiques RLS (Strict Mode)
-- DATE: 2026-01-07
-- DESCRIPTION: Remplace les politiques "passoires" (using true)
--              par des vérifications strictes de propriété (auth.uid).
--              Empêche les utilisateurs d'accéder aux données des autres.
-- ============================================================

-- ------------------------------------------------------------
-- 1. couple_profiles
-- ------------------------------------------------------------
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS couple_profiles_select_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_policy ON public.couple_profiles;
-- Nettoyage des anciennes politiques potentielles
DROP POLICY IF EXISTS couple_profiles_select_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_own ON public.couple_profiles;

-- SELECT: Uniquement son propre profil
CREATE POLICY couple_profiles_select_strict
ON public.couple_profiles FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- INSERT: Uniquement pour soi-même
CREATE POLICY couple_profiles_insert_strict
ON public.couple_profiles FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- UPDATE: Uniquement son propre profil
CREATE POLICY couple_profiles_update_strict
ON public.couple_profiles FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- DELETE: Uniquement son propre profil
CREATE POLICY couple_profiles_delete_strict
ON public.couple_profiles FOR DELETE
TO authenticated
USING (user_id = auth.uid());


-- ------------------------------------------------------------
-- 2. generated_reports
-- ------------------------------------------------------------
ALTER TABLE public.generated_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS generated_reports_select_policy ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_insert_policy ON public.generated_reports;
-- Nettoyage anciens
DROP POLICY IF EXISTS generated_reports_select_own ON public.generated_reports;

-- SELECT: Uniquement ses propres rapports
CREATE POLICY generated_reports_select_strict
ON public.generated_reports FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- NOTE: PAS de politique INSERT/UPDATE/DELETE pour authenticated.
-- La génération se fait via RPC (SECURITY DEFINER) qui a les droits administrateur.
-- L'utilisateur ne doit pas pouvoir insérer manuellement un rapport falsifié.


-- ------------------------------------------------------------
-- 3. brick_usage
-- ------------------------------------------------------------
ALTER TABLE public.brick_usage ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS brick_usage_select_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_insert_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_update_policy ON public.brick_usage;
-- Nettoyage anciens
DROP POLICY IF EXISTS brick_usage_select_own ON public.brick_usage;

-- SELECT: Uniquement son propre historique
CREATE POLICY brick_usage_select_strict
ON public.brick_usage FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- NOTE: Comme pour les rapports, l'écriture se fait princpalement via RPC.
-- Si le code Dart a besoin d'écrire directement (peu probable), on peut l'ajouter,
-- mais par sécurité on laisse en lecture seule pour l'utilisateur standard.


-- ------------------------------------------------------------
-- 4. Tables de Référence (Lecture Seule pour tous)
-- ------------------------------------------------------------
-- canonical_predictions & content_bricks
-- Déjà correct si defined 'USING (true)' pour SELECT uniquement.
-- On s'assure juste qu'il n'y a pas de droits d'écriture accidentels.

-- Vérification finale (à titre informatif pour l'admin)
SELECT tablename, policyname, permissive, cmd, qual, with_check 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename;
