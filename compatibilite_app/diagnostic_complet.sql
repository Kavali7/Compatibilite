-- ============================================================
-- SCRIPT DE DIAGNOSTIC COMPLET - Compatibilité App
-- Exécuter sur Supabase SQL Editor pour diagnostiquer les erreurs
-- ============================================================

-- 1. VÉRIFIER LES TABLES PRINCIPALES
SELECT '=== 1. TABLES EXISTANTES ===' as section;
SELECT table_name, 
       CASE WHEN table_name IS NOT NULL THEN '✅ Existe' ELSE '❌ Manquante' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'couple_profiles',
  'generated_reports',
  'pricing_plans',
  'purchases',
  'app_settings',
  'interpretations',
  'content_bricks',
  'canonical_predictions'
)
ORDER BY table_name;

-- 2. VÉRIFIER LE CONTENU DES TABLES CRITIQUES
SELECT '=== 2. CONTENU DES TABLES ===' as section;

-- Pricing plans
SELECT '--- pricing_plans ---' as table_name;
SELECT id, plan_type, name, price_fcfa, is_active, currency
FROM public.pricing_plans
ORDER BY display_order NULLS LAST, price_fcfa;

-- Interprétations (pour les rapports)
SELECT '--- interpretations (count) ---' as table_name;
SELECT COUNT(*) as total_interpretations FROM public.interpretations;

-- Content bricks (briques de contenu)
SELECT '--- content_bricks (count) ---' as table_name;
SELECT COUNT(*) as total_bricks FROM public.content_bricks;

-- Canonical predictions
SELECT '--- canonical_predictions (count) ---' as table_name;
SELECT COUNT(*) as total_predictions FROM public.canonical_predictions;

-- 3. VÉRIFIER RLS (Row Level Security)
SELECT '=== 3. RLS STATUS ===' as section;
SELECT tablename, 
       CASE WHEN rowsecurity THEN '🔒 RLS ON' ELSE '🔓 RLS OFF' END as rls_status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN (
  'couple_profiles',
  'generated_reports',
  'pricing_plans',
  'purchases',
  'interpretations',
  'content_bricks'
)
ORDER BY tablename;

-- 4. VÉRIFIER LES POLICIES RLS
SELECT '=== 4. RLS POLICIES ===' as section;
SELECT tablename, policyname, cmd, 
       CASE WHEN qual IS NOT NULL THEN '✅ Has USING' ELSE '❌ No USING' END as using_clause
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('couple_profiles', 'generated_reports', 'pricing_plans', 'interpretations')
ORDER BY tablename, policyname;

-- 5. VÉRIFIER LES FONCTIONS RPC
SELECT '=== 5. FONCTIONS RPC ===' as section;
SELECT routine_name,
       CASE WHEN routine_name IS NOT NULL THEN '✅ Existe' ELSE '❌ Manquante' END as status
FROM information_schema.routines 
WHERE routine_schema = 'public'
AND routine_type = 'FUNCTION'
AND routine_name LIKE 'rpc_%' OR routine_name LIKE 'fn_%'
ORDER BY routine_name;

-- 6. VÉRIFIER SI LES INTERPRÉTATIONS SONT CONFIGURÉES
SELECT '=== 6. VÉRIFICATION INTERPRÉTATIONS ===' as section;
SELECT 
  COALESCE(type_interpretation, 'NON DÉFINI') as type,
  COUNT(*) as count
FROM public.interpretations
GROUP BY type_interpretation
ORDER BY type_interpretation;

-- 7. VÉRIFIER LE COUPLE PROFILE LE PLUS RÉCENT
SELECT '=== 7. COUPLE PROFILES RÉCENTS ===' as section;
SELECT id, user_id, name_a, name_b, birth_a, birth_b, created_at
FROM public.couple_profiles
ORDER BY created_at DESC
LIMIT 5;

-- 8. VÉRIFIER LES RAPPORTS GÉNÉRÉS RÉCENTS
SELECT '=== 8. GENERATED REPORTS RÉCENTS ===' as section;
SELECT id, couple_profile_id, type_rapport, created_at, 
       CASE WHEN contenu IS NOT NULL THEN '✅ Has content' ELSE '❌ Empty' END as has_content
FROM public.generated_reports
ORDER BY created_at DESC
LIMIT 5;

-- 9. VÉRIFIER LES PURCHASES
SELECT '=== 9. PURCHASES ===' as section;
SELECT id, user_id, product_type, amount_fcfa, status, payment_provider, created_at
FROM public.purchases
ORDER BY created_at DESC
LIMIT 10;

-- 10. VÉRIFIER LES ERREURS POTENTIELLES
SELECT '=== 10. PROBLÈMES POTENTIELS ===' as section;

-- Plans actifs ?
SELECT 'Plans actifs' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ ' || COUNT(*) || ' plans actifs' 
            ELSE '❌ AUCUN plan actif!' END as result
FROM public.pricing_plans WHERE is_active = true;

-- Interprétations existantes ?
SELECT 'Interprétations' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ ' || COUNT(*) || ' interprétations' 
            ELSE '❌ AUCUNE interprétation!' END as result
FROM public.interpretations;

-- Content bricks existantes ?
SELECT 'Content bricks' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ ' || COUNT(*) || ' briques' 
            ELSE '❌ AUCUNE brique de contenu!' END as result
FROM public.content_bricks;

-- RPC rpc_generer_rapport existe ?
SELECT 'RPC rpc_generer_rapport' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ Fonction existe' 
            ELSE '❌ FONCTION MANQUANTE!' END as result
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name = 'rpc_generer_rapport';

-- 11. TEST DE LA POLICY SUR couple_profiles
SELECT '=== 11. TEST INSERTION couple_profiles ===' as section;
-- On ne peut pas tester l'insertion directement ici car on n'a pas d'auth context
-- Mais on vérifie si la policy permet SELECT pour anon
SELECT 'Policy SELECT sur couple_profiles' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ Policy SELECT existe' 
            ELSE '⚠️ Pas de policy SELECT (peut bloquer les lectures)' END as result
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'couple_profiles'
AND cmd = 'SELECT';

-- Policy INSERT
SELECT 'Policy INSERT sur couple_profiles' as check_name,
       CASE WHEN COUNT(*) > 0 THEN '✅ Policy INSERT existe' 
            ELSE '❌ POLICY INSERT MANQUANTE!' END as result
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'couple_profiles'
AND cmd = 'INSERT';

-- 12. RÉSUMÉ FINAL
SELECT '=== RÉSUMÉ FINAL ===' as section;
SELECT 'Total pricing_plans' as metric, COUNT(*)::text as value FROM public.pricing_plans
UNION ALL
SELECT 'Total interpretations', COUNT(*)::text FROM public.interpretations
UNION ALL
SELECT 'Total content_bricks', COUNT(*)::text FROM public.content_bricks
UNION ALL
SELECT 'Total couple_profiles', COUNT(*)::text FROM public.couple_profiles
UNION ALL
SELECT 'Total generated_reports', COUNT(*)::text FROM public.generated_reports
UNION ALL
SELECT 'Total purchases', COUNT(*)::text FROM public.purchases;
