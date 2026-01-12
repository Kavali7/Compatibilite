-- ============================================================
-- SCRIPT DE CORRECTION POUR ADMIN PANEL
-- 1. Corrige l'erreur "record new has no field updated_at"
-- 2. Met à jour tous les prix à 1 FCFA pour les tests
-- ============================================================

-- 1. Ajouter la colonne updated_at si elle manque
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'pricing_plans' 
                   AND column_name = 'updated_at') THEN
        ALTER TABLE public.pricing_plans ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT now();
    END IF;
END $$;

-- 2. Mettre tous les plans à 1 FCFA pour le test
UPDATE public.pricing_plans SET price_fcfa = 1;

-- 3. Vérification
SELECT name, price_fcfa, updated_at FROM public.pricing_plans;
