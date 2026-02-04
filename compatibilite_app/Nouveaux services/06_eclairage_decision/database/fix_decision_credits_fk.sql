-- ================================================
-- FIX: Correction des contraintes FK pour le système de crédits
-- Date: 2026-02-03
-- Description: Corrige les problèmes de FK qui empêchent l'attribution des crédits
-- ================================================

-- ================================================
-- PARTIE 1: Supprimer les FK problématiques sur user_decision_credits
-- ================================================

-- Supprimer la FK vers cycle_vie_purchases
ALTER TABLE user_decision_credits 
DROP CONSTRAINT IF EXISTS user_decision_credits_cycle_vie_purchase_id_fkey;

-- Rendre la colonne NULL-able et renommer pour clarté
ALTER TABLE user_decision_credits 
ALTER COLUMN cycle_vie_purchase_id DROP NOT NULL;

-- Ajouter une colonne purchase_id générique (référence à la table purchases)
ALTER TABLE user_decision_credits 
ADD COLUMN IF NOT EXISTS purchase_id UUID;

-- Tenter de créer une FK vers la table purchases si elle existe
DO $$
BEGIN
    -- Vérifier si la table purchases existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'purchases') THEN
        -- Ajouter la FK
        ALTER TABLE user_decision_credits 
        ADD CONSTRAINT user_decision_credits_purchase_id_fkey 
        FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON DELETE SET NULL;
        RAISE NOTICE 'FK vers purchases ajoutée avec succès';
    ELSE
        RAISE NOTICE 'Table purchases non trouvée, FK non ajoutée';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Impossible d''ajouter la FK: %', SQLERRM;
END $$;

-- ================================================
-- PARTIE 2: Supprimer les FK problématiques sur user_decision_usage
-- ================================================

-- Supprimer la FK vers cycle_vie_purchases
ALTER TABLE user_decision_usage 
DROP CONSTRAINT IF EXISTS user_decision_usage_cycle_vie_purchase_id_fkey;

-- Ajouter une colonne purchase_id générique
ALTER TABLE user_decision_usage 
ADD COLUMN IF NOT EXISTS purchase_id UUID;

-- Tenter de créer une FK vers purchases
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'purchases') THEN
        ALTER TABLE user_decision_usage 
        ADD CONSTRAINT user_decision_usage_purchase_id_fkey 
        FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON DELETE SET NULL;
        RAISE NOTICE 'FK vers purchases ajoutée sur user_decision_usage';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Impossible d''ajouter la FK: %', SQLERRM;
END $$;

-- ================================================
-- PARTIE 3: Mettre à jour fn_grant_decision_credits
-- ================================================

CREATE OR REPLACE FUNCTION fn_grant_decision_credits(
    p_user_id UUID,
    p_purchase_id UUID,
    p_plan_type TEXT
) RETURNS INTEGER AS $$
DECLARE
    v_credits INTEGER;
    v_expiry_days INTEGER := 90;
BEGIN
    -- Récupérer le nombre de crédits pour ce plan
    SELECT decision_credits_included INTO v_credits
    FROM pricing_plans
    WHERE plan_type = p_plan_type AND is_active = true;
    
    IF v_credits IS NULL OR v_credits = 0 THEN
        RETURN 0;
    END IF;
    
    -- Récupérer la durée d'expiration depuis app_config si disponible
    BEGIN
        SELECT (value::TEXT)::INTEGER INTO v_expiry_days
        FROM app_config WHERE key = 'decision_credits_expiry_days';
    EXCEPTION WHEN OTHERS THEN
        v_expiry_days := 90;
    END;
    
    IF v_expiry_days IS NULL THEN
        v_expiry_days := 90;
    END IF;
    
    -- Créer l'entrée de crédits (sans FK vers cycle_vie_purchases)
    INSERT INTO user_decision_credits (
        user_id, 
        purchase_id, -- Nouvelle colonne générique
        credits_initial, 
        credits_remaining,
        source_type, 
        source_id, 
        expires_at
    ) VALUES (
        p_user_id, 
        p_purchase_id, 
        v_credits, 
        v_credits,
        'service_bonus', 
        (SELECT id FROM pricing_plans WHERE plan_type = p_plan_type LIMIT 1),
        NOW() + (v_expiry_days || ' days')::INTERVAL
    );
    
    RETURN v_credits;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================
