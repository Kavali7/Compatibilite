-- =============================================
-- MIGRATION: Cycle Business (Service 03)
-- Cycles de Vie - Entreprise
-- Prix test: 2 FCFA (production: 15000-25000 FCFA)
-- =============================================

-- ===================
-- TABLES
-- ===================

-- Table des périodes business
CREATE TABLE IF NOT EXISTS public.business_cycle_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    period_name TEXT NOT NULL,
    theme_central TEXT NOT NULL,
    focus_strategique TEXT NOT NULL,
    energie_business TEXT NOT NULL,
    fenetre_strategique JSONB NOT NULL DEFAULT '{"points": []}',
    actions_recommandees TEXT[] NOT NULL DEFAULT '{}',
    risques_eviter TEXT[] NOT NULL DEFAULT '{}',
    indicateurs_cles JSONB NOT NULL DEFAULT '[]',
    decisions_favorables TEXT[] NOT NULL DEFAULT '{}',
    decisions_defavorables TEXT[] NOT NULL DEFAULT '{}',
    astuce_strategique TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(period_number)
);

-- Table des abonnements business
CREATE TABLE IF NOT EXISTS public.business_cycle_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    company_name TEXT NOT NULL,
    reference_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index
CREATE INDEX IF NOT EXISTS idx_business_subs_user ON business_cycle_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_business_subs_status ON business_cycle_subscriptions(status);

-- ===================
-- RLS POLICIES
-- ===================

ALTER TABLE business_cycle_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_cycle_subscriptions ENABLE ROW LEVEL SECURITY;

-- Lecture des périodes pour tous
DROP POLICY IF EXISTS "business_periods_read" ON business_cycle_periods;
CREATE POLICY "business_periods_read" ON business_cycle_periods 
    FOR SELECT USING (is_active = true);

-- Lecture de ses propres abonnements
DROP POLICY IF EXISTS "business_subs_read_own" ON business_cycle_subscriptions;
CREATE POLICY "business_subs_read_own" ON business_cycle_subscriptions 
    FOR SELECT USING (user_id = auth.uid());

-- Insertion d'abonnement (via fonction RPC)
DROP POLICY IF EXISTS "business_subs_insert" ON business_cycle_subscriptions;
CREATE POLICY "business_subs_insert" ON business_cycle_subscriptions 
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- ===================
-- RPC FUNCTIONS
-- ===================

