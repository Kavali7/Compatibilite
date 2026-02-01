-- ===============================================
-- SERVICE 07: PHASES DE VIE (Cycles de 7 ans)
-- ===============================================
-- À exécuter dans Supabase SQL Editor

-- STEP 1: Tables principales
-- ===============================================

CREATE TABLE IF NOT EXISTS public.life_phase_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phase_number INT NOT NULL CHECK (phase_number BETWEEN 1 AND 10),
    phase_name TEXT NOT NULL,
    age_start INT NOT NULL,
    age_end INT NOT NULL,
    theme TEXT NOT NULL,
    full_content TEXT NOT NULL DEFAULT '',
    impacts TEXT[],
    questions_reflection TEXT[],
    travail_guerison TEXT[],
    is_active BOOLEAN DEFAULT true,
    UNIQUE(phase_number)
);

CREATE TABLE IF NOT EXISTS public.life_phase_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    user_birthdate DATE NOT NULL,
    purchase_date TIMESTAMP DEFAULT NOW(),
    payment_id UUID REFERENCES payments(id)
);

-- STEP 2: Row Level Security
-- ===============================================

ALTER TABLE life_phase_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE life_phase_purchases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "phases_select_all" ON life_phase_periods;
CREATE POLICY "phases_select_all" ON life_phase_periods FOR SELECT USING (true);

DROP POLICY IF EXISTS "purchases_own_select" ON life_phase_purchases;
CREATE POLICY "purchases_own_select" ON life_phase_purchases 
    FOR SELECT USING (user_id = auth.uid());

DROP POLICY IF EXISTS "purchases_own_insert" ON life_phase_purchases;
CREATE POLICY "purchases_own_insert" ON life_phase_purchases 
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- STEP 3: Pricing Plan
-- ===============================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pricing_plans WHERE plan_type = 'life_phase_report') THEN
        INSERT INTO pricing_plans (
            plan_type, name, description, 
            price_fcfa, duration_days, is_active
        ) VALUES (
            'life_phase_report',
            'Rapport Phases de Vie',
            'Analyse complète de vos phases de vie (cycles de 7 ans) avec historique et conseils',
            5000,
            36500,
            true
        );
    ELSE
        UPDATE pricing_plans SET
            name = 'Rapport Phases de Vie',
            description = 'Analyse complète de vos phases de vie (cycles de 7 ans) avec historique et conseils',
            price_fcfa = 5000,
            is_active = true
        WHERE plan_type = 'life_phase_report';
    END IF;
END $$;

-- STEP 4: Seed Data - Les 10 Phases de Vie
-- ===============================================

INSERT INTO life_phase_periods (phase_number, phase_name, age_start, age_end, theme, full_content, impacts, questions_reflection, travail_guerison) VALUES
(1, 'L''Enfance', 0, 7, 'Formation de l''identité', 
 'Cette phase représente le socle de votre personnalité. Les expériences vécues durant ces années ont façonné les fondations de qui vous êtes aujourd''hui. Même si vous ne vous souvenez pas de tout consciemment, votre être profond garde la mémoire de chaque moment significatif.',
 ARRAY['Sécurité émotionnelle de base', 'Relation à l''autorité', 'Schémas d''attachement', 'Confiance fondamentale en la vie'],
 ARRAY['Quels souvenirs marquants gardez-vous de cette période?', 'Comment ces expériences influencent-elles vos choix actuels?', 'Y a-t-il des blessures non cicatrisées?'],
 ARRAY['Journaling sur les souvenirs d''enfance', 'Méditation de l''enfant intérieur', 'Dialogue avec les photos d''enfance']),

(2, 'La Croissance', 7, 14, 'Socialisation et apprentissage', 
 'Cette période marque votre entrée dans le monde social. L''école, les amitiés, les premières compétitions ont façonné votre rapport aux autres et votre estime personnelle.',
 ARRAY['Rapport à l''apprentissage', 'Place dans les groupes sociaux', 'Amitiés et rivalités', 'Estime de soi académique'],
 ARRAY['Étiez-vous populaire ou plutôt isolé?', 'Comment viviez-vous l''apprentissage scolaire?', 'Quelles amitiés vous ont marqué?'],
 ARRAY['Réconciliation avec l''élève que vous étiez', 'Guérison des blessures de rejet', 'Reconnaissance de vos talents naturels']),

(3, 'L''Adolescence', 14, 21, 'Quête d''indépendance', 
 'La phase de la rébellion et de la découverte de soi. Vos premières amours, vos premiers choix d''orientation, vos premiers pas vers l''indépendance ont posé les bases de l''adulte en devenir.',
 ARRAY['Relation à l''autorité parentale', 'Premières expériences amoureuses', 'Choix d''orientation', 'Rapport à la liberté'],
 ARRAY['Comment s''est passée votre rébellion?', 'Quelles passions avez-vous découvertes?', 'Quels regrets gardez-vous de cette période?'],
 ARRAY['Pardon pour les erreurs de jeunesse', 'Intégration des passions abandonnées', 'Réconciliation avec l''adolescent intérieur']),

(4, 'Le Jeune Adulte', 21, 28, 'Construction de vie', 
 'Le temps des premiers grands choix de vie: carrière, relations sérieuses, logement. Cette phase pose les fondations de votre vie adulte.',
 ARRAY['Trajectoire professionnelle', 'Choix relationnels majeurs', 'Indépendance financière', 'Vision de la réussite'],
 ARRAY['Les choix de carrière vous ont-ils satisfait?', 'Les engagements pris étaient-ils réfléchis?', 'Avez-vous trouvé votre voie?'],
 ARRAY['Révision des choix de carrière', 'Analyse des patterns relationnels', 'Clarification des valeurs profondes']),

