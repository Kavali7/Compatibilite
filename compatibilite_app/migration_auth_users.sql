-- ===========================================
-- MIGRATION COMPLÈTE: Passage à Supabase Auth
-- ===========================================
-- Exécuter TOUT ce script dans Supabase Dashboard > SQL Editor

-- ============================================
-- ÉTAPE 0: Nettoyer les données existantes
-- ============================================
TRUNCATE TABLE payments CASCADE;
TRUNCATE TABLE subscriptions CASCADE;
TRUNCATE TABLE user_reports CASCADE;

-- ============================================
-- ÉTAPE 1: Supprimer les anciennes contraintes
-- ============================================
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_user_id_fkey;
ALTER TABLE subscriptions DROP CONSTRAINT IF EXISTS subscriptions_user_id_fkey;
ALTER TABLE user_reports DROP CONSTRAINT IF EXISTS user_reports_user_id_fkey;
ALTER TABLE couple_profiles DROP CONSTRAINT IF EXISTS couple_profiles_user_id_fkey;

-- ============================================
-- ÉTAPE 2: Recréer les contraintes vers auth.users
-- ============================================
ALTER TABLE payments 
ADD CONSTRAINT payments_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE subscriptions 
ADD CONSTRAINT subscriptions_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE user_reports 
ADD CONSTRAINT user_reports_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Couple_profiles (si existe)
DO $$
BEGIN
  IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'couple_profiles') THEN
    ALTER TABLE couple_profiles 
    ADD CONSTRAINT couple_profiles_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- ============================================
-- ÉTAPE 3: Confirmer le succès
-- ============================================
SELECT 'Migration terminée avec succès!' AS status;
