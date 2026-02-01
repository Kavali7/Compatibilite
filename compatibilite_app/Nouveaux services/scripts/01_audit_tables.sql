-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT D'AUDIT DES TABLES SUPABASE
-- Projet : Compatibilité & Guidance - Cycles de Vie
-- Date : 2026-02-01
-- ═══════════════════════════════════════════════════════════════════════════

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 1 : LISTE COMPLÈTE DES TABLES
-- ═════════════════════════════════════════════════════════════════════════

-- Affiche toutes les tables du schéma public avec leur nombre de colonnes
SELECT 
    t.table_name,
    COUNT(c.column_name) as column_count,
    CASE 
        WHEN t.table_name LIKE 'cycle_vie%' THEN '🔄 CYCLES DE VIE'
        WHEN t.table_name LIKE 'decision%' THEN '🎯 DÉCISION (à reconstruire)'
        WHEN t.table_name LIKE 'user_%' THEN '👤 UTILISATEUR'
        WHEN t.table_name IN ('app_settings', 'pricing_plans', 'payments', 'purchases') THEN '⚙️ INFRASTRUCTURE'
        WHEN t.table_name LIKE 'couple%' OR t.table_name LIKE 'report%' THEN '💕 COMPATIBILITÉ'
        ELSE '📦 AUTRE'
    END as category
FROM information_schema.tables t
LEFT JOIN information_schema.columns c 
    ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE t.table_schema = 'public' 
    AND t.table_type = 'BASE TABLE'
GROUP BY t.table_name
ORDER BY category, t.table_name;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 2 : DÉTAIL DES TABLES CYCLES DE VIE
-- ═════════════════════════════════════════════════════════════════════════

-- Structure de cycle_vie_soul_periods
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'cycle_vie_soul_periods'
ORDER BY ordinal_position;

-- Structure de cycle_vie_daily_periods
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'cycle_vie_daily_periods'
ORDER BY ordinal_position;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 3 : TABLES DE DÉCISION (à reconstruire)
-- ═════════════════════════════════════════════════════════════════════════

-- Structure de cycle_vie_decision_types
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'cycle_vie_decision_types'
ORDER BY ordinal_position;

-- Structure de cycle_vie_decision_advice
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'cycle_vie_decision_advice'
ORDER BY ordinal_position;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 4 : VÉRIFICATION DU CONTENU EXISTANT
-- ═════════════════════════════════════════════════════════════════════════

-- Nombre d'enregistrements par table Cycles de Vie
SELECT 'cycle_vie_soul_periods' as table_name, COUNT(*) as row_count 
FROM cycle_vie_soul_periods
UNION ALL
SELECT 'cycle_vie_daily_periods', COUNT(*) FROM cycle_vie_daily_periods
UNION ALL
SELECT 'cycle_vie_decision_types', COUNT(*) FROM cycle_vie_decision_types
UNION ALL
SELECT 'cycle_vie_decision_advice', COUNT(*) FROM cycle_vie_decision_advice;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 5 : VÉRIFICATION DES PRIX EXISTANTS
-- ═════════════════════════════════════════════════════════════════════════

-- Plans tarifaires existants
SELECT 
    id,
    plan_type,
    name,
    price_fcfa,
    is_active
FROM pricing_plans
ORDER BY plan_type;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 6 : POLITIQUES RLS EXISTANTES
-- ═════════════════════════════════════════════════════════════════════════

-- Vérifie les politiques RLS sur les tables Cycles de Vie
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public' 
    AND (tablename LIKE 'cycle_vie%' OR tablename LIKE 'decision%')
ORDER BY tablename, policyname;
