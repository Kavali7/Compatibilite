-- ============================================================
-- SCRIPT DE RESTAURATION INTELLIGENT AVEC VRAIS CONTENUS
-- 1. Crée les tables manquantes (backend RPC)
-- 2. Migre les données de numerology_texts vers le format RPC
-- ============================================================

-- ------------------------------------------------------------
-- 1. CRÉATION DES TABLES MANQUANTES
-- ------------------------------------------------------------

-- Enums (si manquants)
DO $$ BEGIN CREATE TYPE public.periode_rapport AS ENUM ('jour', 'mois', 'annee'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE public.periode_contenu AS ENUM ('jour', 'mois', 'annee', 'toutes'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE public.numero_vibration AS ENUM ('1', '2', '3', '4', '5', '6', '7', '8', '9', '11', '22', '33'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE public.etat_relationnel AS ENUM ('harmonieux', 'neutre', 'tendu', 'indifferent'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE public.statut_utilisateur AS ENUM ('celibataire', 'en_couple', 'indifferent'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE public.ton_redaction AS ENUM ('neutre', 'bienveillant', 'direct', 'coaching'); EXCEPTION WHEN duplicate_object THEN null; END $$;

-- Tables
CREATE TABLE IF NOT EXISTS public.canonical_predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    periode public.periode_rapport NOT NULL,
    numero public.numero_vibration NOT NULL,
    langue TEXT DEFAULT 'fr',
    version SMALLINT DEFAULT 1,
    titre TEXT,
    contenu_md TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(periode, numero, langue, version)
);

CREATE TABLE IF NOT EXISTS public.content_bricks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actif BOOLEAN DEFAULT true,
    bloc SMALLINT NOT NULL,
    periode public.periode_contenu NOT NULL,
    type_brique TEXT NOT NULL,
    numero_cible public.numero_vibration,
    etat_relationnel public.etat_relationnel DEFAULT 'indifferent',
    statut_utilisateur public.statut_utilisateur DEFAULT 'indifferent',
    langue TEXT DEFAULT 'fr',
    version SMALLINT DEFAULT 1,
    modele_texte TEXT NOT NULL,
    cle_choix INTEGER DEFAULT floor(random() * 1000000)::int,
    jours_refroidissement INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_bricks_lookup ON public.content_bricks(bloc, periode, type_brique, numero_cible);

CREATE TABLE IF NOT EXISTS public.brick_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    brick_id UUID REFERENCES public.content_bricks(id) ON DELETE CASCADE,
    dernier_usage TIMESTAMPTZ DEFAULT now(),
    dernier_report_id UUID,
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id, brick_id)
);

CREATE TABLE IF NOT EXISTS public.report_sections (
    code TEXT PRIMARY KEY,
    label_fr TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    description TEXT
);

-- Table legacy numerology_texts (pour l'admin)
DO $$ BEGIN
    CREATE TABLE IF NOT EXISTS public.numerology_texts (
        id SERIAL PRIMARY KEY,
        type TEXT NOT NULL,
        number INTEGER NOT NULL,
        locale TEXT DEFAULT 'fr',
        title TEXT,
        body TEXT,
        segment TEXT,
        created_at TIMESTAMPTZ DEFAULT now(),
        updated_at TIMESTAMPTZ,
        UNIQUE(type, number, locale, segment)
    );
EXCEPTION WHEN duplicate_table THEN null; END $$;


-- ------------------------------------------------------------
-- 2. INSERTION DES DONNÉES DE BASE (numerology_texts)
-- On restaure tes vrais textes ici
-- ------------------------------------------------------------
INSERT INTO public.numerology_texts (type, number, locale, title, body, segment) VALUES
('base', 1, 'fr', 'Initiateur', 'Leadership naturel, aime ouvrir la voie. Energie directe, agit vite. Cherche autonomie et initiative. Peut confondre vitesse et precipitation. Tendance a vouloir tout controler. Besoin d apprendre a deleguer. Courageux face aux defis. Peut etre irritable si on le freine. Progresse quand il pose un rythme stable. Conseil: ecouter les autres et laisser de la place.', ''),
('base', 2, 'fr', 'Harmoniseur', 'Sens du lien et de l harmonie. Empathique, saisit les nuances et relie les points de vue. Diplomate, favorise la cooperation. Peut se taire pour eviter le conflit. Risque de dependance affective. Besoin d affirmer clairement ses besoins. Peut ruminer les critiques. Trouve sa force dans la complementarite. Stabilise la relation par l ecoute reciproque. Conseil: fixer des limites et prendre des decisions.', ''),
('base', 3, 'fr', 'Creatif', 'Expression vive et joie communicative. Sociable, relie les gens et aime jouer avec les idees. Creativite intuitive et humour. Peut se disperser s il s ennuie. Cherche la stimulation et la nouveaute. Besoin de discipline pour terminer. Sensible aux retours, peut douter sans feedback. Apprend a ecouter autant qu a parler. La joie est sa ressource pour avancer. Conseil: canaliser l energie dans un projet concret.', ''),
('base', 4, 'fr', 'Architecte', 'Construction et stabilite. Pragmatique, methodique, avance pas a pas. Besoin de cadre et de plan. Fiable et rassurant, mais peut devenir rigide. Le changement brusque peut le bloquer. Apprend a garder de la souplesse. Excele sur le long terme et dans l organisation. Peut se fatiguer en portant tout seul. Valorise l utilite et le concret. Conseil: alterner effort et pauses, deleguer quand c est possible.', ''),
('base', 5, 'fr', 'Explorateur', 'Liberte et mouvement. Curiosite forte, aime explorer et changer. Energie adaptable, pense vite. Peut s ennuyer ou partir trop vite. Goût du risque, besoin de garde-fous. Souple et malin pour contourner les obstacles. Peut sembler instable s il ne finit pas. Apprend a choisir des changements alignes. Aime surprendre et etre surprendre. Conseil: fixer quelques priorites et tenir jusqu au bout.', ''),
('base', 6, 'fr', 'Gardien', 'Harmonie et service. Protecteur, soigne le lien, recherche un foyer paisible. Sens du beau et du confort. Peut se sur-responsabiliser. Tendance au perfectionnisme relationnel. Besoin de poser des limites pour ne pas se vider. Aime rassembler et apaiser. Peut culpabiliser pour les autres. Besoin d etre soutenu autant qu il soutient. Conseil: partager la charge et garder du temps pour soi.', ''),
('base', 7, 'fr', 'Analyste', 'Introspection et quete de sens. Analyse, observe, cherche la verite. Besoin de solitude pour integrer. Peut paraitre distant ou secret. Intuition fine, mais scepticisme possible. Apprend a partager ses ressentis. Observe avant d agir, trouve des solutions subtiles. Se ressource dans la nature ou l etude. Peut s isoler s il ne communique pas. Conseil: alterner retrait et echange, ouvrir ses conclusions.', ''),
('base', 8, 'fr', 'Batisseur', 'Pouvoir et realisation. Vision strategique, aime diriger et impacter. Sens du concret et des ressources. Peut devenir controleur ou trop exigeant. Besoin de reconnaissance et de resultats visibles. Apprend a deleguer et a faire confiance. Gere bien la matiere quand il reste aligne et etique. Risque d epuisement par surengagement. La mesure est sa force. Conseil: equilibrer ambition et respect du rythme commun.', ''),
('base', 9, 'fr', 'Humaniste', 'Idealiste et humaniste. Altruiste, ouvert aux cultures et aux differents points de vue. Sens du collectif et de l universel. Peut vouloir sauver tout le monde. Risque de dispersion et de flou pratique. Besoin de limites pour se proteger. Vision large, sensibilite aux injustices. Emotif et empathique, se recharge dans la creativite ou le voyage. Apprend a finir et a trier. Conseil: garder un socle personnel clair avant de se donner.', ''),
('base', 11, 'fr', 'Visionnaire', 'Intuition haute et inspiration. Hyper sensible aux ambiances. Vision fine, creativite spirituelle. Peut etre anxieux ou surexcite. Besoin d ancrage et de routines pour se stabiliser. Capte ce qui n est pas dit. Risque de surcharge mentale. Apprend a filtrer l essentiel. Quand aligne, guide naturellement et inspire. Conseil: ritualiser l ancrage (respiration, corps) pour clarifier ses choix.', ''),
('base', 22, 'fr', 'Stratege', 'Maitre batisseur: capacite a realiser grand en restant pragmatique. Vision d architecte, aime structurer et durer. Peut se sentir ecrase par la charge. Besoin de decouper en etapes et de s entourer. Equilibre materiel et sens. Peut osciller entre doute et puissance. Apprend a collaborer pour tenir la longueur. Quand aligne, concreti se des projets solides. Conseil: poser des fondations avant d accelerer.', ''),
('base', 33, 'fr', 'Inspireur', 'Service et inspiration elevee. Souhaite aider largement, vibration altruiste. Peut se sur-responsabiliser ou viser le parfait. Besoin de joie simple pour durer. Sens artistique et empathie forte. Peut oublier ses propres besoins en aidant. Apprend a mettre des limites saines. Guide en montrant l exemple. Trouve sa force dans la compassion et l humour. Conseil: prendre soin de soi avant de servir les autres.', ''),

('personal_day', 1, 'fr', NULL, 'Impulsion: initier une action, poser un premier pas. Agir avec courage sans brusquer.', ''),
('personal_day', 2, 'fr', NULL, 'Partenariat: cooperer, ecouter, negocier en douceur. Chercher l accord gagnant-gagnant.', ''),
('personal_day', 3, 'fr', NULL, 'Expression: communiquer, creer, partager un message. Miser sur la legerete et la clarte.', ''),
('personal_day', 4, 'fr', NULL, 'Structure: organiser, planifier, avancer methodiquement. Verifier les details utiles.', ''),
('personal_day', 5, 'fr', NULL, 'Mouvement: rester souple, accueillir un changement. Tester avant de s engager.', ''),
('personal_day', 6, 'fr', NULL, 'Soutien: prendre soin des proches et de soi. Repartir les responsabilites pour eviter la charge.', ''),
('personal_day', 7, 'fr', NULL, 'Recul: observer, analyser, mediter avant d agir. Laisser de l espace a l intuition.', ''),
('personal_day', 8, 'fr', NULL, 'Impact: affirmer, negocier, traiter une question materielle. Garder l etique en priorite.', ''),
('personal_day', 9, 'fr', NULL, 'Cloture: finir, partager, faire un geste de generosite. Laisser partir ce qui doit se clore.', ''),

('daily_action', 1, 'fr', NULL, 'Impulsez ensemble: choisissez une decision rapide a deux, meme modeste. Verifiez que le rythme convient aux deux. Agissez puis appreciez le resultat. Ne cherchez pas la perfection, mais l elan commun.', ''),
('daily_action', 2, 'fr', NULL, 'Liez et ecoutez: privilegiez le dialogue, la co-decision, un geste d apaisement. Ne tranchez pas seul. Reformulez ce que l autre dit. Terminez par un accord clair, meme petit.', ''),
('daily_action', 3, 'fr', NULL, 'Exprimez et clarifiez: partagez idees et envies, mais concluez. Evitez l ironie, dites un compliment precis. Finissez une discussion en suspens. Creer quelque chose ensemble renforce le lien.', ''),
('daily_action', 4, 'fr', NULL, 'Structurez: rangez, planifiez, mettez un cadre simple. Definissez qui fait quoi aujourd hui. Une petite organisation commune diminue le stress. Ajoutez un moment detente apres l effort.', ''),
('daily_action', 5, 'fr', NULL, 'Bougez avec souplesse: testez une nouveaute ensemble, mais gardez un port d attache. Si un imprevu arrive, adaptez sans tout bousculer. Debrief rapide pour rester alignes.', ''),
('daily_action', 6, 'fr', NULL, 'Prenez soin: demandez explicitement le type de soutien souhaite. Repartissez une tache. Offrez-vous un moment cocon. Valorisez l effort de l autre, meme petit.', ''),
('daily_action', 7, 'fr', NULL, 'Recul et partage: accordez-vous un temps calme ou une courte meditation. Puis partagez un ressenti cle en quelques phrases simples. Laissez de l espace sans fuir la connexion.', ''),
('daily_action', 8, 'fr', NULL, 'Impact et integrite: reglez un sujet materiel ou financier avec transparence. Posez des criteres justes, ecoutez l avis de l autre. Concluez par un accord et un geste de detente.', ''),
('daily_action', 9, 'fr', NULL, 'Cloturez et allegez: terminez un dossier ou un malentendu. Faites un geste de generosite ou de pardon. Liberez l energie avant de repartir sur du neuf.', ''),

('personal_year', 1, 'fr', NULL, 'Debut de cycle: lancer, planter, oser. Tout n est pas visible, patience. Bon pour initier des projets ou des rencontres. Eviter de tout forcer en meme temps. Clarifier un cap et avancer pas a pas. Energie de premiere impulsion a nourrir.', ''),
('personal_year', 2, 'fr', NULL, 'Cooperation et ajustement. Rythme plus lent, gestation. Relations et duos au centre. Ne pas precipiter, laisser murir. Apprendre a dire ce que l on ressent. La patience ouvre des portes discrètes.', ''),
('personal_year', 3, 'fr', NULL, 'Expression, reseaux, joie. Visibilite accrue, opportunites sociales. Creativite mise en avant. Risque de dispersion: prioriser quelques objectifs. Communiquer avec legerete et clarté. Profiter pour montrer son travail.', ''),
('personal_year', 4, 'fr', NULL, 'Structure et travail. On consolide, on pose des fondations. Routines et methodes a installer. Patience face aux retards possibles. Risque de rigidite: garder une marge de jeu. Les efforts constants payent sur la duree.', ''),
('personal_year', 5, 'fr', NULL, 'Changements et mobilite. Opportunites, voyages, virages. Besoin de souplesse et de garde-fous. Ne pas tout bousculer sans plan. Explorer, tester, ajuster. Rester connecte a ce qui fait sens.', ''),
('personal_year', 6, 'fr', NULL, 'Responsabilites, famille, engagements. Bon pour officialiser, soigner, reparer. Risque de surcharge si l on veut tout porter. S appuyer sur le soutien proche. Equilibrer devoir et plaisir. L harmonisation passe par des choix clairs.', ''),
('personal_year', 7, 'fr', NULL, 'Introspection, etude, tri. Rythme plus calme, on decante. Besoin de sens et de recul. Eviter de se juger si les resultats tardent. Clarifier ses priorites interieures. La qualite prime sur la quantite.', ''),
('personal_year', 8, 'fr', NULL, 'Realisation et impact. Questions materielle et pouvoir mises en avant. Negocier, affirmer, agir avec etique. Risque de tension si on force trop. Structurer ses objectifs et mesurer les efforts. L alignement attire les ressources.', ''),
('personal_year', 9, 'fr', NULL, 'Cloture et detachement. Faire des bilans, ranger, laisser partir. Ne pas lancer un enorme cycle sans avoir nettoye. Emotionnel en mouvement, besoin de bienveillance. Honorer ce qui se termine et preparer la suite. Ouvrir un espace pour l apres.', '')

ON CONFLICT (type, number, locale, segment) DO UPDATE SET
  title = excluded.title, body = excluded.body, updated_at = now();


-- ------------------------------------------------------------
-- 3. MIGRATION VERS LES TABLES RPC (canonical_predictions, content_bricks)
-- On prend ce qu'on vient d'insérer et on le met au bon endroit pour que l'app mobile le trouve.
-- ------------------------------------------------------------

-- A. Remplir canonical_predictions (Bloc 0 - Canon)
-- On utilise 'personal_year' pour 'annee' et 'personal_day' pour 'jour' comme base
-- (C'est une approximation pour restaurer le service, à affiner ensuite)

INSERT INTO public.canonical_predictions (periode, numero, titre, contenu_md)
SELECT 
  'annee', number::text::public.numero_vibration, coalesce(title, 'Année '||number), body
FROM public.numerology_texts
WHERE type = 'personal_year'
ON CONFLICT (periode, numero, langue, version) DO UPDATE SET contenu_md = excluded.contenu_md;

INSERT INTO public.canonical_predictions (periode, numero, titre, contenu_md)
SELECT 
  'jour', number::text::public.numero_vibration, coalesce(title, 'Jour '||number), body
FROM public.numerology_texts
WHERE type = 'personal_day'
ON CONFLICT (periode, numero, langue, version) DO UPDATE SET contenu_md = excluded.contenu_md;

INSERT INTO public.canonical_predictions (periode, numero, titre, contenu_md)
SELECT 
  'mois', number::text::public.numero_vibration, coalesce(title, 'Mois '||number), body
FROM public.numerology_texts
WHERE type = 'personal_year' -- Fallback: on utilise l'année pour le mois par défaut
ON CONFLICT (periode, numero, langue, version) DO NOTHING;


-- B. Remplir content_bricks (Blocs 1, 2, 3)
-- On utilise 'daily_action' pour créer une brique 'acte' du jour

INSERT INTO public.content_bricks (bloc, periode, type_brique, numero_cible, modele_texte)
SELECT 
  3, 'jour', 'acte', number::text::public.numero_vibration, body
FROM public.numerology_texts
WHERE type = 'daily_action'
ON CONFLICT DO NOTHING;

-- Briques par défaut génériques (Indispensable pour éviter que RPC ne trouve rien)
-- On utilise les textes 'base' pour générer des briques 'energie' génériques
INSERT INTO public.content_bricks (bloc, periode, type_brique, numero_cible, modele_texte)
SELECT 
  1, 'toutes', 'energie', number::text::public.numero_vibration, body
FROM public.numerology_texts
WHERE type = 'base'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- 4. DONNÉES DE CONFIGURATION (Report Sections)
-- ------------------------------------------------------------
INSERT INTO public.report_sections (code, label_fr) VALUES
('b3_acte_jour', 'L''acte magique'),
('b3_rituel_jour', 'Rituel du soir'),
('b3_couple_jour', 'Vibration Couple'),
('b3_travail_jour', 'Travail & Projets'),
('b3_argent_jour', 'Abondance'),
('b3_sante_jour', 'Vitalité'),
('b3_feu_jour', 'Feu sacré')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 5. SÉCURITÉ (POLICIES)
-- ------------------------------------------------------------
ALTER TABLE public.canonical_predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_bricks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.brick_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.numerology_texts ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN CREATE POLICY "Public read canonical" ON public.canonical_predictions FOR SELECT USING (true); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE POLICY "Public read bricks" ON public.content_bricks FOR SELECT USING (actif = true); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE POLICY "Public read sections" ON public.report_sections FOR SELECT USING (true); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE POLICY "Public read interpretations" ON public.numerology_texts FOR SELECT USING (true); EXCEPTION WHEN duplicate_object THEN null; END $$; -- Alias interpretations -> numerology_texts
DO $$ BEGIN CREATE POLICY "Users read own usage" ON public.brick_usage FOR SELECT USING (auth.uid() = user_id); EXCEPTION WHEN duplicate_object THEN null; END $$;

