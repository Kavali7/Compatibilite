-- ============================================================
-- SCRIPT DE VÉRIFICATION DU CONTENU
-- ============================================================
-- Ce script affiche un échantillon de chaque type de contenu pour vérification.

-- 1. RAPPORT BASIQUE (PERSONNEL)
-- Affiche les descriptions des nombres de base (Chemin de Vie)
SELECT '--- BASE (PERSONNEL) ---' as section;
SELECT number, title, substring(body from 1 for 100) || '...' as apercu 
FROM public.numerology_texts 
WHERE type = 'base' 
ORDER BY number 
LIMIT 5;

-- 2. RAPPORT BASIQUE (COUPLE)
-- Affiche les descriptions de la vibration du couple
SELECT '--- COUPLE ---' as section;
SELECT number, substring(body from 1 for 100) || '...' as apercu 
FROM public.numerology_texts 
WHERE type = 'couple' 
ORDER BY number 
LIMIT 5;

-- 3. PRÉVISIONS TEMPORELLES (CANONICAL) - ANNÉE
-- Affiche les textes principaux pour l'année (normalement nettoyés des "VIBRATION...")
SELECT '--- ANNÉE (CANONICAL) ---' as section;
SELECT numero, titre, substring(contenu_md from 1 for 100) || '...' as apercu 
FROM public.canonical_predictions 
WHERE periode = 'annee' 
ORDER BY numero 
LIMIT 3;

-- 4. PRÉVISIONS TEMPORELLES (CANONICAL) - MOIS
-- Affiche les textes principaux pour le mois
SELECT '--- MOIS (CANONICAL) ---' as section;
SELECT numero, titre, substring(contenu_md from 1 for 100) || '...' as apercu 
FROM public.canonical_predictions 
WHERE periode = 'mois' 
ORDER BY numero 
LIMIT 3;

-- 5. PRÉVISIONS TEMPORELLES (BRIQUES)
-- Affiche les "briques" (phrases courtes) pour l'énergie, le focus, etc.
SELECT '--- BRIQUES (ÉNERGIE) ---' as section;
SELECT type_brique, numero_cible, substring(modele_texte from 1 for 100) || '...' as apercu 
FROM public.content_bricks 
WHERE type_brique = 'energie' 
LIMIT 5;

SELECT '--- BRIQUES (FOCUS) ---' as section;
SELECT type_brique, numero_cible, substring(modele_texte from 1 for 100) || '...' as apercu 
FROM public.content_bricks 
WHERE type_brique = 'focus' 
LIMIT 5;
