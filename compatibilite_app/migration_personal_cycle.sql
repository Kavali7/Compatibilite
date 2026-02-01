-- =============================================
-- MIGRATION COMPLÈTE: Cycle Personnel (Service 02)
-- Cycles de Vie - Kbal Compatibilité
-- 
-- Ce script inclut:
-- 1. Création des tables
-- 2. Index et contraintes
-- 3. Politiques RLS
-- 4. Fonctions RPC
-- 5. Entrée pricing_plans
-- 6. Contenu des 7 périodes (seed data)
-- =============================================

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTIE 1: CRÉATION DES TABLES
-- ═══════════════════════════════════════════════════════════════════════════

-- Supprimer les contraintes existantes si rerun
DROP TABLE IF EXISTS personal_cycle_subscriptions CASCADE;
DROP TABLE IF EXISTS personal_cycle_periods CASCADE;

-- Table pour stocker les 7 périodes du cycle personnel
CREATE TABLE public.personal_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identifiant de la période (1-7)
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    
    -- Métadonnées de la période
    period_name TEXT NOT NULL,           -- Ex: "Le Nouveau Départ"
    theme_central TEXT NOT NULL,         -- Ex: "L'Initiation"
    
    -- Durée relative (en jours après anniversaire)
    day_start INT NOT NULL,              -- Ex: 1, 53, 105, etc.
    day_end INT NOT NULL,                -- Ex: 52, 104, 156, etc.
    
    -- Contenu structuré
    energie_periode TEXT NOT NULL,        -- Introduction personnalisée
    description_theme TEXT NOT NULL,      -- Description du thème central
    
    -- Domaines (JSONB)
    domaines_favorables JSONB NOT NULL DEFAULT '{}',   -- {tres_favorables: [], favorables: []}
    domaines_eviter JSONB NOT NULL DEFAULT '{}',       -- {reporter: [], attention: []}
    
    -- Conseils et affirmations
    conseils TEXT[] NOT NULL DEFAULT '{}',
    affirmation TEXT NOT NULL,
    influence_decisions TEXT NOT NULL,
    enseignement TEXT NOT NULL,
    
    -- Métadonnées
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(period_number)
);

-- Index pour recherche rapide
CREATE INDEX idx_personal_cycle_period ON personal_cycle_periods(period_number);

-- Table pour les abonnements au cycle personnel
CREATE TABLE public.personal_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    
    -- Données utilisateur
    user_birthdate DATE NOT NULL,
    user_firstname TEXT,
    
    -- Période d'abonnement
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '1 year'),
    
    -- Paiement associé
    payment_id UUID,
    
    -- Statut
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    auto_renew BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour recherche par utilisateur
CREATE INDEX idx_personal_subs_user ON personal_cycle_subscriptions(user_id);
CREATE INDEX idx_personal_subs_status ON personal_cycle_subscriptions(status);

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTIE 2: POLITIQUES RLS
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE personal_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

-- Périodes lisibles par tous (anon et authenticated)
DROP POLICY IF EXISTS "personal_periods_select_all" ON personal_cycle_periods;
CREATE POLICY "personal_periods_select_all" ON personal_cycle_periods
    FOR SELECT USING (true);

-- Abonnements: lecture par tous (pour vérification sans auth)
DROP POLICY IF EXISTS "personal_subs_select_all" ON personal_cycle_subscriptions;
CREATE POLICY "personal_subs_select_all" ON personal_cycle_subscriptions
    FOR SELECT USING (true);

-- Abonnements: insertion pour authenticated
DROP POLICY IF EXISTS "personal_subs_insert_auth" ON personal_cycle_subscriptions;
CREATE POLICY "personal_subs_insert_auth" ON personal_cycle_subscriptions
    FOR INSERT WITH CHECK (true);

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTIE 3: FONCTIONS RPC
-- ═══════════════════════════════════════════════════════════════════════════

