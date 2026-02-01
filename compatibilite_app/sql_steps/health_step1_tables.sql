-- ============================================================
-- SERVICE 04: CYCLE SANTÉ - Step 1: Tables
-- ============================================================

-- Table des périodes de santé (7 périodes de bien-être)
CREATE TABLE IF NOT EXISTS public.health_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    period_name TEXT NOT NULL,
    theme_central TEXT NOT NULL,
    etat_energetique TEXT NOT NULL,
    points_vigilance TEXT[] DEFAULT '{}',
    activites_recommandees TEXT[] DEFAULT '{}',
    activites_moderer TEXT[] DEFAULT '{}',
    alimentation_privilegier TEXT[] DEFAULT '{}',
    alimentation_eviter TEXT[] DEFAULT '{}',
    repos_sommeil TEXT NOT NULL DEFAULT '',
    conseils_pratiques TEXT[] DEFAULT '{}',
    affirmation_bien_etre TEXT NOT NULL DEFAULT '',
    enseignement TEXT NOT NULL DEFAULT '',
    avertissement TEXT NOT NULL DEFAULT 'Ce conseil ne remplace pas un avis médical professionnel.',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(period_number)
);

-- Créer un index sur period_number
CREATE INDEX IF NOT EXISTS idx_health_cycle_periods_number ON health_cycle_periods(period_number);

-- Table des abonnements Cycle Santé
CREATE TABLE IF NOT EXISTS public.health_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    birth_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Créer un index sur user_id et status
CREATE INDEX IF NOT EXISTS idx_health_subs_user ON health_cycle_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_health_subs_status ON health_cycle_subscriptions(status);
