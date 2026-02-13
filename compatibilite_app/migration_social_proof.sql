-- Migration: Social Proof Configuration Table
-- Permet de gérer les notifications de preuve sociale depuis le panneau admin

-- 1. Créer la table social_proof_config
CREATE TABLE IF NOT EXISTS public.social_proof_config (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    proof_type text NOT NULL CHECK (proof_type IN ('toast', 'badge', 'testimonial')),
    target_screen text NOT NULL CHECK (target_screen IN ('wizard', 'catalog', 'welcome')),
    enabled boolean NOT NULL DEFAULT true,
    display_order int NOT NULL DEFAULT 0,
    region text NOT NULL DEFAULT 'all' CHECK (region IN ('all', 'africa', 'europe')),
    
    -- Toast fields (prénoms, messages, timing)
    first_names text[],
    last_initials text[],
    message_templates text[],
    time_labels text[],
    show_duration_ms int DEFAULT 4000,
    pause_min_ms int DEFAULT 6000,
    pause_max_ms int DEFAULT 12000,
    
    -- Badge fields
    badge_text text,
    badge_counter int,
    badge_counter_label text,
    
    -- Testimonial fields
    testimonial_name text,
    testimonial_text text,
    testimonial_rating int DEFAULT 5 CHECK (testimonial_rating BETWEEN 1 AND 5),
    testimonial_photo_url text,
    
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- 2. Commentaire descriptif
COMMENT ON TABLE public.social_proof_config IS 'Configuration des notifications de preuve sociale (toast, badge, témoignages)';

-- 3. Trigger updated_at
CREATE OR REPLACE FUNCTION update_social_proof_config_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_social_proof_config_updated_at ON public.social_proof_config;
CREATE TRIGGER trigger_update_social_proof_config_updated_at
    BEFORE UPDATE ON public.social_proof_config
    FOR EACH ROW
    EXECUTE FUNCTION update_social_proof_config_updated_at();

-- 4. RLS
ALTER TABLE public.social_proof_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_public_read_social_proof" ON public.social_proof_config;
CREATE POLICY "allow_public_read_social_proof" ON public.social_proof_config
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "allow_admin_all_social_proof" ON public.social_proof_config;
CREATE POLICY "allow_admin_all_social_proof" ON public.social_proof_config
    FOR ALL USING (auth.role() = 'service_role');

-- 5. Données initiales

-- Toast Afrique
INSERT INTO social_proof_config (proof_type, target_screen, region, display_order,
    first_names, last_initials, message_templates, time_labels,
    show_duration_ms, pause_min_ms, pause_max_ms)
VALUES (
    'toast', 'wizard', 'africa', 1,
    ARRAY['Fatou', 'Adama', 'Aïssa', 'Ibrahim', 'Mariam', 'Moussa', 'Aminata', 'Ousmane', 'Nafissatou', 'Abdoulaye', 'Ramatou', 'Issouf', 'Djamila', 'Koffi', 'Binta', 'Youssouf', 'Salimata', 'Dramane', 'Fanta', 'Habib', 'Rokia', 'Souleymane', 'Kadiatou', 'Seydou', 'Aicha', 'Mamadou', 'Fatoumata', 'Boukary', 'Nana', 'Issa'],
    ARRAY['K.', 'D.', 'M.', 'T.', 'B.', 'S.', 'O.', 'C.', 'A.', 'N.', 'H.', 'G.', 'L.', 'Y.', 'F.', 'Z.', 'R.', 'W.', 'P.', 'E.'],
    ARRAY['🎉 {name} vient de découvrir sa compatibilité', '✨ {name} vient d''acheter son rapport', '❤️ {name} et son partenaire connaissent maintenant leur avenir', '💫 {name} a reçu son analyse de couple', '🔮 {name} vient de consulter ses prévisions', '💕 {name} a débloqué son rapport de compatibilité'],
    ARRAY['il y a 2 min', 'il y a 3 min', 'il y a 5 min', 'il y a 7 min', 'il y a 12 min', 'il y a 15 min', 'il y a 20 min', 'il y a 25 min'],
    4000, 6000, 12000
);

-- Toast Europe
INSERT INTO social_proof_config (proof_type, target_screen, region, display_order,
    first_names, last_initials, message_templates, time_labels,
    show_duration_ms, pause_min_ms, pause_max_ms)
VALUES (
    'toast', 'wizard', 'europe', 2,
    ARRAY['Marie', 'Lucas', 'Emma', 'Hugo', 'Léa', 'Thomas', 'Chloé', 'Antoine', 'Sarah', 'Pierre', 'Camille', 'Julien', 'Manon', 'Nicolas', 'Inès', 'Alexandre', 'Jade', 'Raphaël', 'Louise', 'Maxime', 'Clara', 'Paul', 'Eva', 'Nathan', 'Laura', 'Gabriel', 'Sofia', 'Arthur', 'Zoé', 'Louis'],
    ARRAY['M.', 'D.', 'L.', 'B.', 'G.', 'R.', 'P.', 'F.', 'V.', 'C.', 'H.', 'J.', 'S.', 'T.', 'A.', 'N.', 'W.', 'K.', 'E.', 'O.'],
    ARRAY['🎉 {name} vient de découvrir sa compatibilité', '✨ {name} vient d''acheter son rapport', '❤️ {name} et son partenaire connaissent maintenant leur avenir', '💫 {name} a reçu son analyse de couple', '🔮 {name} vient de consulter ses prévisions', '💕 {name} a débloqué son rapport de compatibilité'],
    ARRAY['il y a 2 min', 'il y a 3 min', 'il y a 5 min', 'il y a 7 min', 'il y a 12 min', 'il y a 15 min', 'il y a 20 min', 'il y a 25 min'],
    4000, 6000, 12000
);

-- Badge pour le service compatibilite_couple
INSERT INTO social_proof_config (proof_type, target_screen, region, display_order,
    badge_text, badge_counter, badge_counter_label)
VALUES (
    'badge', 'catalog', 'all', 1,
    '🔥 Populaire', 2847, 'analyses cette semaine'
);

-- Témoignages Afrique
INSERT INTO social_proof_config (proof_type, target_screen, region, display_order,
    testimonial_name, testimonial_text, testimonial_rating)
VALUES 
    ('testimonial', 'welcome', 'africa', 1,
     'Aminata K.', 'Nous hésitions depuis 2 ans. Ce rapport a éclairé notre relation d''une manière que nous n''imaginions pas. Aujourd''hui nous sommes plus forts que jamais.', 5),
    ('testimonial', 'welcome', 'africa', 2,
     'Moussa D.', 'J''étais sceptique au départ. Mais les résultats étaient si précis que ma femme et moi avons enfin compris pourquoi certains mois étaient plus difficiles.', 5),
    ('testimonial', 'welcome', 'africa', 3,
     'Fatoumata B.', 'Le meilleur investissement pour notre couple. Les prévisions mensuelles nous aident à anticiper et à mieux communiquer.', 4);

-- Témoignages Europe
INSERT INTO social_proof_config (proof_type, target_screen, region, display_order,
    testimonial_name, testimonial_text, testimonial_rating)
VALUES 
    ('testimonial', 'welcome', 'europe', 4,
     'Marie L.', 'Incroyable. On se demandait si on était vraiment faits l''un pour l''autre. La réponse était là, claire et détaillée. Merci !', 5),
    ('testimonial', 'welcome', 'europe', 5,
     'Thomas R.', 'Ma copine a insisté pour qu''on essaie. Honnêtement, les résultats m''ont bluffé. Très pertinent sur nos dynamiques de couple.', 5),
    ('testimonial', 'welcome', 'europe', 6,
     'Chloé V.', 'Les prévisions pour l''année nous ont permis de planifier notre mariage au meilleur moment. Tout s''est passé merveilleusement bien.', 5);

-- 6. Permissions
GRANT SELECT ON public.social_proof_config TO anon;
GRANT SELECT ON public.social_proof_config TO authenticated;
GRANT ALL ON public.social_proof_config TO service_role;