-- Fonction pour calculer la période actuelle basée sur l'anniversaire
CREATE OR REPLACE FUNCTION fn_get_current_personal_period(
    p_birthdate DATE,
    p_target_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(
    period_number INT,
    period_name TEXT,
    theme_central TEXT,
    day_in_period INT,
    days_remaining INT,
    period_start_date DATE,
    period_end_date DATE,
    energie_periode TEXT,
    description_theme TEXT,
    domaines_favorables JSONB,
    domaines_eviter JSONB,
    conseils TEXT[],
    affirmation TEXT,
    influence_decisions TEXT,
    enseignement TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_last_birthday DATE;
    v_days_since INT;
    v_period INT;
    v_day_in_period INT;
    v_period_start DATE;
    v_period_end DATE;
    v_period_info RECORD;
BEGIN
    -- Trouver le dernier anniversaire
    v_last_birthday := make_date(
        EXTRACT(YEAR FROM p_target_date)::INT,
        EXTRACT(MONTH FROM p_birthdate)::INT,
        EXTRACT(DAY FROM p_birthdate)::INT
    );
    
    IF v_last_birthday > p_target_date THEN
        v_last_birthday := v_last_birthday - INTERVAL '1 year';
    END IF;
    
    -- Calculer les jours depuis l'anniversaire
    v_days_since := p_target_date - v_last_birthday;
    
    -- Déterminer la période (1-7)
    v_period := LEAST(7, (v_days_since / 52) + 1);
    v_day_in_period := (v_days_since % 52) + 1;
    
    -- Calculer les dates de début et fin de la période
    v_period_start := v_last_birthday + ((v_period - 1) * 52);
    v_period_end := v_last_birthday + (v_period * 52) - 1;
    
    -- Récupérer les infos de la période
    SELECT * INTO v_period_info FROM personal_cycle_periods 
    WHERE personal_cycle_periods.period_number = v_period
    AND is_active = true;
    
    RETURN QUERY SELECT 
        v_period,
        COALESCE(v_period_info.period_name, 'Période ' || v_period),
        COALESCE(v_period_info.theme_central, ''),
        v_day_in_period,
        52 - v_day_in_period,
        v_period_start,
        v_period_end,
        COALESCE(v_period_info.energie_periode, ''),
        COALESCE(v_period_info.description_theme, ''),
        COALESCE(v_period_info.domaines_favorables, '{}'::JSONB),
        COALESCE(v_period_info.domaines_eviter, '{}'::JSONB),
        COALESCE(v_period_info.conseils, ARRAY[]::TEXT[]),
        COALESCE(v_period_info.affirmation, ''),
        COALESCE(v_period_info.influence_decisions, ''),
        COALESCE(v_period_info.enseignement, '');
END;
$$;

-- Fonction pour obtenir le calendrier annuel complet
CREATE OR REPLACE FUNCTION fn_get_personal_year_calendar(
    p_birthdate DATE,
    p_year INT DEFAULT EXTRACT(YEAR FROM CURRENT_DATE)
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_birthday DATE;
    v_periods JSONB := '[]'::JSONB;
    v_period RECORD;
    i INT;
BEGIN
    -- Anniversaire de l'année spécifiée
    v_birthday := make_date(
        p_year,
        EXTRACT(MONTH FROM p_birthdate)::INT,
        EXTRACT(DAY FROM p_birthdate)::INT
    );
    
    -- Construire le calendrier pour chaque période
    FOR i IN 1..7 LOOP
        SELECT * INTO v_period FROM personal_cycle_periods 
        WHERE period_number = i AND is_active = true;
        
        v_periods := v_periods || jsonb_build_object(
            'period_number', i,
            'period_name', COALESCE(v_period.period_name, 'Période ' || i),
            'theme_central', COALESCE(v_period.theme_central, ''),
            'start_date', (v_birthday + ((i - 1) * 52))::TEXT,
            'end_date', (v_birthday + (i * 52) - 1)::TEXT,
            'affirmation', COALESCE(v_period.affirmation, '')
        );
    END LOOP;
    
    RETURN jsonb_build_object(
        'success', true,
        'birthday', v_birthday,
        'year', p_year,
        'periods', v_periods
    );
END;
$$;

-- Fonction pour créer un abonnement
CREATE OR REPLACE FUNCTION fn_create_personal_cycle_subscription(
    p_user_id UUID,
    p_payment_id UUID,
    p_birthdate DATE,
    p_firstname TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_subscription_id UUID;
    v_start DATE := CURRENT_DATE;
    v_end DATE := CURRENT_DATE + INTERVAL '1 year';
BEGIN
    INSERT INTO personal_cycle_subscriptions (
        user_id, user_birthdate, user_firstname,
        start_date, end_date, payment_id, status
    ) VALUES (
        p_user_id, p_birthdate, p_firstname,
        v_start, v_end, p_payment_id, 'active'
    ) RETURNING id INTO v_subscription_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'subscription_id', v_subscription_id,
        'start_date', v_start,
        'end_date', v_end,
        'calendar', fn_get_personal_year_calendar(p_birthdate)
    );
END;
$$;

-- Fonction pour vérifier l'accès d'un utilisateur
CREATE OR REPLACE FUNCTION fn_check_personal_cycle_access(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM personal_cycle_subscriptions
        WHERE user_id = p_user_id
        AND status = 'active'
        AND end_date >= CURRENT_DATE
    );
END;
$$;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTIE 4: ENTRÉE PRICING PLANS (2 FCFA pour test)
-- ═══════════════════════════════════════════════════════════════════════════

-- Supprimer l'entrée existante si rerun
DELETE FROM pricing_plans WHERE plan_type = 'personal_cycle_annual';

-- Insérer le plan de prix pour le cycle personnel
INSERT INTO pricing_plans (plan_type, name, price_fcfa, is_active, description)
VALUES (
    'personal_cycle_annual', 
    'Cycle Personnel - Abonnement Annuel', 
    2, 
    true,
    'Accès illimité pendant 1 an à votre calendrier personnalisé de 7 périodes avec conseils et guidance pour chaque phase.'
);

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTIE 5: SEED DATA - Les 7 Périodes
-- ═══════════════════════════════════════════════════════════════════════════

-- Période 1: Le Nouveau Départ
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    1, 
    'Le Nouveau Départ', 
    'L''Initiation',
    1, 52,
    'Vous entrez dans la première période de votre cycle annuel personnel. Cette phase marque un nouveau départ, une renaissance énergétique qui vous invite à semer les graines de ce que vous souhaitez récolter dans les mois à venir.',
    'Cette période est gouvernée par une énergie d''impulsion et de commencement. Comme le premier jour du printemps qui éveille la nature endormie, vous ressentez un regain de vitalité et d''enthousiasme. Les projets que vous lancez maintenant portent en eux le potentiel de votre année entière. C''est le moment idéal pour définir vos intentions pour l''année, lancer de nouveaux projets, prendre des initiatives audacieuses et établir de nouvelles habitudes. Les énergies cosmiques vous soutiennent particulièrement dans tout ce qui concerne les commencements. Votre capacité à attirer les opportunités est à son maximum.',
    '{"tres_favorables": ["Nouveaux projets — Tout ce que vous initiez maintenant a de grandes chances de succès", "Rencontres — Les nouvelles relations établies sont durables", "Changements personnels — Nouvelle coiffure, nouveau style, nouvelle image", "Sports et activités physiques — Votre énergie est à son pic"], "favorables": ["Négociations et contrats", "Voyages d''exploration", "Apprentissage de nouvelles compétences", "Investissements à long terme"]}',
    '{"reporter": ["Conclusions — Ce n''est pas le moment de terminer, mais de commencer", "Bilans exhaustifs — Attendez la période 7 pour cela", "Routines établies — Osez sortir de votre zone de confort"], "attention": ["Ne vous dispersez pas dans trop de projets simultanés", "Évitez l''impatience — les graines ont besoin de temps pour germer", "Ne négligez pas la planification au profit de l''action impulsive"]}',
    ARRAY[
        'Fixez 3 objectifs majeurs pour l''année et commencez à travailler dessus immédiatement.',
        'Créez un tableau de vision représentant ce que vous souhaitez manifester.',
        'Rencontrez de nouvelles personnes — participez à des événements, rejoignez des groupes.',
        'Bougez votre corps — l''énergie de cette période demande à être exprimée physiquement.',
        'Documentez vos intentions — écrivez vos projets et relisez-les régulièrement.',
        'Osez demander — les portes s''ouvrent plus facilement pendant cette période.',
        'Célébrez chaque petit pas — reconnaissez les progrès dès qu''ils apparaissent.'
    ],
    'Je suis le créateur de ma réalité. Chaque jour, je plante des graines de succès et de bonheur. L''univers conspire en ma faveur.',
    'Durant cette période, vos décisions concernant les nouveaux départs sont particulièrement bien inspirées. Faites confiance à votre intuition quand il s''agit de changer de travail ou de carrière, déménager dans un nouveau lieu, commencer une nouvelle relation, ou lancer une entreprise. En revanche, les décisions de rupture définitive (divorce, vente finale, fermeture) seraient mieux prises dans une autre période.',
    'La Période 1 vous rappelle que chaque fin est un nouveau commencement. Elle vous enseigne l''art de l''initiation, le courage de faire le premier pas, et la confiance en votre capacité à créer votre propre destinée.'
);

-- Période 2: La Construction
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    2, 
    'La Construction', 
    'Les Fondations',
    53, 104,
    'Vous entrez dans la deuxième période de votre cycle annuel. Après l''élan initial du Nouveau Départ, vient le temps de la construction méthodique. Cette phase vous invite à poser des fondations solides pour vos projets.',
    'Cette période est gouvernée par une énergie de travail patient et de consolidation. Les idées que vous avez semées dans la période précédente demandent maintenant à être cultivées avec soin et régularité. C''est le temps des efforts constants plutôt que des coups d''éclat. C''est le moment idéal pour structurer vos projets, établir des systèmes et des processus, travailler sur les détails pratiques et renforcer vos compétences. Les énergies cosmiques vous soutiennent dans tout ce qui requiert patience et persévérance.',
    '{"tres_favorables": ["Travail méthodique — Les tâches répétitives portent leurs fruits", "Formation et études — L''apprentissage est profond et durable", "Questions financières — Budgets, économies, investissements prudents", "Santé — Établir des routines saines"], "favorables": ["Rénovations et améliorations du foyer", "Relations familiales", "Contrats à long terme", "Documentation et organisation"]}',
    '{"reporter": ["Prises de risque majeures — Ce n''est pas le moment pour l''audace", "Changements impulsifs — Privilégiez la stabilité", "Dépenses inconsidérées — Économisez plutôt"], "attention": ["Ne vous impatientez pas face aux résultats lents", "Évitez de vous comparer aux autres", "Ne négligez pas le repos malgré la charge de travail"]}',
    ARRAY[
        'Créez un planning détaillé pour chaque projet important.',
        'Établissez des routines quotidiennes qui soutiennent vos objectifs.',
        'Mettez de l''ordre dans vos papiers, finances et espaces de vie.',
        'Investissez dans vos compétences — cours, formations, lectures.',
        'Prenez soin de votre corps — cette période demande de l''énergie physique.',
        'Documentez vos progrès — même les petits pas comptent.',
        'Entourez-vous de personnes fiables — la qualité prime sur la quantité.'
    ],
    'Je construis ma vie brique par brique, avec patience et détermination. Chaque effort d''aujourd''hui est un investissement pour demain.',
    'Durant cette période, vos décisions concernant les engagements à long terme sont bien inspirées : achats immobiliers, investissements durables, contrats de travail, engagements relationnels sérieux. Évitez les décisions qui requièrent de la spontanéité ou des risques élevés.',
    'La Période 2 vous enseigne la valeur du travail patient. Elle vous rappelle que les plus grandes réalisations se construisent jour après jour, geste après geste. La discipline devient votre alliée la plus précieuse.'
);

-- Période 3: L'Expansion
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    3, 
    'L''Expansion', 
    'La Croissance',
    105, 156,
    'Vous entrez dans la troisième période de votre cycle annuel. Après le travail de construction, vient le temps de l''expansion et de la croissance. Cette phase vous ouvre des portes et multiplie vos opportunités.',
    'Cette période est gouvernée par une énergie d''expansion et d''abondance. Les fondations que vous avez posées commencent à porter leurs fruits. Vous êtes naturellement attiré vers de nouveaux horizons et de nouvelles possibilités. C''est le moment idéal pour élargir votre cercle social et professionnel, voyager et découvrir de nouveaux environnements, communiquer et partager vos idées, saisir les opportunités qui se présentent. Les énergies cosmiques vous soutiennent dans tout ce qui concerne la communication et les connexions.',
    '{"tres_favorables": ["Relations sociales — Réseautage, nouvelles amitiés", "Communication — Présentations, négociations, ventes", "Voyages — Courts ou longs, tous sont bénéfiques", "Créativité — Expression artistique et innovation"], "favorables": ["Marketing et promotion", "Enseignement et partage de connaissances", "Collaborations et partenariats", "Événements et célébrations"]}',
    '{"reporter": ["Travail solitaire prolongé — Privilégiez les interactions", "Économies strictes — C''est le temps d''investir dans les relations", "Isolement volontaire — Sortez de votre cocon"], "attention": ["Ne vous dispersez pas dans trop de directions", "Évitez les engagements superficiels", "Gardez un ancrage malgré l''euphorie"]}',
    ARRAY[
        'Participez à des événements — conférences, fêtes, réunions.',
        'Contactez d''anciennes relations — ravivez des connexions perdues.',
        'Partagez votre expertise — enseignez, écrivez, présentez.',
        'Planifiez un voyage — même court, le changement de lieu est bénéfique.',
        'Exprimez votre créativité — arts, écriture, musique.',
        'Osez vous montrer — visibilité publique favorable.',
        'Célébrez vos succès — partagez votre joie avec les autres.'
    ],
    'Je m''ouvre aux opportunités infinies que l''univers m''offre. Ma lumière attire naturellement les bonnes personnes et les bonnes circonstances.',
    'Durant cette période, vos décisions concernant l''expansion sont bien inspirées : lancement de nouveaux produits ou services, élargissement de votre marché, nouvelles collaborations, publications et visibilité médiatique. Les décisions de consolidation ou restriction peuvent être reportées.',
    'La Période 3 vous enseigne l''art de saisir les opportunités. Elle vous rappelle que la croissance vient souvent de l''ouverture aux autres et de la volonté de partager ce que vous êtes.'
);

