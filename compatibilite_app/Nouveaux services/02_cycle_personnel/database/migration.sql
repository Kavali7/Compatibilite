-- =============================================
-- MIGRATION: Cycle Annuel Personnel
-- Service 02 - Cycles de Vie
-- =============================================

-- Table pour stocker les 7 périodes du cycle personnel
CREATE TABLE IF NOT EXISTS public.personal_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identifiant de la période (1-7)
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    
    -- Métadonnées de la période
    period_name TEXT NOT NULL,           -- Ex: "Le Nouveau Départ"
    theme_central TEXT NOT NULL,         -- Ex: "L'Initiation"
    
    -- Durée relative (en jours après anniversaire)
    day_start INT NOT NULL,              -- Ex: 1, 53, 105, etc.
    day_end INT NOT NULL,                -- Ex: 52, 104, 156, etc.
    
    -- Contenu du rapport (Markdown)
    full_content TEXT NOT NULL,
    
    -- Sections structurées
    domaines_favorables JSONB,           -- {tres_favorables: [], favorables: []}
    domaines_eviter JSONB,               -- {reporter: [], attention: []}
    conseils TEXT[],
    affirmation TEXT,
    influence_decisions TEXT,
    enseignement TEXT,
    
    -- Métadonnées
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(period_number)
);

-- Index pour recherche rapide
CREATE INDEX IF NOT EXISTS idx_personal_cycle_period 
ON personal_cycle_periods(period_number);

-- Table pour les abonnements au cycle personnel
CREATE TABLE IF NOT EXISTS public.personal_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    
    -- Données utilisateur
    user_birthdate DATE NOT NULL,
    user_firstname TEXT,
    
    -- Période d'abonnement
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    
    -- Paiement associé
    payment_id UUID REFERENCES payments(id),
    
    -- Statut
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    auto_renew BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour recherche par utilisateur
CREATE INDEX IF NOT EXISTS idx_personal_subs_user 
ON personal_cycle_subscriptions(user_id);

CREATE INDEX IF NOT EXISTS idx_personal_subs_status 
ON personal_cycle_subscriptions(status);

-- =============================================
-- RLS Policies
-- =============================================

ALTER TABLE personal_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

-- Périodes lisibles par tous
CREATE POLICY "personal_periods_select_all" ON personal_cycle_periods
    FOR SELECT USING (true);

-- Abonnements visibles uniquement par le propriétaire
CREATE POLICY "personal_subs_select_own" ON personal_cycle_subscriptions
    FOR SELECT USING (user_id = auth.uid());

-- =============================================
-- RPC Functions
-- =============================================

-- Fonction pour calculer la période actuelle basée sur l'anniversaire
CREATE OR REPLACE FUNCTION fn_get_current_personal_period(
    p_birthdate DATE,
    p_target_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(
    period_number INT,
    period_name TEXT,
    days_in_period INT,
    days_remaining INT,
    start_date DATE,
    end_date DATE
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_last_birthday DATE;
    v_days_since INT;
    v_period INT;
    v_day_in_period INT;
    v_period_start DATE;
    v_period_end DATE;
    v_period_info RECORD;
BEGIN
    -- Trouver le dernier anniversaire
    v_last_birthday := make_date(
        EXTRACT(YEAR FROM p_target_date)::INT,
        EXTRACT(MONTH FROM p_birthdate)::INT,
        EXTRACT(DAY FROM p_birthdate)::INT
    );
    
    IF v_last_birthday > p_target_date THEN
        v_last_birthday := v_last_birthday - INTERVAL '1 year';
    END IF;
    
    -- Calculer les jours depuis l'anniversaire
    v_days_since := p_target_date - v_last_birthday;
    
    -- Déterminer la période (1-7)
    v_period := LEAST(7, (v_days_since / 52) + 1);
    v_day_in_period := (v_days_since % 52) + 1;
    
    -- Calculer les dates de début et fin de la période
    v_period_start := v_last_birthday + ((v_period - 1) * 52);
    v_period_end := v_last_birthday + (v_period * 52) - 1;
    
    -- Récupérer les infos de la période
    SELECT * INTO v_period_info FROM personal_cycle_periods 
    WHERE personal_cycle_periods.period_number = v_period;
    
    RETURN QUERY SELECT 
        v_period,
        COALESCE(v_period_info.period_name, 'Période ' || v_period),
        v_day_in_period,
        52 - v_day_in_period,
        v_period_start,
        v_period_end;
END;
$$;

-- Fonction pour obtenir le calendrier annuel complet
CREATE OR REPLACE FUNCTION fn_get_personal_year_calendar(
    p_birthdate DATE,
    p_year INT DEFAULT EXTRACT(YEAR FROM CURRENT_DATE)
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_birthday DATE;
    v_periods JSONB := '[]'::JSONB;
    v_period RECORD;
    i INT;
BEGIN
    -- Anniversaire de l'année spécifiée
    v_birthday := make_date(
        p_year,
        EXTRACT(MONTH FROM p_birthdate)::INT,
        EXTRACT(DAY FROM p_birthdate)::INT
    );
    
    -- Construire le calendrier pour chaque période
    FOR i IN 1..7 LOOP
        SELECT * INTO v_period FROM personal_cycle_periods 
        WHERE period_number = i;
        
        v_periods := v_periods || jsonb_build_object(
            'period_number', i,
            'period_name', COALESCE(v_period.period_name, 'Période ' || i),
            'theme', COALESCE(v_period.theme_central, ''),
            'start_date', (v_birthday + ((i - 1) * 52))::TEXT,
            'end_date', (v_birthday + (i * 52) - 1)::TEXT,
            'affirmation', v_period.affirmation
        );
    END LOOP;
    
    RETURN jsonb_build_object(
        'success', true,
        'birthday', v_birthday,
        'year', p_year,
        'periods', v_periods
    );
END;
$$;

-- Fonction pour créer un abonnement
CREATE OR REPLACE FUNCTION fn_create_personal_cycle_subscription(
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
    v_subscription_id UUID;
    v_start DATE := CURRENT_DATE;
    v_end DATE := CURRENT_DATE + INTERVAL '1 year';
BEGIN
    INSERT INTO personal_cycle_subscriptions (
        user_id, user_birthdate, user_firstname,
        start_date, end_date, payment_id, status
    ) VALUES (
        p_user_id, p_birthdate, p_firstname,
        v_start, v_end, p_payment_id, 'active'
    ) RETURNING id INTO v_subscription_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'subscription_id', v_subscription_id,
        'start_date', v_start,
        'end_date', v_end,
        'calendar', fn_get_personal_year_calendar(p_birthdate)
    );
END;
$$;

-- Fonction pour vérifier l'accès
CREATE OR REPLACE FUNCTION fn_check_personal_cycle_access(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM personal_cycle_subscriptions
        WHERE user_id = p_user_id
        AND status = 'active'
        AND end_date >= CURRENT_DATE
    );
END;
$$;
