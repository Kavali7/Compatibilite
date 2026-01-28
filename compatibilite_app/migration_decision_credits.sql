-- ================================================
-- MIGRATION: Système de Crédits Décision
-- Date: 2026-01-28
-- Description: Ajoute le système de crédits pour les analyses de décision
-- ================================================

-- ================================================
-- PARTIE 1: Vérification des tables existantes
-- ================================================

DO $$
BEGIN
    RAISE NOTICE 'Vérification des tables existantes...';
    
    -- Vérifier pricing_plans
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'pricing_plans') THEN
        RAISE NOTICE '✓ Table pricing_plans existe';
    ELSE
        RAISE EXCEPTION '✗ Table pricing_plans manquante - exécuter migration_pricing_plans.sql d''abord';
    END IF;
    
    -- Vérifier cycle_vie_purchases
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cycle_vie_purchases') THEN
        RAISE NOTICE '✓ Table cycle_vie_purchases existe';
    ELSE
        RAISE EXCEPTION '✗ Table cycle_vie_purchases manquante - exécuter migration_cycles_vie.sql d''abord';
    END IF;
    
    -- Vérifier cycle_vie_decision_types
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cycle_vie_decision_types') THEN
        RAISE NOTICE '✓ Table cycle_vie_decision_types existe';
    ELSE
        RAISE EXCEPTION '✗ Table cycle_vie_decision_types manquante - exécuter migration_cycles_vie.sql d''abord';
    END IF;
END $$;

-- ================================================
-- PARTIE 2: Enrichir table pricing_plans
-- ================================================

-- Ajouter les nouvelles colonnes pour le système de crédits
ALTER TABLE pricing_plans 
ADD COLUMN IF NOT EXISTS decision_credits_included INTEGER DEFAULT 0;

ALTER TABLE pricing_plans 
ADD COLUMN IF NOT EXISTS features JSONB DEFAULT '[]'::jsonb;

ALTER TABLE pricing_plans 
ADD COLUMN IF NOT EXISTS badge_text TEXT;

-- Mettre à jour les plans Cycles de Vie existants avec les crédits par défaut
-- Express: 0 crédits (pas d'accès aux analyses)
UPDATE pricing_plans 
SET 
    decision_credits_included = 0,
    features = '[
        {"icon": "calendar", "text": "Cycle du jour personnalisé"},
        {"icon": "clock", "text": "7 périodes avec horaires"},
        {"icon": "star", "text": "Période Soul avec traits"}
    ]'::jsonb,
    badge_text = NULL
WHERE plan_type = 'cycle_vie_express';

-- Consultation: 1 crédit (analyse du type choisi à l'achat)
UPDATE pricing_plans 
SET 
    decision_credits_included = 1,
    features = '[
        {"icon": "calendar", "text": "Cycle du jour personnalisé"},
        {"icon": "clock", "text": "7 périodes avec horaires"},
        {"icon": "star", "text": "Période Soul avec traits"},
        {"icon": "psychology", "text": "1 analyse de décision incluse", "highlight": true}
    ]'::jsonb,
    badge_text = 'Populaire'
WHERE plan_type = 'cycle_vie_consultation';

-- Stratégique: 3 crédits
UPDATE pricing_plans 
SET 
    decision_credits_included = 3,
    features = '[
        {"icon": "calendar", "text": "Tous les cycles (personnel, business, santé)"},
        {"icon": "clock", "text": "7 périodes avec horaires"},
        {"icon": "star", "text": "Période Soul complète"},
        {"icon": "psychology", "text": "3 analyses de décision incluses", "highlight": true},
        {"icon": "trending_up", "text": "Conseils stratégiques détaillés"}
    ]'::jsonb,
    badge_text = 'Meilleur rapport qualité/prix'
WHERE plan_type = 'cycle_vie_strategique';

-- Abonnement Premium: -1 = illimité
UPDATE pricing_plans 
SET 
    decision_credits_included = -1, -- -1 signifie illimité
    features = '[
        {"icon": "all_inclusive", "text": "Accès illimité à tous les cycles"},
        {"icon": "psychology", "text": "Analyses de décision ILLIMITÉES", "highlight": true},
        {"icon": "notifications", "text": "Notifications quotidiennes"},
        {"icon": "history", "text": "Historique complet"},
        {"icon": "support", "text": "Support prioritaire"}
    ]'::jsonb,
    badge_text = 'Premium'
