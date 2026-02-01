-- =============================================
-- ÉTAPE 4 (CORRIGÉE): Ajouter le pricing plan
-- =============================================

-- D'abord vérifier si le plan existe déjà
SELECT plan_type, name, price_fcfa, is_active FROM pricing_plans WHERE plan_type = 'business_cycle_annual';

-- Si le résultat ci-dessus retourne 0 row, exécuter cet INSERT:
INSERT INTO pricing_plans (plan_type, name, description, price_fcfa, duration_days, is_active)
VALUES (
    'business_cycle_annual',
    'Cycle Business Annuel',
    'Accès complet au cycle business pendant 1 an',
    2,  -- Prix de test: 2 FCFA
    365,
    true
);

-- Si le plan existe déjà et que vous voulez le mettre à jour, utilisez plutôt:
-- UPDATE pricing_plans 
-- SET name = 'Cycle Business Annuel',
--     description = 'Accès complet au cycle business pendant 1 an',
--     price_fcfa = 2,
--     duration_days = 365,
--     is_active = true
-- WHERE plan_type = 'business_cycle_annual';

-- Vérifier le résultat
SELECT plan_type, name, price_fcfa, is_active FROM pricing_plans WHERE plan_type = 'business_cycle_annual';
