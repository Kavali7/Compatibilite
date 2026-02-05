-- ============================================================
-- DIAGNOSTIC: État du système "Mes Achats"
-- À exécuter dans Supabase SQL Editor
-- Date: 05 Février 2026
-- ============================================================

-- ============================================================
-- PARTIE 1: Vérification de l'existence des tables
-- ============================================================

SELECT '=== PARTIE 1: TABLES EXISTANTES ===' AS section;

SELECT 
  table_name,
  CASE WHEN table_name IS NOT NULL THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END AS status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN (
    'stored_reports',
    'payments',
    'couple_profiles',
    'personal_cycle_subscriptions',
    'business_cycle_subscriptions',
    'health_cycle_subscriptions',
    'lunar_subscriptions',
    'user_decision_credits',
    'purchases'
  )
ORDER BY table_name;

-- ============================================================
-- PARTIE 2: Structure de la table stored_reports (si existe)
-- ============================================================

SELECT '=== PARTIE 2: STRUCTURE STORED_REPORTS ===' AS section;

SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'stored_reports'
ORDER BY ordinal_position;

-- ============================================================
-- PARTIE 3: Contenu de stored_reports
-- ============================================================

SELECT '=== PARTIE 3: CONTENU STORED_REPORTS ===' AS section;

SELECT 
  COUNT(*) AS total_reports,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(DISTINCT service_type) AS service_types
FROM stored_reports;

-- Détail par type de service
SELECT 
  service_type,
  COUNT(*) AS count,
  MIN(created_at) AS oldest,
  MAX(created_at) AS newest
FROM stored_reports
GROUP BY service_type
ORDER BY count DESC;

-- ============================================================
-- PARTIE 4: Vérification des fonctions RPC
-- ============================================================

SELECT '=== PARTIE 4: FONCTIONS RPC ===' AS section;

SELECT 
  routine_name AS function_name,
  '✅ EXISTE' AS status
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_type = 'FUNCTION'
  AND routine_name IN (
    'fn_store_report',
    'fn_get_user_stored_reports',
    'fn_get_stored_report',
    'fn_record_purchase',
    'fn_insert_payment'
  )
ORDER BY routine_name;

-- ============================================================
-- PARTIE 5: État des tables de subscriptions
-- ============================================================

SELECT '=== PARTIE 5: SUBSCRIPTIONS EXISTANTES ===' AS section;

-- Personal Cycle
SELECT 
  'personal_cycle_subscriptions' AS table_name,
  COUNT(*) AS total,
  COUNT(CASE WHEN status = 'active' THEN 1 END) AS active
FROM personal_cycle_subscriptions;

-- Business Cycle (si existe)
SELECT 
  'business_cycle_subscriptions' AS table_name,
  COUNT(*) AS total
FROM business_cycle_subscriptions;

-- Health Cycle (si existe)
SELECT 
  'health_cycle_subscriptions' AS table_name,
  COUNT(*) AS total
FROM health_cycle_subscriptions;

-- Lunar (si existe)
SELECT 
  'lunar_subscriptions' AS table_name,
  COUNT(*) AS total
FROM lunar_subscriptions;

-- ============================================================
-- PARTIE 6: État de la table payments
-- ============================================================

SELECT '=== PARTIE 6: PAYMENTS ===' AS section;

SELECT 
  COUNT(*) AS total_payments,
  COUNT(CASE WHEN status = 'success' THEN 1 END) AS successful,
  COUNT(DISTINCT user_id) AS unique_users
FROM payments;

-- Distribution par plan_type
SELECT 
  plan_type,
  COUNT(*) AS count,
  SUM(amount) AS total_amount
FROM payments
WHERE status = 'success'
GROUP BY plan_type
ORDER BY count DESC;

-- Derniers paiements (10)
SELECT 
  id,
  user_id,
  plan_type,
  amount,
  status,
  created_at
FROM payments
ORDER BY created_at DESC
LIMIT 10;

-- ============================================================
-- PARTIE 7: État de couple_profiles (legacy)
-- ============================================================

SELECT '=== PARTIE 7: COUPLE_PROFILES (LEGACY) ===' AS section;

SELECT 
  COUNT(*) AS total_profiles,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(payment_id) AS with_payment
FROM couple_profiles;

-- ============================================================
-- PARTIE 8: Crédits de décision
-- ============================================================

SELECT '=== PARTIE 8: USER_DECISION_CREDITS ===' AS section;

SELECT 
  COUNT(*) AS total_users,
  SUM(balance) AS total_credits
FROM user_decision_credits
WHERE balance > 0;

-- ============================================================
-- PARTIE 9: Résumé et recommandations
-- ============================================================

SELECT '=== RÉSUMÉ ===' AS section;

SELECT 
  'stored_reports' AS table_name,
  (SELECT COUNT(*) FROM stored_reports) AS row_count,
  CASE WHEN (SELECT COUNT(*) FROM stored_reports) = 0 
       THEN '⚠️ VIDE - Intégration requise'
       ELSE '✅ Contient des données'
  END AS recommendation;

