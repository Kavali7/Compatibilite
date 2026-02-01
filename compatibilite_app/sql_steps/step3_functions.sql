-- =============================================
-- ÉTAPE 3: Créer les fonctions RPC
-- =============================================

-- Fonction: Obtenir la période business actuelle
CREATE OR REPLACE FUNCTION fn_get_current_business_period(
    p_reference_date DATE,
    p_today DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_anniversary DATE;
    v_days_since INT;
    v_period_number INT;
    v_day_in_period INT;
    v_days_remaining INT;
    v_period_start DATE;
    v_period_end DATE;
    v_period RECORD;
BEGIN
    -- Calculer le dernier anniversaire
    v_last_anniversary := make_date(
        EXTRACT(YEAR FROM p_today)::INT,
        EXTRACT(MONTH FROM p_reference_date)::INT,
        EXTRACT(DAY FROM p_reference_date)::INT
    );
    
    IF v_last_anniversary > p_today THEN
        v_last_anniversary := v_last_anniversary - INTERVAL '1 year';
    END IF;
    
    -- Jours depuis anniversaire
    v_days_since := p_today - v_last_anniversary;
    
    -- Calcul période (1-7)
    v_period_number := LEAST(7, (v_days_since / 52) + 1);
    v_day_in_period := (v_days_since % 52) + 1;
    v_days_remaining := 52 - v_day_in_period;
    
    -- Dates de la période
    v_period_start := v_last_anniversary + ((v_period_number - 1) * 52);
    v_period_end := v_last_anniversary + (v_period_number * 52) - 1;
    
    -- Récupérer les infos de la période
    SELECT * INTO v_period FROM business_cycle_periods WHERE period_number = v_period_number;
    
    RETURN jsonb_build_object(
        'period_number', v_period_number,
        'period_name', v_period.period_name,
        'theme_central', v_period.theme_central,
        'day_in_period', v_day_in_period,
        'days_remaining', v_days_remaining,
        'period_start_date', v_period_start,
        'period_end_date', v_period_end,
        'focus_strategique', v_period.focus_strategique,
        'energie_business', v_period.energie_business,
        'fenetre_strategique', v_period.fenetre_strategique,
        'actions_recommandees', v_period.actions_recommandees,
        'risques_eviter', v_period.risques_eviter,
        'indicateurs_cles', v_period.indicateurs_cles,
        'decisions_favorables', v_period.decisions_favorables,
        'decisions_defavorables', v_period.decisions_defavorables,
        'astuce_strategique', v_period.astuce_strategique
    );
END;
$$;

-- Fonction: Obtenir le calendrier annuel business
CREATE OR REPLACE FUNCTION fn_get_business_year_calendar(
    p_reference_date DATE,
    p_today DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_anniversary DATE;
    v_current_period INT;
    v_periods JSONB := '[]'::JSONB;
    v_period RECORD;
    v_start DATE;
    v_end DATE;
BEGIN
    v_last_anniversary := make_date(
        EXTRACT(YEAR FROM p_today)::INT,
        EXTRACT(MONTH FROM p_reference_date)::INT,
        EXTRACT(DAY FROM p_reference_date)::INT
    );
    
    IF v_last_anniversary > p_today THEN
        v_last_anniversary := v_last_anniversary - INTERVAL '1 year';
    END IF;
    
    v_current_period := LEAST(7, ((p_today - v_last_anniversary) / 52) + 1);
    
    FOR v_period IN SELECT * FROM business_cycle_periods ORDER BY period_number LOOP
        v_start := v_last_anniversary + ((v_period.period_number - 1) * 52);
        v_end := v_last_anniversary + (v_period.period_number * 52) - 1;
        
        v_periods := v_periods || jsonb_build_object(
            'period_number', v_period.period_number,
            'period_name', v_period.period_name,
            'theme_central', v_period.theme_central,
            'start_date', v_start,
            'end_date', v_end,
            'is_current', v_period.period_number = v_current_period
        );
    END LOOP;
    
    RETURN jsonb_build_object(
        'reference_date', p_reference_date,
        'cycle_start', v_last_anniversary,
        'cycle_end', v_last_anniversary + INTERVAL '364 days',
        'current_period', v_current_period,
        'periods', v_periods
    );
END;
$$;

-- Fonction: Créer un abonnement business
CREATE OR REPLACE FUNCTION fn_create_business_cycle_subscription(
    p_user_id UUID,
    p_company_name TEXT,
    p_reference_date DATE,
    p_payment_id TEXT
)
RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_subscription_id UUID;
BEGIN
    INSERT INTO business_cycle_subscriptions (
        user_id, company_name, reference_date, payment_id,
        start_date, end_date, status
    ) VALUES (
        p_user_id, p_company_name, p_reference_date, p_payment_id,
        CURRENT_DATE, CURRENT_DATE + INTERVAL '365 days', 'active'
    )
    RETURNING id INTO v_subscription_id;
    
    RETURN v_subscription_id;
END;
$$;

-- Fonction: Vérifier l'accès business
CREATE OR REPLACE FUNCTION fn_check_business_cycle_access(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM business_cycle_subscriptions
        WHERE user_id = p_user_id
        AND status = 'active'
        AND end_date >= CURRENT_DATE
    );
END;
$$;

SELECT 'Fonctions RPC créées!' AS info;
