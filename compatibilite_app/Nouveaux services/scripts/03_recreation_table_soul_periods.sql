-- ═══════════════════════════════════════════════════════════════════════════
-- 03_recreation_table_soul_periods.sql
-- Portrait de l'Âme - Service 01
-- RECRÉATION COMPLÈTE DE LA TABLE avec toutes les colonnes nécessaires
-- Exécuter dans Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════════════════════════════

-- ⚠️ ATTENTION: Ce script SUPPRIME les données existantes et recrée la table
-- Assurez-vous d'avoir une sauvegarde si nécessaire

-- ═════════════════════════════════════════════════════════════════════════
-- ÉTAPE 1: Suppression de la table existante
-- ═════════════════════════════════════════════════════════════════════════
DROP TABLE IF EXISTS cycle_vie_soul_periods CASCADE;

-- ═════════════════════════════════════════════════════════════════════════
-- ÉTAPE 2: Création de la nouvelle table avec TOUTES les colonnes
-- ═════════════════════════════════════════════════════════════════════════
CREATE TABLE cycle_vie_soul_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identifiants de période
    period_number INTEGER NOT NULL CHECK (period_number >= 1 AND period_number <= 7),
    polarity CHAR(1) NOT NULL CHECK (polarity IN ('A', 'B')),
    
    -- Dates d'application (format "MM-DD" pour recherche)
    date_start TEXT NOT NULL,
    date_end TEXT NOT NULL,
    
    -- Noms et titres
    period_name TEXT NOT NULL,       -- Ex: "Les Souverains" 
    period_title TEXT NOT NULL,      -- Ex: "L'Âme Souveraine"
    
    -- Contenu enrichi complet (8 sections)
    description_general TEXT NOT NULL,      -- Héritage Cosmique + Essence Profonde
    traits_positifs TEXT,                   -- Forces Naturelles
    traits_vigilance TEXT,                  -- Défis à Transcender
    professions_favorables TEXT,            -- Vocations Idéales
    sante_vigilance TEXT,                   -- Points de Vigilance Santé
    pays_affinites TEXT,                    -- Affinités Géographiques
    conseils TEXT,                          -- ✨ NOUVEAU: Conseils pour l'Épanouissement
    message_cosmique TEXT,                  -- ✨ NOUVEAU: Message Cosmique de conclusion
    
    -- Contrôle d'affichage
    is_active BOOLEAN DEFAULT true,
    
    -- Métadonnées
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Contrainte d'unicité
    UNIQUE(period_number, polarity)
);

-- ═════════════════════════════════════════════════════════════════════════
-- ÉTAPE 3: Index pour performance
-- ═════════════════════════════════════════════════════════════════════════
CREATE INDEX idx_soul_periods_lookup ON cycle_vie_soul_periods(period_number, polarity);

-- ═════════════════════════════════════════════════════════════════════════
-- ÉTAPE 4: Politique RLS
-- ═════════════════════════════════════════════════════════════════════════
ALTER TABLE cycle_vie_soul_periods ENABLE ROW LEVEL SECURITY;

-- Lecture publique (contenu affiché après achat)
CREATE POLICY "Public read access for soul periods"
    ON cycle_vie_soul_periods
    FOR SELECT
    USING (true);

-- ═════════════════════════════════════════════════════════════════════════
-- ÉTAPE 5: Trigger de mise à jour automatique
-- ═════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION update_soul_periods_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_soul_periods_timestamp
    BEFORE UPDATE ON cycle_vie_soul_periods
    FOR EACH ROW
    EXECUTE FUNCTION update_soul_periods_timestamp();

-- ═════════════════════════════════════════════════════════════════════════
-- VÉRIFICATION
-- ═════════════════════════════════════════════════════════════════════════
SELECT '✅ TABLE cycle_vie_soul_periods RECRÉÉE' as status;

-- Afficher la structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'cycle_vie_soul_periods'
ORDER BY ordinal_position;
