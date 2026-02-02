-- ============================================================
-- SERVICE 08 : TIMING LUNAIRE - Script SQL Consolidé
-- ============================================================
-- Exécutez ce script dans Supabase SQL Editor
-- ============================================================

-- ============================================================
-- STEP 1: Création des tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.lunar_phases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phase_number INT NOT NULL CHECK (phase_number BETWEEN 1 AND 8),
    phase_name TEXT NOT NULL,
    phase_key TEXT NOT NULL UNIQUE,
    theme TEXT NOT NULL,
    energy_type TEXT NOT NULL,
    full_content TEXT NOT NULL DEFAULT '',
    activities_favorables TEXT[],
    activities_eviter TEXT[],
    conseil TEXT,
    duration_days INT DEFAULT 3,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.lunar_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- STEP 2: RLS Policies
-- ============================================================

ALTER TABLE lunar_phases ENABLE ROW LEVEL SECURITY;
ALTER TABLE lunar_subscriptions ENABLE ROW LEVEL SECURITY;

-- Phases lunaires: lecture publique
CREATE POLICY "lunar_phases_select_public" ON lunar_phases 
    FOR SELECT USING (true);

-- Abonnements: lecture par propriétaire
CREATE POLICY "lunar_subscriptions_select_own" ON lunar_subscriptions 
    FOR SELECT USING (user_id = auth.uid());

-- Abonnements: insertion par utilisateur authentifié
CREATE POLICY "lunar_subscriptions_insert_auth" ON lunar_subscriptions 
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- ============================================================
-- STEP 3: Fonction de calcul de phase lunaire
-- ============================================================

CREATE OR REPLACE FUNCTION fn_get_lunar_phase(check_date DATE DEFAULT CURRENT_DATE)
RETURNS INT AS $$
DECLARE
    known_new_moon DATE := '2024-01-11'; -- Nouvelle Lune de référence
    days_since_new_moon INT;
    lunar_cycle NUMERIC := 29.53; -- Jours dans un cycle lunaire
    day_in_cycle NUMERIC;
    phase INT;
BEGIN
    days_since_new_moon := check_date - known_new_moon;
    day_in_cycle := MOD(days_since_new_moon, lunar_cycle);
    
    -- 8 phases de ~3.7 jours chacune
    phase := FLOOR(day_in_cycle / (lunar_cycle / 8)) + 1;
    RETURN LEAST(phase, 8);
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- STEP 4: Pricing Plan
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pricing_plans WHERE plan_type = 'lunar_timing_monthly') THEN
        INSERT INTO pricing_plans (
            plan_type, 
            name, 
            description,
            price_fcfa, 
            duration_days,
            is_active
        ) VALUES (
            'lunar_timing_monthly',
            'Timing Lunaire - Abonnement Mensuel',
            'Calendrier lunaire personnalisé avec conseils quotidiens selon les 8 phases de la Lune',
            2,  -- Prix test (production: 1500-2000 FCFA)
            30,
            true
        );
    ELSE
        UPDATE pricing_plans SET
            name = 'Timing Lunaire - Abonnement Mensuel',
            description = 'Calendrier lunaire personnalisé avec conseils quotidiens selon les 8 phases de la Lune',
            price_fcfa = 2,
            duration_days = 30,
            is_active = true
        WHERE plan_type = 'lunar_timing_monthly';
    END IF;
END $$;

-- ============================================================
-- STEP 5: Seed Data - Les 8 Phases Lunaires
-- ============================================================

INSERT INTO lunar_phases (phase_number, phase_name, phase_key, theme, energy_type, full_content, activities_favorables, activities_eviter, conseil)
VALUES
(1, 'Nouvelle Lune', 'new_moon', 'Intentions et nouveaux départs', 'Initiation',
 'La Nouvelle Lune marque le début d''un nouveau cycle lunaire. C''est le moment idéal pour planter les graines de vos intentions. La Lune est invisible dans le ciel, représentant le vide fertile qui précède toute création.',
 ARRAY['Définir vos intentions', 'Méditation et visualisation', 'Nouveaux projets', 'Planification stratégique', 'Rituels de manifestation', 'Journaling profond'],
 ARRAY['Lancer des projets majeurs sans préparation', 'Prendre des décisions impulsives', 'Actions publiques et exposées'],
 'Dans le silence de la Nouvelle Lune, plantez les graines de vos rêves. Ce qui est semé maintenant avec intention claire fleurira à la Pleine Lune.'),

(2, 'Premier Croissant', 'waxing_crescent', 'Action et impulsion', 'Action',
 'Le Premier Croissant apparaît dans le ciel, fin sourire de lumière. C''est le signal que l''élan est donné — le temps de passer à l''action sur vos intentions.',
 ARRAY['Premiers pas concrets', 'Défis créatifs', 'Surmonter les obstacles', 'Risques calculés', 'Inscriptions et débuts'],
 ARRAY['Douter et abandonner', 'Ignorer les signes', 'Procrastiner'],
 'L''élan est donné. Avancez avec courage et détermination. Les obstacles sont des tests, pas des stop.'),

