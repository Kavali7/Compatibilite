-- =====================================================
-- NETTOYAGE DES POLICIES DUPLIQUÉES
-- Supprimer toutes les policies conflictuelles
-- =====================================================

-- Supprimer les policies ciblant {public} (erreur de configuration)
DROP POLICY IF EXISTS "Users can update own profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can update their own couple profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can view their own couple profile" ON public.couple_profiles;

-- Supprimer les doublons "strict" 
DROP POLICY IF EXISTS "couple_profiles_delete_strict" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_select_strict" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_update_strict" ON public.couple_profiles;

-- Supprimer les autres doublons
DROP POLICY IF EXISTS "authenticated_insert_own_profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_delete_own" ON public.couple_profiles;

-- Garder seulement :
-- - allow_insert_own_profile
-- - allow_select_own_profile  
-- - allow_update_own_profile
-- - service_role_full_access

-- Vérifier le résultat
SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'couple_profiles';
