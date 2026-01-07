-- ============================================================
-- SCRIPT DE RÉORGANISATION & SÉCURITÉ (MASTER SCRIPT)
-- DATE: 2026-01-07
-- AUTHOR: Agent Antigravity
-- DESCRIPTION:
--   1. Sécurise les nouvelles tables (V2) en mode STRICT (Auth UID).
--   2. Sécurise les anciennes tables (V1 - Paiement) en mode AUTHENTIFIED.
--   3. Verrouille la table 'users' custom (obsolète) pour éviter les erreurs.
--   4. Nettoie les configurations en doublon.
-- ============================================================

-- ------------------------------------------------------------
-- 1. NETTOYAGE DES CONFIGURATIONS (SETTINGS)
-- ------------------------------------------------------------
DELETE FROM public.app_settings WHERE key = 'temporal_bonuses'; 
-- On ne garde que 'bonus_temporels' (Français) qui est utilisé par le code Dart actuel.


-- ------------------------------------------------------------
-- 2. SÉCURISATION V2 (Données métier & profils) => STRICT
-- ------------------------------------------------------------

-- A. COUPLE_PROFILES
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS couple_profiles_select_strict ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_strict ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_strict ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_strict ON public.couple_profiles;
-- Nettoyage old policies
DROP POLICY IF EXISTS couple_profiles_select_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_own ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_select_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_insert_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_update_policy ON public.couple_profiles;
DROP POLICY IF EXISTS couple_profiles_delete_policy ON public.couple_profiles;


CREATE POLICY couple_profiles_select_strict ON public.couple_profiles FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY couple_profiles_insert_strict ON public.couple_profiles FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY couple_profiles_update_strict ON public.couple_profiles FOR UPDATE TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY couple_profiles_delete_strict ON public.couple_profiles FOR DELETE TO authenticated USING (user_id = auth.uid());


-- B. GENERATED_REPORTS
ALTER TABLE public.generated_reports ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS generated_reports_select_strict ON public.generated_reports;
-- Nettoyage old policies
DROP POLICY IF EXISTS generated_reports_select_own ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_select_policy ON public.generated_reports;
DROP POLICY IF EXISTS generated_reports_insert_policy ON public.generated_reports;

CREATE POLICY generated_reports_select_strict ON public.generated_reports FOR SELECT TO authenticated USING (user_id = auth.uid());
-- Pas d'INSERT/UPDATE pour generated_reports (géré par RPC Service Role)


-- C. BRICK_USAGE
ALTER TABLE public.brick_usage ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS brick_usage_select_strict ON public.brick_usage;
-- Nettoyage old policies
DROP POLICY IF EXISTS brick_usage_select_own ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_select_policy ON public.brick_usage;
DROP POLICY IF EXISTS brick_usage_insert_policy ON public.brick_usage;

CREATE POLICY brick_usage_select_strict ON public.brick_usage FOR SELECT TO authenticated USING (user_id = auth.uid());


-- ------------------------------------------------------------
-- 3. SÉCURISATION V1 (Paiement & Legacy) => AUTHENTIFIED ONLY
-- Nous remplaçons "Allow anon..." par "authenticated"
-- ------------------------------------------------------------

-- D. PAYMENTS
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
-- Supprimer les anciennes politiques dangereuses "Allow anon..."
DROP POLICY IF EXISTS "Allow anon insert on payments" ON public.payments;
DROP POLICY IF EXISTS "Allow anon select on payments" ON public.payments;
-- Créer nouvelles politiques plus sûres
CREATE POLICY payments_select_own ON public.payments FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY payments_insert_auth ON public.payments FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());


-- E. SUBSCRIPTIONS
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon insert on subscriptions" ON public.subscriptions;
DROP POLICY IF EXISTS "Allow anon select on subscriptions" ON public.subscriptions;

CREATE POLICY subscriptions_select_own ON public.subscriptions FOR SELECT TO authenticated USING (user_id = auth.uid());
-- L'insertion de souscription se fait souvent coté serveur ou via RPC, mais AuthService.dart la fait client-side post-paiement
CREATE POLICY subscriptions_insert_auth ON public.subscriptions FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());


-- F. USER_REPORTS (Table de liaison Paiement <-> Session)
ALTER TABLE public.user_reports ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon insert on user_reports" ON public.user_reports;
DROP POLICY IF EXISTS "Allow anon select on user_reports" ON public.user_reports;

CREATE POLICY user_reports_select_own ON public.user_reports FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY user_reports_insert_auth ON public.user_reports FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());


-- ------------------------------------------------------------
-- 4. VERROUILLAGE TABLE 'USERS' CUSTOM (OBSOLÈTE)
-- ------------------------------------------------------------
-- Cette table ne doit plus être utilisée par le public (remplacée par auth.users).
-- On laisse l'accès au 'service_role' au cas où un script admin en aurait besoin.
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon insert on users" ON public.users;
DROP POLICY IF EXISTS "Allow anon select on users" ON public.users;
DROP POLICY IF EXISTS "Allow anon update on users" ON public.users;

-- Aucune policy publique = Accès bloqué pour anon/authenticated (Deny All implicite).
-- Seul le 'service_role' (clé secrète) pourra y accéder.

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
SELECT 'Réorganisation et sécurisation terminées avec succès' as status;
