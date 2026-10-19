-- ============================================================
-- REQUÊTES DE DÉCOUVERTE DU BACKEND — Kbal Compatibilité
-- ============================================================
-- Exécuter ces requêtes une par une dans le Supabase SQL Editor.
-- Copier/coller chaque résultat et l'envoyer pour la rédaction
-- du fichier Reference-Backend.md.
-- ============================================================


-- ============================================================
-- 1. INVENTAIRE DES TABLES
-- ============================================================
SELECT table_name, 
       (SELECT count(*) FROM information_schema.columns c 
        WHERE c.table_name = t.table_name AND c.table_schema = 'public') as nb_colonnes
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;


-- ============================================================
-- 2. STRUCTURE DÉTAILLÉE DE CHAQUE TABLE
-- (Colonnes, types, nullabilité, valeurs par défaut)
-- ============================================================
SELECT 
    t.table_name,
    c.column_name,
    c.data_type,
    c.udt_name,
    c.is_nullable,
    c.column_default,
    c.character_maximum_length
FROM information_schema.tables t
JOIN information_schema.columns c 
    ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE t.table_schema = 'public' 
  AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name, c.ordinal_position;


-- ============================================================
-- 3. CONTRAINTES (Primary Keys, Foreign Keys, Unique, Check)
-- ============================================================
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name AND tc.table_schema = ccu.table_schema
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;


-- ============================================================
-- 4. INDEX
-- ============================================================
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;


-- ============================================================
-- 5a. POLITIQUES RLS (Row Level Security)
-- ============================================================
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;


-- ============================================================
-- 5b. TABLES AVEC RLS ACTIVÉ
-- ============================================================
SELECT 
    relname as table_name,
    relrowsecurity as rls_enabled,
    relforcerowsecurity as rls_forced
FROM pg_class
WHERE relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
  AND relkind = 'r'
ORDER BY relname;


-- ============================================================
-- 6. FONCTIONS RPC (Noms + Signatures)
-- ============================================================
SELECT 
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type,
    p.prosecdef AS is_security_definer,
    l.lanname AS language
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
JOIN pg_language l ON p.prolang = l.oid
WHERE n.nspname = 'public'
  AND l.lanname IN ('sql', 'plpgsql')
ORDER BY p.proname;


-- ============================================================
-- 7. CORPS DES FONCTIONS RPC (Définitions complètes)
-- ============================================================
SELECT 
    p.proname AS function_name,
    pg_get_functiondef(p.oid) AS full_definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
JOIN pg_language l ON p.prolang = l.oid
WHERE n.nspname = 'public'
  AND l.lanname IN ('sql', 'plpgsql')
ORDER BY p.proname;


-- ============================================================
-- 8. TRIGGERS
-- ============================================================
SELECT 
    event_object_table AS table_name,
    trigger_name,
    event_manipulation AS event,
    action_timing AS timing,
    action_statement AS action
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;


-- ============================================================
-- 9. ENUMS PERSONNALISÉS
-- ============================================================
SELECT 
    t.typname AS enum_name,
    array_agg(e.enumlabel ORDER BY e.enumsortorder) AS values
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_namespace n ON t.typnamespace = n.oid
WHERE n.nspname = 'public'
GROUP BY t.typname
ORDER BY t.typname;


-- ============================================================
-- 10. VUES (Views)
-- ============================================================
SELECT 
    table_name AS view_name,
    view_definition
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;


-- ============================================================
-- 11. CONFIGURATION APPLICATIVE (app_settings)
-- ============================================================
SELECT key, value, updated_at
FROM app_settings
ORDER BY key;


-- ============================================================
-- 12. TARIFICATION (pricing_plans)
-- ============================================================
SELECT *
FROM pricing_plans
ORDER BY plan_type;


-- ============================================================
-- 13. CATALOGUE DE SERVICES (service_catalog)
-- ============================================================
SELECT *
FROM service_catalog
ORDER BY display_order;


-- ============================================================
-- 14. ÉTAT DES UTILISATEURS
-- ============================================================
SELECT 
    (SELECT count(*) FROM auth.users) AS auth_users_count,
    (SELECT count(*) FROM public.users) AS public_users_count;

-- Derniers utilisateurs inscrits
SELECT id, email, created_at 
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 20;


-- ============================================================
-- 15. ÉTAT DES PAIEMENTS
-- ============================================================
SELECT plan_type, status, payment_method, COUNT(*), SUM(amount_fcfa) as total
FROM payments
GROUP BY plan_type, status, payment_method
ORDER BY count DESC;

-- Derniers paiements
SELECT id, user_id, plan_type, amount_fcfa, status, payment_method, transaction_id, created_at
FROM payments
ORDER BY created_at DESC
LIMIT 20;


-- ============================================================
-- 16. RAPPORTS STOCKÉS (stored_reports)
-- ============================================================
SELECT service_type, COUNT(*) as total
FROM stored_reports
GROUP BY service_type
ORDER BY total DESC;


-- ============================================================
-- 17. RELATIONS ENTRE TABLES (Foreign Keys détaillées)
-- ============================================================
SELECT
    tc.table_name AS source_table,
    kcu.column_name AS source_column,
    ccu.table_name AS target_table,
    ccu.column_name AS target_column,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;


-- ============================================================
-- 18. VOLUMÉTRIE DES TABLES
-- ============================================================
SELECT 
    relname AS table_name,
    n_live_tup AS row_count
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_live_tup DESC;


-- ============================================================
-- 19. GRANTS & PERMISSIONS
-- ============================================================
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND grantee IN ('anon', 'authenticated', 'service_role')
ORDER BY table_name, grantee, privilege_type;


-- ============================================================
-- 20. PAGES LÉGALES
-- ============================================================
SELECT id, slug, title, is_active, updated_at
FROM legal_pages
ORDER BY slug;
