-- MIGRATION: Timing Lunaire
CREATE TABLE IF NOT EXISTS public.lunar_phases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phase_number INT NOT NULL CHECK (phase_number BETWEEN 1 AND 8),
    phase_name TEXT NOT NULL,
    phase_key TEXT NOT NULL UNIQUE,
    theme TEXT NOT NULL,
    energy_type TEXT NOT NULL,
    full_content TEXT NOT NULL,
    activities_favorables TEXT[],
    activities_eviter TEXT[],
    conseil TEXT,
    duration_days INT DEFAULT 3,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS public.lunar_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active'
);

ALTER TABLE lunar_phases ENABLE ROW LEVEL SECURITY;
ALTER TABLE lunar_subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lunar_phases_select" ON lunar_phases FOR SELECT USING (true);
CREATE POLICY "lunar_subs_own" ON lunar_subscriptions FOR SELECT USING (user_id = auth.uid());

-- Fonction calcul phase lunaire (algorithme simplifié)
-- Note: Pour production, utiliser une API astronomique ou algorithme précis
CREATE OR REPLACE FUNCTION fn_get_lunar_phase(check_date DATE DEFAULT CURRENT_DATE)
RETURNS INT AS $$
DECLARE
    known_new_moon DATE := '2024-01-11'; -- Nouvelle Lune connue
    days_since_new_moon INT;
    lunar_cycle NUMERIC := 29.53; -- Jours dans un cycle lunaire
    day_in_cycle NUMERIC;
    phase INT;
BEGIN
    days_since_new_moon := check_date - known_new_moon;
    day_in_cycle := days_since_new_moon % lunar_cycle;
    
    -- 8 phases de ~3.7 jours chacune
    phase := FLOOR(day_in_cycle / (lunar_cycle / 8)) + 1;
    RETURN LEAST(phase, 8);
END;
$$ LANGUAGE plpgsql;