(5, 'La Première Maturité', 28, 35, 'Stabilisation', 
 'La phase où l''on consolide ce qui a été construit. Famille, carrière, patrimoine prennent leur place. C''est aussi le temps des premières responsabilités lourdes.',
 ARRAY['Sentiment de sécurité établi', 'Équilibre travail-vie', 'Responsabilités familiales', 'Position sociale'],
 ARRAY['Avez-vous atteint la stabilité recherchée?', 'Cette stabilité vous épanouit-elle?', 'Quels compromis avez-vous faits?'],
 ARRAY['Réévaluation des compromis', 'Espace pour les rêves mis de côté', 'Équilibre des responsabilités']),

(6, 'La Crise du Milieu', 35, 42, 'Réévaluation profonde', 
 'La fameuse "crise de la quarantaine" commence souvent ici. C''est le temps des grandes remises en question: "Est-ce vraiment la vie que je voulais?"',
 ARRAY['Sens de la vie', 'Remises en question fondamentales', 'Aspirations profondes', 'Authenticité'],
 ARRAY['Vivez-vous la vie que vous vouliez enfant?', 'Quels rêves avez-vous abandonnés?', 'Qu''est-ce qui vous manque vraiment?'],
 ARRAY['Reconnexion aux rêves d''enfance', 'Courage de l''authenticité', 'Permission de changer']),

(7, 'La Sagesse Émergente', 42, 49, 'Transmission', 
 'Le temps de la maturité et du mentorat. Vous avez accumulé assez d''expérience pour guider les autres. C''est aussi le temps de récolter les fruits de vos investissements.',
 ARRAY['Rôle de mentor', 'Contribution à la société', 'Héritage en construction', 'Sagesse acquise'],
 ARRAY['Que transmettez-vous aux générations suivantes?', 'Quel héritage souhaitez-vous laisser?', 'Utilisez-vous votre expérience au service des autres?'],
 ARRAY['Partage actif de l''expérience', 'Mentorat formalisé', 'Documentation de votre sagesse']),

(8, 'L''Accomplissement', 49, 56, 'Récolte des fruits', 
 'C''est la phase où les décennies d''effort portent leurs fruits. Position d''influence, reconnaissance, liberté financière sont souvent au rendez-vous.',
 ARRAY['Position d''influence établie', 'Reconnaissance sociale', 'Liberté financière', 'Légitimité acquise'],
 ARRAY['Récoltez-vous ce que vous avez semé?', 'Comment utilisez-vous votre influence?', 'Êtes-vous satisfait de votre parcours?'],
 ARRAY['Gratitude pour le chemin parcouru', 'Utilisation éthique de l''influence', 'Préparation du legs']),

(9, 'La Sagesse Profonde', 56, 63, 'Héritage spirituel', 
 'Au-delà du matériel, c''est le temps de transmettre la sagesse spirituelle et les valeurs profondes. La réconciliation avec le passé devient prioritaire.',
 ARRAY['Transmission spirituelle', 'Réconciliation avec le passé', 'Paix intérieure', 'Préparation du legs'],
 ARRAY['Quel héritage spirituel transmettez-vous?', 'Êtes-vous en paix avec votre parcours?', 'Avez-vous pardonné et demandé pardon?'],
 ARRAY['Rituels de pardon', 'Documentation des valeurs familiales', 'Transmission des traditions']),

(10, 'La Transcendance', 63, 100, 'Paix intérieure', 
 'La phase finale est celle de l''acceptation sereine et de la préparation à la transition. C''est le temps de la sagesse accomplie et de la transmission ultime.',
 ARRAY['Acceptation de la vie', 'Sérénité face à l''avenir', 'Sagesse accomplie', 'Préparation à la transition'],
 ARRAY['Êtes-vous réconcilié avec la vie dans son ensemble?', 'Quels conseils donneriez-vous aux jeunes?', 'Que souhaitez-vous qu''on retienne de vous?'],
 ARRAY['Méditation sur l''impermanence', 'Transmission des dernières sagesses', 'Célébration de la vie'])

ON CONFLICT (phase_number) DO UPDATE SET
    phase_name = EXCLUDED.phase_name,
    age_start = EXCLUDED.age_start,
    age_end = EXCLUDED.age_end,
    theme = EXCLUDED.theme,
    full_content = EXCLUDED.full_content,
    impacts = EXCLUDED.impacts,
    questions_reflection = EXCLUDED.questions_reflection,
    travail_guerison = EXCLUDED.travail_guerison;

-- STEP 5: Fonction de calcul de phase
-- ===============================================

CREATE OR REPLACE FUNCTION fn_get_current_life_phase(birthdate DATE)
RETURNS INT AS $$
DECLARE
    age_years INT;
BEGIN
    age_years := EXTRACT(YEAR FROM AGE(NOW(), birthdate));
    RETURN LEAST((age_years / 7) + 1, 10);
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- VERIFICATION
-- ===============================================
-- SELECT * FROM life_phase_periods ORDER BY phase_number;
-- SELECT * FROM pricing_plans WHERE plan_type = 'life_phase_report';
