-- =====================================================
-- Phase 2: Report Sections Setup
-- Run this in Supabase SQL Editor to add controllable sections
-- =====================================================

-- Insert default sections if they don't exist
INSERT INTO report_sections (code, label_fr, is_active, display_order, periode, description)
VALUES 
  ('couple_dynamic', 'Dynamique du couple', true, 1, 'toutes', 'Interprétation du nombre du couple'),
  ('couple_report', 'Rapport du couple', true, 2, 'toutes', 'Analyse approfondie de la relation'),
  ('partner_portraits', 'Portraits des partenaires', true, 3, 'toutes', 'Profil numérologique de chaque partenaire'),
  ('daily_advice', 'Conseil du jour', true, 4, 'jour', 'Conseil quotidien basé sur les cycles'),
  ('temporal_reports', 'Prévisions Temporelles', true, 5, 'toutes', 'Prévisions année/mois/jour')
ON CONFLICT (code) DO NOTHING;

-- Verify inserted sections
SELECT code, label_fr, is_active, display_order FROM report_sections ORDER BY display_order;
