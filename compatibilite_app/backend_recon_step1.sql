-- ============================================================
-- SCRIPT DE RECONNAISSANCE - ÉTAPE 1
-- But : Obtenir une vue d'ensemble de la structure actuelle
-- ============================================================

-- 1. Lister toutes les tables publiques (pour vérifier ce qui existe vraiment)
SELECT 
    table_name, 
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name) as colonnes_count,
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) as taille
FROM information_schema.tables t
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Lister les politiques de sécurité (RLS) actives
-- Cela nous dira si 'fix_rls_secure.sql' ou 'fix_rls_policies.sql' est actif
SELECT 
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

-- 3. Lister les extensions installées (ex: pgcrypto, etc)
SELECT extname, extversion FROM pg_extension;

-- 4. Lister les clés étrangères (pour comprendre les liens user -> auth)
SELECT
    tc.table_schema, 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_schema='public';

-- 5. Vérifier la configuration 'app_settings' (pour confirmer le fix précédent)
SELECT * FROM public.app_settings;
