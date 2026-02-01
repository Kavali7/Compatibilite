-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT SQL - Service 01 : Portrait de l'Âme
-- Prix Test : 2 FCFA
-- Date : 2026-02-01
-- ═══════════════════════════════════════════════════════════════════════════

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 1 : AJOUT DU PLAN TARIFAIRE (Prix Test)
-- ═════════════════════════════════════════════════════════════════════════

-- Vérifier si le plan existe déjà
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pricing_plans WHERE plan_type = 'portrait_ame'
    ) THEN
        INSERT INTO pricing_plans (
            plan_type,
            name,
            description,
            price_fcfa,
            is_active,
            features
        ) VALUES (
            'portrait_ame',
            'Portrait de l''Âme',
            'Découvrez votre essence profonde, vos talents naturels et vos défis karmiques basés sur les Cycles de Vie ancestraux.',
            2,  -- Prix test : 2 FCFA
            true,
            '["Période Soul personnalisée", "Dons naturels", "Défis karmiques", "Vocations favorables", "Affinités géographiques"]'
        );
        RAISE NOTICE 'Plan portrait_ame créé avec prix test 2 FCFA';
    ELSE
        -- Mettre à jour le prix test si le plan existe
        UPDATE pricing_plans 
        SET price_fcfa = 2,
            is_active = true,
            name = 'Portrait de l''Âme',
            description = 'Découvrez votre essence profonde, vos talents naturels et vos défis karmiques basés sur les Cycles de Vie ancestraux.'
        WHERE plan_type = 'portrait_ame';
        RAISE NOTICE 'Plan portrait_ame mis à jour avec prix test 2 FCFA';
    END IF;
END $$;

-- ═════════════════════════════════════════════════════════════════════════
-- PARTIE 2 : VÉRIFICATION
-- ═════════════════════════════════════════════════════════════════════════

-- Vérifier que le plan a été créé
SELECT 
    id,
    plan_type,
    name,
    price_fcfa,
    is_active,
    description
FROM pricing_plans 
WHERE plan_type = 'portrait_ame';

-- Afficher tous les plans liés aux cycles de vie
SELECT 
    plan_type,
    name,
    price_fcfa,
    is_active
FROM pricing_plans 
WHERE plan_type LIKE '%cycle%' OR plan_type LIKE '%portrait%'
ORDER BY plan_type;
