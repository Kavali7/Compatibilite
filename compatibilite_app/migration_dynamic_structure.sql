-- ============================================================
-- MIGRATION: STRUCTURE DE RAPPORT DYNAMIQUE
-- Objectif : Rendre les titres et sections configurables via DB
-- ============================================================

-- 1. Création de la table de configuration
CREATE TABLE IF NOT EXISTS public.report_sections (
  code TEXT PRIMARY KEY,           -- identifiant technique (ex: 'b3_rituel')
  label_fr TEXT NOT NULL,          -- titre affiché (ex: '**Rituel :** ')
  is_active BOOLEAN DEFAULT true,  -- activer/désactiver la section
  display_order INTEGER,           -- ordre d'affichage (pour tri futur)
  periode TEXT,                    -- contexte ('user', 'couple', 'jour', 'mois', 'annee', 'all')
  description TEXT                 -- note interne pour l'admin
);

-- 2. Sécurisation (RLS)
ALTER TABLE public.report_sections ENABLE ROW LEVEL SECURITY;

-- Lecture publique (pour l'app/API)
CREATE POLICY "Public read access" ON public.report_sections
FOR SELECT TO authenticated, anon USING (true);

-- Écriture réservée aux admins (ou via service role pour l'instant)
-- Note: Pour l'instant on laisse fermé en écriture publique via RLS par défaut (deny all verify)

-- 3. Population avec les valeurs ACTUELLES (Hardcoded -> DB)
-- On utilise ON CONFLICT DO UPDATE pour permettre de re-jouer le script sans erreur

INSERT INTO public.report_sections (code, label_fr, periode, description, display_order) VALUES
-- BLOC 2 (RISQUE / LEVIER)
('b2_posture', '**Posture du moment :**', 'all', 'Bloc 2 - Posture', 10),
('b2_levier', '**Levier à activer :**', 'all', 'Bloc 2 - Levier', 20),
('b2_risque', '**Risque à surveiller :**', 'all', 'Bloc 2 - Risque', 30),

-- BLOC 3 (JOUR)
('b3_acte_jour', '**Acte du jour :**', 'jour', 'Bloc 3 - Acte (Jour)', 40),
('b3_rituel_jour', '**Rituel :**', 'jour', 'Bloc 3 - Rituel (Jour)', 50),
('b3_couple_jour', '**Couple :**', 'jour', 'Bloc 3 - Couple (Jour)', 60),
('b3_travail_jour', '**Travail/Affaires :**', 'jour', 'Bloc 3 - Travail (Jour)', 70),
('b3_argent_jour', '**Argent :**', 'jour', 'Bloc 3 - Argent (Jour)', 80),
('b3_sante_jour', '**Énergie/Santé :**', 'jour', 'Bloc 3 - Santé (Jour)', 90),
('b3_feu_jour', '**Feu du jour :**', 'jour', 'Bloc 3 - Feu (Jour)', 100),

-- BLOC 3 (MOIS)
('b3_acte_mois', '**Acte du mois :**', 'mois', 'Bloc 3 - Acte (Mois)', 40),
('b3_rituel_mois', '**Rituel :**', 'mois', 'Bloc 3 - Rituel (Mois)', 50),
('b3_couple_mois', '**Couple :**', 'mois', 'Bloc 3 - Couple (Mois)', 60),
('b3_travail_mois', '**Travail/Affaires :**', 'mois', 'Bloc 3 - Travail (Mois)', 70),
('b3_argent_mois', '**Argent :**', 'mois', 'Bloc 3 - Argent (Mois)', 80),
('b3_sante_mois', '**Énergie/Santé :**', 'mois', 'Bloc 3 - Santé (Mois)', 90),
('b3_feu_mois', '**Feu du mois :**', 'mois', 'Bloc 3 - Feu (Mois)', 100),

-- BLOC 3 (ANNÉE)
('b3_acte_annee', '**Acte de l’année :**', 'annee', 'Bloc 3 - Acte (Année)', 40),
('b3_rituel_annee', '**Rituel :**', 'annee', 'Bloc 3 - Rituel (Année)', 50),
('b3_couple_annee', '**Couple :**', 'annee', 'Bloc 3 - Couple (Année)', 60),
('b3_travail_annee', '**Travail/Affaires :**', 'annee', 'Bloc 3 - Travail (Année)', 70),
('b3_argent_annee', '**Argent :**', 'annee', 'Bloc 3 - Argent (Année)', 80),
('b3_sante_annee', '**Énergie/Santé :**', 'annee', 'Bloc 3 - Santé (Année)', 90),
('b3_feu_annee', '**Feu de l’année :**', 'annee', 'Bloc 3 - Feu (Année)', 100)

ON CONFLICT (code) DO UPDATE SET
  label_fr = EXCLUDED.label_fr,
  periode = EXCLUDED.periode;

-- Verification
SELECT * FROM public.report_sections;
