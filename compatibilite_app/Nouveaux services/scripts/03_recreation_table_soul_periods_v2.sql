-- ═══════════════════════════════════════════════════════════════════════════
-- 03_recreation_table_soul_periods_v2.sql
-- NOUVELLE STRUCTURE avec sections complètes et dates CORRECTES
-- ═══════════════════════════════════════════════════════════════════════════

-- Supprimer l'ancienne table
DROP TABLE IF EXISTS cycle_vie_soul_periods CASCADE;

-- Créer la nouvelle table avec TOUTES les sections du rapport MD
CREATE TABLE cycle_vie_soul_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identifiants de période
    period_number INTEGER NOT NULL CHECK (period_number >= 1 AND period_number <= 7),
    polarity CHAR(1) NOT NULL CHECK (polarity IN ('A', 'B')),
    
    -- Dates d'application CORRECTES (format "DD mois" pour affichage)
    date_start TEXT NOT NULL,  -- Ex: "22 mars"
    date_end TEXT NOT NULL,    -- Ex: "17 avril"
    
    -- Titre de l'identité cosmique
    identite_cosmique TEXT NOT NULL,  -- Ex: "L'Âme Souveraine"
    
    -- Introduction personnalisée (texte en italique au début)
    introduction TEXT NOT NULL,
    
    -- Sections principales du rapport (contenu INTÉGRAL)
    heritage_cosmique TEXT NOT NULL,       -- Section "Votre Héritage Cosmique"
    coeur_etre TEXT NOT NULL,              -- Section "Le Cœur de Votre Être"
    forces_naturelles TEXT NOT NULL,       -- Section "Vos Forces Naturelles"
    defis_transcender TEXT NOT NULL,       -- Section "Vos Défis à Transcender"
    vocations_ideales TEXT NOT NULL,       -- Section "Vos Vocations Idéales"
    affinites_geographiques TEXT NOT NULL, -- Section "Vos Affinités Géographiques"
    vigilance_sante TEXT NOT NULL,         -- Section "Points de Vigilance Santé"
    conseils_epanouissement TEXT NOT NULL, -- Section "Conseils pour Votre Épanouissement"
    message_cosmique TEXT NOT NULL,        -- Section "Votre Message Cosmique"
    
    -- Contrôle
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Contrainte d'unicité
    UNIQUE(period_number, polarity)
);

-- Index pour recherche par date (optimisation)
CREATE INDEX idx_soul_periods_dates ON cycle_vie_soul_periods(date_start, date_end);

-- Politique RLS pour lecture publique
ALTER TABLE cycle_vie_soul_periods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lecture publique soul_periods"
ON cycle_vie_soul_periods FOR SELECT
USING (true);

-- ═══════════════════════════════════════════════════════════════════════════
-- CALENDRIER DES 14 PÉRIODES (pour référence)
-- ═══════════════════════════════════════════════════════════════════════════
-- 1A: 22 mars → 17 avril   | L'Âme Souveraine
-- 1B: 17 avril → 12 mai    | L'Âme Artiste Raffinée
-- 2A: 12 mai → 8 juin      | L'Âme Voyageuse Intellectuelle
-- 2B: 8 juin → 3 juillet   | L'Âme Intuitive Lumineuse
-- 3A: 4 juillet → 31 juillet | L'Âme Conquérante Audacieuse
-- 3B: 31 juillet → 24 août | L'Âme Souveraine Royale
-- 4A: 25 août → 20 sept    | L'Âme Sage Érudite
-- 4B: 20 sept → 15 oct     | L'Âme de l'Équilibre Harmonieux
-- 5A: 16 oct → 11 nov      | L'Âme Guerrière Passionnée
-- 5B: 11 nov → 7 déc       | L'Âme Généreuse et Juste
-- 6A: 8 déc → 3 janv       | L'Âme Stratège Patiente
-- 6B: 3 janv → 29 janv     | L'Âme Ambitieuse Méthodique
-- 7A: 30 janv → 26 févr    | L'Âme Humaniste Visionnaire
-- 7B: 26 févr → 22 mars    | L'Âme Mystique Intuitive
-- ═══════════════════════════════════════════════════════════════════════════

SELECT '✅ TABLE cycle_vie_soul_periods RECRÉÉE avec nouvelle structure' AS status;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'cycle_vie_soul_periods'
ORDER BY ordinal_position;
