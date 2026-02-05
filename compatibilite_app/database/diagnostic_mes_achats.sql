-- ============================================
-- DIAGNOSTIC COMPLET : SYSTÈME "MES ACHATS"
-- ============================================

-- 1. Lister TOUTES les tables liées aux achats/paiements
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND (table_name LIKE '%purchase%' 
     OR table_name LIKE '%payment%' 
     OR table_name LIKE '%achat%'
     OR table_name LIKE '%order%'
     OR table_name LIKE '%subscription%')
ORDER BY table_name;

-- 2. Structure de la table principale des paiements
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;

-- 3. Voir les 10 derniers paiements (tous utilisateurs)
SELECT id, user_id, plan_type, amount, status, created_at
FROM payments
ORDER BY created_at DESC
LIMIT 10;

-- 4. Voir les achats d'un utilisateur spécifique (remplacer l'ID)
-- SELECT * FROM payments WHERE user_id = 'VOTRE_USER_ID' ORDER BY created_at DESC;

-- 5. Lister les fonctions RPC liées aux achats
SELECT routine_name 
FROM information_schema.routines
WHERE routine_schema = 'public'
AND (routine_name LIKE '%purchase%' 
     OR routine_name LIKE '%payment%'
     OR routine_name LIKE '%achat%'
     OR routine_name LIKE '%user_report%');

-- 6. Vérifier la table stored_reports
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'stored_reports'
ORDER BY ordinal_position;

-- 7. Voir les rapports stockés
SELECT id, user_id, report_type, created_at
FROM stored_reports
ORDER BY created_at DESC
LIMIT 10;

-- 8. Vérifier user_reports
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'user_reports'
ORDER BY ordinal_position;

-- 9. Compter les achats par type de service
SELECT plan_type, COUNT(*) as total, 
       SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed
FROM payments
GROUP BY plan_type
ORDER BY total DESC;

-- 10. VÉRIFIER LES FONCTIONS RPC POUR STORED_REPORTS
SELECT routine_name 
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN ('fn_store_report', 'fn_get_user_stored_reports', 'fn_get_stored_report');

-- 11. Vérifier si stored_reports a des données
SELECT COUNT(*) as total_stored_reports FROM stored_reports;
