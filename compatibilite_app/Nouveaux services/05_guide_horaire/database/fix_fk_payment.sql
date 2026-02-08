-- Script de correction FK pour daily_guide_purchases
-- À exécuter dans le SQL Editor de Supabase

-- 1. Supprimer la FK qui cause l'erreur
ALTER TABLE daily_guide_purchases
DROP CONSTRAINT IF EXISTS daily_guide_purchases_payment_id_fkey;

-- 2. Vérification
SELECT conname FROM pg_constraint 
WHERE conrelid = 'daily_guide_purchases'::regclass 
AND contype = 'f';
