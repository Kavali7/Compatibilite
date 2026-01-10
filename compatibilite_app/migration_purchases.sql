-- ============================================================
-- MIGRATION: Table purchases pour tracker tous les achats
-- Permet de centraliser les paiements Kkiapay et FedaPay
-- ============================================================

-- Création de la table purchases
CREATE TABLE IF NOT EXISTS public.purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Type de produit acheté
  product_type TEXT NOT NULL CHECK (product_type IN ('base', 'annee', 'mois', 'jour', 'bundle', 'subscription')),
  
  -- Date de la période (pour les prévisions temporelles)
  period_date DATE,
  
  -- Informations de paiement
  payment_provider TEXT NOT NULL CHECK (payment_provider IN ('kkiapay', 'fedapay')),
  transaction_id TEXT NOT NULL,
  amount_fcfa INT NOT NULL CHECK (amount_fcfa > 0),
  
  -- Statut
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'success', 'failed', 'refunded')),
  
  -- Métadonnées supplémentaires (JSON)
  metadata JSONB DEFAULT '{}',
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Contraintes
  CONSTRAINT purchases_transaction_unique UNIQUE (transaction_id)
);

-- Trigger pour updated_at
DROP TRIGGER IF EXISTS trg_purchases_updated_at ON public.purchases;
CREATE TRIGGER trg_purchases_updated_at
BEFORE UPDATE ON public.purchases
FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

-- Index pour performance
CREATE INDEX IF NOT EXISTS idx_purchases_user_date ON public.purchases (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_purchases_user_product ON public.purchases (user_id, product_type, status);
CREATE INDEX IF NOT EXISTS idx_purchases_status ON public.purchases (status) WHERE status = 'success';

-- ============================================================
-- RLS (Row Level Security)
-- ============================================================

ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;

-- Policy: Les utilisateurs peuvent voir leurs propres achats
DROP POLICY IF EXISTS purchases_select_own ON public.purchases;
CREATE POLICY purchases_select_own
ON public.purchases
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Policy: Insertion via RPC uniquement (SECURITY DEFINER dans les fonctions)
-- Pas de policy INSERT directe pour les clients

-- ============================================================
-- Fonction helper pour vérifier si un utilisateur a acheté un produit
-- ============================================================

CREATE OR REPLACE FUNCTION public.fn_has_purchased(
  p_user_id UUID,
  p_product_type TEXT,
  p_period_date DATE DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  IF p_period_date IS NOT NULL THEN
    RETURN EXISTS (
      SELECT 1 FROM public.purchases
      WHERE user_id = p_user_id
        AND product_type = p_product_type
        AND period_date = p_period_date
        AND status = 'success'
    );
  ELSE
    RETURN EXISTS (
      SELECT 1 FROM public.purchases
      WHERE user_id = p_user_id
        AND product_type = p_product_type
        AND status = 'success'
    );
  END IF;
END;
$$;

-- ============================================================
-- Fonction pour enregistrer un achat (appelée par l'app)
-- ============================================================

CREATE OR REPLACE FUNCTION public.fn_record_purchase(
  p_user_id UUID,
  p_product_type TEXT,
  p_period_date DATE,
  p_payment_provider TEXT,
  p_transaction_id TEXT,
  p_amount_fcfa INT,
  p_metadata JSONB DEFAULT '{}'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_purchase_id UUID;
BEGIN
  INSERT INTO public.purchases (
    user_id,
    product_type,
    period_date,
    payment_provider,
    transaction_id,
    amount_fcfa,
    status,
    metadata
  ) VALUES (
    p_user_id,
    p_product_type,
    p_period_date,
    p_payment_provider,
    p_transaction_id,
    p_amount_fcfa,
    'success',
    p_metadata
  )
  RETURNING id INTO v_purchase_id;
  
  RETURN v_purchase_id;
END;
$$;

-- ============================================================
-- Vue pour les rapports admin (optionnel)
-- ============================================================

CREATE OR REPLACE VIEW public.purchases_summary AS
SELECT 
  DATE_TRUNC('day', created_at) AS purchase_date,
  product_type,
  payment_provider,
  COUNT(*) AS total_purchases,
  SUM(amount_fcfa) AS total_revenue
FROM public.purchases
WHERE status = 'success'
GROUP BY DATE_TRUNC('day', created_at), product_type, payment_provider
ORDER BY purchase_date DESC;
