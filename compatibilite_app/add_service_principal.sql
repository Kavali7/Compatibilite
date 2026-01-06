-- ============================================================
-- Add service_principal setting to app_settings
-- This controls which service is shown as the main/home service
-- ============================================================

-- Add the setting if it doesn't exist
INSERT INTO app_settings (key, value, description, updated_at) 
VALUES (
  'service_principal',
  '{
    "service": "compatibilite",
    "options": ["compatibilite", "prevision_jour", "prevision_mois", "prevision_annee"]
  }'::jsonb,
  'Service principal affiché en accueil de l''application',
  now()
) 
ON CONFLICT (key) DO NOTHING;

-- Verify
SELECT * FROM app_settings WHERE key = 'service_principal';
