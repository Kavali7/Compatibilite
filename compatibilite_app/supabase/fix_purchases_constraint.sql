-- =====================================================
-- Script de correction: Ajouter cycles_vie aux types de produits valides
-- Exécuter dans Supabase SQL Editor
-- =====================================================

-- 1. Supprimer l'ancienne contrainte
ALTER TABLE purchases DROP CONSTRAINT IF EXISTS purchases_product_type_check;

-- 2. Recréer la contrainte avec cycles_vie ajouté
-- (les types existants peuvent inclure: rapport_complet, consultation, abonnement, etc.)
ALTER TABLE purchases ADD CONSTRAINT purchases_product_type_check 
  CHECK (product_type IN (
    'rapport_complet',
    'consultation', 
    'abonnement',
    'express',
    'cycles_vie',           -- NOUVEAU TYPE AJOUTÉ
    'cycles_vie_express',   -- Variante express
    'cycles_vie_consultation', -- Variante consultation
    'cycles_vie_abonnement' -- Variante abonnement
  ));

-- Vérification: afficher les types autorisés
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conname = 'purchases_product_type_check';