-- Période 4: La Stabilisation
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    4, 
    'La Stabilisation', 
    'L''Équilibre',
    157, 208,
    'Vous entrez dans la quatrième période de votre cycle annuel. Après l''expansion, vient le temps de la stabilisation. Cette phase centrale vous invite à trouver l''équilibre et à consolider vos acquis.',
    'Cette période est gouvernée par une énergie de stabilité et d''harmonie. Vous êtes à mi-chemin de votre cycle annuel, et c''est le moment de faire le point, d''ajuster ce qui doit l''être, et de créer un équilibre durable. C''est le moment idéal pour évaluer vos progrès depuis votre anniversaire, créer de l''harmonie dans tous les domaines de vie, résoudre les conflits en suspens et prendre soin de votre foyer et famille. Les énergies cosmiques vous soutiennent dans tout ce qui concerne l''harmonie et la sécurité.',
    '{"tres_favorables": ["Vie familiale — Relations avec parents, enfants, conjoint", "Foyer — Décoration, achats pour la maison, déménagement", "Équilibre travail-vie — Ajustements nécessaires", "Santé émotionnelle — Guérison, thérapie, réconciliation"], "favorables": ["Questions légales et juridiques", "Partenariats équilibrés", "Investissements immobiliers", "Arts et esthétique"]}',
    '{"reporter": ["Prises de risque extrêmes — Privilégiez la prudence", "Ruptures brusques — Cherchez d''abord l''harmonie", "Nouvelles aventures solitaires — Privilégiez le collectif"], "attention": ["Ne négligez pas vos proches au profit du travail", "Évitez les décisions unilatérales", "Attention aux déséquilibres alimentaires ou de sommeil"]}',
    ARRAY[
        'Faites un bilan à mi-parcours de vos objectifs de l''année.',
        'Investissez dans votre foyer — rendez votre espace de vie harmonieux.',
        'Passez du temps de qualité avec votre famille et vos proches.',
        'Résolvez les conflits qui ont été laissés en suspens.',
        'Équilibrez vos activités — travail, repos, loisirs, relations.',
        'Prenez soin de votre santé — bilans, check-ups, ajustements.',
        'Cultivez la gratitude pour ce que vous avez construit.'
    ],
    'Je crée l''harmonie dans ma vie. J''honore mes besoins et ceux des autres. Mon foyer est mon sanctuaire de paix.',
    'Durant cette période, vos décisions concernant le foyer et la famille sont bien inspirées : achats immobiliers, décisions familiales importantes, partenariats équilibrés, questions de succession ou d''héritage. Les décisions d''expansion agressive sont moins favorables.',
    'La Période 4 vous enseigne l''art de l''équilibre. Elle vous rappelle que le succès véritable inclut l''harmonie dans tous les domaines de vie, pas seulement les accomplissements professionnels.'
);

