-- ============================================================
-- CORRECTION RLS POUR LA TABLE PAYMENTS
-- ============================================================

-- 1. Activer RLS
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer les anciennes politiques (nettoyage)
DROP POLICY IF EXISTS "Allow anon insert on payments" ON public.payments;
DROP POLICY IF EXISTS "Allow anon select on payments" ON public.payments;
DROP POLICY IF EXISTS "payments_select_own" ON public.payments;
DROP POLICY IF EXISTS "payments_insert_auth" ON public.payments;
DROP POLICY IF EXISTS "payments_service_role" ON public.payments;

-- 3. Créer la politique d'INSERTION pour les utilisateurs connectés
-- Permet à l'utilisateur d'enregistrer son propre paiement
CREATE POLICY "payments_insert_auth"
ON public.payments
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- 4. Créer la politique de LECTURE pour les utilisateurs connectés
-- Permet à l'utilisateur de voir ses propres paiements
CREATE POLICY "payments_select_own"
ON public.payments
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- 5. Créer une politique ADMIN (service_role)
-- Permet au backend/admin de tout faire
CREATE POLICY "payments_service_role"
ON public.payments
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
