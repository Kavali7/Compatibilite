-- =====================================================
-- FIX DÉFINITIF POUR couple_profiles
-- Même approche que fn_insert_payment (SECURITY DEFINER)
-- =====================================================

-- 1. S'assurer que RLS est activé
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer TOUTES les anciennes policies pour repartir de zéro
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON public.couple_profiles;
DROP POLICY IF EXISTS "Service role full access on profiles" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_insert_own" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_update_own" ON public.couple_profiles;
DROP POLICY IF EXISTS "couple_profiles_select_own" ON public.couple_profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.couple_profiles;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON public.couple_profiles;
DROP POLICY IF EXISTS "Enable read access for users" ON public.couple_profiles;

-- 3. Créer des policies simples et permissives
CREATE POLICY "allow_insert_own_profile" ON public.couple_profiles
FOR INSERT TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "allow_update_own_profile" ON public.couple_profiles
FOR UPDATE TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "allow_select_own_profile" ON public.couple_profiles
FOR SELECT TO authenticated
USING (auth.uid() = user_id);

-- 4. Permettre au service_role d'avoir accès complet
CREATE POLICY "service_role_full_access" ON public.couple_profiles
FOR ALL TO service_role
USING (true)
WITH CHECK (true);

-- 5. BONUS: Créer une fonction SECURITY DEFINER comme backup
-- (Au cas où les policies ne suffisent pas)
CREATE OR REPLACE FUNCTION public.fn_upsert_couple_profile(
  p_user_id uuid,
  p_partner_a_name text,
  p_partner_a_birth date,
  p_partner_b_name text,
  p_partner_b_birth date,
  p_relation_status text DEFAULT NULL,
  p_challenges text[] DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_result jsonb;
  v_profile_id uuid;
BEGIN
  -- Upsert the profile
  INSERT INTO couple_profiles (
    user_id,
    partner_a_name,
    partner_a_birth,
    partner_b_name,
    partner_b_birth,
    relation_status,
    challenges,
    updated_at
  )
  VALUES (
    p_user_id,
    p_partner_a_name,
    p_partner_a_birth,
    p_partner_b_name,
    p_partner_b_birth,
    p_relation_status,
    p_challenges,
    NOW()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    partner_a_name = EXCLUDED.partner_a_name,
    partner_a_birth = EXCLUDED.partner_a_birth,
    partner_b_name = EXCLUDED.partner_b_name,
    partner_b_birth = EXCLUDED.partner_b_birth,
    relation_status = EXCLUDED.relation_status,
    challenges = EXCLUDED.challenges,
    updated_at = NOW()
  RETURNING id INTO v_profile_id;

  SELECT jsonb_build_object(
    'success', true,
    'profile_id', v_profile_id,
    'user_id', p_user_id
  ) INTO v_result;

  RETURN v_result;
END;
$$;

-- 6. Donner les permissions d'exécution
GRANT EXECUTE ON FUNCTION public.fn_upsert_couple_profile TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_upsert_couple_profile TO service_role;

-- Vérification: Lister les policies actives
SELECT schemaname, tablename, policyname, cmd, roles 
FROM pg_policies 
WHERE tablename = 'couple_profiles';