-- PARTIE 4: Mettre à jour fn_consume_decision_credit
-- ================================================

CREATE OR REPLACE FUNCTION fn_consume_decision_credit(
    p_user_id UUID,
    p_decision_type_id UUID,
    p_cycle_type TEXT,
    p_period_number INTEGER,
    p_target_date DATE
) RETURNS JSONB AS $$
DECLARE
    v_credit_id UUID;
    v_remaining INTEGER;
    v_result JSONB;
BEGIN
    -- Chercher un crédit valide (non expiré, avec crédits restants)
    SELECT id, credits_remaining INTO v_credit_id, v_remaining
    FROM user_decision_credits
    WHERE user_id = p_user_id 
      AND credits_remaining > 0
      AND expires_at > NOW()
    ORDER BY expires_at ASC -- Utiliser les plus anciens d'abord
    LIMIT 1
    FOR UPDATE;
    
    IF v_credit_id IS NULL THEN
        -- Pas de crédits disponibles
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Aucun crédit disponible',
            'credit_consumed', false
        );
    END IF;
    
    -- Décrémenter le crédit
    UPDATE user_decision_credits
    SET credits_remaining = credits_remaining - 1,
        updated_at = NOW()
    WHERE id = v_credit_id;
    
    -- Enregistrer l'utilisation
    INSERT INTO user_decision_usage (
        user_id,
        credit_id,
        decision_type_id,
        cycle_type,
        period_number,
        target_date
    ) VALUES (
        p_user_id,
        v_credit_id,
        p_decision_type_id,
        p_cycle_type,
        p_period_number,
        p_target_date
    );
    
    RETURN jsonb_build_object(
        'success', true,
        'message', 'Crédit consommé avec succès',
        'credit_consumed', true,
        'credits_remaining', v_remaining - 1
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================
-- PARTIE 5: Mettre à jour fn_get_decision_credits
-- ================================================

CREATE OR REPLACE FUNCTION fn_get_decision_credits(
    p_user_id UUID
) RETURNS JSONB AS $$
DECLARE
    v_total INTEGER := 0;
    v_used INTEGER := 0;
    v_remaining INTEGER := 0;
    v_earliest_expiry TIMESTAMPTZ;
BEGIN
    -- Calculer les totaux
    SELECT 
        COALESCE(SUM(credits_initial), 0),
        COALESCE(SUM(credits_initial - credits_remaining), 0),
        COALESCE(SUM(credits_remaining), 0),
        MIN(expires_at) FILTER (WHERE credits_remaining > 0 AND expires_at > NOW())
    INTO v_total, v_used, v_remaining, v_earliest_expiry
    FROM user_decision_credits
    WHERE user_id = p_user_id 
      AND expires_at > NOW();
    
    RETURN jsonb_build_object(
        'total_credits', v_total,
        'used_credits', v_used,
        'remaining_credits', v_remaining,
        'is_unlimited', false,
        'expires_soonest', v_earliest_expiry
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================
-- PARTIE 6: Vérification finale
-- ================================================

DO $$
BEGIN
    RAISE NOTICE '=== Vérification des corrections ===';
    
    -- Vérifier fn_grant_decision_credits
    IF EXISTS (SELECT 1 FROM information_schema.routines WHERE routine_name = 'fn_grant_decision_credits') THEN
        RAISE NOTICE '✓ fn_grant_decision_credits mise à jour';
    END IF;
    
    -- Vérifier fn_consume_decision_credit
    IF EXISTS (SELECT 1 FROM information_schema.routines WHERE routine_name = 'fn_consume_decision_credit') THEN
        RAISE NOTICE '✓ fn_consume_decision_credit mise à jour';
    END IF;
    
    -- Vérifier fn_get_decision_credits
    IF EXISTS (SELECT 1 FROM information_schema.routines WHERE routine_name = 'fn_get_decision_credits') THEN
        RAISE NOTICE '✓ fn_get_decision_credits mise à jour';
    END IF;
    
    RAISE NOTICE '=== Corrections terminées ===';
END $$;
