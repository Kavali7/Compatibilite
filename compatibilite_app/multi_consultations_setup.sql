-- =====================================================
-- MULTI-CONSULTATIONS: Modifier la structure de couple_profiles
-- Permet plusieurs consultations par utilisateur
-- À exécuter dans Supabase SQL Editor
-- =====================================================

-- 1. Supprimer la contrainte UNIQUE sur user_id (si elle existe)
-- Cela permet à un utilisateur d'avoir plusieurs profils couple
ALTER TABLE couple_profiles DROP CONSTRAINT IF EXISTS couple_profiles_user_id_key;

-- 2. Ajouter colonne payment_id pour lier chaque consultation à son paiement
ALTER TABLE couple_profiles ADD COLUMN IF NOT EXISTS payment_id uuid;

-- 3. Créer un index pour recherche rapide par user_id
CREATE INDEX IF NOT EXISTS idx_couple_profiles_user_id ON couple_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_couple_profiles_payment_id ON couple_profiles(payment_id);

-- 4. Nouvelle fonction pour CRÉER un profil (pas UPSERT)
-- Chaque paiement = nouveau profil
CREATE OR REPLACE FUNCTION public.fn_create_couple_profile(
  p_user_id uuid,
  p_user_firstname text,
  p_user_birthdate date,
  p_user_gender text DEFAULT 'non_precise',
  p_partner_firstname text DEFAULT NULL,
  p_partner_birthdate date DEFAULT NULL,
  p_partner_gender text DEFAULT 'non_precise',
  p_payment_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile_id uuid;
BEGIN
  -- Générer un nouvel UUID pour le profil
  v_profile_id := gen_random_uuid();
  
  INSERT INTO couple_profiles (
    id,
    user_id,
    user_firstname,
    user_birthdate,
    user_gender,
    partner_firstname,
    partner_birthdate,
    partner_gender,
    payment_id,
    created_at,
    updated_at
  )
  VALUES (
    v_profile_id,
    p_user_id,
    p_user_firstname,
    p_user_birthdate,
    p_user_gender::sexe_personne,
    p_partner_firstname,
    p_partner_birthdate,
    p_partner_gender::sexe_personne,
    p_payment_id,
    NOW(),
    NOW()
  );

  RETURN jsonb_build_object(
    'success', true,
    'profile_id', v_profile_id,
    'user_id', p_user_id,
    'payment_id', p_payment_id
  );
END;
$$;

-- 5. Donner les permissions
GRANT EXECUTE ON FUNCTION public.fn_create_couple_profile TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_create_couple_profile TO anon;
GRANT EXECUTE ON FUNCTION public.fn_create_couple_profile TO service_role;

-- 6. Modifier fn_get_couple_profile_id pour récupérer le profil lié à un payment_id
-- OU le plus récent si pas de payment_id spécifié
CREATE OR REPLACE FUNCTION public.fn_get_couple_profile_id(
  p_user_id uuid,
  p_payment_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile_id uuid;
BEGIN
  IF p_payment_id IS NOT NULL THEN
    -- Chercher par payment_id
    SELECT id INTO v_profile_id
    FROM couple_profiles
    WHERE payment_id = p_payment_id
    LIMIT 1;
  ELSE
    -- Chercher le plus récent pour cet utilisateur
    SELECT id INTO v_profile_id
    FROM couple_profiles
    WHERE user_id = p_user_id
    ORDER BY created_at DESC
    LIMIT 1;
  END IF;
  
  RETURN v_profile_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fn_get_couple_profile_id TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_couple_profile_id TO anon;

-- 7. Vérification
SELECT 'Multi-consultations setup complete!' AS status;