-- Période 5: La Réflexion
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    5, 
    'La Réflexion', 
    'L''Introspection',
    209, 260,
    'Vous entrez dans la cinquième période de votre cycle annuel. Après la stabilisation, vient le temps de la réflexion profonde. Cette phase vous invite à regarder à l''intérieur et à ajuster votre trajectoire.',
    'Cette période est gouvernée par une énergie de contemplation et d''analyse. C''est le moment de prendre du recul, d''évaluer sincèrement vos progrès, et de faire les ajustements nécessaires pour la suite de votre année. C''est le moment idéal pour faire le point sur vos accomplissements, identifier ce qui fonctionne et ce qui ne fonctionne pas, prendre des décisions concernant l''avenir et vous ressourcer et vous reconnecter à vous-même. Les énergies cosmiques vous soutiennent dans tout ce qui concerne l''analyse et la spiritualité.',
    '{"tres_favorables": ["Introspection — Méditation, journaling, thérapie", "Études et recherches — Approfondir vos connaissances", "Santé mentale — Prendre soin de votre esprit", "Planification stratégique — Réajuster vos objectifs"], "favorables": ["Voyages intérieurs (retraites spirituelles)", "Travail en solo", "Documentation et archivage", "Résolution de problèmes complexes"]}',
    '{"reporter": ["Lancements majeurs — Attendez la période suivante", "Grandes fêtes — Privilégiez l''intimité", "Décisions hâtives — Prenez le temps de réfléchir"], "attention": ["Ne vous isolez pas excessivement", "Évitez la rumination négative", "Acceptez l''aide des autres si nécessaire"]}',
    ARRAY[
        'Tenez un journal — Documentez vos pensées et insights.',
        'Méditez quotidiennement — Même 10 minutes font la différence.',
        'Révisez vos objectifs — Ajustez ce qui doit l''être.',
        'Passez du temps dans la nature — Ressourcez-vous.',
        'Lisez des ouvrages inspirants — Nourrissez votre esprit.',
        'Consultez un mentor ou coach si vous avez besoin de guidance.',
        'Préparez la suite — Planifiez les prochaines étapes.'
    ],
    'Je prends le temps de me connaître profondément. Ma sagesse intérieure me guide vers les meilleures décisions.',
    'Durant cette période, vos décisions concernant les changements de direction sont bien inspirées : réorientation professionnelle, fins de partenariats qui ne fonctionnent plus, ajustements de vie importants. Les décisions d''expansion rapide sont moins favorables.',
    'La Période 5 vous enseigne l''importance de la pause réflexive. Elle vous rappelle que l''action sans réflexion mène souvent à l''épuisement et aux erreurs.'
);

