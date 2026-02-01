-- =============================================
-- MIGRATION: Portrait de l'Âme (Soul Profile)
-- Service 01 - Cycles de Vie
-- =============================================

-- Table pour stocker les 14 profils Soul
CREATE TABLE IF NOT EXISTS public.soul_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identifiant du profil (1A, 1B, 2A, ..., 7B)
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    polarity CHAR(1) NOT NULL CHECK (polarity IN ('A', 'B')),
    profile_code VARCHAR(3) GENERATED ALWAYS AS (period_number || polarity) STORED,
    
    -- Métadonnées du profil
    cosmic_identity TEXT NOT NULL,  -- Ex: "L'Âme Souveraine"
    
    -- Plages de dates (format MM-DD)
    date_start VARCHAR(5) NOT NULL,  -- Ex: "03-22" pour 22 mars
    date_end VARCHAR(5) NOT NULL,    -- Ex: "04-17" pour 17 avril
    
    -- Contenu du rapport (Markdown)
    full_content TEXT NOT NULL,
    
    -- Sections individuelles (pour affichage flexible)
    heritage_cosmique TEXT,
    essence_profonde TEXT,
    forces_naturelles JSONB,  -- Array de {titre, description}
    defis TEXT,
    vocations JSONB,          -- Array de catégories/métiers
    affinites_geo TEXT[],
    vigilance_sante TEXT[],
    conseils TEXT[],
    message_cosmique TEXT,
    
    -- Métadonnées
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Contrainte d'unicité
    UNIQUE(period_number, polarity)
);

-- Index pour recherche rapide par code
CREATE INDEX IF NOT EXISTS idx_soul_profiles_code 
ON soul_profiles(period_number, polarity);

-- Table pour les achats de Portrait de l'Âme
CREATE TABLE IF NOT EXISTS public.soul_profile_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    payment_id UUID REFERENCES payments(id),
    
    -- Données utilisateur pour calcul
    user_birthdate DATE NOT NULL,
    user_firstname TEXT,
    
    -- Profil calculé
    profile_id UUID REFERENCES soul_profiles(id),
    calculated_period INT NOT NULL,
    calculated_polarity CHAR(1) NOT NULL,
    
    -- Rapport généré (avec personnalisation)
    generated_report JSONB NOT NULL,
    
    -- Statut
    status VARCHAR(20) DEFAULT 'completed',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour historique utilisateur
CREATE INDEX IF NOT EXISTS idx_soul_purchases_user 
ON soul_profile_purchases(user_id);

-- =============================================
-- RLS Policies
-- =============================================

ALTER TABLE soul_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE soul_profile_purchases ENABLE ROW LEVEL SECURITY;

-- Profils lisibles par tous (contenu public pour affichage)
CREATE POLICY "soul_profiles_select_all" ON soul_profiles
    FOR SELECT USING (true);

-- Achats visibles uniquement par le propriétaire
CREATE POLICY "soul_purchases_select_own" ON soul_profile_purchases
    FOR SELECT USING (user_id = auth.uid());

-- =============================================
-- RPC Functions
-- =============================================

-- Fonction pour calculer le profil Soul à partir d'une date
CREATE OR REPLACE FUNCTION fn_calculate_soul_profile(p_birthdate DATE)
RETURNS TABLE(period_number INT, polarity CHAR(1), profile_code TEXT) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_month INT;
    v_day INT;
    v_year INT;
    v_period INT;
    v_polarity CHAR(1);
