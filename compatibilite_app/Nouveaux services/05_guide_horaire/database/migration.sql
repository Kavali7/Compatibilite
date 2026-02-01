-- MIGRATION: Guide Horaire
CREATE TABLE IF NOT EXISTS public.daily_time_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slot_number INT NOT NULL CHECK (slot_number BETWEEN 1 AND 7),
    slot_name TEXT NOT NULL,
    hour_start INT NOT NULL,
    hour_end INT NOT NULL,
    energy_type TEXT NOT NULL,
    activities_optimales TEXT[],
    activities_eviter TEXT[],
    conseil TEXT,
    UNIQUE(slot_number)
);

CREATE TABLE IF NOT EXISTS public.daily_guide_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    purchase_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id)
);