-- Période 6: La Transformation
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    6, 
    'La Transformation', 
    'Le Renouveau',
    261, 312,
    'Vous entrez dans la sixième période de votre cycle annuel. Après la réflexion, vient le temps de la transformation. Cette phase puissante vous invite à lâcher ce qui ne vous sert plus et à embrasser le changement.',
    'Cette période est gouvernée par une énergie de mutation et de renaissance. Les insights gagnés durant la période de réflexion doivent maintenant être traduits en actions concrètes. C''est le temps de transformer les problèmes en solutions. C''est le moment idéal pour lâcher prise sur ce qui ne fonctionne plus, opérer des changements significatifs, résoudre des situations bloquées et vous réinventer. Les énergies cosmiques vous soutiennent dans tout ce qui concerne la transformation et le renouveau.',
    '{"tres_favorables": ["Changements majeurs — Nouvelle direction, nouveau départ", "Résolution de conflits — Débloquer des situations", "Investissements stratégiques — Réallocation de ressources", "Questions légales — Règlements, héritages, litiges"], "favorables": ["Thérapies profondes", "Recherches occultes ou psychologiques", "Négociations difficiles", "Clôture de cycles anciens"]}',
    '{"reporter": ["Maintien du statu quo — C''est le temps du changement", "Nouvelles relations superficielles — Privilégiez la profondeur", "Investissements risqués à court terme"], "attention": ["Ne résistez pas au changement nécessaire", "Évitez les conflits inutiles", "Attention aux émotions intenses"]}',
    ARRAY[
        'Identifiez ce qui doit partir — Habitudes, relations, situations.',
        'Faites le grand ménage — Physique et émotionnel.',
        'Investissez dans votre transformation — Formation, accompagnement.',
        'Affrontez vos peurs — C''est le moment de les traverser.',
        'Créez de nouveaux rituels pour remplacer les anciens.',
        'Acceptez les fins comme des portes vers de nouveaux débuts.',
        'Faites confiance au processus de transformation.'
    ],
    'Je me transforme avec grâce et puissance. Ce qui ne me sert plus quitte ma vie pour faire place à ce qui m''élève.',
    'Durant cette période, vos décisions concernant les transformations profondes sont bien inspirées : ruptures nécessaires, réinventions professionnelles, changements de vie majeurs, résolutions de situations bloquées. Les décisions de préservation à tout prix sont moins favorables.',
    'La Période 6 vous enseigne l''art de la transformation consciente. Elle vous rappelle que la mort symbolique précède toujours la renaissance, et que le lâcher-prise est la porte de la croissance.'
);

