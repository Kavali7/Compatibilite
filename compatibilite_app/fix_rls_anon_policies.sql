-- ============================================================
-- CORRECTION: Ajouter le rôle 'anon' aux policies RLS
-- L'app utilise une auth personnalisée (table 'users'), pas Supabase Auth
-- Le client se connecte en tant que 'anon' et non 'authenticated'
-- ============================================================

-- couple_profiles: accès uniquement au propriétaire
DROP POLICY IF EXISTS couple_profiles_anon_select ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_insert ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_update ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_anon_delete ON public.couple_profiles;

-- Nettoyage des anciennes policies potentiellement conflictuelles
DROP POLICY IF EXISTS couple_profiles_select_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_policy ON public.couple_profiles;

DROP POLICY IF EXISTS "Users can view own profile" ON public.couple_profiles;
CREATE POLICY "Users can view own profile" ON public.couple_profiles
FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can create own profile" ON public.couple_profiles;
CREATE POLICY "Users can create own profile" ON public.couple_profiles
FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.couple_profiles;
CREATE POLICY "Users can update own profile" ON public.couple_profiles
FOR UPDATE USING (auth.uid() = user_id);

-- generated_reports: accès uniquement au propriétaire (via session_id lié ou user_id)
DROP POLICY IF EXISTS generated_reports_anon_select ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_anon_insert ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_select_policy ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_insert_policy ON public.generated_reports;
DROP POLICY IF EXISTS "Users can view own reports" ON public.generated_reports;

-- Note: On suppose que generated_reports a une colonne user_id (comme vu dans les scripts RPC)
-- Si la colonne n'existe pas, cette commande échouera (vérifier schema si nécessaire)
CREATE POLICY "Users can view own reports" ON public.generated_reports
FOR SELECT USING (auth.uid() = user_id);

-- L'insertion se fait souvent via RPC (bypass RLS) ou par le serveur.
-- Si le client insère, on ajoute:
DROP POLICY IF EXISTS "Users can insert own reports" ON public.generated_reports;
CREATE POLICY "Users can insert own reports" ON public.generated_reports
FOR INSERT WITH CHECK (auth.uid() = user_id);


-- brick_usage: technique
DROP POLICY IF EXISTS brick_usage_anon_select ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_anon_insert ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_anon_update ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_select_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_insert_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_update_policy ON public.brick_usage;
DROP POLICY IF EXISTS "Users can view own usage" ON public.brick_usage;

CREATE POLICY "Users can view own usage" ON public.brick_usage
FOR SELECT USING (auth.uid() = user_id);

-- canonical_predictions / content_bricks : lecture publique authentifiée
DROP POLICY IF EXISTS canonical_predictions_anon_select ON public.canonical_predictions;
DROP POLICY IF EXISTS canonical_predictions_select_auth ON public.canonical_predictions;
DROP POLICY IF EXISTS "Authenticated users can view predictions" ON public.canonical_predictions;
CREATE POLICY "Authenticated users can view predictions" ON public.canonical_predictions
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS content_bricks_anon_select ON public.content_bricks;
DROP POLICY IF EXISTS content_bricks_select_auth ON public.content_bricks;
DROP POLICY IF EXISTS "Authenticated users can view content" ON public.content_bricks;
CREATE POLICY "Authenticated users can view content" ON public.content_bricks
FOR SELECT TO authenticated USING (true);

-- Activations RLS
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canonical_predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_bricks ENABLE ROW LEVEL SECURITY;

-- Vérification
SELECT '✅ Policies anon ajoutées' as status;

SELECT schemaname, tablename, policyname, cmd, roles
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('couple_profiles', 'generated_reports', 'brick_usage', 'canonical_predictions', 'content_bricks')
ORDER BY tablename, policyname;
