-- ============================================================
-- RPC : Générer le Profil Complet (Calculs + Textes) - V2
-- Inclut Intime, Réalisation, Hérédité, Kabbale.
-- ============================================================

CREATE OR REPLACE FUNCTION public.rpc_generer_profil_complet(p_couple_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_couple record;
  
  -- Partner A
  v_nom_a text;
  v_lp_a integer;
  v_name_a integer;
  v_intime_a integer;
  v_real_a integer; -- Personality
  v_kabbale_a integer;
  
  -- Partner B
  v_nom_b text;
  v_lp_b integer;
  v_name_b integer;
  v_intime_b integer;
  v_real_b integer;
  v_kabbale_b integer;
  
  -- Couple
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

  v_nom_a := v_couple.partner_a_first_name || ' ' || v_couple.partner_a_last_name;
  v_nom_b := v_couple.partner_b_first_name || ' ' || v_couple.partner_b_last_name;

  -- 2. Calculs A
  v_lp_a     := public.fn_nombre_personne(v_couple.partner_a_birth_date);
  v_name_a   := public.fn_calcul_nom(v_nom_a);
  v_intime_a := public.fn_calcul_intime(v_nom_a);
  v_real_a   := public.fn_calcul_realisation(v_nom_a);
  v_kabbale_a:= public.fn_calcul_kabbale(v_nom_a);
  
  -- Calculs B
  v_lp_b     := public.fn_nombre_personne(v_couple.partner_b_birth_date);
  v_name_b   := public.fn_calcul_nom(v_nom_b);
  v_intime_b := public.fn_calcul_intime(v_nom_b);
  v_real_b   := public.fn_calcul_realisation(v_nom_b);
  v_kabbale_b:= public.fn_calcul_kabbale(v_nom_b);

  -- Couple
  v_couple_num := public.fn_reduire_maitre(v_lp_a + v_lp_b);

  -- 3. Récupération des Textes
  -- Note: Intime/Realisation utilisent les textes 'base' dans l'app Dart.
  -- Kabbale a ses propres textes 'kabbalah'.
  SELECT jsonb_object_agg(key_id, data) INTO v_texts
  FROM (
    -- Partner A
    SELECT 'pA_base' as key_id, to_jsonb(t) as data FROM public.numerology_texts t WHERE type = 'base' AND number = v_lp_a AND locale = 'fr'
    UNION ALL
    SELECT 'pA_name', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'name' AND number = v_name_a AND locale = 'fr'
    UNION ALL
    SELECT 'pA_intime', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'base' AND number = v_intime_a AND locale = 'fr' -- Reutilise Base
    UNION ALL
    SELECT 'pA_real', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'base' AND number = v_real_a AND locale = 'fr' -- Reutilise Base
    UNION ALL
    SELECT 'pA_kab', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'kabbalah' AND number = v_kabbale_a AND locale = 'fr'
    
    UNION ALL
    
    -- Partner B
    SELECT 'pB_base', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'base' AND number = v_lp_b AND locale = 'fr'
    UNION ALL
    SELECT 'pB_name', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'name' AND number = v_name_b AND locale = 'fr'
    UNION ALL
    SELECT 'pB_intime', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'base' AND number = v_intime_b AND locale = 'fr'
    UNION ALL
    SELECT 'pB_real', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'base' AND number = v_real_b AND locale = 'fr'
    UNION ALL
    SELECT 'pB_kab', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'kabbalah' AND number = v_kabbale_b AND locale = 'fr'

    UNION ALL
    
    -- Couple
    SELECT 'couple', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'couple' AND number = v_couple_num AND locale = 'fr'
    UNION ALL
    SELECT 'couple_deep', to_jsonb(t) FROM public.numerology_texts t WHERE type = 'couple_deep' AND number = v_couple_num AND locale = 'fr'
  ) t;

  -- 4. Construction JSON
  RETURN jsonb_build_object(
    'partner_a', jsonb_build_object(
      'life_path', v_lp_a,
      'name_number', v_name_a,
      'intimate_number', v_intime_a,
      'personality_number', v_real_a,
      'kabbalah_number', v_kabbale_a,
      'heredity_number', 0, -- TODO: Heredity calc if needed (last name only)
      
      'base_text', v_texts->'pA_base',
      'name_text', v_texts->'pA_name',
      'intimate_text', v_texts->'pA_intime',
      'personality_text', v_texts->'pA_real',
      'kabbalah_text', v_texts->'pA_kab'
    ),
    'partner_b', jsonb_build_object(
      'life_path', v_lp_b,
      'name_number', v_name_b,
      'intimate_number', v_intime_b,
      'personality_number', v_real_b,
      'kabbalah_number', v_kabbale_b,
      'heredity_number', 0,
      
      'base_text', v_texts->'pB_base',
      'name_text', v_texts->'pB_name',
      'intimate_text', v_texts->'pB_intime',
      'personality_text', v_texts->'pB_real',
      'kabbalah_text', v_texts->'pB_kab'
    ),
    'couple', jsonb_build_object(
      'number', v_couple_num,
      'text', v_texts->'couple',
      'deep_text', v_texts->'couple_deep'
    )
  );
END;
$$;
