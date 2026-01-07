-- ============================================================
-- NETTOYAGE : Suppression des configurations obsolètes
-- DATE: 2026-01-07
-- ============================================================

-- 1. Supprimer l'ancien paramètre en anglais (doublon inutile)
DELETE FROM public.app_settings 
WHERE key = 'temporal_bonuses';

-- 2. Confirmer qu'il ne reste que la bonne version (français)
SELECT key, value, updated_at 
FROM public.app_settings 
WHERE key IN ('temporal_bonuses', 'bonus_temporels');
