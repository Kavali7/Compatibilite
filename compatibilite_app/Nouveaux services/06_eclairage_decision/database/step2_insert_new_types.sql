-- =============================================
-- SERVICE 06 - ÉCLAIRAGE DÉCISION
-- SCRIPT 2/3 : INSERTION DES 8 NOUVEAUX TYPES
-- =============================================
-- Prérequis : Exécuter step1_fix_codes_and_descriptions.sql AVANT
-- Ce script insère les 8 nouveaux types qui existent dans
-- le Flutter (decision_advice_purchase_screen.dart) mais pas en DB.
-- =============================================

-- Vérification pré-insertion : combien de types actifs ?
SELECT COUNT(*) as types_actifs FROM cycle_vie_decision_types WHERE is_active = true;
-- Attendu : 19 (20 - 1 désactivé)

INSERT INTO cycle_vie_decision_types
  (code, label, category, description, detailed_description, display_order, is_active)
VALUES

-- Type 21: Début de Relation (Personnel)
('debut_relation', 'Début de Relation', 'personnel',
 'Démarrer une nouvelle relation amoureuse',
 'Vous vous apprêtez à démarrer une nouvelle relation amoureuse ? Ce type concerne le commencement d''une relation romantique : premier rendez-vous, déclaration de sentiments, début officiel d''une relation. Différent du mariage, il s''agit ici de l''étape initiale de la rencontre et de la séduction.

Exemples : Inviter quelqu''un à un premier rendez-vous, déclarer vos sentiments, officialiser une relation naissante, renouer avec un ancien amour.',
 21, true),

-- Type 22: Autre Décision (Autre)
('autre', 'Autre Décision Importante', 'autre',
 'Décision importante ne correspondant à aucune catégorie',
 'Votre décision ne correspond à aucune des catégories proposées ? Ce type convient à toute décision majeure qui ne trouve pas sa place ailleurs. Recevez un éclairage général basé sur l''énergie du moment choisi.

Exemples : Adopter un enfant, changer de religion, prendre une année sabbatique, s''engager dans une cause, démarrer un projet artistique personnel.',
 22, true),

-- Type 23: Construction / Rénovation (Immobilier)
('construction_renovation', 'Construction / Rénovation', 'immobilier',
 'Construire ou rénover un bâtiment',
 'Vous allez entreprendre des travaux de construction ou de rénovation ? Ce type concerne tout projet immobilier impliquant des travaux : construction d''une maison, rénovation d''un appartement, agrandissement, aménagement de local professionnel.

Exemples : Construire votre maison, rénover une cuisine, agrandir un bureau, poser une toiture, refaire l''électricité d''un bâtiment.',
 23, true),

-- Type 24: Négociation / Accord (Juridique)
('negociation_accord', 'Négociation / Accord formel', 'juridique',
 'Négocier un accord ou un arrangement formel',
 'Vous êtes en phase de négociation pour un accord important ? Ce type couvre les pourparlers formels : négociation salariale, médiation de conflit, accord amiable, arrangement familial, traité commercial.

Exemples : Négocier les termes d''un accord, trouver un compromis dans un conflit, négocier une indemnité, conclure un accord amiable avec un voisin.',
 24, true),

-- Type 25: Campagne Publicitaire (Commerce)
('campagne_pub', 'Campagne Pub / Marketing', 'commerce',
 'Lancer une campagne de communication ou publicité',
 'Vous allez lancer une campagne de communication ou de publicité ? Ce type concerne le lancement d''actions promotionnelles : campagne publicitaire, réseaux sociaux, envoi de prospectus, lancement de site web. Le timing influence la réception de votre message par le public.

Exemples : Lancer une campagne Facebook/Instagram, publier une annonce, distribuer des flyers, envoyer un emailing commercial, inaugurer votre page de vente.',
 25, true),

-- Type 26: Vente d'un Bien (Commerce)
('vente_bien', 'Vente d''un Bien', 'commerce',
 'Vendre un bien, un produit ou un service important',
 'Vous souhaitez vendre un bien, un produit ou un service important ? Ce type concerne la mise en vente et la conclusion d''une transaction : vendre un terrain, une voiture, un stock de marchandises. Le moment de la vente peut influencer le prix obtenu.

Exemples : Vendre votre voiture, céder un terrain, liquider un stock, vendre du bétail, conclure une vente commerciale importante.',
 26, true),

-- Type 27: Inscription Formation (Éducation)
('inscription_formation', 'Inscription Formation / École', 'education',
 'S''inscrire à une formation ou un programme éducatif',
 'Vous allez vous inscrire à une formation, une école ou un programme d''apprentissage ? Ce type concerne tout engagement éducatif : inscription universitaire, formation professionnelle, cours en ligne, programme de certification.

Exemples : S''inscrire à l''université, rejoindre une formation professionnelle, commencer un cours en ligne, passer un concours d''entrée.',
 27, true),

-- Type 28: Pèlerinage / Retraite (Spirituel)
('pelerinage_retraite', 'Pèlerinage / Retraite spirituelle', 'spirituel',
 'Entreprendre un voyage ou une retraite spirituelle',
 'Vous envisagez un pèlerinage, une retraite spirituelle ou un voyage intérieur ? Ce type concerne les déplacements et séjours à vocation spirituelle ou de développement personnel : pèlerinage religieux, retraite de méditation, voyage initiatique.

Exemples : Partir en pèlerinage à la Mecque, faire une retraite de méditation, participer à un voyage initiatique, rejoindre un ashram, entreprendre un chemin de Saint-Jacques.',
 28, true)

ON CONFLICT (code) DO NOTHING;  -- Sécurité : pas d'écrasement si déjà présent

-- Vérification post-insertion
SELECT code, label, category, display_order, is_active,
       CASE WHEN detailed_description IS NOT NULL THEN '✅' ELSE '❌' END as has_detail
FROM cycle_vie_decision_types
WHERE is_active = true
ORDER BY display_order;
-- Attendu : 27 types actifs (19 existants corrigés + 8 nouveaux)
