-- =============================================
-- MIGRATION: Cycle Business (Entreprise)
-- Service 03 - Cycles de Vie
-- =============================================

-- Table des périodes business
CREATE TABLE IF NOT EXISTS public.business_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    period_name TEXT NOT NULL,
    theme_central TEXT NOT NULL,
    day_start INT NOT NULL,
    day_end INT NOT NULL,
    full_content TEXT NOT NULL,
    actions_recommandees TEXT[],
    risques_eviter TEXT[],
    decisions_favorables TEXT[],
    decisions_defavorables TEXT[],
    astuce TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(period_number)
);

-- Table des abonnements business
CREATE TABLE IF NOT EXISTS public.business_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    company_name TEXT,
    reference_date DATE NOT NULL, -- Date création entreprise ou anniversaire dirigeant
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index
CREATE INDEX idx_business_subs_user ON business_cycle_subscriptions(user_id);

-- RLS
ALTER TABLE business_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "business_periods_select" ON business_cycle_periods FOR SELECT USING (true);
CREATE POLICY "business_subs_select_own" ON business_cycle_subscriptions FOR SELECT USING (user_id = auth.uid());

-- RPC: Période business actuelle
CREATE OR REPLACE FUNCTION fn_get_current_business_period(p_reference_date DATE, p_today DATE DEFAULT CURRENT_DATE)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_anniversary DATE;
    v_days_since INT;
    v_period INT;
    v_period_info RECORD;
BEGIN
    v_last_anniversary := make_date(EXTRACT(YEAR FROM p_today)::INT, EXTRACT(MONTH FROM p_reference_date)::INT, EXTRACT(DAY FROM p_reference_date)::INT);
    IF v_last_anniversary > p_today THEN
        v_last_anniversary := v_last_anniversary - INTERVAL '1 year';
    END IF;
    v_days_since := p_today - v_last_anniversary;
    v_period := LEAST(7, (v_days_since / 52) + 1);
    
    SELECT * INTO v_period_info FROM business_cycle_periods WHERE period_number = v_period;
    
    RETURN jsonb_build_object(
        'period_number', v_period,
        'period_name', v_period_info.period_name,
        'theme', v_period_info.theme_central,
        'days_in_period', (v_days_since % 52) + 1,
        'days_remaining', 52 - (v_days_since % 52) - 1,
        'start_date', v_last_anniversary + ((v_period - 1) * 52),
        'end_date', v_last_anniversary + (v_period * 52) - 1
    );
END;
$$;
