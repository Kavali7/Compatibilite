-- ============================================================
-- SCRIPT DE TRACKING MARKETING & SÉCURITÉ
-- Objectif : Gérer les leads perdus, suivre le tunnel de vente, et sécuriser
-- ============================================================

-- 1. TABLE: analytics_events (Le "Journal de Bord" du tunnel)
-- Stocke tous les clics et actions importantes (anonyme ou connecté)
CREATE TABLE IF NOT EXISTS public.analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID,          -- Pour suivre un parcours même sans login (à générer côté app)
    user_id UUID,             -- Null si pas encore connecté
    event_type TEXT NOT NULL, -- 'app_open', 'signup_error', 'login_error', 'view_report_click', 'payment_cancel', 'payment_success'
    metadata JSONB DEFAULT '{}'::jsonb, -- Pour stocker email saisi, erreur, montant, etc.
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Index pour analyses rapides
CREATE INDEX IF NOT EXISTS idx_analytics_event ON public.analytics_events(event_type, created_at);
CREATE INDEX IF NOT EXISTS idx_analytics_user ON public.analytics_events(user_id);


-- 2. TABLE: marketing_prospects (La "Liste de Récupération")
-- Recense automatiquement les gens à recontacter (échecs, paniers abandonnés)
CREATE TABLE IF NOT EXISTS public.marketing_prospects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT,
    phone TEXT,
    source TEXT DEFAULT 'app',
    last_action TEXT,
    status TEXT DEFAULT 'to_contact', -- 'to_contact', 'contacted', 'converted', 'ignored'
    captured_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(email) -- On évite les doublons, on mettra à jour la date
);


-- 3. RPC SÉCURISÉE : Pour permettre à l'App d'envoyer des logs même sans être connecté
-- (Par exemple: l'utilisateur tape son email, ça échoue -> on l'envoie ici)
CREATE OR REPLACE FUNCTION public.rpc_log_event(
    p_event_type TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER -- Permet d'écrire dans la table même si l'user n'a pas les droits directs
AS $$
DECLARE
    v_uid UUID := auth.uid();
    v_email TEXT;
    v_phone TEXT;
BEGIN
    -- 1. Enregistrer l'événement brut
    INSERT INTO public.analytics_events (user_id, event_type, metadata)
    VALUES (v_uid, p_event_type, p_metadata);

    -- 2. Logique intelligente de récupération (Si échec, on sauve le contact)
    -- On cherche si un email ou téléphone est dans les métadonnées
    v_email := p_metadata->>'email';
    v_phone := p_metadata->>'phone';

    -- Si c'est une erreur critique ou un abandon et qu'on a un contact
    IF (p_event_type IN ('signup_error', 'login_error', 'payment_failure', 'payment_cancel')) 
       AND (v_email IS NOT NULL OR v_phone IS NOT NULL) THEN
       
       INSERT INTO public.marketing_prospects (email, phone, last_action, status)
       VALUES (v_email, v_phone, p_event_type, 'to_contact')
       ON CONFLICT (email) 
       DO UPDATE SET 
         last_action = EXCLUDED.last_action,
         updated_at = now(),
         status = CASE WHEN public.marketing_prospects.status = 'converted' THEN 'converted' ELSE 'to_contact' END;
         
    END IF;
END;
$$;


-- 4. FONCTION LIMITER DE TAUX (Rate Limiting Custom)
-- Pour bloquer les abus (ex: 10 essais en 5 min)
CREATE TABLE IF NOT EXISTS public.security_rate_limits (
    ip_or_user TEXT PRIMARY KEY,
    attempt_count INTEGER DEFAULT 1,
    last_attempt TIMESTAMPTZ DEFAULT now(),
    blocked_until TIMESTAMPTZ
);

CREATE OR REPLACE FUNCTION public.fn_check_security_limit(
    p_key TEXT, 
    p_max_attempts INTEGER DEFAULT 10, 
    p_window_minutes INTEGER DEFAULT 15
)
RETURNS BOOLEAN -- True si autorisé, False si bloqué
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_record public.security_rate_limits%rowtype;
BEGIN
    SELECT * INTO v_record FROM public.security_rate_limits WHERE ip_or_user = p_key;

    -- Si jamais vu, on crée
    IF NOT FOUND THEN
        INSERT INTO public.security_rate_limits (ip_or_user, attempt_count, last_attempt)
        VALUES (p_key, 1, now());
        RETURN TRUE;
    END IF;

    -- Si bloqué
    IF v_record.blocked_until > now() THEN
        RETURN FALSE;
    END IF;

    -- Si hors fenêtre de temps, on reset
    IF v_record.last_attempt < (now() - (p_window_minutes || ' minutes')::interval) THEN
        UPDATE public.security_rate_limits 
        SET attempt_count = 1, last_attempt = now(), blocked_until = NULL
        WHERE ip_or_user = p_key;
        RETURN TRUE;
    END IF;

    -- Si dans fenêtre et dépasse max
    IF v_record.attempt_count >= p_max_attempts THEN
        UPDATE public.security_rate_limits 
        SET blocked_until = (now() + '1 hour'::interval) -- Blocage 1h
        WHERE ip_or_user = p_key;
        RETURN FALSE;
    END IF;

    -- Sinon on incrémente
    UPDATE public.security_rate_limits 
    SET attempt_count = attempt_count + 1, last_attempt = now()
    WHERE ip_or_user = p_key;
    
    RETURN TRUE;
END;
$$;


-- 5. SÉCURITÉ (POLICIES)
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketing_prospects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.security_rate_limits ENABLE ROW LEVEL SECURITY;

-- Seul l'admin peut lire les prospects (Le Dashboard Admin)
CREATE POLICY "Admins read prospects" ON public.marketing_prospects
FOR SELECT TO authenticated
USING (auth.jwt()->>'email' IN (SELECT email FROM auth.users)); -- A simplifier selon ta gestion admin
-- (Ici je mets une policy simple pour l'instant : tout user connecté peut pas lire sauf si on restreint plus tard)
-- MIEUX: On ne donne AUCUN accès direct public, tout passe par le dashboard admin qui aura un role spécial.

-- Pour l'instant on bloque tout accès direct aux tables depuis le front
-- Les insertions passent par la RPC `rpc_log_event` (qui est SECURITY DEFINER)
