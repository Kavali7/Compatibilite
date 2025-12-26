-- ============================================================
-- SCRIPT DE CORRECTION : Foreign Key couple_profiles
-- Le problème: couple_profiles.user_id références auth.users(id)
-- Mais l'app utilise une table 'users' personnalisée
-- Solution: Supprimer la contrainte FK et garder juste le user_id comme texte/uuid
-- ============================================================

-- 1) Vérifier les contraintes actuelles
SELECT 
  tc.constraint_name, 
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name = 'couple_profiles';

-- 2) Supprimer la contrainte FK vers auth.users
-- Note: le nom exact de la contrainte peut varier
ALTER TABLE public.couple_profiles 
DROP CONSTRAINT IF EXISTS couple_profiles_user_id_fkey;

-- 3) Si le nom est différent, essayer ces alternatives
DO $$ 
DECLARE
  constraint_name_var text;
BEGIN
  -- Trouver le nom réel de la contrainte
  SELECT tc.constraint_name INTO constraint_name_var
  FROM information_schema.table_constraints AS tc 
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'couple_profiles'
  AND kcu.column_name = 'user_id'
  LIMIT 1;
  
  IF constraint_name_var IS NOT NULL THEN
    EXECUTE 'ALTER TABLE public.couple_profiles DROP CONSTRAINT ' || constraint_name_var;
    RAISE NOTICE 'Dropped constraint: %', constraint_name_var;
  ELSE
    RAISE NOTICE 'No foreign key constraint found on couple_profiles.user_id';
  END IF;
END $$;

-- 4) Vérifier que la contrainte a été supprimée
SELECT 
  tc.constraint_name, 
  tc.table_name, 
  kcu.column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name = 'couple_profiles';

-- 5) Faire de même pour brick_usage et generated_reports si nécessaire
ALTER TABLE public.brick_usage 
DROP CONSTRAINT IF EXISTS brick_usage_user_id_fkey;

ALTER TABLE public.generated_reports 
DROP CONSTRAINT IF EXISTS generated_reports_user_id_fkey;
