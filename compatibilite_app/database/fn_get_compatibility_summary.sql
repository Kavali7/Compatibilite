-- Migration: Création de fn_get_compatibility_summary
-- Cette fonction récupère le résumé d'un rapport de compatibilité

CREATE OR REPLACE FUNCTION public.fn_get_compatibility_summary(
    p_couple_profile_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
    v_result jsonb;
    v_profile record;
    v_report record;
BEGIN
    -- 1. Récupérer les infos du profil couple
    SELECT 
        cp.id,
        cp.user_firstname,
        cp.partner_firstname,
        cp.user_birthdate,
        cp.partner_birthdate,
        cp.created_at
    INTO v_profile
    FROM couple_profiles cp
    WHERE cp.id = p_couple_profile_id;

    IF v_profile IS NULL THEN
        RETURN jsonb_build_object('error', 'Profil couple non trouvé');
    END IF;

    -- 2. Chercher un rapport généré pour ce profil
    SELECT 
        gr.numero_couple,
        gr.bloc0_titre,
        gr.bloc0_contenu_md,
        gr.bloc1_contenu,
        gr.bloc2_contenu,
        gr.bloc3_contenu,
        gr.contexte,
        gr.etat_rel,
        gr.created_at as report_date
    INTO v_report
    FROM generated_reports gr
    WHERE gr.couple_profile_id = p_couple_profile_id
    ORDER BY gr.created_at DESC
    LIMIT 1;

    -- 3. Construire le résultat
    IF v_report IS NOT NULL THEN
        v_result := jsonb_build_object(
            'user_firstname', v_profile.user_firstname,
            'partner_firstname', v_profile.partner_firstname,
            'profile_id', v_profile.id,
            'created_at', v_profile.created_at,
            'couple_number', v_report.numero_couple,
            'couple_vibration', COALESCE(v_report.bloc0_titre, 'Analyse de compatibilité'),
            'daily_advice', COALESCE(v_report.bloc0_contenu_md, ''),
            'interpretation', COALESCE(v_report.bloc1_contenu, ''),
            'dynamics', COALESCE(v_report.bloc2_contenu, ''),
            'advice', COALESCE(v_report.bloc3_contenu, ''),
            'etat_relationnel', v_report.etat_rel,
            'report_date', v_report.report_date,
            'contexte', v_report.contexte
        );
    ELSE
        -- Pas de rapport généré
        v_result := jsonb_build_object(
            'user_firstname', v_profile.user_firstname,
            'partner_firstname', v_profile.partner_firstname,
            'profile_id', v_profile.id,
            'created_at', v_profile.created_at,
            'couple_number', NULL,
            'couple_vibration', 'Rapport non disponible',
            'daily_advice', 'Le rapport complet n''a pas été généré pour ce profil.'
        );
    END IF;

    RETURN v_result;
END;
$$;

-- Accorder les permissions
GRANT EXECUTE ON FUNCTION public.fn_get_compatibility_summary(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_compatibility_summary(uuid) TO anon;

-- Commentaire
COMMENT ON FUNCTION public.fn_get_compatibility_summary IS 
'Récupère le résumé et les données d''un rapport de compatibilité pour un profil couple donné';
