-- ============================================================
-- SERVICE 05: GUIDE HORAIRE - Pricing Plans
-- ============================================================

-- Plan jour unique
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pricing_plans WHERE plan_type = 'daily_guide_day') THEN
        INSERT INTO pricing_plans (
            plan_type,
            name,
            description,
            price_fcfa,
            duration_days,
            is_active
        ) VALUES (
            'daily_guide_day',
            'Guide Horaire - Jour',
            'Optimisez votre journée avec les 7 créneaux énergétiques personnalisés.',
            2,  -- Prix test (2 FCFA) - À modifier en production: 500 FCFA
            1,
            true
        );
    ELSE
        UPDATE pricing_plans SET
            name = 'Guide Horaire - Jour',
            description = 'Optimisez votre journée avec les 7 créneaux énergétiques personnalisés.',
            price_fcfa = 2,  -- Prix test
            is_active = true
        WHERE plan_type = 'daily_guide_day';
    END IF;
END $$;

-- Plan semaine (optionnel)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pricing_plans WHERE plan_type = 'daily_guide_week') THEN
        INSERT INTO pricing_plans (
            plan_type,
            name,
            description,
            price_fcfa,
            duration_days,
            is_active
        ) VALUES (
            'daily_guide_week',
            'Guide Horaire - Semaine',
            'Accédez à votre guide horaire pendant 7 jours consécutifs.',
            10,  -- Prix test (10 FCFA) - À modifier en production: 2500 FCFA
            7,
            true
        );
    ELSE
        UPDATE pricing_plans SET
            name = 'Guide Horaire - Semaine',
            description = 'Accédez à votre guide horaire pendant 7 jours consécutifs.',
            price_fcfa = 10,  -- Prix test
            is_active = true
        WHERE plan_type = 'daily_guide_week';
    END IF;
END $$;

-- Table des achats de guides quotidiens (si n'existe pas)
CREATE TABLE IF NOT EXISTS public.daily_guide_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    payment_id UUID REFERENCES payments(id),
    purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    target_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, target_date)
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_daily_guide_user ON daily_guide_purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_guide_date ON daily_guide_purchases(target_date);

-- RLS pour daily_guide_purchases
ALTER TABLE daily_guide_purchases ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs peuvent voir leurs propres achats
DROP POLICY IF EXISTS "daily_guide_select_own" ON daily_guide_purchases;
CREATE POLICY "daily_guide_select_own" ON daily_guide_purchases
    FOR SELECT USING (auth.uid() = user_id);

-- Les utilisateurs peuvent créer leurs propres achats
DROP POLICY IF EXISTS "daily_guide_insert_own" ON daily_guide_purchases;
CREATE POLICY "daily_guide_insert_own" ON daily_guide_purchases
    FOR INSERT WITH CHECK (auth.uid() = user_id);
