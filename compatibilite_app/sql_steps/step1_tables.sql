-- =============================================
-- ÉTAPE 1: Créer les tables
-- =============================================

-- Table des périodes business
CREATE TABLE IF NOT EXISTS public.business_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    period_name TEXT NOT NULL,
    theme_central TEXT NOT NULL,
    focus_strategique TEXT NOT NULL,
    energie_business TEXT NOT NULL,
    fenetre_strategique JSONB NOT NULL DEFAULT '{"points": []}',
    actions_recommandees TEXT[] NOT NULL DEFAULT '{}',
    risques_eviter TEXT[] NOT NULL DEFAULT '{}',
    indicateurs_cles JSONB NOT NULL DEFAULT '[]',
    decisions_favorables TEXT[] NOT NULL DEFAULT '{}',
    decisions_defavorables TEXT[] NOT NULL DEFAULT '{}',
    astuce_strategique TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(period_number)
);

-- Table des abonnements business
CREATE TABLE IF NOT EXISTS public.business_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    company_name TEXT NOT NULL,
    reference_date DATE NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '365 days'),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    payment_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_business_subscriptions_user ON business_cycle_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_business_subscriptions_status ON business_cycle_subscriptions(status);

SELECT 'Tables créées avec succès!' AS info;
