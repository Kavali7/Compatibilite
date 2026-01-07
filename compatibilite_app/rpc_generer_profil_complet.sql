-- ============================================================
-- RPC : Générer le Profil Complet (Calculs + Textes)
-- Remplace la logique Dart 'NumerologyService'.
-- ============================================================

CREATE OR REPLACE FUNCTION public.rpc_generer_profil_complet(p_couple_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER -- Nécessaire pour lire couple_profiles/users si RLS restrictif
AS $$
DECLARE
  v_couple record;
  
  -- Partner A Datas
  v_lp_a integer; -- Life Path
  v_name_a integer; -- Expression / Name Number
  
  -- Partner B Datas
  v_lp_b integer;
  v_name_b integer;
  
  -- Couple Datas
  v_couple_num integer;
  
  -- Textes
  v_texts jsonb;
BEGIN
  -- 1. Récupérer les infos du couple
  SELECT * INTO v_couple 
  FROM public.couple_profiles 
  WHERE id = p_couple_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('error', 'Couple introuvable');
  END IF;

  -- 2. Calculs (Utilise nos fonctions SQL)
  v_lp_a   := public.fn_nombre_personne(v_couple.partner_a_birth_date);
  v_name_a := public.fn_calcul_nom(v_couple.partner_a_first_name || ' ' || v_couple.partner_a_last_name); -- Nom complet ? Ou juste Prénom ? Dart utilise "Name" input field.
  -- Dart: nameNumber(input.name). Input name is usually first name in the form? 
  -- Let's assume input names are what we use.
  
  v_lp_b   := public.fn_nombre_personne(v_couple.partner_b_birth_date);
  v_name_b := public.fn_calcul_nom(v_couple.partner_b_first_name || ' ' || v_couple.partner_b_last_name);

  -- Couple Number (Somme des Life Paths, réduit)
  v_couple_num := public.fn_reduire_maitre(v_lp_a + v_lp_b);

  -- 3. Récupération des Textes
  -- On optimise en une seule requête aggrégée
  SELECT jsonb_object_agg(key_id, data) INTO v_texts
  FROM (
    -- Partner A Base (Life Path)
    SELECT 'pA_base' as key_id, jsonb_build_object('title', title, 'body', body) as data
    FROM public.numerology_texts 
    WHERE type = 'base' AND number = v_lp_a AND locale = 'fr'
    UNION ALL
    -- Partner A Name
    SELECT 'pA_name', jsonb_build_object('title', title, 'body', body)
    FROM public.numerology_texts 
    WHERE type = 'name' AND number = v_name_a AND locale = 'fr'
    UNION ALL
    -- Partner B Base
    SELECT 'pB_base', jsonb_build_object('title', title, 'body', body)
    FROM public.numerology_texts 
    WHERE type = 'base' AND number = v_lp_b AND locale = 'fr'
    UNION ALL
    -- Partner B Name
    SELECT 'pB_name', jsonb_build_object('title', title, 'body', body)
    FROM public.numerology_texts 
    WHERE type = 'name' AND number = v_name_b AND locale = 'fr'
    UNION ALL
    -- Couple
    SELECT 'couple', jsonb_build_object('title', title, 'body', body)
    FROM public.numerology_texts 
    WHERE type = 'couple' AND number = v_couple_num AND locale = 'fr'
    UNION ALL
    -- Couple Deep
    SELECT 'couple_deep', jsonb_build_object('title', title, 'body', body)
    FROM public.numerology_texts 
    WHERE type = 'couple_deep' AND number = v_couple_num AND locale = 'fr'
  ) t;

  -- 4. Construction du JSON final
  -- Structure alignée avec ce que Dart attendrait (ou on adapte Dart)
  RETURN jsonb_build_object(
    'partner_a', jsonb_build_object(
      'life_path', v_lp_a,
      'name_number', v_name_a,
      'base_text', v_texts->'pA_base',
      'name_text', v_texts->'pA_name'
    ),
    'partner_b', jsonb_build_object(
      'life_path', v_lp_b,
      'name_number', v_name_b,
      'base_text', v_texts->'pB_base',
      'name_text', v_texts->'pB_name'
    ),
    'couple', jsonb_build_object(
      'number', v_couple_num,
      'text', v_texts->'couple',
      'deep_text', v_texts->'couple_deep'
    )
  );
END;
$$;
