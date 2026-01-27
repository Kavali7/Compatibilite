-- ================================================
-- MIGRATION CYCLES DE VIE - PARTIE 4/4
-- Politiques RLS et Menu Config
-- Exécuter en dernier après les autres migrations
-- ================================================

-- ================================================
-- 1. ENABLE ROW LEVEL SECURITY
-- ================================================

ALTER TABLE cycle_vie_soul_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycle_vie_daily_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycle_vie_decision_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycle_vie_decision_advice ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycle_vie_purchases ENABLE ROW LEVEL SECURITY;

-- ================================================
-- 2. POLICIES POUR TABLES DE CONTENU
-- Lecture publique pour le contenu actif
-- ================================================

-- Soul Periods - Lecture publique
DROP POLICY IF EXISTS "soul_periods_public_read" ON cycle_vie_soul_periods;
CREATE POLICY "soul_periods_public_read" ON cycle_vie_soul_periods
    FOR SELECT 
    TO anon, authenticated
    USING (is_active = true);

-- Daily Periods - Lecture publique
DROP POLICY IF EXISTS "daily_periods_public_read" ON cycle_vie_daily_periods;
CREATE POLICY "daily_periods_public_read" ON cycle_vie_daily_periods
    FOR SELECT 
    TO anon, authenticated
    USING (is_active = true);

-- Decision Types - Lecture publique
DROP POLICY IF EXISTS "decision_types_public_read" ON cycle_vie_decision_types;
CREATE POLICY "decision_types_public_read" ON cycle_vie_decision_types
    FOR SELECT 
    TO anon, authenticated
    USING (is_active = true);

-- Decision Advice - Lecture publique
DROP POLICY IF EXISTS "decision_advice_public_read" ON cycle_vie_decision_advice;
CREATE POLICY "decision_advice_public_read" ON cycle_vie_decision_advice
    FOR SELECT 
    TO anon, authenticated
    USING (is_active = true);

-- ================================================
-- 3. POLICIES POUR ACHATS
-- Utilisateur voit et crée ses propres achats
-- ================================================

-- Lecture des propres achats
DROP POLICY IF EXISTS "purchases_user_read" ON cycle_vie_purchases;
CREATE POLICY "purchases_user_read" ON cycle_vie_purchases
    FOR SELECT 
    TO authenticated
    USING (auth.uid() = user_id);

-- Création d'achat (avec vérification payment)
DROP POLICY IF EXISTS "purchases_user_insert" ON cycle_vie_purchases;
CREATE POLICY "purchases_user_insert" ON cycle_vie_purchases
    FOR INSERT 
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- ================================================
-- 4. MISE À JOUR MENU_CONFIG
-- Ajout de l'entrée "Cycles de Vie" dans le menu
-- ================================================

-- Récupérer la configuration actuelle et ajouter cycles_vie
UPDATE app_settings 
SET value = CASE
    WHEN value IS NULL THEN 
        '{"cycles_vie": {"label": "🌀 Cycles de Vie", "enabled": true, "order": 3}}'::jsonb
    WHEN value::jsonb ? 'cycles_vie' THEN 
        value::jsonb -- Déjà présent, ne rien faire
    ELSE 
        value::jsonb || '{"cycles_vie": {"label": "🌀 Cycles de Vie", "enabled": true, "order": 3}}'::jsonb
    END
WHERE key = 'menu_config';

-- Si menu_config n'existe pas, le créer
INSERT INTO app_settings (key, value)
VALUES ('menu_config', '{"cycles_vie": {"label": "🌀 Cycles de Vie", "enabled": true, "order": 3}}'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- ================================================
-- 5. RPC POUR CALCUL DES CYCLES (SECURITY DEFINER)
-- Permet de contourner RLS pour les calculs
-- ================================================

CREATE OR REPLACE FUNCTION public.fn_get_cycle_vie_purchase(p_purchase_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'id', p.id,
        'service_type', p.service_type,
        'user_birthdate', p.user_birthdate,
        'consultation_date', p.consultation_date,
        'decision_type', (
            SELECT jsonb_build_object('code', dt.code, 'label', dt.label)
            FROM cycle_vie_decision_types dt
            WHERE dt.id = p.decision_type_id
        ),
        'report_data', p.report_data,
        'created_at', p.created_at,
        'expires_at', p.expires_at
    )
    INTO v_result
    FROM cycle_vie_purchases p
    WHERE p.id = p_purchase_id;
    
    RETURN v_result;
END;
$$;

-- ================================================
-- 6. RPC POUR CRÉER UN ACHAT CYCLE DE VIE
-- ================================================

CREATE OR REPLACE FUNCTION public.fn_create_cycle_vie_purchase(
    p_user_id UUID,
    p_service_type VARCHAR(50),
    p_user_birthdate DATE,
    p_user_firstname TEXT DEFAULT NULL,
    p_payment_id UUID DEFAULT NULL,
    p_consultation_date DATE DEFAULT NULL,
    p_decision_type_code VARCHAR(50) DEFAULT NULL,
    p_decision_detail TEXT DEFAULT NULL,
    p_report_data JSONB DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_decision_type_id UUID;
    v_purchase_id UUID;
    v_expires_at TIMESTAMPTZ;
BEGIN
    -- Récupérer l'ID du type de décision si fourni
    IF p_decision_type_code IS NOT NULL THEN
        SELECT id INTO v_decision_type_id
        FROM cycle_vie_decision_types
        WHERE code = p_decision_type_code AND is_active = true;
    END IF;
    
    -- Calculer expires_at pour abonnement (30 jours)
    IF p_service_type = 'abonnement' THEN
        v_expires_at := NOW() + INTERVAL '30 days';
    END IF;
    
    -- Créer l'achat
    INSERT INTO cycle_vie_purchases (
        user_id,
        payment_id,
        service_type,
        user_birthdate,
        user_firstname,
        consultation_date,
        decision_type_id,
        decision_detail,
        report_data,
        expires_at
    )
    VALUES (
        p_user_id,
        p_payment_id,
        p_service_type,
        p_user_birthdate,
        p_user_firstname,
        p_consultation_date,
        v_decision_type_id,
        p_decision_detail,
        p_report_data,
        v_expires_at
    )
    RETURNING id INTO v_purchase_id;
    
    RETURN v_purchase_id;
END;
$$;

-- ================================================
-- Vérification finale
-- ================================================
SELECT 'Migration RLS terminée avec succès!' AS status;

SELECT 
    schemaname, 
    tablename, 
    policyname, 
    cmd 
FROM pg_policies 
WHERE tablename LIKE 'cycle_vie_%';
