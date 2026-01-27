-- ================================================
-- MIGRATION CYCLES DE VIE - PARTIE 2/4
-- Pricing Plans (prix de test à 5 FCFA)
-- Exécuter après migration_cycles_vie.sql
-- ================================================

-- 1. Ajouter une colonne description si elle n'existe pas
ALTER TABLE pricing_plans 
ADD COLUMN IF NOT EXISTS description TEXT;

-- 2. Supprimer TOUS les CHECK constraints sur plan_type
ALTER TABLE pricing_plans 
DROP CONSTRAINT IF EXISTS pricing_plans_plan_type_check;

ALTER TABLE pricing_plans 
DROP CONSTRAINT IF EXISTS "vérification_type_de_plan_de_tarification";

-- 3. Supprimer les anciens plans cycles_vie s'ils existent (pour éviter les doublons)
DELETE FROM pricing_plans WHERE plan_type LIKE 'cycle_vie_%';

-- 4. Insérer les 4 nouveaux plans tarifaires
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
    );

-- ================================================
-- Vérification
-- ================================================
SELECT 'Plans tarifaires Cycles de Vie créés:' AS status;
SELECT plan_type, name, price_fcfa, is_active 
FROM pricing_plans 
WHERE plan_type LIKE 'cycle_vie_%'
ORDER BY plan_type;
