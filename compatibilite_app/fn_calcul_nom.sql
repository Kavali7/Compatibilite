-- ============================================================
-- FONCTION : Calcul de la valeur numérologique d'un nom
-- Port du code Dart NumerologyService._letterValues & logic
-- A=1, B=2, ... I=9, J=1 ...
-- Gère la normalisation (accents) et la réduction.
-- ============================================================

CREATE OR REPLACE FUNCTION public.fn_calcul_nom(p_nom text)
RETURNS integer
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  v_cleaned text;
  v_sum integer := 0;
  v_char char;
  v_val integer;
  i integer;
BEGIN
  -- 1. Normalisation (Upper + Accents)
  -- Note: unaccent() nécessite l'extension 'unaccent', on fait simple avec translate
  v_cleaned := upper(translate(p_nom, 
    'àáâäãåæçéèêëíìîïñóòôöõúùûüýÿœ', 
    'AAAAAAACEEEEIIIINOOOOOUUUUYYOE'
  ));
  
  -- Garder A-Z uniquement
  v_cleaned := regexp_replace(v_cleaned, '[^A-Z]', '', 'g');

  IF length(v_cleaned) = 0 THEN
    RETURN 0;
  END IF;

  -- 2. Somme des lettres
  FOR i IN 1..length(v_cleaned) LOOP
    v_char := substring(v_cleaned from i for 1);
    
    -- Table de correspondance (A=1 ... I=9, J=1 ... R=9, S=1 ...)
    -- ASCII 'A' = 65. Valeur = (ASCII - 64 - 1) % 9 + 1
    -- Ex: A(65) -> 1-1=0 %9=0 +1 = 1
    -- Ex: J(74) -> 10-1=9 %9=0 +1 = 1 (NON! J=10 -> 1)
    -- Formule: (ascii(c) - 65) % 9 + 1
    v_val := (ascii(v_char) - 65) % 9 + 1;
    
    v_sum := v_sum + v_val;
  END LOOP;

  -- 3. Réduction (Utilise fn_reduire_maitre existante ou logic simple)
  -- On suppose que fn_reduire_maitre existe (vue dans rpc_generer_rapport)
  -- Sinon on réimplémente une réduction simple avec maîtres 11,22,33
  
  RETURN public.fn_reduire_maitre(v_sum);
END;
$$;
