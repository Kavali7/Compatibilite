-- Migration: Service Catalog Table
-- Permet de stocker et modifier les services depuis le panneau admin

-- 1. Créer la table service_catalog
CREATE TABLE IF NOT EXISTS public.service_catalog (
    id text PRIMARY KEY,
    name text NOT NULL,
    emoji text NOT NULL DEFAULT '⭐',
    advantages text[] NOT NULL DEFAULT '{}',
    plan_type text,
    screen_route text NOT NULL,
    enabled boolean NOT NULL DEFAULT true,
    display_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- 2. Ajouter un commentaire descriptif
COMMENT ON TABLE public.service_catalog IS 'Configuration des services affichés dans le catalogue';

-- 3. Créer un trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_service_catalog_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_service_catalog_updated_at ON public.service_catalog;
CREATE TRIGGER trigger_update_service_catalog_updated_at
    BEFORE UPDATE ON public.service_catalog
    FOR EACH ROW
    EXECUTE FUNCTION update_service_catalog_updated_at();

-- 4. Politiques RLS
ALTER TABLE public.service_catalog ENABLE ROW LEVEL SECURITY;

-- Lecture publique (tout le monde peut voir les services)
DROP POLICY IF EXISTS "allow_public_read_service_catalog" ON public.service_catalog;
CREATE POLICY "allow_public_read_service_catalog" ON public.service_catalog
    FOR SELECT USING (true);

-- Modification réservée au service_role (admin)
DROP POLICY IF EXISTS "allow_admin_all_service_catalog" ON public.service_catalog;
CREATE POLICY "allow_admin_all_service_catalog" ON public.service_catalog
    FOR ALL USING (auth.role() = 'service_role');

-- 5. Insérer les données initiales des 10 services
INSERT INTO public.service_catalog (id, name, emoji, advantages, plan_type, screen_route, enabled, display_order) VALUES
(
    'compatibilite_couple',
    'Compatibilité Couple',
    '❤️',
    ARRAY['Fini les doutes sur votre relation', 'Comprenez pourquoi certains moments sont difficiles', 'Révélez les forces cachées de votre union', 'Un rapport clair basé sur vos dates de naissance', 'Des milliers de couples ont déjà testé'],
    'consultation',
    'compatibility_wizard',
    true,
    1
),
(
    'previsions_temporelles',
    'Ce Que l''Avenir Réserve À Votre Couple',
    '🔮',
    ARRAY['Anticipez les moments clés avant qu''ils n''arrivent', 'Transformez l''incertitude en clarté', 'Évitez les erreurs de timing qui fragilisent les couples', 'Conseils personnalisés selon votre période', 'Plus de mauvaises surprises'],
    'temporal',
    'temporal_purchase',
    true,
    2
),
(
    'portrait_ame',
    'Qui Êtes-Vous Vraiment',
    '✨',
    ARRAY['Comprenez enfin pourquoi vous réagissez ainsi', 'Identifiez les obstacles qui vous freinent sans le savoir', 'Comprenez vos affinités relationnelles profondes', 'Un rapport de plus de 1 000 mots sur vous seul', 'Basé sur votre date de naissance uniquement'],
    'portrait_ame',
    'portrait_ame_purchase',
    true,
    3
),
(
    'cycle_personnel',
    'Calendrier de Votre Destinée',
    '📅',
    ARRAY['Comprenez pourquoi certaines périodes sont plus dures', 'Anticipez les mois favorables à venir', 'Planifiez vos décisions importantes au bon moment', 'Un cycle complet sur 12 mois', 'Basé sur votre année personnelle'],
    'personal_cycle_annual',
    'personal_cycle_purchase',
    true,
    4
),
(
    'cycle_business',
    'L''Année Business Idéale',
    '💼',
    ARRAY['Anticipez les meilleures périodes pour investir', 'Évitez les mois à risque pour votre activité', 'Planifiez vos lancements aux moments opportuns', 'Vision complète de votre année professionnelle', 'Conseils stratégiques mois par mois'],
    'business_cycle_annual',
    'business_cycle_purchase',
    true,
    5
),
(
    'cycle_sante',
    'Cycle Santé',
    '💚',
    ARRAY['Respectez les rythmes naturels de votre corps', 'Anticipez les périodes de fatigue', 'Optimisez votre énergie au quotidien', 'Conseils bien-être personnalisés', 'Prévention basée sur vos cycles'],
    'health_cycle_annual',
    'health_cycle_purchase',
    true,
    6
),
(
    'guide_horaire',
    'Horloge de Productivité',
    '⏰',
    ARRAY['Format clair et pratique', 'La productivité devient naturelle', 'Optimisez chaque heure de votre journée', 'Conseils adaptés à votre rythme personnel', 'Guide quotidien ou hebdomadaire'],
    'daily_guide_day',
    'daily_guide_purchase',
    true,
    7
),
(
    'eclairage_decision',
    'Guide des Grandes Décisions',
    '💡',
    ARRAY['Des alternatives proposées si le timing n''est pas idéal', 'Avertissements clairs si la période est défavorable', '20 catégories de décisions couvertes', 'Système de crédits flexible', 'Décidez avec sérénité'],
    'decision_credit',
    'decision_advice',
    true,
    8
),
(
    'phases_vie',
    'D''où Venez-Vous, Où Allez-Vous',
    '🔄',
    ARRAY['Comprenez les grandes étapes de votre existence', 'Identifiez où vous en êtes dans votre parcours', 'Anticipez les transitions majeures à venir', 'Vision globale de votre chemin de vie', 'Sagesse des cycles longs'],
    'life_phase_report',
    'life_phases_purchase',
    true,
    9
),
(
    'timing_lunaire',
    'Calendrier Lunaire Personnel',
    '🌙',
    ARRAY['Alignez vos actions avec les phases lunaires', 'Optimisez votre énergie selon la lune', 'Conseils pour chaque phase du cycle', 'Calendrier personnalisé mensuel', 'Connexion avec les rythmes naturels'],
    'lunar_timing_monthly',
    'lunar_timing_purchase',
    true,
    10
)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    emoji = EXCLUDED.emoji,
    advantages = EXCLUDED.advantages,
    plan_type = EXCLUDED.plan_type,
    screen_route = EXCLUDED.screen_route,
    enabled = EXCLUDED.enabled,
    display_order = EXCLUDED.display_order,
    updated_at = now();

-- 6. Accorder les permissions
GRANT SELECT ON public.service_catalog TO anon;
GRANT SELECT ON public.service_catalog TO authenticated;
GRANT ALL ON public.service_catalog TO service_role;
