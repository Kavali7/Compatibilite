-- ============================================================
-- SCRIPT DE NETTOYAGE DE CONTENU
-- Objectif : Supprimer les titres répétitifs et normaliser la typo
-- ============================================================

-- 1. Supprimer les lignes commençant par "ANNÉE X..." ou "VIBRATION X..."
--    (regex multiline avec 'm', case insensitive 'i', global 'g' est implicite en SQL update standard ou via replace)
--    Note sur REGEXP_REPLACE (PostgreSQL) : 'g' flags permet de remplacer toutes les occurrences, 'n' permet au '.' de matcher les newlines si besoin (ici on veut juste le début de ligne '^').
--    Le flag 'm' (multiline) fait que '^' matche le début de chaque ligne, pas juste le début du string.

UPDATE public.canonical_predictions
SET contenu_md = REGEXP_REPLACE(
    contenu_md, 
    '^(ANNÉE|MOIS|JOUR|VIBRATION).*\n+', -- Pattern : Début ligne + Mot clé + reste de la ligne + saut de ligne
    '', 
    'gmi' -- Global, Multiline (très important pour matcher ^ à chaque ligne), Case Insensitive
);

-- 2. Supprimer les en-têtes "Climat Général :" s'ils sont jugés redondants (Optionnel, décommenter si voulu)
-- UPDATE public.canonical_predictions
-- SET contenu_md = REGEXP_REPLACE(contenu_md, '^Climat Général :.*\n+', '', 'gmi');


-- 3. Normalisation des apostrophes
--    Remplacer l'apostrophe droite (') par l'apostrophe typographique (’)
--    Cela améliore le rendu visuel (évite la confusion avec les quotes de code)
UPDATE public.canonical_predictions
SET contenu_md = REPLACE(contenu_md, '''', '’');


-- 4. Vérification (Afficher un extrait pour confirmer)
SELECT substring(contenu_md from 1 for 100) as extrait_apres_nettoyage 
FROM public.canonical_predictions 
LIMIT 5;
