-- ============================================================
-- DIAGNOSTIC SYSTÈME (PAYMENTS & RLS)
-- ============================================================

-- 1. Vérifier la table payments
SELECT 'Table payments exists' as check, EXISTS (
   SELECT FROM information_schema.tables 
   WHERE  table_schema = 'public'
   AND    table_name   = 'payments'
) as result;

-- 2. Vérifier si RLS est actif sur payments
SELECT 'RLS Enabled' as check, relrowsecurity as result
FROM pg_class
WHERE oid = 'public.payments'::regclass;

-- 3. Lister les politiques actives sur payments
SELECT polname, polcmd, polroles 
FROM pg_policy 
WHERE polrelid = 'public.payments'::regclass;

-- 4. Vérifier les 5 derniers paiements (pour voir si ça marche pour certains)
SELECT created_at, user_id, amount_fcfa, status, payment_method 
FROM public.payments 
ORDER BY created_at DESC 
LIMIT 5;

-- 5. Vérifier les plans
SELECT name, price_fcfa, is_active FROM public.pricing_plans;
