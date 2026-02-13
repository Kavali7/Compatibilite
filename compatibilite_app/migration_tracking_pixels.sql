-- Migration: Tracking Pixels Configuration
-- Ajoute l'entrée tracking_pixels dans app_settings pour stocker les Pixel IDs
-- Meta Pixel, TikTok Pixel, GA4 Measurement ID

INSERT INTO app_settings (key, value, updated_at)
VALUES (
  'tracking_pixels',
  '{
    "meta_pixel_id": "",
    "tiktok_pixel_id": "",
    "ga4_measurement_id": "",
    "enabled": true
  }'::jsonb,
  NOW()
)
ON CONFLICT (key) DO NOTHING;
