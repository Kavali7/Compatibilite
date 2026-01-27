-- ================================================
-- MIGRATION CYCLES DE VIE - PARTIE 2/4
-- Pricing Plans (prix de test à 5 FCFA)
-- Exécuter après migration_cycles_vie.sql
-- ================================================

-- Insérer les 4 plans tarifaires pour les services Cycles de Vie
-- Prix initiaux à 5 FCFA pour les tests, modifiables depuis le panneau admin

INSERT INTO pricing_plans (plan_type, name, description, price_fcfa, is_active, duration_days)
VALUES 
    (
        'cycle_vie_express', 
        'Lecture Express Cycles', 
        'Découvrez votre cycle du jour avec les heures clés favorables et défavorables. Service idéal pour optimiser votre journée.', 
        5, 
        true, 
        NULL
    ),
    (
        'cycle_vie_strategique', 
        'Lecture Stratégique Cycles', 
        'Analyse complète de votre profil Soul Cycle + tous vos cycles actuels (personnel, business, santé). Comprenez vos rythmes de vie.', 
        5, 
        true, 
        NULL
    ),
    (
        'cycle_vie_consultation', 
        'Consultation Date', 
        'Analyse personnalisée d''une date spécifique pour une décision importante (achat, contrat, voyage...). Recevez des conseils précis.', 
        5, 
        true, 
        NULL
    ),
    (
        'cycle_vie_abonnement', 
        'Abonnement Cycles Premium', 
        'Notifications quotidiennes personnalisées + accès illimité à tous les services Cycles de Vie. L''optimisation de vie au quotidien.', 
        5, 
        true, 
        30
    )
ON CONFLICT (plan_type) 
DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price_fcfa = EXCLUDED.price_fcfa,
    duration_days = EXCLUDED.duration_days,
    is_active = EXCLUDED.is_active;

-- ================================================
-- Vérification
-- ================================================
SELECT 'Plans tarifaires Cycles de Vie créés:' AS status;
SELECT plan_type, name, price_fcfa, is_active 
FROM pricing_plans 
WHERE plan_type LIKE 'cycle_vie_%'
ORDER BY plan_type;