(3, 'Premier Quartier', 'first_quarter', 'Décisions et engagement', 'Décision',
 'La Lune est à moitié visible — exactement entre le début et l''accomplissement. C''est le moment des choix décisifs.',
 ARRAY['Prendre des décisions importantes', 'S''engager fermement', 'Résoudre les conflits', 'Ajustements stratégiques', 'Signatures et engagements'],
 ARRAY['L''hésitation', 'La procrastination', 'Éviter les confrontations nécessaires'],
 'Le moment est venu de trancher. Engagez-vous pleinement ou abandonnez clairement. L''entre-deux n''est plus une option.'),

(4, 'Gibbeuse Croissante', 'waxing_gibbous', 'Ajustements et patience', 'Patience',
 'La Lune grossit vers sa plénitude. Le travail est presque accompli, mais les derniers ajustements sont cruciaux.',
 ARRAY['Affiner et peaufiner vos projets', 'Patience et persévérance', 'Préparation finale', 'Analyse des détails', 'Tests et vérifications'],
 ARRAY['Précipiter la finalisation', 'Négliger les détails importants', 'L''impatience destructrice'],
 'La patience paie. Le fruit mûrit sous vos yeux. Affinez les derniers détails — la Pleine Lune approche et avec elle, la récolte.'),

(5, 'Pleine Lune', 'full_moon', 'Culmination et célébration', 'Culmination',
 'La Pleine Lune illumine la nuit de toute sa splendeur. C''est l''apogée du cycle, le moment de la récolte et de la célébration. Ce que vous avez semé à la Nouvelle Lune atteint maintenant sa plénitude.',
 ARRAY['Célébrer les accomplissements', 'Récolter les fruits', 'Rituels de gratitude', 'Événements sociaux', 'Clarifications'],
 ARRAY['Commencer de nouveaux projets majeurs', 'Décisions sous le coup de l''émotion', 'Conflits et confrontations'],
 'Sous la lumière de la Pleine Lune, célébrez ce que vous avez accompli. La lumière révèle ce qui était caché — accueillez ces vérités avec grâce.'),

(6, 'Gibbeuse Décroissante', 'waning_gibbous', 'Gratitude et partage', 'Partage',
 'La Lune commence à décroître après sa plénitude. C''est le temps de partager les fruits récoltés et d''exprimer la gratitude.',
 ARRAY['Partager connaissances', 'Enseigner et transmettre', 'Exprimer la gratitude', 'Célébrations collectives', 'Dons et générosité'],
 ARRAY['Garder les succès pour soi', 'L''ingratitude et les plaintes', 'Négliger de remercier'],
 'Ce qui a été reçu doit être partagé. La gratitude multiplie les bénédictions. Donnez et vous recevrez encore plus.'),

(7, 'Dernier Quartier', 'last_quarter', 'Lâcher-prise et pardon', 'Libération',
 'La Lune est à nouveau à moitié visible, mais décroissante. C''est le temps du lâcher-prise, du pardon et de l''élimination.',
 ARRAY['Lâcher prise', 'Pardonner', 'Nettoyer et désencombrer', 'Terminer les projets', 'Ruptures nécessaires'],
 ARRAY['S''accrocher au passé', 'Rancune', 'Éviter les confrontations libératrices'],
 'Libérez ce qui vous retient. Le pardon n''est pas un cadeau aux autres, c''est un cadeau à vous-même. Le lâcher-prise ouvre la porte au renouveau.'),

(8, 'Dernier Croissant', 'waning_crescent', 'Repos et préparation', 'Repos',
 'La Lune s''efface progressivement, fin croissant avant l''obscurité. C''est le temps du repos profond et de la préparation intérieure au nouveau cycle.',
 ARRAY['Repos et récupération', 'Méditation profonde', 'Introspection et bilan', 'Préparation des nouvelles intentions', 'Activités spirituelles'],
 ARRAY['Nouvelles initiatives majeures', 'Suractivité et agitation', 'Ignorer les besoins de repos', 'Décisions importantes'],
 'Dans le silence qui précède le renouveau, écoutez la voix intérieure. Votre âme prépare le prochain cycle. Accordez-vous le repos que vous méritez.')

ON CONFLICT (phase_key) DO UPDATE SET
    phase_name = EXCLUDED.phase_name,
    theme = EXCLUDED.theme,
    energy_type = EXCLUDED.energy_type,
    full_content = EXCLUDED.full_content,
    activities_favorables = EXCLUDED.activities_favorables,
    activities_eviter = EXCLUDED.activities_eviter,
    conseil = EXCLUDED.conseil;

-- ============================================================
-- VÉRIFICATION
-- ============================================================

-- Vérifier les phases
SELECT phase_number, phase_name, theme FROM lunar_phases ORDER BY phase_number;

-- Vérifier le pricing
SELECT plan_type, name, price_fcfa, is_active FROM pricing_plans WHERE plan_type = 'lunar_timing_monthly';

-- Tester la fonction de calcul
SELECT fn_get_lunar_phase(CURRENT_DATE) AS current_phase;
