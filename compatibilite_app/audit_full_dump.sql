-- ============================================================
-- AUDIT COMPLET DU SCHÉMA SUPABASE
-- Ce script liste TOUT ce qui existe dans la base de données
-- Permet de vérifier l'existant avant de restaurer quoi que ce soit
-- ============================================================

-- 1. LISTE DE TOUTES LES TABLES
SELECT '=== 1. TOUTES LES TABLES ===' as section;
SELECT 
    table_name,
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name) as nb_colonnes,
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) as taille_totale
FROM information_schema.tables t
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. DÉTAILS DES COLONNES POUR CHAQUE TABLE
SELECT '=== 2. STRUCTURE DES TABLES ===' as section;
SELECT 
    table_name, 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. LISTE DES VUES (VIEWS)
SELECT '=== 3. VUES ===' as section;
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public';

-- 4. LISTE DES FONCTIONS (ROUTINES)
SELECT '=== 4. FONCTIONS ET RPC ===' as section;
SELECT 
    routine_name, 
    data_type as return_type,
    external_language
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_type = 'FUNCTION'
ORDER BY routine_name;

-- 5. LISTE DES ENUMS (TYPES PERSONNALISÉS)
SELECT '=== 5. TYPES ENUM ===' as section;
SELECT 
    t.typname as enum_name,
    e.enumlabel as enum_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid  
JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'public'
ORDER BY t.typname, e.enumsortorder;
