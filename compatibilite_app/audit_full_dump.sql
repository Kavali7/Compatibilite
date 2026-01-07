-- ============================================================
-- AUDIT COMPLET DU BACKEND (FULL DUMP)
-- DATE: 2026-01-07
-- DESCRIPTION: Ce script aggrege tables, colonnes, politiques et fonctions
--              en une seule liste de résultats JSON.
-- INSTRUCTION: Exécutez tout, et copiez le résultat (ou faites une capture large).
-- ============================================================

WITH 
-- 1. Tables et leur taille
tables_info AS (
    SELECT 
        'TABLE' as category,
        table_name as name,
        jsonb_build_object(
            'size', pg_size_pretty(pg_total_relation_size(quote_ident(table_name))),
            'columns_count', (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name)
        ) as details
    FROM information_schema.tables t
    WHERE table_schema = 'public'
),

-- 2. Politiques de sécurité (RLS)
policies_info AS (
    SELECT 
        'POLICY' as category,
        tablename || '.' || policyname as name,
        jsonb_build_object(
            'roles', roles,
            'cmd', cmd,
            'permissive', permissive,
            'using', qual,
            'with_check', with_check
        ) as details
    FROM pg_policies
    WHERE schemaname = 'public'
),

-- 3. Fonctions et RPC
functions_info AS (
    SELECT 
        'FUNCTION' as category,
        routine_name as name,
        jsonb_build_object(
            'return_type', data_type,
            'security_type', external_language
        ) as details
    FROM information_schema.routines
    WHERE routine_schema = 'public'
      AND routine_type = 'FUNCTION'
),

-- 4. Extensions
extensions_info AS (
    SELECT 
        'EXTENSION' as category,
        extname as name,
        jsonb_build_object('version', extversion) as details
    FROM pg_extension
)

-- Aggregation finale
SELECT * FROM tables_info
UNION ALL
SELECT * FROM policies_info
UNION ALL
SELECT * FROM functions_info
UNION ALL
SELECT * FROM extensions_info
ORDER BY category, name;
