-- ================================================
-- MIGRATION CYCLES DE VIE - PARTIE 1/4
-- Tables principales
-- Exécuter ce fichier en premier dans Supabase SQL Editor
-- ================================================

-- 1. Table des 7 périodes Soul Cycle (basé sur date de naissance)
-- 14 entrées = 7 périodes × 2 polarités (A et B)
CREATE TABLE IF NOT EXISTS public.cycle_vie_soul_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    polarity CHAR(1) NOT NULL CHECK (polarity IN ('A', 'B')),
    
    -- Dates (format MM-DD, sans année)
    date_start VARCHAR(5) NOT NULL, -- e.g. "03-22"
    date_end VARCHAR(5) NOT NULL,   -- e.g. "05-12"
    
    -- Contenu principal (géré depuis admin)
    period_name TEXT NOT NULL,
    period_title TEXT NOT NULL,
    description_general TEXT NOT NULL,
    
    -- Contenu détaillé
    traits_positifs TEXT,
    traits_vigilance TEXT,
    professions_favorables TEXT,
    sante_vigilance TEXT,
    pays_affinites TEXT,
    
    -- Méta
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(period_number, polarity)
);

-- 2. Table des périodes quotidiennes A-G
-- 7 entrées pour les 7 périodes de chaque jour
CREATE TABLE IF NOT EXISTS public.cycle_vie_daily_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_letter CHAR(1) NOT NULL CHECK (period_letter IN ('A', 'B', 'C', 'D', 'E', 'F', 'G')),
    
    -- Mapping jour de semaine (1=Lundi commence par cette période)
    weekday_number INT CHECK (weekday_number BETWEEN 1 AND 7),
    
    -- Contenu
    period_name TEXT NOT NULL,
    keyword TEXT NOT NULL,
    description TEXT NOT NULL,
    activities_favorables TEXT,
    activities_eviter TEXT,
    
    -- Style visuel
    color_code VARCHAR(7), -- hex color e.g. "#10b981"
    icon_name VARCHAR(50),
    energy_level VARCHAR(20), -- 'high', 'medium', 'low', 'neutral'
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(period_letter)
);

-- 3. Table des types de décisions
-- Liste extensible des types de décisions que l'utilisateur peut consulter
CREATE TABLE IF NOT EXISTS public.cycle_vie_decision_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE, -- e.g. "location", "achat_vehicule"
    label TEXT NOT NULL,
    icon_name VARCHAR(50),
    description TEXT,
    category VARCHAR(50), -- "immobilier", "finance", "personnel", "carriere", "sante", "autre"
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Table des conseils par type de décision × période
-- Permet de personnaliser les conseils selon le type et la période
CREATE TABLE IF NOT EXISTS public.cycle_vie_decision_advice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_type_id UUID NOT NULL REFERENCES cycle_vie_decision_types(id) ON DELETE CASCADE,
    
    -- Contexte du cycle
    cycle_type VARCHAR(20) NOT NULL CHECK (cycle_type IN ('personal', 'business', 'health', 'daily')),
    period_number INT NOT NULL, -- 1-7 pour personal/business/health, 1-7 pour daily (A=1, B=2, etc.)
    
    -- Contenu
    favorability_score INT CHECK (favorability_score BETWEEN 0 AND 100), -- 0=très défavorable, 100=très favorable
    advice_text TEXT NOT NULL,
    warnings TEXT,
    alternatives_suggestion TEXT, -- Texte suggérant des alternatives
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(decision_type_id, cycle_type, period_number)
);

-- 5. Table des achats cycles de vie
-- Historique de tous les achats de services Cycles de Vie
CREATE TABLE IF NOT EXISTS public.cycle_vie_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    payment_id UUID REFERENCES payments(id),
    
    -- Type de service acheté
    service_type VARCHAR(50) NOT NULL CHECK (service_type IN ('express', 'strategique', 'consultation', 'abonnement')),
    
    -- Données utilisateur
    user_birthdate DATE NOT NULL,
    user_firstname TEXT,
    
    -- Pour consultation date spécifique
    consultation_date DATE, -- Date analysée (si service=consultation)
    decision_type_id UUID REFERENCES cycle_vie_decision_types(id),
    decision_detail TEXT, -- Détail libre saisi par l'utilisateur
    
    -- Rapport généré (JSON stockant les données calculées)
    report_data JSONB,
    
    -- Metadata
    status VARCHAR(20) DEFAULT 'completed',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ -- Pour abonnement, date d'expiration
);

-- ================================================
-- INDEX pour performance
-- ================================================
CREATE INDEX IF NOT EXISTS idx_cycle_vie_purchases_user ON cycle_vie_purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_cycle_vie_purchases_created ON cycle_vie_purchases(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cycle_vie_purchases_service ON cycle_vie_purchases(service_type);
CREATE INDEX IF NOT EXISTS idx_cycle_vie_decision_advice_type ON cycle_vie_decision_advice(decision_type_id);

-- ================================================
-- Trigger pour updated_at
-- ================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Appliquer le trigger aux tables
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cycle_vie_soul_periods_updated_at') THEN
        CREATE TRIGGER update_cycle_vie_soul_periods_updated_at
            BEFORE UPDATE ON cycle_vie_soul_periods
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cycle_vie_daily_periods_updated_at') THEN
        CREATE TRIGGER update_cycle_vie_daily_periods_updated_at
            BEFORE UPDATE ON cycle_vie_daily_periods
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cycle_vie_decision_types_updated_at') THEN
        CREATE TRIGGER update_cycle_vie_decision_types_updated_at
            BEFORE UPDATE ON cycle_vie_decision_types
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cycle_vie_decision_advice_updated_at') THEN
        CREATE TRIGGER update_cycle_vie_decision_advice_updated_at
            BEFORE UPDATE ON cycle_vie_decision_advice
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END
$$;

-- ================================================
-- Vérification
-- ================================================
SELECT 'Tables créées avec succès:' AS status;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name LIKE 'cycle_vie_%';