-- Fonction: Obtenir la période business actuelle
CREATE OR REPLACE FUNCTION fn_get_current_business_period(
    p_reference_date DATE,
    p_today DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_anniversary DATE;
    v_days_since INT;
    v_period_number INT;
    v_day_in_period INT;
    v_days_remaining INT;
    v_period_start DATE;
    v_period_end DATE;
    v_period RECORD;
BEGIN
    -- Calculer le dernier anniversaire
    v_last_anniversary := make_date(
        EXTRACT(YEAR FROM p_today)::INT,
        EXTRACT(MONTH FROM p_reference_date)::INT,
        EXTRACT(DAY FROM p_reference_date)::INT
    );
    
    IF v_last_anniversary > p_today THEN
        v_last_anniversary := v_last_anniversary - INTERVAL '1 year';
    END IF;
    
    -- Jours depuis anniversaire
    v_days_since := p_today - v_last_anniversary;
    
    -- Calcul période (1-7)
    v_period_number := LEAST(7, (v_days_since / 52) + 1);
    v_day_in_period := (v_days_since % 52) + 1;
    v_days_remaining := 52 - v_day_in_period;
    
    -- Dates de la période
    v_period_start := v_last_anniversary + ((v_period_number - 1) * 52);
    v_period_end := v_last_anniversary + (v_period_number * 52) - 1;
    
    -- Récupérer les infos de la période
    SELECT * INTO v_period FROM business_cycle_periods WHERE period_number = v_period_number;
    
    RETURN jsonb_build_object(
        'period_number', v_period_number,
        'period_name', v_period.period_name,
        'theme_central', v_period.theme_central,
        'day_in_period', v_day_in_period,
        'days_remaining', v_days_remaining,
        'period_start_date', v_period_start,
        'period_end_date', v_period_end,
        'focus_strategique', v_period.focus_strategique,
        'energie_business', v_period.energie_business,
        'fenetre_strategique', v_period.fenetre_strategique,
        'actions_recommandees', v_period.actions_recommandees,
        'risques_eviter', v_period.risques_eviter,
        'indicateurs_cles', v_period.indicateurs_cles,
        'decisions_favorables', v_period.decisions_favorables,
        'decisions_defavorables', v_period.decisions_defavorables,
        'astuce_strategique', v_period.astuce_strategique
    );
END;
$$;

-- Fonction: Calendrier annuel business
CREATE OR REPLACE FUNCTION fn_get_business_year_calendar(
    p_reference_date DATE,
    p_today DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_anniversary DATE;
    v_current_period INT;
    v_calendar JSONB := '[]';
    v_period RECORD;
BEGIN
    -- Dernier anniversaire
    v_last_anniversary := make_date(
        EXTRACT(YEAR FROM p_today)::INT,
        EXTRACT(MONTH FROM p_reference_date)::INT,
        EXTRACT(DAY FROM p_reference_date)::INT
    );
    
    IF v_last_anniversary > p_today THEN
        v_last_anniversary := v_last_anniversary - INTERVAL '1 year';
    END IF;
    
    -- Période actuelle
    v_current_period := LEAST(7, ((p_today - v_last_anniversary) / 52) + 1);
    
    -- Construire le calendrier
    FOR v_period IN SELECT * FROM business_cycle_periods ORDER BY period_number LOOP
        v_calendar := v_calendar || jsonb_build_object(
            'period_number', v_period.period_number,
            'period_name', v_period.period_name,
            'theme_central', v_period.theme_central,
            'start_date', v_last_anniversary + ((v_period.period_number - 1) * 52),
            'end_date', v_last_anniversary + (v_period.period_number * 52) - 1,
            'is_current', v_period.period_number = v_current_period
        );
    END LOOP;
    
    RETURN jsonb_build_object(
        'reference_date', p_reference_date,
        'cycle_start', v_last_anniversary,
        'cycle_end', v_last_anniversary + INTERVAL '1 year' - INTERVAL '1 day',
        'current_period', v_current_period,
        'periods', v_calendar
    );
END;
$$;

-- Fonction: Créer un abonnement business
CREATE OR REPLACE FUNCTION fn_create_business_cycle_subscription(
    p_user_id UUID,
    p_company_name TEXT,
    p_reference_date DATE,
    p_payment_id UUID
)
RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_subscription_id UUID;
BEGIN
    INSERT INTO business_cycle_subscriptions (
        user_id, company_name, reference_date, start_date, end_date, payment_id, status
    ) VALUES (
        p_user_id,
        p_company_name,
        p_reference_date,
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '1 year',
        p_payment_id,
        'active'
    )
    RETURNING id INTO v_subscription_id;
    
    RETURN v_subscription_id;
END;
$$;

-- Fonction: Vérifier accès business
CREATE OR REPLACE FUNCTION fn_check_business_cycle_access(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM business_cycle_subscriptions
        WHERE user_id = p_user_id
        AND status = 'active'
        AND end_date >= CURRENT_DATE
    );
END;
$$;

-- ===================
-- PRICING PLAN
-- ===================

INSERT INTO pricing_plans (plan_type, name, description, price_fcfa, duration_days, is_active)
VALUES (
    'business_cycle_annual',
    'Cycle Business - Abonnement Annuel',
    'Accès complet au Cycle Business pour votre entreprise pendant 1 an. Stratégies personnalisées pour chaque phase de votre année d''affaires.',
    2,  -- Prix test (production: 15000-25000)
    365,
    true
)
ON CONFLICT (plan_type) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price_fcfa = EXCLUDED.price_fcfa,
    is_active = EXCLUDED.is_active;

-- ===================
-- SEED DATA - 7 PÉRIODES
-- ===================

-- Période 1: Le Lancement
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    1, 'Le Lancement', 'Initiative et Expansion',
    'Votre entreprise entre dans sa première période stratégique de l''année. Cette phase d''impulsion vous offre l''énergie idéale pour lancer de nouvelles initiatives et prendre des décisions audacieuses.',
    'Cette période est gouvernée par une énergie d''initiative et d''expansion. Les projets lancés maintenant bénéficient d''un momentum favorable. C''est le moment d''agir sur les idées qui mûrissent depuis longtemps.',
    '{"points": ["Nouveaux produits ou services — Lancement idéal", "Partenariats stratégiques — Négociations favorables", "Recrutement clé — Attirer les talents", "Marketing audacieux — Campagnes impactantes", "Expansion géographique — Nouveaux marchés"]}',
    ARRAY['Lancez ce nouveau produit que vous préparez depuis des mois', 'Contactez ce partenaire potentiel — Les premières impressions sont excellentes', 'Investissez dans le marketing — La visibilité acquise sera durable', 'Recrutez des profils ambitieux — Ils apporteront l''énergie nécessaire', 'Présentez votre vision — Réunions d''équipe, présentations clients', 'Signez de nouveaux contrats — Les négociations sont favorables', 'Documentez vos objectifs annuels — Clarté = Focus'],
    ARRAY['Précipitation sans préparation — L''audace n''exclut pas la planification', 'Dispersion — Ne lancez pas 10 projets simultanément', 'Sous-estimation des ressources — Budgétez correctement', 'Ignorer les signaux faibles — Restez attentif au marché'],
    '[{"kpi": "Leads générés", "raison": "Mesure l''impact des nouvelles initiatives"}, {"kpi": "Trafic web/app", "raison": "Visibilité des lancements"}, {"kpi": "Nouvelles signatures", "raison": "Validation du marché"}, {"kpi": "Engagement équipe", "raison": "Adhésion à la vision"}]',
    ARRAY['Lancer de nouveaux produits/services', 'Signer des partenariats stratégiques', 'Investir dans le marketing et la visibilité', 'Recruter des talents clés', 'Ouvrir de nouveaux marchés'],
    ARRAY['Restructurer ou réduire les effectifs', 'Abandonner des projets en cours', 'Se replier sur le cœur de métier exclusivement'],
    'Communiquez votre vision cette période. Les équipes qui comprennent le "pourquoi" sont 3x plus engagées que celles qui ne connaissent que le "quoi".'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 2: La Consolidation
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    2, 'La Consolidation', 'Structure et Rigueur',
    'Votre entreprise entre dans sa période de consolidation. Après l''élan du lancement, il est temps de solidifier les fondations et d''optimiser les processus.',
    'Cette période est gouvernée par une énergie de structure et de rigueur. Les initiatives lancées précédemment doivent maintenant être ancrées dans des systèmes durables.',
    '{"points": ["Processus internes — Documentation, standardisation", "Formation équipe — Montée en compétences", "Systèmes et outils — Infrastructure technique", "Gestion financière — Budgets, cash-flow", "Qualité — Standards et contrôles"]}',
    ARRAY['Documentez vos processus clés — Créez des SOP (Standard Operating Procedures)', 'Formez votre équipe — Investissez dans les compétences', 'Améliorez vos outils — CRM, ERP, outils de collaboration', 'Optimisez votre trésorerie — Revoyez les cycles de paiement', 'Établissez des standards de qualité — Ce qui n''est pas mesuré ne s''améliore pas', 'Renforcez la culture d''entreprise — Valeurs, rituels, communication', 'Sécurisez vos contrats — Revoyez les aspects juridiques'],
    ARRAY['Négliger les fondations pour courir après la croissance', 'Sous-investir dans la formation', 'Ignorer les problèmes de trésorerie', 'Procrastiner sur la documentation'],
    '[{"kpi": "Marge opérationnelle", "raison": "Efficacité des processus"}, {"kpi": "Rotation du personnel", "raison": "Santé de la culture"}, {"kpi": "Satisfaction client", "raison": "Qualité du service"}, {"kpi": "Délais de livraison", "raison": "Performance opérationnelle"}]',
    ARRAY['Investir dans l''infrastructure et les outils', 'Recruter des profils opérationnels', 'Renégocier les contrats fournisseurs', 'Mettre en place des indicateurs de performance'],
    ARRAY['Lancer de nouvelles lignes de produits', 'Expansion agressive', 'Changements stratégiques majeurs'],
    'Un processus bien documenté économise 10x le temps investi à le créer. Cette période est parfaite pour construire cette dette positive.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 3: La Croissance
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    3, 'La Croissance', 'Expansion et Visibilité',
    'Votre entreprise entre dans sa période de croissance maximale. Les fondations consolidées supportent maintenant une expansion vigoureuse.',
    'Cette période est gouvernée par une énergie d''expansion et de visibilité. C''est le moment de pousser les ventes, d''augmenter la notoriété et de conquérir des parts de marché.',
    '{"points": ["Ventes et acquisition — Push commercial", "Marketing intensif — Campagnes majeures", "Partenariats commerciaux — Distribution, affiliation", "Présence médiatique — PR, interviews, conférences", "Réseautage — Événements, salons"]}',
    ARRAY['Intensifiez vos efforts commerciaux — C''est LE moment pour vendre', 'Lancez une campagne marketing majeure — Investissez dans la visibilité', 'Participez à des événements — Salons, conférences, webinaires', 'Développez votre réseau — Chaque connexion compte', 'Sollicitez des témoignages clients — La preuve sociale convertit', 'Explorez de nouveaux canaux — Distribution, marketplaces, partenaires', 'Négociez des contrats d''envergure — Visez plus grand'],
    ARRAY['Croître plus vite que vos capacités — Attention au burnout', 'Négliger la qualité pour la quantité — La réputation se perd vite', 'Sous-estimer les besoins en trésorerie — La croissance consomme du cash', 'Ignorer les signaux d''essoufflement de l''équipe'],
    '[{"kpi": "Chiffre d''affaires", "raison": "Croissance réelle"}, {"kpi": "Coût d''acquisition client (CAC)", "raison": "Efficacité marketing"}, {"kpi": "Nombre de nouveaux clients", "raison": "Expansion de la base"}, {"kpi": "Part de marché", "raison": "Position concurrentielle"}]',
    ARRAY['Augmenter les budgets marketing', 'Recruter des commerciaux', 'Signer des partenariats de distribution', 'Lever des fonds (si nécessaire)'],
    ARRAY['Réduire les effectifs', 'Limiter les investissements', 'Se replier sur l''existant'],
    'Pendant cette période, chaque euro investi en marketing a un retour potentiel 2x supérieur. Osez investir — mais mesurez tout.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 4: L'Optimisation
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    4, 'L''Optimisation', 'Équilibre et Efficience',
    'Votre entreprise entre dans sa période d''optimisation. Après la croissance, il est temps d''améliorer l''efficacité et d''équilibrer les différentes dimensions de l''activité.',
    'Cette période est gouvernée par une énergie d''équilibre et d''efficience. C''est le moment d''optimiser chaque aspect de l''entreprise pour maximiser la rentabilité.',
    '{"points": ["Rentabilité — Améliorer les marges", "Efficacité opérationnelle — Réduire les gaspillages", "Équilibre travail-vie — Pour vous et l''équipe", "Relations clients — Fidélisation, satisfaction", "Partenariats équilibrés — Renégociations"]}',
    ARRAY['Analysez votre rentabilité par produit, client, canal', 'Identifiez les inefficacités — Temps perdu, ressources gaspillées', 'Optimisez votre pricing — Ajustez si nécessaire', 'Améliorez l''expérience client — Fidélisation > Acquisition', 'Équilibrez les charges de travail — Prévenez l''épuisement', 'Renégociez les contrats défavorables', 'Automatisez les tâches répétitives'],
    ARRAY['Optimiser au détriment de la qualité', 'Réduire les coûts de manière aveugle', 'Ignorer le bien-être de l''équipe', 'Négliger les clients existants'],
    '[{"kpi": "Marge nette", "raison": "Rentabilité réelle"}, {"kpi": "Taux de rétention client", "raison": "Fidélisation"}, {"kpi": "Productivité par employé", "raison": "Efficience"}, {"kpi": "NPS (Net Promoter Score)", "raison": "Satisfaction client"}]',
    ARRAY['Optimiser les processus existants', 'Améliorer les marges', 'Investir dans la satisfaction client', 'Renégocier les contrats'],
    ARRAY['Lancer de nouveaux projets majeurs', 'Expansion agressive', 'Changements radicaux'],
    'Un client fidélisé coûte 5x moins qu''un client acquis. Cette période est parfaite pour investir dans la relation client.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 5: L'Analyse
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    5, 'L''Analyse', 'Réflexion et Stratégie',
    'Votre entreprise entre dans sa période d''analyse stratégique. C''est le moment de prendre du recul, d''évaluer objectivement la situation et de planifier les ajustements nécessaires.',
    'Cette période est gouvernée par une énergie de réflexion et d''analyse. Les données accumulées depuis le début du cycle doivent être étudiées pour éclairer les décisions futures.',
    '{"points": ["Analyse de données — KPIs, tendances, patterns", "Veille concurrentielle — Positionnement marché", "Stratégie — Révision et ajustements", "Conseil externe — Mentors, consultants", "Documentation — Capitalisation des apprentissages"]}',
    ARRAY['Faites un audit complet de vos performances depuis l''anniversaire', 'Analysez vos données — Quels patterns émergent ?', 'Consultez des experts — Regard externe précieux', 'Révisez votre stratégie — Ajustez si nécessaire', 'Documentez vos apprentissages — Qu''avez-vous appris ?', 'Planifiez les prochaines étapes pour les périodes 6 et 7', 'Prenez du recul — Temps de réflexion pour le dirigeant'],
    ARRAY['Paralysie par l''analyse — À un moment, il faut décider', 'Ignorer les données négatives — La réalité prime sur les espoirs', 'S''isoler dans la réflexion — Incluez l''équipe', 'Négliger l''action courante'],
    '[{"kpi": "Tendances YoY", "raison": "Évolution sur l''année"}, {"kpi": "ROI par canal", "raison": "Efficacité des investissements"}, {"kpi": "Satisfaction employés", "raison": "Santé organisationnelle"}, {"kpi": "Pipeline futur", "raison": "Visibilité sur l''avenir"}]',
    ARRAY['Engager des consultants/conseillers', 'Réaliser des études de marché', 'Réviser la stratégie', 'Former l''équipe dirigeante'],
    ARRAY['Lancements majeurs', 'Expansion rapide', 'Décisions impulsives'],
    'Les entreprises qui survivent ne sont pas les plus fortes, mais celles qui s''adaptent. Cette période est votre fenêtre d''adaptation.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 6: La Restructuration
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    6, 'La Restructuration', 'Transformation et Changement',
    'Votre entreprise entre dans sa période de restructuration. C''est le moment d''opérer les changements identifiés lors de l''analyse et de préparer le renouveau.',
    'Cette période est gouvernée par une énergie de transformation et de changement. Les insights de la période précédente doivent maintenant se traduire en actions concrètes de restructuration.',
    '{"points": ["Réorganisation — Structure, équipes, processus", "Pivots — Ajustements stratégiques majeurs", "Fins de cycle — Arrêt des projets non performants", "Négociations difficiles — Renégociations, ruptures", "Investissements de transformation"]}',
    ARRAY['Opérez les changements identifiés — N''attendez plus', 'Arrêtez ce qui ne fonctionne pas — Produits, projets, partenariats', 'Réorganisez si nécessaire — Structure, rôles, responsabilités', 'Investissez dans la transformation — Formation, outils, processus', 'Communiquez clairement — L''équipe a besoin de comprendre', 'Préparez le prochain cycle — Vision, objectifs', 'Gérez le changement — Accompagnez les personnes impactées'],
    ARRAY['Résister au changement nécessaire — L''inaction coûte cher', 'Changer pour changer — Seuls les changements justifiés', 'Négliger la communication — L''incertitude tue la motivation', 'Sous-estimer l''impact émotionnel — Les changements affectent les personnes'],
    '[{"kpi": "Coûts de restructuration", "raison": "Maîtrise du budget transformation"}, {"kpi": "Engagement équipe", "raison": "Impact sur le moral"}, {"kpi": "Vélocité du changement", "raison": "Rapidité d''exécution"}, {"kpi": "Quick wins", "raison": "Victoires rapides pour le moral"}]',
    ARRAY['Restructurer l''organisation', 'Arrêter les projets non rentables', 'Renégocier les contrats défavorables', 'Pivoter stratégiquement si nécessaire'],
    ARRAY['Maintenir le statu quo à tout prix', 'Lancer de nouveaux projets', 'Ignorer les signaux de changement'],
    'Le meilleur moment pour restructurer est quand vous pouvez encore choisir comment. Le pire est quand le marché vous y force.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- Période 7: Le Bilan
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central,
    focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter,
    indicateurs_cles, decisions_favorables, decisions_defavorables,
    astuce_strategique
) VALUES (
    7, 'Le Bilan', 'Conclusion et Préparation',
    'Votre entreprise entre dans sa dernière période de l''année. C''est le temps du bilan, de la reconnaissance des accomplissements et de la préparation du prochain cycle.',
    'Cette période est gouvernée par une énergie de conclusion et de préparation. L''année touche à sa fin et il est temps de célébrer les victoires tout en préparant l''avenir.',
    '{"points": ["Bilan annuel — Finances, objectifs, équipe", "Célébration — Reconnaissance des accomplissements", "Planification — Objectifs du prochain cycle", "Relations — Remerciements clients/partenaires", "Préparation — Budget, ressources, stratégie"]}',
    ARRAY['Réalisez le bilan financier complet de l''année', 'Évaluez l''atteinte des objectifs fixés il y a un an', 'Célébrez les réussites avec votre équipe', 'Remerciez clients, partenaires et collaborateurs', 'Définissez les objectifs du prochain cycle', 'Préparez le budget de la nouvelle année', 'Planifiez les lancements pour la Période 1 à venir'],
    ARRAY['Négliger le bilan — Les leçons non apprises se répètent', 'Oublier de célébrer — La reconnaissance motive', 'Se précipiter sur le prochain cycle — Finissez d''abord l''actuel', 'Ignorer les remerciements — Les relations comptent'],
    '[{"kpi": "Résultat net annuel", "raison": "Performance globale"}, {"kpi": "Atteinte des objectifs", "raison": "Taux de réussite"}, {"kpi": "Croissance YoY", "raison": "Tendance générale"}, {"kpi": "Satisfaction équipe", "raison": "Santé organisationnelle"}]',
    ARRAY['Clôturer les projets en cours', 'Définir la stratégie de l''année suivante', 'Distribuer des bonus/récompenses', 'Planifier les investissements futurs'],
    ARRAY['Lancer de nouveaux projets majeurs', 'Prendre des engagements à long terme', 'Ignorer le bilan de l''année'],
    'Les entreprises qui réussissent sur le long terme sont celles qui prennent le temps de réfléchir avant d''agir. Ce bilan est votre moment de sagesse.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    focus_strategique = EXCLUDED.focus_strategique,
    energie_business = EXCLUDED.energie_business,
    fenetre_strategique = EXCLUDED.fenetre_strategique,
    actions_recommandees = EXCLUDED.actions_recommandees,
    risques_eviter = EXCLUDED.risques_eviter,
    indicateurs_cles = EXCLUDED.indicateurs_cles,
    decisions_favorables = EXCLUDED.decisions_favorables,
    decisions_defavorables = EXCLUDED.decisions_defavorables,
    astuce_strategique = EXCLUDED.astuce_strategique;

-- ===================
-- VERIFICATION
-- ===================

-- Vérifier les tables créées
SELECT 'Tables créées:' AS info;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'business_cycle%';

-- Vérifier les données
SELECT 'Périodes insérées:' AS info;
SELECT period_number, period_name, theme_central FROM business_cycle_periods ORDER BY period_number;

-- Vérifier le pricing plan
SELECT 'Pricing plan:' AS info;
SELECT plan_type, name, price_fcfa, is_active FROM pricing_plans WHERE plan_type = 'business_cycle_annual';