-- Période 7: La Récolte
INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central, day_start, day_end,
    energie_periode, description_theme,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, influence_decisions, enseignement
) VALUES (
    7, 
    'La Récolte', 
    'Le Bilan et la Préparation',
    313, 365,
    'Vous entrez dans la septième et dernière période de votre cycle annuel. Après toutes les phases précédentes, vient le temps de la récolte et de la préparation. Cette phase conclut votre année et prépare la suivante.',
    'Cette période est gouvernée par une énergie de conclusion et de sagesse. C''est le moment de regarder tout le chemin parcouru depuis votre dernier anniversaire, de célébrer vos accomplissements, et de vous préparer pour le nouveau cycle qui approche. C''est le moment idéal pour faire le bilan de votre année, célébrer vos réussites, résoudre les situations en suspens et vous préparer pour le prochain cycle. Les énergies cosmiques vous soutiennent dans tout ce qui concerne la conclusion et la sagesse.',
    '{"tres_favorables": ["Bilans — Financiers, professionnels, personnels", "Célébrations — Reconnaître vos accomplissements", "Clôtures — Terminer les projets en cours", "Transmission — Partager votre sagesse acquise"], "favorables": ["Voyages de ressourcement", "Philanthropie et générosité", "Méditation et spiritualité", "Planification du prochain cycle"]}',
    '{"reporter": ["Nouveaux grands projets — Attendez le prochain cycle", "Engagements à long terme — Évaluez d''abord", "Décisions majeures non urgentes"], "attention": ["Ne vous précipitez pas vers la fin", "Évitez de minimiser vos accomplissements", "Prenez le temps de vous reposer"]}',
    ARRAY[
        'Faites un bilan écrit de votre année — succès, apprentissages, défis.',
        'Célébrez vos victoires — Grandes et petites.',
        'Terminez les projets en cours ou décidez consciemment de les abandonner.',
        'Exprimez votre gratitude — Remerciez ceux qui vous ont aidé.',
        'Reposez-vous — Rechargez vos batteries.',
        'Définissez vos intentions pour le prochain cycle.',
        'Faites un acte de générosité — Partagez votre abondance.'
    ],
    'Je récolte les fruits de mes efforts et je remercie l''univers pour cette année riche d''apprentissages. Je suis prêt(e) pour un nouveau cycle de croissance.',
    'Durant cette période, vos décisions concernant les conclusions sont bien inspirées : clôture de contrats et partenariats, ventes et liquidations, résolutions finales, dons et philanthropie. Les décisions de lancement sont mieux gardées pour la période 1.',
    'La Période 7 vous enseigne l''art de la gratitude et du lâcher-prise. Elle vous rappelle que chaque fin est le prélude d''un nouveau commencement, et que la sagesse s''acquiert par l''expérience consciente.'
);

-- ═══════════════════════════════════════════════════════════════════════════
-- VÉRIFICATION FINALE
-- ═══════════════════════════════════════════════════════════════════════════

-- Vérifier les tables créées
SELECT 'Tables créées:' AS info;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'personal_cycle%';

-- Vérifier les données
SELECT 'Périodes insérées:' AS info;
SELECT period_number, period_name, theme_central FROM personal_cycle_periods ORDER BY period_number;

-- Vérifier le pricing plan
SELECT 'Pricing plan:' AS info;
SELECT plan_type, name, price_fcfa, is_active FROM pricing_plans WHERE plan_type = 'personal_cycle_annual';
