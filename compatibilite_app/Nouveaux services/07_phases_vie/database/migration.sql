-- MIGRATION: Phases de Vie (Cycles de 7 ans)
CREATE TABLE IF NOT EXISTS public.life_phase_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phase_number INT NOT NULL CHECK (phase_number BETWEEN 1 AND 10),
    phase_name TEXT NOT NULL,
    age_start INT NOT NULL,
    age_end INT NOT NULL,
    theme TEXT NOT NULL,
    full_content TEXT NOT NULL,
    impacts TEXT[],
    questions_reflection TEXT[],
    travail_guerison TEXT[],
    is_active BOOLEAN DEFAULT true,
    UNIQUE(phase_number)
);

CREATE TABLE IF NOT EXISTS public.life_phase_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    user_birthdate DATE NOT NULL,
    purchase_date TIMESTAMP DEFAULT NOW(),
    payment_id UUID REFERENCES payments(id)
);

ALTER TABLE life_phase_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE life_phase_purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "phases_select" ON life_phase_periods FOR SELECT USING (true);
CREATE POLICY "purchases_own" ON life_phase_purchases FOR SELECT USING (user_id = auth.uid());

-- Fonction calcul phase actuelle
CREATE OR REPLACE FUNCTION fn_get_current_life_phase(birthdate DATE)
RETURNS INT AS $$
DECLARE
    age_years INT;
BEGIN
    age_years := EXTRACT(YEAR FROM AGE(NOW(), birthdate));
    RETURN LEAST((age_years / 7) + 1, 10);
END;
$$ LANGUAGE plpgsql;
