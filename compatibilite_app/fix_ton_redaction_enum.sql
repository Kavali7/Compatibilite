-- ============================================================
-- CORRECTION: Ajouter 'neutre' à l'enum ton_redaction
-- Le RPC utilise 'neutre' mais l'enum ne le contient pas
-- ============================================================

-- Ajouter 'neutre' à l'enum ton_redaction
ALTER TYPE public.ton_redaction ADD VALUE IF NOT EXISTS 'neutre';

-- Vérifier que la valeur a été ajoutée
SELECT enumlabel FROM pg_enum 
WHERE enumtypid = 'public.ton_redaction'::regtype
ORDER BY enumsortorder;

SELECT '✅ Enum ton_redaction mis à jour avec neutre' as status;
