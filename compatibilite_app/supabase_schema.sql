-- ===========================================
-- SCHEMA SUPABASE - Intégration Paiement Kkiapay
-- ===========================================
-- Exécuter ce script dans l'éditeur SQL de Supabase
-- Dashboard > SQL Editor > New Query

-- ============================================
-- TABLE: pricing_plans (Forfaits configurables)
-- ============================================
CREATE TABLE IF NOT EXISTS pricing_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_type TEXT NOT NULL CHECK (plan_type IN ('consultation', 'subscription')),
  name TEXT NOT NULL,
  price_fcfa INTEGER NOT NULL,
  duration_days INTEGER, -- NULL pour consultation, 30 pour mensuel
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Données initiales
INSERT INTO pricing_plans (plan_type, name, price_fcfa, duration_days) VALUES
  ('consultation', 'Rapport unique', 500, NULL),
  ('subscription', 'Abonnement mensuel', 10000, 30)
ON CONFLICT DO NOTHING;

-- ============================================
-- TABLE: users (Comptes utilisateurs)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

-- Index pour recherche par email
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================
-- TABLE: payments (Historique transactions)
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  session_id UUID, -- Référence vers sessions_compatibilite
  transaction_id TEXT NOT NULL, -- ID Kkiapay
  amount_fcfa INTEGER NOT NULL,
  payment_method TEXT, -- 'momo', 'card', etc.
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'success', 'failed', 'cancelled')),
  plan_type TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Index pour recherche par utilisateur
CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_transaction_id ON payments(transaction_id);

-- ============================================
-- TABLE: subscriptions (Abonnements actifs)
-- ============================================
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan_id UUID REFERENCES pricing_plans(id),
  starts_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL,
  is_active BOOLEAN DEFAULT true,
  payment_id UUID REFERENCES payments(id)
);

-- Index pour recherche d'abonnements actifs
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_active ON subscriptions(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_subscriptions_expires_at ON subscriptions(expires_at);

-- ============================================
-- TABLE: user_reports (Liaison user ↔ rapports)
-- ============================================
CREATE TABLE IF NOT EXISTS user_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID NOT NULL, -- Référence vers sessions_compatibilite
  purchased_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, session_id)
);

-- Index pour recherche par utilisateur
CREATE INDEX IF NOT EXISTS idx_user_reports_user_id ON user_reports(user_id);

-- ============================================
-- POLITIQUES RLS (Row Level Security)
-- ============================================

-- Activer RLS sur toutes les tables
ALTER TABLE pricing_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_reports ENABLE ROW LEVEL SECURITY;

-- Politique publique pour pricing_plans (lecture seule)
CREATE POLICY "Allow public read on pricing_plans"
ON pricing_plans FOR SELECT
TO public
USING (is_active = true);

-- Politique pour users (l'app peut créer et lire)
CREATE POLICY "Allow anon insert on users"
ON users FOR INSERT
TO anon
WITH CHECK (true);

CREATE POLICY "Allow anon select on users"
ON users FOR SELECT
TO anon
USING (true);

CREATE POLICY "Allow anon update on users"
ON users FOR UPDATE
TO anon
USING (true);

-- Politique pour payments
CREATE POLICY "Allow anon insert on payments"
ON payments FOR INSERT
TO anon
WITH CHECK (true);

CREATE POLICY "Allow anon select on payments"
ON payments FOR SELECT
TO anon
USING (true);

-- Politique pour subscriptions
CREATE POLICY "Allow anon insert on subscriptions"
ON subscriptions FOR INSERT
TO anon
WITH CHECK (true);

CREATE POLICY "Allow anon select on subscriptions"
ON subscriptions FOR SELECT
TO anon
USING (true);

-- Politique pour user_reports
CREATE POLICY "Allow anon insert on user_reports"
ON user_reports FOR INSERT
TO anon
WITH CHECK (true);

CREATE POLICY "Allow anon select on user_reports"
ON user_reports FOR SELECT
TO anon
USING (true);

-- ============================================
-- VERIFICATION
-- ============================================
-- Vérifier que les tables ont été créées
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('pricing_plans', 'users', 'payments', 'subscriptions', 'user_reports');

-- Vérifier les forfaits
SELECT * FROM pricing_plans;
