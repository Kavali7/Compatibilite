-- MIGRATION: Cycle Santé
CREATE TABLE IF NOT EXISTS public.health_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    period_name TEXT NOT NULL,
    theme TEXT NOT NULL,
    day_start INT NOT NULL,
    day_end INT NOT NULL,
    full_content TEXT NOT NULL,
    points_vigilance TEXT[],
    activites_recommandees TEXT[],
    alimentation_conseils TEXT[],
    is_active BOOLEAN DEFAULT true,
    UNIQUE(period_number)
);

CREATE TABLE IF NOT EXISTS public.health_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    user_birthdate DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active'
);

ALTER TABLE health_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_cycle_subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "health_periods_select" ON health_cycle_periods FOR SELECT USING (true);
CREATE POLICY "health_subs_own" ON health_cycle_subscriptions FOR SELECT USING (user_id = auth.uid());
