-- ============================================================
-- CORRECTION: Recréer fn_choisir_brique avec integer au lieu de smallint
-- Et sans filtre strict sur ton_redaction
-- ============================================================

DROP FUNCTION IF EXISTS public.fn_choisir_brique(uuid, smallint, periode_contenu, text, numero_vibration, ton_redaction, etat_relationnel, statut_utilisateur, date, text, text, smallint);

CREATE OR REPLACE FUNCTION public.fn_choisir_brique(
  p_user_id uuid,
  p_bloc integer,  -- Changed from smallint to integer
  p_periode public.periode_contenu,
  p_type_brique text,
  p_numero public.numero_vibration,
  p_ton text,  -- Changed from ton_redaction to text for flexibility
  p_etat public.etat_relationnel,
  p_statut public.statut_utilisateur,
  p_date date,
  p_seed text,
  p_langue text default 'fr',
  p_version integer default 1  -- Changed from smallint to integer
)
RETURNS TABLE (id uuid, modele_texte text)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  v_seed_num int;
BEGIN
  v_seed_num := abs(hashtext(p_seed || '|' || p_bloc::text || '|' || p_type_brique || '|' || p_numero::text)) % 1000001;

  RETURN QUERY
  WITH candidates AS (
    SELECT cb.id, cb.modele_texte, cb.cle_choix
    FROM public.content_bricks cb
    LEFT JOIN public.brick_usage bu
      ON bu.user_id = p_user_id AND bu.brick_id = cb.id
    WHERE cb.actif = true
      AND cb.bloc = p_bloc
      AND cb.periode IN (p_periode, 'toutes')
      AND cb.type_brique = p_type_brique
      AND cb.numero_cible = p_numero
      -- Ton filter removed for flexibility (any active brick matches)
      AND cb.etat_relationnel IN ('indifferent', p_etat)
      AND cb.statut_utilisateur IN ('indifferent', p_statut)
      AND cb.langue = p_langue
      AND cb.version = p_version
      AND (
        bu.dernier_usage IS NULL
        OR bu.dernier_usage <= (p_date - cb.jours_refroidissement)
      )
  ),
  pick AS (
    (SELECT c.id, c.modele_texte FROM candidates c WHERE c.cle_choix >= v_seed_num ORDER BY c.cle_choix ASC LIMIT 1)
    UNION ALL
    (SELECT c.id, c.modele_texte FROM candidates c WHERE c.cle_choix < v_seed_num ORDER BY c.cle_choix ASC LIMIT 1)
    LIMIT 1
  )
  SELECT p.id, p.modele_texte FROM pick p;
END;
$$;

-- Vérifier la nouvelle signature
SELECT p.proname, pg_get_function_arguments(p.oid) as arguments
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' AND p.proname = 'fn_choisir_brique';

SELECT '✅ fn_choisir_brique recréée avec types flexibles' as status;
