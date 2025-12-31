-- ============================================================
-- CORRECTION: Ajouter le rôle 'anon' aux policies RLS
-- L'app utilise une auth personnalisée (table 'users'), pas Supabase Auth
-- Le client se connecte en tant que 'anon' et non 'authenticated'
-- ============================================================

-- couple_profiles: ajouter policies pour anon
DROP POLICY IF EXISTS couple_profiles_anon_select ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_insert ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_update ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_delete ON public.couple_profiles;

CREATE POLICY couple_profiles_anon_select ON public.couple_profiles
FOR SELECT TO anon USING (true);

CREATE POLICY couple_profiles_anon_insert ON public.couple_profiles
FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY couple_profiles_anon_update ON public.couple_profiles
FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY couple_profiles_anon_delete ON public.couple_profiles
FOR DELETE TO anon USING (true);

-- generated_reports: ajouter policies pour anon
DROP POLICY IF EXISTS generated_reports_anon_select ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_anon_insert ON public.generated_reports;

CREATE POLICY generated_reports_anon_select ON public.generated_reports
FOR SELECT TO anon USING (true);

CREATE POLICY generated_reports_anon_insert ON public.generated_reports
FOR INSERT TO anon WITH CHECK (true);

-- brick_usage: ajouter policies pour anon
DROP POLICY IF EXISTS brick_usage_anon_select ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_anon_insert ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_anon_update ON public.brick_usage;

CREATE POLICY brick_usage_anon_select ON public.brick_usage
FOR SELECT TO anon USING (true);

CREATE POLICY brick_usage_anon_insert ON public.brick_usage
FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY brick_usage_anon_update ON public.brick_usage
FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- canonical_predictions: ajouter policy select pour anon
DROP POLICY IF EXISTS canonical_predictions_anon_select ON public.canonical_predictions;

CREATE POLICY canonical_predictions_anon_select ON public.canonical_predictions
FOR SELECT TO anon USING (true);

-- content_bricks: ajouter policy select pour anon
DROP POLICY IF EXISTS content_bricks_anon_select ON public.content_bricks;

CREATE POLICY content_bricks_anon_select ON public.content_bricks
FOR SELECT TO anon USING (true);

-- Vérification
SELECT '✅ Policies anon ajoutées' as status;

SELECT schemaname, tablename, policyname, cmd, roles
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('couple_profiles', 'generated_reports', 'brick_usage', 'canonical_predictions', 'content_bricks')
ORDER BY tablename, policyname;
