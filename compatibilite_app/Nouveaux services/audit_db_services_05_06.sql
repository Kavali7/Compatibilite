-- =============================================
-- AUDIT DES TABLES EXISTANTES
-- Services 05 (Guide Horaire) & 06 (Éclairage Décision)
-- À exécuter dans Supabase SQL Editor
-- =============================================

-- 1. Structure de cycle_vie_daily_periods
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'cycle_vie_daily_periods'
ORDER BY ordinal_position;

-- 2. Contenu actuel des périodes
SELECT period_letter, weekday_number, period_name, keyword,
       LEFT(description, 80) as description_preview,
       LEFT(activities_favorables, 80) as fav_preview,
       LEFT(activities_eviter, 80) as eviter_preview
FROM cycle_vie_daily_periods
ORDER BY weekday_number NULLS FIRST, period_letter;

-- 3. Nombre de périodes
SELECT COUNT(*) as total,
       COUNT(DISTINCT period_letter) as distinct_letters,
       COUNT(DISTINCT weekday_number) as distinct_weekdays
FROM cycle_vie_daily_periods;

-- 4. Structure de cycle_vie_decision_types
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'cycle_vie_decision_types'
ORDER BY ordinal_position;

-- 5. Types de décision actuels
SELECT code, label, category, display_order, is_active,
       LEFT(description, 60) as desc_preview
FROM cycle_vie_decision_types
ORDER BY display_order;

-- 6. Structure de cycle_vie_decision_advice
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'cycle_vie_decision_advice'
ORDER BY ordinal_position;

-- 7. Nombre de conseils par type
SELECT dt.label, dt.code, COUNT(da.id) as nb_conseils,
       string_agg(DISTINCT da.cycle_type, ', ') as cycle_types,
       string_agg(DISTINCT da.period_number::text, ', ' ORDER BY da.period_number::text) as periods
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice da ON da.decision_type_id = dt.id
GROUP BY dt.label, dt.code
ORDER BY dt.label;

-- 8. Structure daily_guide_purchases
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'daily_guide_purchases'
ORDER BY ordinal_position;

-- 9. RLS policies
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE tablename IN ('cycle_vie_daily_periods', 'cycle_vie_decision_types',
                    'cycle_vie_decision_advice', 'daily_guide_purchases');

-- 10. FK constraints
SELECT tc.constraint_name, tc.table_name, kcu.column_name,
       ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_name IN ('cycle_vie_daily_periods', 'cycle_vie_decision_advice', 'daily_guide_purchases');
