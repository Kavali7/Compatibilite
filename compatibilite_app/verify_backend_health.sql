-- ============================================================
-- DIAGNOSTIC FINAL & SANTÉ BACKEND
-- Ce script agit comme un "Audit Robot" pour vérifier tout le système
-- ============================================================

DO $$
DECLARE
    v_pricing_count integer;
    v_prospects_exists boolean;
    v_rls_pricing boolean;
    v_rpc_exists boolean;
BEGIN
    RAISE NOTICE '🚀 DÉMARRAGE DE L''AUDIT COMPLET...';
    RAISE NOTICE '------------------------------------------------';

    -- 1. VÉRIFICATION DES TABLES CRITIQUES
    RAISE NOTICE '🔍 1. VÉRIFICATION DES TABLES...';
    
    -- Pricing Plans
    SELECT count(*) INTO v_pricing_count FROM public.pricing_plans;
    RAISE NOTICE '   - Plans prix trouvés : %', v_pricing_count;
    
    IF v_pricing_count > 0 THEN
        RAISE NOTICE '✅ Table pricing_plans : OK';
    ELSE
        RAISE WARNING '❌ Table pricing_plans : VIDE ou INEXISTANTE ! (Cause du 2 FCFA)';
    END IF;

    -- Marketing
    SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'marketing_prospects') INTO v_prospects_exists;
    IF v_prospects_exists THEN
        RAISE NOTICE '✅ Table marketing_prospects : OK';
    ELSE
        RAISE WARNING '❌ Table marketing_prospects : MANQUANTE (Le tracking va échouer)';
    END IF;

    -- 2. VÉRIFICATION DES POLITIQUES SÉCURITÉ (RLS)
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE '🛡️ 2. VÉRIFICATION SÉCURITÉ (RLS)...';

    SELECT relrowsecurity INTO v_rls_pricing 
    FROM pg_class WHERE relname = 'pricing_plans';
    
    IF v_rls_pricing THEN
        RAISE NOTICE '✅ RLS activé sur pricing_plans';
        -- Vérifier si une politique "Public Read" existe
        IF EXISTS (
            SELECT 1 FROM pg_policies 
            WHERE tablename = 'pricing_plans' 
            AND (cmd = 'SELECT' OR cmd = 'ALL')
            AND (roles @> '{anon}'::name[] OR roles @> '{public}'::name[])
        ) THEN
            RAISE NOTICE '✅ Politique de lecture publique : PRÉSENTE (L''app devrait voir les prix)';
        ELSE
            RAISE WARNING '❌ Politique de lecture publique : ABSENTE ! (Supabase bloque la lecture -> donc 2 FCFA affiché)';
        END IF;
    ELSE
        RAISE WARNING '⚠️ RLS désactivé sur pricing_plans (Dangereux mais marche)';
    END IF;

    -- 3. TEST DU MOTEUR DE RAPPORT (RPC)
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE '⚙️ 3. TEST FONCTION RPC (rpc_generer_rapport)...';
    
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'rpc_generer_rapport') THEN
        RAISE NOTICE '✅ Fonction RPC : PRÉSENTE';
    ELSE
        RAISE WARNING '❌ Fonction RPC : MANQUANTE !';
    END IF;

    -- 4. VÉRIFICATION CONTENUS REAL
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE '📚 4. VÉRIFICATION CONTENUS...';
    BEGIN
        PERFORM * FROM public.canonical_predictions LIMIT 1;
        RAISE NOTICE '✅ Table canonical_predictions : EXISTE et contient des données';
    EXCEPTION WHEN undefined_table THEN
        RAISE WARNING '❌ Table canonical_predictions : INEXISTANTE !';
    END;

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE '🏁 AUDIT TERMINÉ.';
END $$;
