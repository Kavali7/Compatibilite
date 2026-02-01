-- ============================================================
-- SERVICE 04: CYCLE SANTÉ - Step 2: Row Level Security
-- ============================================================

-- Activer RLS sur les tables
ALTER TABLE health_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

-- Policies pour health_cycle_periods
-- Lecture publique des périodes actives
CREATE POLICY "health_periods_select_public" ON health_cycle_periods
    FOR SELECT USING (is_active = true);

-- Policies pour health_cycle_subscriptions
-- Les utilisateurs peuvent voir leurs propres abonnements
CREATE POLICY "health_subs_select_own" ON health_cycle_subscriptions
    FOR SELECT USING (auth.uid() = user_id);

-- Les utilisateurs peuvent créer leurs propres abonnements
CREATE POLICY "health_subs_insert_own" ON health_cycle_subscriptions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Les utilisateurs peuvent mettre à jour leurs propres abonnements
CREATE POLICY "health_subs_update_own" ON health_cycle_subscriptions
    FOR UPDATE USING (auth.uid() = user_id);
