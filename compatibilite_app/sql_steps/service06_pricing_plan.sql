-- =============================================
-- Service 06 - Éclairage Décision : Pricing Plan
-- Prix de TEST: 2 FCFA (à modifier après validation)
-- =============================================

-- Supprimer l'ancien plan s'il existe
DELETE FROM pricing_plans WHERE plan_type = 'decision_credit';

-- Insertion du plan tarifaire pour le Service 06 (prix TEST)
INSERT INTO pricing_plans (plan_type, name, description, price_fcfa, duration_days, is_active)
VALUES (
  'decision_credit',
  'Éclairage Décision',
  'Conseil personnalisé pour vos décisions importantes',
  2,  -- Prix TEST: 2 FCFA
  365,
  true
);

-- Vérification
SELECT * FROM pricing_plans WHERE plan_type = 'decision_credit';
