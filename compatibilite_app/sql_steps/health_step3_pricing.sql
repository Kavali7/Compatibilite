-- ============================================================
-- SERVICE 04: CYCLE SANTÉ - Step 3: Pricing Plan
-- ============================================================

-- Vérifier si le plan existe déjà et l'ajouter si non
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pricing_plans WHERE plan_type = 'health_cycle_annual') THEN
        INSERT INTO pricing_plans (
            plan_type,
            name,
            description,
            price_fcfa,
            duration_days,
            is_active
        ) VALUES (
            'health_cycle_annual',
            'Cycle Santé - Abonnement Annuel',
            'Découvrez vos 7 périodes de bien-être personnalisées avec conseils alimentation, activités, et recommandations santé.',
            2,  -- Prix test (2 FCFA) - À modifier en production: 5000-8000 FCFA
            365,
            true
        );
    ELSE
        UPDATE pricing_plans SET
            name = 'Cycle Santé - Abonnement Annuel',
            description = 'Découvrez vos 7 périodes de bien-être personnalisées avec conseils alimentation, activités, et recommandations santé.',
            price_fcfa = 2,  -- Prix test
            is_active = true
        WHERE plan_type = 'health_cycle_annual';
    END IF;
END $$;
