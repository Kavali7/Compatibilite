-- ============================================================
-- SCRIPT COMPLET DE CORRECTION - Rapports Temporels
-- À exécuter dans la console SQL de Supabase
-- ============================================================

-- =============================
-- ÉTAPE 1: DIAGNOSTIC
-- =============================

-- 1.1 Vérifier les FK actuelles
SELECT 'FOREIGN KEYS ACTUELLES:' as info;
SELECT tc.table_name, kcu.column_name, ccu.table_name AS foreign_table
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name IN ('couple_profiles', 'generated_reports', 'brick_usage');

-- 1.2 Vérifier si canonical_predictions a des données
SELECT 'CANONICAL_PREDICTIONS COUNT:' as info;
SELECT periode, COUNT(*) as count FROM canonical_predictions GROUP BY periode ORDER BY periode;

-- 1.3 Vérifier si content_bricks a des données
SELECT 'CONTENT_BRICKS COUNT:' as info;
SELECT bloc, COUNT(*) as count FROM content_bricks WHERE actif = true GROUP BY bloc ORDER BY bloc;

-- =============================
-- ÉTAPE 2: SUPPRIMER LES FK
-- =============================

-- 2.1 couple_profiles
DO $$ 
DECLARE
  constraint_name_var text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name_var
  FROM information_schema.table_constraints AS tc 
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'couple_profiles'
  AND kcu.column_name = 'user_id'
  LIMIT 1;
  
  IF constraint_name_var IS NOT NULL THEN
    EXECUTE 'ALTER TABLE public.couple_profiles DROP CONSTRAINT ' || constraint_name_var;
    RAISE NOTICE 'Dropped constraint on couple_profiles: %', constraint_name_var;
  ELSE
    RAISE NOTICE 'No FK constraint found on couple_profiles.user_id - already removed or never existed';
  END IF;
END $$;

-- 2.2 generated_reports
DO $$ 
DECLARE
  constraint_name_var text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name_var
  FROM information_schema.table_constraints AS tc 
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'generated_reports'
  AND kcu.column_name = 'user_id'
  LIMIT 1;
  
  IF constraint_name_var IS NOT NULL THEN
    EXECUTE 'ALTER TABLE public.generated_reports DROP CONSTRAINT ' || constraint_name_var;
    RAISE NOTICE 'Dropped constraint on generated_reports: %', constraint_name_var;
  ELSE
    RAISE NOTICE 'No FK constraint found on generated_reports.user_id';
  END IF;
END $$;

-- 2.3 brick_usage
DO $$ 
DECLARE
  constraint_name_var text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name_var
  FROM information_schema.table_constraints AS tc 
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'brick_usage'
  AND kcu.column_name = 'user_id'
  LIMIT 1;
  
  IF constraint_name_var IS NOT NULL THEN
    EXECUTE 'ALTER TABLE public.brick_usage DROP CONSTRAINT ' || constraint_name_var;
    RAISE NOTICE 'Dropped constraint on brick_usage: %', constraint_name_var;
  ELSE
    RAISE NOTICE 'No FK constraint found on brick_usage.user_id';
  END IF;
END $$;

-- =============================
-- ÉTAPE 3: CORRIGER RLS POLICIES
-- =============================

-- 3.1 couple_profiles
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS couple_profiles_select_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_select_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_policy ON public.couple_profiles;

CREATE POLICY couple_profiles_select_policy ON public.couple_profiles
FOR SELECT TO authenticated USING (true);

CREATE POLICY couple_profiles_insert_policy ON public.couple_profiles
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY couple_profiles_update_policy ON public.couple_profiles
FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY couple_profiles_delete_policy ON public.couple_profiles
FOR DELETE TO authenticated USING (true);

-- 3.2 generated_reports
ALTER TABLE public.generated_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS generated_reports_select_own ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_select_policy ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_insert_policy ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_update_policy ON public.generated_reports;

CREATE POLICY generated_reports_select_policy ON public.generated_reports
FOR SELECT TO authenticated USING (true);

CREATE POLICY generated_reports_insert_policy ON public.generated_reports
FOR INSERT TO authenticated WITH CHECK (true);

-- 3.3 brick_usage
ALTER TABLE public.brick_usage ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS brick_usage_select_own ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_select_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_insert_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_update_policy ON public.brick_usage;

CREATE POLICY brick_usage_select_policy ON public.brick_usage
FOR SELECT TO authenticated USING (true);

CREATE POLICY brick_usage_insert_policy ON public.brick_usage
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY brick_usage_update_policy ON public.brick_usage
FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

-- =============================
-- ÉTAPE 4: VÉRIFICATION FINALE
-- =============================

SELECT 'VÉRIFICATION FK APRÈS CORRECTION:' as info;
SELECT tc.table_name, kcu.column_name, ccu.table_name AS foreign_table
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name IN ('couple_profiles', 'generated_reports', 'brick_usage')
AND kcu.column_name = 'user_id';

SELECT 'POLICIES APRÈS CORRECTION:' as info;
SELECT schemaname, tablename, policyname, permissive, cmd
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('couple_profiles', 'generated_reports', 'brick_usage')
ORDER BY tablename, policyname;

-- =============================
-- TEST INSERTION (optionnel)
-- =============================
-- Décommentez pour tester:
-- INSERT INTO couple_profiles (user_id, user_firstname, user_birthdate, user_gender, partner_firstname, partner_birthdate, partner_gender)
-- VALUES ('11111111-1111-1111-1111-111111111111', 'TestUser', '1990-01-01', 'homme', 'TestPartner', '1992-06-15', 'femme');
-- DELETE FROM couple_profiles WHERE user_firstname = 'TestUser';

SELECT '✅ SCRIPT TERMINÉ - Vérifiez les résultats ci-dessus' as status;
