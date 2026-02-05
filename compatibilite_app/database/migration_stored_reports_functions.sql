-- ============================================
-- MIGRATION COMPLÈTE : Système Stored Reports
-- Pour le fonctionnement de "Mes Achats"
-- ============================================

-- 0. Supprimer les anciennes fonctions (pour éviter les conflits de type)
DROP FUNCTION IF EXISTS public.fn_get_user_stored_reports(uuid);
DROP FUNCTION IF EXISTS public.fn_get_stored_report(uuid);
DROP FUNCTION IF EXISTS public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb);

-- 1. Créer la table stored_reports si elle n'existe pas
CREATE TABLE IF NOT EXISTS public.stored_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    payment_id uuid,
    service_type text NOT NULL,
    service_label text NOT NULL,
    report_data jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- 2. Index pour les recherches fréquentes
CREATE INDEX IF NOT EXISTS idx_stored_reports_user_id 
ON public.stored_reports(user_id);

CREATE INDEX IF NOT EXISTS idx_stored_reports_service_type 
ON public.stored_reports(service_type);

-- 3. RLS Policies
ALTER TABLE public.stored_reports ENABLE ROW LEVEL SECURITY;

-- Lecture : utilisateur peut voir ses propres rapports
DROP POLICY IF EXISTS "users_read_own_stored_reports" ON public.stored_reports;
CREATE POLICY "users_read_own_stored_reports" ON public.stored_reports
    FOR SELECT USING (auth.uid() = user_id);

-- Insert : via RPC uniquement (SECURITY DEFINER)
DROP POLICY IF EXISTS "service_role_all_stored_reports" ON public.stored_reports;
CREATE POLICY "service_role_all_stored_reports" ON public.stored_reports
    FOR ALL USING (auth.role() = 'service_role');

-- 4. Fonction pour stocker un rapport
CREATE OR REPLACE FUNCTION public.fn_store_report(
    p_user_id uuid,
    p_payment_id uuid DEFAULT NULL,
    p_service_type text DEFAULT '',
    p_service_label text DEFAULT '',
    p_report_data jsonb DEFAULT '{}'::jsonb,
    p_metadata jsonb DEFAULT '{}'::jsonb
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
    v_report_id uuid;
BEGIN
    INSERT INTO stored_reports (
        user_id,
        payment_id,
        service_type,
        service_label,
        report_data,
        metadata,
        created_at
    ) VALUES (
        p_user_id,
        p_payment_id,
        p_service_type,
        p_service_label,
        p_report_data,
        p_metadata,
        now()
    )
    RETURNING id INTO v_report_id;
    
    RETURN v_report_id;
END;
$$;

-- 5. Fonction pour récupérer les rapports d'un utilisateur
CREATE OR REPLACE FUNCTION public.fn_get_user_stored_reports(
    p_user_id uuid
)
RETURNS SETOF jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
    RETURN QUERY
    SELECT jsonb_build_object(
        'id', sr.id,
        'user_id', sr.user_id,
        'payment_id', sr.payment_id,
        'service_type', sr.service_type,
        'service_label', sr.service_label,
        'report_data', sr.report_data,
        'metadata', sr.metadata,
        'created_at', sr.created_at
    )
    FROM stored_reports sr
    WHERE sr.user_id = p_user_id
    ORDER BY sr.created_at DESC;
END;
$$;

-- 6. Fonction pour récupérer un rapport spécifique
CREATE OR REPLACE FUNCTION public.fn_get_stored_report(
    p_report_id uuid
)
RETURNS SETOF jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
    RETURN QUERY
    SELECT jsonb_build_object(
        'id', sr.id,
        'user_id', sr.user_id,
        'payment_id', sr.payment_id,
        'service_type', sr.service_type,
        'service_label', sr.service_label,
        'report_data', sr.report_data,
        'metadata', sr.metadata,
        'created_at', sr.created_at
    )
    FROM stored_reports sr
    WHERE sr.id = p_report_id;
END;
$$;

-- 7. Accorder les permissions
GRANT EXECUTE ON FUNCTION public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb) TO anon;
GRANT EXECUTE ON FUNCTION public.fn_get_user_stored_reports(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_stored_report(uuid) TO authenticated;

-- 8. Commentaires
COMMENT ON TABLE public.stored_reports IS 'Rapports stockés après achat - affichés dans Mes Achats';
COMMENT ON FUNCTION public.fn_store_report IS 'Stocke un rapport après achat';
COMMENT ON FUNCTION public.fn_get_user_stored_reports IS 'Récupère tous les rapports d''un utilisateur';
COMMENT ON FUNCTION public.fn_get_stored_report IS 'Récupère un rapport par son ID';