BEGIN
    v_month := EXTRACT(MONTH FROM p_birthdate);
    v_day := EXTRACT(DAY FROM p_birthdate);
    v_year := EXTRACT(YEAR FROM p_birthdate);
    
    -- Calcul de la période basé sur les plages de dates
    IF (v_month = 3 AND v_day >= 22) OR (v_month = 4 AND v_day <= 17) THEN
        v_period := 1;
    ELSIF (v_month = 4 AND v_day >= 18) OR (v_month = 5 AND v_day <= 12) THEN
        v_period := 1;  -- Encore période 1B
    ELSIF (v_month = 5 AND v_day >= 13) OR (v_month = 6 AND v_day <= 8) THEN
        v_period := 2;
    ELSIF (v_month = 6 AND v_day >= 9) OR (v_month = 7 AND v_day <= 3) THEN
        v_period := 2;  -- Période 2B
    ELSIF (v_month = 7 AND v_day >= 4) OR (v_month = 7 AND v_day <= 31) THEN
        v_period := 3;
    ELSIF (v_month = 8 AND v_day >= 1) OR (v_month = 8 AND v_day <= 24) THEN
        v_period := 3;  -- Période 3B
    ELSIF (v_month = 8 AND v_day >= 25) OR (v_month = 9 AND v_day <= 20) THEN
        v_period := 4;
    ELSIF (v_month = 9 AND v_day >= 21) OR (v_month = 10 AND v_day <= 15) THEN
        v_period := 4;  -- Période 4B
    ELSIF (v_month = 10 AND v_day >= 16) OR (v_month = 11 AND v_day <= 11) THEN
        v_period := 5;
    ELSIF (v_month = 11 AND v_day >= 12) OR (v_month = 12 AND v_day <= 7) THEN
        v_period := 5;  -- Période 5B
    ELSIF (v_month = 12 AND v_day >= 8) OR (v_month = 1 AND v_day <= 3) THEN
        v_period := 6;
    ELSIF (v_month = 1 AND v_day >= 4) OR (v_month = 1 AND v_day <= 29) THEN
        v_period := 6;  -- Période 6B
    ELSIF (v_month = 1 AND v_day >= 30) OR (v_month = 2 AND v_day <= 26) THEN
        v_period := 7;
    ELSE
        v_period := 7;  -- Période 7B (26 fév - 22 mars)
    END IF;
    
    -- Calcul de la polarité basé sur l'année
    IF v_year % 2 = 0 THEN
        v_polarity := 'A';
    ELSE
        v_polarity := 'B';
    END IF;
    
    RETURN QUERY SELECT v_period, v_polarity, (v_period::TEXT || v_polarity);
END;
$$;

-- Fonction pour obtenir le profil complet
CREATE OR REPLACE FUNCTION fn_get_soul_profile(p_birthdate DATE)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_period INT;
    v_polarity CHAR(1);
    v_profile RECORD;
BEGIN
    -- Calculer période et polarité
    SELECT * INTO v_period, v_polarity 
    FROM fn_calculate_soul_profile(p_birthdate);
    
    -- Récupérer le profil
    SELECT * INTO v_profile 
    FROM soul_profiles 
    WHERE period_number = v_period AND polarity = v_polarity;
    
    IF v_profile IS NULL THEN
        RETURN jsonb_build_object('error', 'Profil non trouvé');
    END IF;
    
    RETURN jsonb_build_object(
        'success', true,
        'period', v_period,
        'polarity', v_polarity,
        'profile_code', v_period::TEXT || v_polarity,
        'cosmic_identity', v_profile.cosmic_identity,
        'full_content', v_profile.full_content
    );
END;
$$;

-- Fonction pour créer un achat
CREATE OR REPLACE FUNCTION fn_create_soul_purchase(
    p_user_id UUID,
    p_payment_id UUID,
    p_birthdate DATE,
    p_firstname TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_profile_data JSONB;
    v_period INT;
    v_polarity CHAR(1);
    v_profile_id UUID;
    v_purchase_id UUID;
BEGIN
    -- Calculer le profil
    SELECT * INTO v_period, v_polarity 
    FROM fn_calculate_soul_profile(p_birthdate);
    
    -- Obtenir l'ID du profil
    SELECT id INTO v_profile_id 
    FROM soul_profiles 
    WHERE period_number = v_period AND polarity = v_polarity;
    
    -- Générer le rapport personnalisé
    v_profile_data := fn_get_soul_profile(p_birthdate);
    
    -- Remplacer les placeholders
    v_profile_data := jsonb_set(
        v_profile_data, 
        '{full_content}', 
        to_jsonb(REPLACE(REPLACE(
            v_profile_data->>'full_content',
            '[Prénom]', p_firstname
        ), '[date de naissance]', to_char(p_birthdate, 'DD/MM/YYYY')))
    );
    
    -- Créer l'achat
    INSERT INTO soul_profile_purchases (
        user_id, payment_id, user_birthdate, user_firstname,
        profile_id, calculated_period, calculated_polarity,
        generated_report
    ) VALUES (
        p_user_id, p_payment_id, p_birthdate, p_firstname,
        v_profile_id, v_period, v_polarity,
        v_profile_data
    ) RETURNING id INTO v_purchase_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'purchase_id', v_purchase_id,
        'profile', v_profile_data
    );
END;
$$;