WHERE plan_type = 'cycle_vie_abonnement';

-- ================================================
-- PARTIE 3: Table des packs de crédits (achat à la carte)
-- ================================================

CREATE TABLE IF NOT EXISTS public.decision_credit_packs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    credits_count INTEGER NOT NULL CHECK (credits_count > 0),
    price_fcfa INTEGER NOT NULL CHECK (price_fcfa > 0),
    discount_percent INTEGER DEFAULT 0 CHECK (discount_percent >= 0 AND discount_percent <= 100),
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insérer les packs par défaut (modifiables depuis l'admin)
INSERT INTO decision_credit_packs (name, description, credits_count, price_fcfa, discount_percent, display_order)
VALUES 
    ('1 Analyse', 'Analyse d''une décision spécifique', 1, 250, 0, 1),
    ('Pack 5 Analyses', 'Économisez 20% sur 5 analyses', 5, 1000, 20, 2),
    ('Pack 10 Analyses', 'Économisez 28% sur 10 analyses', 10, 1800, 28, 3)
ON CONFLICT DO NOTHING;

-- ================================================
-- PARTIE 4: Table des crédits utilisateurs
-- ================================================

CREATE TABLE IF NOT EXISTS public.user_decision_credits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Lié à l'achat spécifique (empêche partage entre comptes)
    cycle_vie_purchase_id UUID REFERENCES cycle_vie_purchases(id) ON DELETE CASCADE,
    
    -- Compteurs
    credits_initial INTEGER NOT NULL CHECK (credits_initial >= 0),
    credits_remaining INTEGER NOT NULL CHECK (credits_remaining >= 0),
    
    -- Source du crédit
    source_type TEXT NOT NULL CHECK (source_type IN ('service_bonus', 'pack_purchase', 'admin_bonus')),
    source_id UUID, -- ID du plan ou pack source
    
    -- Expiration (90 jours par défaut)
    expires_at TIMESTAMPTZ NOT NULL,
    
    -- Flags de notification
    notified_7d BOOLEAN DEFAULT false,
    notified_1d BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_udc_user_id ON user_decision_credits(user_id);
CREATE INDEX IF NOT EXISTS idx_udc_purchase_id ON user_decision_credits(cycle_vie_purchase_id);
CREATE INDEX IF NOT EXISTS idx_udc_expires_at ON user_decision_credits(expires_at);
CREATE INDEX IF NOT EXISTS idx_udc_remaining ON user_decision_credits(credits_remaining) WHERE credits_remaining > 0;

-- ================================================
-- PARTIE 5: Table d'historique d'utilisation
-- ================================================

CREATE TABLE IF NOT EXISTS public.user_decision_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Quel crédit a été utilisé
    credit_id UUID REFERENCES user_decision_credits(id) ON DELETE SET NULL,
    
    -- Lié à l'achat spécifique
    cycle_vie_purchase_id UUID REFERENCES cycle_vie_purchases(id) ON DELETE CASCADE,
    
    -- Détails de l'analyse effectuée
    decision_type_id UUID NOT NULL REFERENCES cycle_vie_decision_types(id),
    cycle_type TEXT NOT NULL,
    period_number INTEGER NOT NULL,
    target_date DATE NOT NULL,
    
    -- Timestamp
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour recherche rapide
CREATE INDEX IF NOT EXISTS idx_udu_user_id ON user_decision_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_udu_purchase_id ON user_decision_usage(cycle_vie_purchase_id);
CREATE INDEX IF NOT EXISTS idx_udu_decision_type ON user_decision_usage(decision_type_id);

-- ================================================
-- PARTIE 6: Table de configuration globale
-- ================================================

CREATE TABLE IF NOT EXISTS public.app_config (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insérer les configurations par défaut
INSERT INTO app_config (key, value, description) VALUES
    ('decision_credits_expiry_days', '90', 'Durée de validité des crédits en jours'),
    ('decision_credits_notify_days', '[7, 1]', 'Jours avant expiration pour envoyer notification')
ON CONFLICT (key) DO NOTHING;

-- ================================================
-- PARTIE 7: Triggers pour updated_at
-- ================================================

-- Trigger pour decision_credit_packs
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_decision_credit_packs_updated_at') THEN
        CREATE TRIGGER update_decision_credit_packs_updated_at
            BEFORE UPDATE ON decision_credit_packs
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- Trigger pour user_decision_credits
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_user_decision_credits_updated_at') THEN
        CREATE TRIGGER update_user_decision_credits_updated_at
            BEFORE UPDATE ON user_decision_credits
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- ================================================
-- PARTIE 8: Fonctions RPC pour le client Flutter
-- ================================================

-- Fonction: Récupérer les crédits disponibles pour un achat
CREATE OR REPLACE FUNCTION fn_get_decision_credits(
    p_user_id UUID,
    p_purchase_id UUID
) RETURNS TABLE (
    total_credits INTEGER,
    used_credits INTEGER,
    remaining_credits INTEGER,
    is_unlimited BOOLEAN,
    expires_soonest TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(udc.credits_initial)::INTEGER, 0) as total_credits,
        COALESCE((SELECT COUNT(*)::INTEGER FROM user_decision_usage WHERE cycle_vie_purchase_id = p_purchase_id), 0) as used_credits,
        COALESCE(SUM(udc.credits_remaining)::INTEGER, 0) as remaining_credits,
        EXISTS(
            SELECT 1 FROM user_decision_credits 
            WHERE cycle_vie_purchase_id = p_purchase_id 
            AND credits_initial = -1
        ) as is_unlimited,
        MIN(udc.expires_at) as expires_soonest
    FROM user_decision_credits udc
    WHERE udc.user_id = p_user_id
      AND udc.cycle_vie_purchase_id = p_purchase_id
      AND udc.credits_remaining > 0
      AND udc.expires_at > NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction: Consommer un crédit
CREATE OR REPLACE FUNCTION fn_consume_decision_credit(
    p_user_id UUID,
    p_purchase_id UUID,
    p_decision_type_id UUID,
    p_cycle_type TEXT,
    p_period_number INTEGER,
    p_target_date DATE
) RETURNS JSONB AS $$
DECLARE
    v_credit_id UUID;
    v_is_unlimited BOOLEAN;
    v_already_used BOOLEAN;
BEGIN
    -- Vérifier si déjà utilisé pour ce type/purchase
    SELECT EXISTS(
        SELECT 1 FROM user_decision_usage 
        WHERE cycle_vie_purchase_id = p_purchase_id 
        AND decision_type_id = p_decision_type_id
    ) INTO v_already_used;
    
    IF v_already_used THEN
        RETURN jsonb_build_object('success', true, 'message', 'Déjà débloqué', 'credit_consumed', false);
    END IF;
    
    -- Vérifier si illimité
    SELECT EXISTS(
        SELECT 1 FROM user_decision_credits 
        WHERE cycle_vie_purchase_id = p_purchase_id 
        AND credits_initial = -1
        AND expires_at > NOW()
    ) INTO v_is_unlimited;
    
    IF v_is_unlimited THEN
        -- Enregistrer l'usage sans consommer de crédit
        INSERT INTO user_decision_usage (
            user_id, cycle_vie_purchase_id, decision_type_id, 
            cycle_type, period_number, target_date
        ) VALUES (
            p_user_id, p_purchase_id, p_decision_type_id,
            p_cycle_type, p_period_number, p_target_date
        );
        
        RETURN jsonb_build_object('success', true, 'message', 'Accès illimité', 'credit_consumed', false);
    END IF;
    
    -- Trouver un crédit disponible (FIFO par expiration)
    SELECT id INTO v_credit_id
    FROM user_decision_credits
    WHERE user_id = p_user_id
      AND cycle_vie_purchase_id = p_purchase_id
      AND credits_remaining > 0
      AND expires_at > NOW()
    ORDER BY expires_at ASC
    LIMIT 1
    FOR UPDATE;
    
    IF v_credit_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'message', 'Aucun crédit disponible', 'credit_consumed', false);
    END IF;
    
    -- Consommer le crédit
    UPDATE user_decision_credits 
    SET credits_remaining = credits_remaining - 1
    WHERE id = v_credit_id;
    
    -- Enregistrer l'usage
    INSERT INTO user_decision_usage (
        user_id, credit_id, cycle_vie_purchase_id, decision_type_id, 
        cycle_type, period_number, target_date
    ) VALUES (
        p_user_id, v_credit_id, p_purchase_id, p_decision_type_id,
        p_cycle_type, p_period_number, p_target_date
    );
    
    RETURN jsonb_build_object('success', true, 'message', 'Crédit consommé', 'credit_consumed', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction: Attribuer des crédits lors d'un achat
CREATE OR REPLACE FUNCTION fn_grant_decision_credits(
    p_user_id UUID,
    p_purchase_id UUID,
    p_plan_type TEXT
) RETURNS INTEGER AS $$
DECLARE
    v_credits INTEGER;
    v_expiry_days INTEGER;
BEGIN
    -- Récupérer le nombre de crédits pour ce plan
    SELECT decision_credits_included INTO v_credits
    FROM pricing_plans
    WHERE plan_type = p_plan_type;
    
    IF v_credits IS NULL OR v_credits = 0 THEN
        RETURN 0;
    END IF;
    
    -- Récupérer la durée d'expiration
    SELECT (value::TEXT)::INTEGER INTO v_expiry_days
    FROM app_config WHERE key = 'decision_credits_expiry_days';
    
    IF v_expiry_days IS NULL THEN
        v_expiry_days := 90;
    END IF;
    
    -- Créer l'entrée de crédits
    INSERT INTO user_decision_credits (
        user_id, cycle_vie_purchase_id, credits_initial, credits_remaining,
        source_type, source_id, expires_at
    ) VALUES (
        p_user_id, p_purchase_id, v_credits, v_credits,
        'service_bonus', 
        (SELECT id FROM pricing_plans WHERE plan_type = p_plan_type LIMIT 1),
        NOW() + (v_expiry_days || ' days')::INTERVAL
    );
    
    RETURN v_credits;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================
-- PARTIE 9: RLS Policies
-- ================================================

-- Activer RLS sur les nouvelles tables
ALTER TABLE decision_credit_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_decision_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_decision_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

-- decision_credit_packs: lecture publique (pour afficher les packs)
DROP POLICY IF EXISTS "decision_credit_packs_read" ON decision_credit_packs;
CREATE POLICY "decision_credit_packs_read" ON decision_credit_packs
    FOR SELECT USING (is_active = true);

-- user_decision_credits: utilisateur voit ses propres crédits
DROP POLICY IF EXISTS "user_decision_credits_own" ON user_decision_credits;
CREATE POLICY "user_decision_credits_own" ON user_decision_credits
    FOR ALL USING (auth.uid() = user_id);

-- user_decision_usage: utilisateur voit son propre historique
DROP POLICY IF EXISTS "user_decision_usage_own" ON user_decision_usage;
CREATE POLICY "user_decision_usage_own" ON user_decision_usage
    FOR ALL USING (auth.uid() = user_id);

-- app_config: lecture publique
DROP POLICY IF EXISTS "app_config_read" ON app_config;
CREATE POLICY "app_config_read" ON app_config
    FOR SELECT USING (true);

-- ================================================
-- VÉRIFICATION FINALE
-- ================================================

SELECT '✅ Migration terminée avec succès!' AS status;

SELECT 'Tables créées/modifiées:' AS info;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('decision_credit_packs', 'user_decision_credits', 'user_decision_usage', 'app_config');

SELECT 'Colonnes ajoutées à pricing_plans:' AS info;
SELECT column_name, data_type FROM information_schema.columns 
WHERE table_name = 'pricing_plans' 
AND column_name IN ('decision_credits_included', 'features', 'badge_text');

SELECT 'Packs de crédits créés:' AS info;
SELECT name, credits_count, price_fcfa, discount_percent FROM decision_credit_packs;

SELECT 'Plans Cycles de Vie mis à jour:' AS info;
SELECT plan_type, name, decision_credits_included, badge_text 
FROM pricing_plans WHERE plan_type LIKE 'cycle_vie_%';
