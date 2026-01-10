-- ==========================================================
-- SCRIPT DE CORRECTION DES PERMISSIONS (RLS)
-- Table: public.couple_profiles
-- ==========================================================

-- 1. Activer la sécurité RLS sur la table (au cas où ce n'est pas fait)
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;

-- 2. Nettoyer les anciennes politiques (pour éviter les conflits)
DROP POLICY IF EXISTS "Users can view their own couple profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can insert their own couple profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can update their own couple profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can delete their own couple profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON public.couple_profiles;

-- 3. Créer une politique "SELECT" (Lecture)
CREATE POLICY "Users can view their own couple profile"
ON public.couple_profiles
FOR SELECT
USING (auth.uid() = user_id);

-- 4. Créer une politique "INSERT" (Création)
CREATE POLICY "Users can insert their own couple profile"
ON public.couple_profiles
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 5. Créer une politique "UPDATE" (Modification)
CREATE POLICY "Users can update their own couple profile"
ON public.couple_profiles
FOR UPDATE
USING (auth.uid() = user_id);

-- 6. Créer une politique "DELETE" (Suppression)
CREATE POLICY "Users can delete their own couple profile"
ON public.couple_profiles
FOR DELETE
USING (auth.uid() = user_id);

-- ==========================================================
-- VERIFICATION (Optionnel)
-- ==========================================================
-- Vérifie que les politiques sont bien appliquées
SELECT * FROM pg_policies WHERE tablename = 'couple_profiles';
