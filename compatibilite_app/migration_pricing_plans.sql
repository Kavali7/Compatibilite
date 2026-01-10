-- ============================================================
-- MIGRATION: Mise à jour table pricing_plans
-- Ajoute description et currency pour gestion dynamique
-- ============================================================

-- 1. Vérifier si pricing_plans existe, sinon la créer
CREATE TABLE IF NOT EXISTS public.pricing_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_type TEXT NOT NULL CHECK (plan_type IN ('consultation', 'subscription', 'annee', 'mois', 'jour', 'bundle')),
  name TEXT NOT NULL,
  description TEXT,
  price_fcfa INT NOT NULL CHECK (price_fcfa >= 0),
  currency TEXT NOT NULL DEFAULT 'FCFA',
  duration_days INT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Ajouter les nouvelles colonnes si elles n'existent pas
DO $$ 
BEGIN
  -- Ajouter description si manquante
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'pricing_plans' 
                 AND column_name = 'description') THEN
    ALTER TABLE public.pricing_plans ADD COLUMN description TEXT;
  END IF;
  
  -- Ajouter currency si manquante
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'pricing_plans' 
                 AND column_name = 'currency') THEN
    ALTER TABLE public.pricing_plans ADD COLUMN currency TEXT NOT NULL DEFAULT 'FCFA';
  END IF;
  
  -- Ajouter display_order si manquante
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'pricing_plans' 
                 AND column_name = 'display_order') THEN
    ALTER TABLE public.pricing_plans ADD COLUMN display_order INT DEFAULT 0;
  END IF;
END $$;

-- 3. Trigger pour updated_at (si non existant)
CREATE OR REPLACE FUNCTION public.fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_pricing_plans_updated_at ON public.pricing_plans;
CREATE TRIGGER trg_pricing_plans_updated_at
BEFORE UPDATE ON public.pricing_plans
FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

-- 4. RLS (Row Level Security)
ALTER TABLE public.pricing_plans ENABLE ROW LEVEL SECURITY;

-- Tout le monde peut lire les plans actifs
DROP POLICY IF EXISTS pricing_plans_select_all ON public.pricing_plans;
CREATE POLICY pricing_plans_select_all
ON public.pricing_plans FOR SELECT
USING (is_active = true);

-- 5. Insérer les plans par défaut si la table est vide
INSERT INTO public.pricing_plans (plan_type, name, description, price_fcfa, currency, duration_days, display_order)
SELECT * FROM (VALUES
  ('consultation', 'Rapport de Compatibilité', 'Analyse complète de votre compatibilité de couple', 500, 'FCFA', NULL, 1),
  ('annee', 'Prévision Annuelle', 'Vos prévisions détaillées pour toute l''année', 1000, 'FCFA', 365, 2),
  ('mois', 'Prévision Mensuelle', 'Prévisions pour le mois en cours', 500, 'FCFA', 30, 3),
  ('jour', 'Prévision du Jour', 'Guidance pour la journée', 200, 'FCFA', 1, 4),
  ('subscription', 'Abonnement Mensuel', 'Accès illimité à toutes les prévisions', 2000, 'FCFA', 30, 5)
) AS v(plan_type, name, description, price_fcfa, currency, duration_days, display_order)
WHERE NOT EXISTS (SELECT 1 FROM public.pricing_plans LIMIT 1);

-- 6. Créer une table app_settings pour la devise globale
CREATE TABLE IF NOT EXISTS public.app_settings (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Insérer la devise par défaut
INSERT INTO public.app_settings (key, value)
VALUES ('currency', '{"symbol": "FCFA", "position": "after", "locale": "fr-BJ"}')
ON CONFLICT (key) DO NOTHING;

-- RLS pour app_settings (lecture publique)
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS app_settings_select_all ON public.app_settings;
CREATE POLICY app_settings_select_all
ON public.app_settings FOR SELECT
USING (true);

-- ============================================================
-- VÉRIFICATION: Voir les plans actuels
-- ============================================================
-- SELECT * FROM public.pricing_plans ORDER BY display_order;
-- SELECT * FROM public.app_settings;
