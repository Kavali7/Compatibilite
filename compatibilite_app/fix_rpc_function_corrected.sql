-- =====================================================
-- FUNCTION CORRIGÉE avec les VRAIS noms de colonnes
-- Colonnes: user_firstname, user_birthdate, user_gender,
--           partner_firstname, partner_birthdate, partner_gender
-- =====================================================

-- Supprimer l'ancienne fonction incorrecte
DROP FUNCTION IF EXISTS public.fn_upsert_couple_profile;

-- Créer la fonction corrigée
CREATE OR REPLACE FUNCTION public.fn_upsert_couple_profile(
  p_user_id uuid,
  p_user_firstname text,
  p_user_birthdate date,
  p_user_gender text DEFAULT 'non_precise',
  p_partner_firstname text DEFAULT NULL,
  p_partner_birthdate date DEFAULT NULL,
  p_partner_gender text DEFAULT 'non_precise'
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile_id uuid;
BEGIN
  INSERT INTO couple_profiles (
    user_id,
    user_firstname,
    user_birthdate,
    user_gender,
    partner_firstname,
    partner_birthdate,
    partner_gender,
    updated_at
  )
  VALUES (
    p_user_id,
    p_user_firstname,
    p_user_birthdate,
    p_user_gender,
    p_partner_firstname,
    p_partner_birthdate,
    p_partner_gender,
    NOW()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    user_firstname = EXCLUDED.user_firstname,
    user_birthdate = EXCLUDED.user_birthdate,
    user_gender = EXCLUDED.user_gender,
    partner_firstname = EXCLUDED.partner_firstname,
    partner_birthdate = EXCLUDED.partner_birthdate,
    partner_gender = EXCLUDED.partner_gender,
    updated_at = NOW()
  RETURNING id INTO v_profile_id;

  RETURN jsonb_build_object(
    'success', true,
    'profile_id', v_profile_id,
    'user_id', p_user_id
  );
END;
$$;

-- Donner les permissions
GRANT EXECUTE ON FUNCTION public.fn_upsert_couple_profile TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_upsert_couple_profile TO service_role;

-- Test de la fonction (optionnel)
-- SELECT fn_upsert_couple_profile(
--   'ee3ebee7-bcbc-4480-90d5-8e690c643362'::uuid,
--   'TestUser', '1990-01-01'::date, 'homme',
--   'TestPartner', '1992-05-15'::date, 'femme'
-- );
