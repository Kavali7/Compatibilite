-- ============================================================
-- FIX: Activation des bonus temporels (Année, Mois, Jour)
-- DATE: 2026-01-07
-- DESCRIPTION: Ce script force l'activation des rapports temporels
--              dans la configuration globale `app_settings`.
-- ============================================================

INSERT INTO public.app_settings (key, value)
VALUES (
  'bonus_temporels',
  '{
    "activé": true,
    "année": true,
    "mois": true,
    "jour": true,
    "note": "Configuration forcée par fix_temporal_settings.sql"
  }'::jsonb
)
ON CONFLICT (key)
DO UPDATE SET
  value = EXCLUDED.value,
  updated_at = now();

-- Vérification immédiate
SELECT key, value 
FROM public.app_settings 
WHERE key = 'bonus_temporels';
