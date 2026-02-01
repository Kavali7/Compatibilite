-- =============================================
-- ÉTAPE 2: Configurer les politiques RLS
-- =============================================

-- Activer RLS
ALTER TABLE business_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

-- Politiques pour business_cycle_periods (lecture publique)
DROP POLICY IF EXISTS "Periods readable by all" ON business_cycle_periods;
CREATE POLICY "Periods readable by all" ON business_cycle_periods
    FOR SELECT USING (true);

-- Politiques pour business_cycle_subscriptions
DROP POLICY IF EXISTS "Users see own subscriptions" ON business_cycle_subscriptions;
CREATE POLICY "Users see own subscriptions" ON business_cycle_subscriptions
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users insert own subscriptions" ON business_cycle_subscriptions;
CREATE POLICY "Users insert own subscriptions" ON business_cycle_subscriptions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

SELECT 'Politiques RLS configurées!' AS info;
