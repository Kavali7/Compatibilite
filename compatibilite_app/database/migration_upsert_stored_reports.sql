-- ============================================
-- MIGRATION : UPSERT pour Stored Reports
-- Ajoute la logique UPSERT par upsert_key
-- À exécuter dans l'éditeur SQL de Supabase
-- ============================================

-- 1. Ajouter la colonne upsert_key
ALTER TABLE public.stored_reports 
ADD COLUMN IF NOT EXISTS upsert_key TEXT;

-- 2. Ajouter la colonne updated_at
ALTER TABLE public.stored_reports 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- 3. Backfill upsert_key pour les enregistrements existants
-- Chaque service_type génère une clé basée sur les métadonnées disponibles
UPDATE public.stored_reports
SET upsert_key = CASE
    -- Compatibilité : compatibility|nom1|birth1|nom2|birth2
    WHEN service_type = 'compatibility' THEN
        'compatibility|' || 
        COALESCE(LOWER(metadata->>'user1_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'user1_birth_date', 'unknown') || '|' ||
        COALESCE(LOWER(metadata->>'user2_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'user2_birth_date', 'unknown')
    
    -- Portrait Âme : portrait_ame|nom|birthdate
    WHEN service_type = 'portrait_ame' THEN
        'portrait_ame|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Cycle Personnel : cycle_personnel|nom|birthdate
    WHEN service_type = 'cycle_personnel' THEN
        'cycle_personnel|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Cycle Business : cycle_business|nom|birthdate
    WHEN service_type = 'cycle_business' THEN
        'cycle_business|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Cycle Santé : cycle_sante|nom|birthdate
    WHEN service_type = 'cycle_sante' THEN
        'cycle_sante|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Guide Horaire : guide_horaire|nom|birthdate|target_date
    WHEN service_type = 'guide_horaire' THEN
        'guide_horaire|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown') || '|' ||
        COALESCE(metadata->>'target_date', 'unknown')
    
    -- Éclairage Décision : eclairage_decision|decision_type|birthdate
    WHEN service_type = 'eclairage_decision' THEN
        'eclairage_decision|' ||
        COALESCE(LOWER(metadata->>'decision_type'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Phases de Vie : phases_vie|nom|birthdate
    WHEN service_type = 'phases_vie' THEN
        'phases_vie|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Timing Lunaire : lunar_timing|nom|birthdate
    WHEN service_type = 'lunar_timing' THEN
        'lunar_timing|' ||
        COALESCE(LOWER(metadata->>'user_name'), 'unknown') || '|' ||
        COALESCE(metadata->>'birth_date', 'unknown')
    
    -- Prévisions Temporelles : temporal|period_type|target_date
    WHEN service_type = 'temporal_prediction' THEN
        'temporal|' ||
        COALESCE(metadata->>'period_type', 'unknown') || '|' ||
        COALESCE(metadata->>'target_date', 'unknown')
    
    -- Fallback : service_type|id (pour tout service inconnu)
    ELSE service_type || '|' || id::text
END
WHERE upsert_key IS NULL;

-- 4. Rendre upsert_key NOT NULL après le backfill
ALTER TABLE public.stored_reports 
ALTER COLUMN upsert_key SET NOT NULL;

-- 5. Créer la contrainte UNIQUE sur (user_id, upsert_key)
-- D'abord supprimer si elle existe déjà (pour réexécution idempotente)
ALTER TABLE public.stored_reports 
DROP CONSTRAINT IF EXISTS uq_stored_reports_user_upsert_key;

ALTER TABLE public.stored_reports 
ADD CONSTRAINT uq_stored_reports_user_upsert_key UNIQUE (user_id, upsert_key);

-- 6. Index sur upsert_key pour les recherches
CREATE INDEX IF NOT EXISTS idx_stored_reports_upsert_key 
ON public.stored_reports(upsert_key);

-- 7. Remplacer fn_store_report par la version UPSERT
DROP FUNCTION IF EXISTS public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb);

CREATE OR REPLACE FUNCTION public.fn_store_report(
    p_user_id uuid,
    p_payment_id uuid DEFAULT NULL,
    p_service_type text DEFAULT '',
    p_service_label text DEFAULT '',
    p_report_data jsonb DEFAULT '{}'::jsonb,
    p_metadata jsonb DEFAULT '{}'::jsonb,
    p_upsert_key text DEFAULT ''
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
        upsert_key,
        created_at
    ) VALUES (
        p_user_id,
        p_payment_id,
        p_service_type,
        p_service_label,
        p_report_data,
        p_metadata,
        p_upsert_key,
        now()
    )
    ON CONFLICT (user_id, upsert_key)
    DO UPDATE SET
        payment_id = COALESCE(EXCLUDED.payment_id, stored_reports.payment_id),
        service_label = EXCLUDED.service_label,
        report_data = EXCLUDED.report_data,
        metadata = EXCLUDED.metadata,
        updated_at = now()
    RETURNING id INTO v_report_id;
    
    RETURN v_report_id;
END;
$$;

-- 8. Accorder les permissions (nouvelle signature avec 7 paramètres)
GRANT EXECUTE ON FUNCTION public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_store_report(uuid, uuid, text, text, jsonb, jsonb, text) TO anon;

-- 9. Commentaire mis à jour
COMMENT ON FUNCTION public.fn_store_report IS 'Stocke ou met à jour un rapport via UPSERT (clé: user_id + upsert_key)';

-- ============================================
-- VÉRIFICATION POST-MIGRATION
-- ============================================
-- Exécuter ces requêtes pour vérifier :
-- 
-- SELECT upsert_key, service_type, created_at, updated_at 
-- FROM stored_reports 
-- ORDER BY created_at DESC 
-- LIMIT 10;
--
-- SELECT constraint_name, constraint_type 
-- FROM information_schema.table_constraints 
-- WHERE table_name = 'stored_reports' 
-- AND constraint_type = 'UNIQUE';
