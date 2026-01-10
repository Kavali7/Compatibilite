-- ============================================================
-- SCRIPT DE VÉRIFICATION - Compatibilité App
-- Exécuter sur Supabase pour vérifier l'intégrité du schéma
-- ============================================================

-- 1. Vérifier les tables existantes
SELECT 'TABLES' as check_type, table_name, 
       CASE WHEN table_name IS NOT NULL THEN '✅' ELSE '❌' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'pricing_plans', 
  'purchases', 
  'app_settings',
  'couple_profiles',
  'generated_reports',
  'payments'
)
ORDER BY table_name;

-- 2. Vérifier les colonnes de pricing_plans
SELECT 'PRICING_PLANS COLUMNS' as check_type, column_name, data_type,
       CASE WHEN column_name IS NOT NULL THEN '✅' ELSE '❌' END as status
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'pricing_plans'
ORDER BY ordinal_position;

-- 3. Vérifier les colonnes de purchases
SELECT 'PURCHASES COLUMNS' as check_type, column_name, data_type,
       CASE WHEN column_name IS NOT NULL THEN '✅' ELSE '❌' END as status
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'purchases'
ORDER BY ordinal_position;

-- 4. Vérifier RLS activé sur les tables
SELECT 'RLS STATUS' as check_type, tablename, 
       CASE WHEN rowsecurity THEN '✅ RLS ON' ELSE '❌ RLS OFF' END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('pricing_plans', 'purchases', 'app_settings', 'couple_profiles', 'generated_reports');

-- 5. Vérifier les politiques RLS
SELECT 'RLS POLICIES' as check_type, tablename, policyname, cmd as action
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- 6. Vérifier les fonctions
SELECT 'FUNCTIONS' as check_type, routine_name,
       CASE WHEN routine_name IS NOT NULL THEN '✅' ELSE '❌' END as status
FROM information_schema.routines 
WHERE routine_schema = 'public'
AND routine_type = 'FUNCTION'
AND routine_name IN (
  'fn_set_updated_at',
  'fn_has_purchased',
  'fn_record_purchase',
  'rpc_generer_rapport'
)
ORDER BY routine_name;

-- 7. Voir les plans de tarification actuels
SELECT 'PRICING PLANS DATA' as check_type, 
       plan_type, name, price_fcfa, currency, is_active, display_order
FROM public.pricing_plans
ORDER BY display_order;

-- 8. Vérifier app_settings
SELECT 'APP SETTINGS' as check_type, key, value
FROM public.app_settings;

-- 9. Compter les achats
SELECT 'PURCHASES COUNT' as check_type, 
       status, COUNT(*) as count
FROM public.purchases
GROUP BY status;

-- 10. Résumé final
SELECT '=== RÉSUMÉ ===' as info;
SELECT 'Tables pricing_plans: ' || COUNT(*) || ' plans' as info FROM public.pricing_plans;
SELECT 'Tables purchases: ' || COUNT(*) || ' achats' as info FROM public.purchases;
SELECT 'App settings: ' || COUNT(*) || ' configs' as info FROM public.app_settings;
