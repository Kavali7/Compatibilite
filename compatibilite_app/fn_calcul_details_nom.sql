-- ============================================================
-- HELPER FUNCTIONS FOR NUMEROLOGY DETAILS
-- Replicates Dart logic for Intimate (Vowels), Personality (Consonants), Kabbalah.
-- ============================================================

-- ------------------------------------------------------------
-- 1. CALCUL INTIME (Voyelles)
-- Dart: Sum of Vowels (A, E, I, O, U, Y)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_calcul_intime(p_nom text)
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
  -- Normalisation (Upper + Accents)
  v_cleaned := upper(translate(p_nom, 
    'àáâäãåæçéèêëíìîïñóòôöõúùûüýÿœ', 
    'AAAAAAACEEEEIIIINOOOOOUUUUYYOE'
  ));
  
  -- Garder QUE les voyelles (A, E, I, O, U, Y)
  -- Regex replacer tout ce qui N'EST PAS voyelle par vide
  -- Note: Dart inclut Y comme voyelle.
  v_cleaned := regexp_replace(v_cleaned, '[^AEIOUY]', '', 'g');

  IF length(v_cleaned) = 0 THEN
    RETURN 0;
  END IF;

  FOR i IN 1..length(v_cleaned) LOOP
    v_char := substring(v_cleaned from i for 1);
    -- A=1, E=5, I=9, O=6, U=3, Y=7 ... Wait, use Pythagorean table from fn_calcul_nom?
    -- Dart uses _letterValues which maps Y to 7. Yes.
    -- (ascii(c) - 65) % 9 + 1
    v_val := (ascii(v_char) - 65) % 9 + 1;
    v_sum := v_sum + v_val;
  END LOOP;

  RETURN public.fn_reduire_maitre(v_sum);
END;
$$;

-- ------------------------------------------------------------
-- 2. CALCUL RÉALISATION / PERSONALITY (Consonnes)
-- Dart: Sum of NON-Vowels
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_calcul_realisation(p_nom text)
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
  -- Normalisation
  v_cleaned := upper(translate(p_nom, 
    'àáâäãåæçéèêëíìîïñóòôöõúùûüýÿœ', 
    'AAAAAAACEEEEIIIINOOOOOUUUUYYOE'
  ));
  
  -- NE GARDER QUE LES CONSONNES (A-Z sauf AEIOUY)
  v_cleaned := regexp_replace(v_cleaned, '[^A-Z]', '', 'g'); -- Garder lettres
  v_cleaned := regexp_replace(v_cleaned, '[AEIOUY]', '', 'g'); -- Virer voyelles

  IF length(v_cleaned) = 0 THEN
    RETURN 0;
  END IF;

  FOR i IN 1..length(v_cleaned) LOOP
    v_char := substring(v_cleaned from i for 1);
    v_val := (ascii(v_char) - 65) % 9 + 1;
    v_sum := v_sum + v_val;
  END LOOP;

  RETURN public.fn_reduire_maitre(v_sum);
END;
$$;

-- ------------------------------------------------------------
-- 3. CALCUL KABBALE
-- Dart: (ASCII - 64) pour Sum, puis reduce modulo 9 (remainder == 0 ? 9 : remainder)
-- Pas de réduction maître intermédiaire ?
-- Dart: "remainder == 0 ? 9 : remainder" -> C'est une réduction directe à 1-9 sans maîtres.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_calcul_kabbale(p_nom text)
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
  -- Normalisation
  v_cleaned := upper(translate(p_nom, 
    'àáâäãåæçéèêëíìîïñóòôöõúùûüýÿœ', 
    'AAAAAAACEEEEIIIINOOOOOUUUUYYOE'
  ));
  v_cleaned := regexp_replace(v_cleaned, '[^A-Z]', '', 'g');

  IF length(v_cleaned) = 0 THEN
    RETURN 0;
  END IF;

  FOR i IN 1..length(v_cleaned) LOOP
    v_char := substring(v_cleaned from i for 1);
    -- Dart: code - 64 -> A=1, B=2 ... Z=26
    v_val := ascii(v_char) - 64;
    v_sum := v_sum + v_val;
  END LOOP;

  -- Dart Logic: final remainder = total % 9. If 0 -> 9.
  v_sum := v_sum % 9;
  IF v_sum = 0 THEN
    RETURN 9;
  ELSE
    RETURN v_sum;
  END IF;
END;
$$;
