-- =============================================
-- SERVICE 06 - ÉCLAIRAGE DÉCISION
-- SCRIPT 1/3 : CORRECTION DES CODES & MIGRATION
-- =============================================
-- Ce script :
--   1. Corrige 3 codes DB pour matcher le Flutter
--   2. Désactive le type 'proces' (conserve ses 7 conseils)
--   3. Ajoute la colonne detailed_description
--   4. Remplit les detailed_descriptions des 20 types existants
-- =============================================
-- ⚠️ SÉCURITÉ : Toutes les opérations sont des UPDATE/ALTER,
--   aucune suppression de données.
-- =============================================

-- ─── PARTIE 1 : CORRIGER LES 3 CODES ────────────────────

-- Vérification AVANT correction
SELECT code, label, is_active FROM cycle_vie_decision_types
WHERE code IN ('chirurgie', 'regime', 'nouvelle_habitude', 'proces')
ORDER BY display_order;

-- 1a. chirurgie → operation_medicale
UPDATE cycle_vie_decision_types
SET code = 'operation_medicale',
    label = 'Opération Médicale',
    category = 'sante',
    description = 'Intervention chirurgicale planifiée'
WHERE code = 'chirurgie';

-- 1b. regime → debut_traitement
UPDATE cycle_vie_decision_types
SET code = 'debut_traitement',
    label = 'Début de Traitement',
    category = 'sante',
    description = 'Commencer un traitement médical ou thérapeutique'
WHERE code = 'regime';

-- 1c. nouvelle_habitude → changement_habitudes
UPDATE cycle_vie_decision_types
SET code = 'changement_habitudes',
    label = 'Changement d''habitudes de vie',
    category = 'sante',
    description = 'Adopter de nouvelles habitudes quotidiennes'
WHERE code = 'nouvelle_habitude';

-- 1d. Désactiver 'proces' (conserve les 7 conseils liés)
UPDATE cycle_vie_decision_types
SET is_active = false
WHERE code = 'proces';

-- Vérification APRÈS correction
SELECT code, label, category, is_active FROM cycle_vie_decision_types
ORDER BY display_order;

-- ─── PARTIE 2 : AJOUTER COLONNE detailed_description ────

ALTER TABLE cycle_vie_decision_types
ADD COLUMN IF NOT EXISTS detailed_description TEXT;



-- ─── PARTIE 3 : REMPLIR LES DESCRIPTIONS DÉTAILLÉES ─────
-- (20 types existants + descriptions du fichier descriptions_decisions.md)

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de louer un logement ou un local ? Ce type couvre toute recherche et signature de bail locatif : appartement, maison, local commercial ou bureau. Que vous soyez locataire à la recherche d''un nouveau toit ou propriétaire souhaitant mettre en location, cette consultation vous guidera vers le moment le plus favorable.

Exemples : Visiter un appartement, signer un bail, négocier un loyer, choisir entre plusieurs offres de location, renouveler un contrat de bail.'
WHERE code = 'location_immobilier';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez acheter un bien immobilier ? Ce type concerne l''acquisition d''un terrain, d''une maison, d''un appartement ou d''un immeuble, que ce soit pour y habiter ou comme investissement. C''est l''une des décisions les plus engageantes de votre vie — le bon timing peut faire toute la différence.

Exemples : Acheter un terrain à bâtir, acquérir une maison, faire une offre d''achat, finaliser chez le notaire, investir dans un immeuble locatif.'
WHERE code = 'achat_immobilier';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous prévoyez de changer de domicile ou de lieu de travail ? Ce type couvre le déménagement proprement dit : quitter un lieu pour s''installer dans un autre. Le moment choisi pour ce changement influence l''énergie de votre nouveau départ.

Exemples : Déménager dans une nouvelle ville, changer d''appartement, transférer votre bureau, s''installer dans une maison nouvellement acquise.'
WHERE code = 'demenagement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous voulez acheter une voiture, une moto ou tout autre véhicule ? Ce type concerne l''acquisition d''un moyen de transport : véhicule neuf ou d''occasion, moto, camion utilitaire. Le choix du bon moment peut influencer la négociation et la fiabilité de votre achat.

Exemples : Acheter une voiture neuve, négocier un véhicule d''occasion, acquérir une moto, acheter un camion pour votre activité.'
WHERE code = 'achat_vehicule';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous prévoyez un achat significatif qui n''entre pas dans les autres catégories ? Ce type couvre tout achat majeur représentant un investissement conséquent : électroménager, mobilier, équipement professionnel, matériel informatique.

Exemples : Acheter un réfrigérateur, équiper votre cuisine, renouveler votre mobilier, acheter du matériel informatique, acquérir du matériel agricole.'
WHERE code = 'achat_important';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez solliciter un prêt, un crédit ou un financement ? Ce type concerne toute démarche pour obtenir de l''argent d''une institution : prêt bancaire, microcrédit, crédit à la consommation. Le moment de votre demande peut influencer la décision du banquier.

Exemples : Demander un prêt immobilier, solliciter un microcrédit, présenter un dossier de financement, négocier un découvert bancaire.'
WHERE code = 'demande_financement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous cherchez à obtenir des fonds par d''autres moyens qu''un prêt bancaire ? Ce type couvre les démarches pour lever des fonds, négocier un salaire, demander une aide financière. Différent du prêt bancaire, il s''agit ici de convaincre des personnes de vous soutenir.

Exemples : Négocier une augmentation, lever des fonds pour votre startup, demander de l''aide à un proche, solliciter une bourse ou subvention.'
WHERE code = 'recherche_argent';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez placer votre argent pour le faire fructifier ? Ce type concerne tout placement financier : actions, obligations, tontine, investissement immobilier locatif, commerce, ou tout autre véhicule d''investissement.

Exemples : Investir en bourse, placer de l''argent dans une tontine, financer un commerce, acheter des parts dans une entreprise.'
WHERE code = 'investissement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez signer un document engageant ? Ce type concerne tout engagement contractuel formel : contrat de travail, accord commercial, convention de partenariat, bail, ou tout document dont la signature vous engage légalement.

Exemples : Signer un contrat de travail, un accord commercial, une convention de partenariat, un contrat de prestation, un compromis de vente.'
WHERE code = 'signature_contrat';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez créer une entreprise ou lancer un nouveau produit/service ? Ce type concerne le démarrage d''une activité commerciale : création d''entreprise, ouverture de boutique, lancement d''un produit. Le moment du lancement influence le succès initial.

Exemples : Créer votre entreprise, ouvrir un magasin, lancer une application, démarrer un commerce en ligne, inaugurer un restaurant.'
WHERE code = 'lancement_business';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez vous associer avec quelqu''un en affaires ? Ce type concerne la création d''une alliance professionnelle ou commerciale : trouver un associé, former un partenariat, collaborer formellement avec une autre entreprise.

Exemples : S''associer avec un ami pour un business, signer un partenariat commercial, rejoindre une coopérative, collaborer avec une ONG.'
WHERE code = 'partenariat';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez passer un entretien pour un poste ? Ce type concerne les entretiens de recrutement : emploi, stage, mission freelance, ou tout processus de sélection où vous devez convaincre un recruteur de votre valeur.

Exemples : Passer un entretien d''embauche, un entretien de stage, une audition, un examen oral de concours, un entretien pour une mission.'
WHERE code = 'entretien_embauche';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez demander un avancement professionnel ? Ce type concerne les démarches pour obtenir une promotion : augmentation de poste, responsabilités accrues, changement de titre, accès à un meilleur statut.

Exemples : Demander à devenir chef d''équipe, solliciter un changement de grade, négocier un poste de direction, demander plus de responsabilités.'
WHERE code = 'demande_promotion';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de quitter votre poste ou changer radicalement de voie ? Ce type couvre la rupture professionnelle volontaire : démission, reconversion, changement d''employeur. C''est une décision qui mérite d''être prise au bon moment.

Exemples : Démissionner, quitter une entreprise, vous reconvertir professionnellement, abandonner un projet pour en démarrer un autre.'
WHERE code = 'demission';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de vous marier ou de formaliser votre engagement ? Ce type concerne l''union matrimoniale ou tout engagement sentimental formel : cérémonie, fiançailles, demande en mariage. Le choix de la date peut influencer l''harmonie de votre union.

Exemples : Fixer la date du mariage civil, organiser la cérémonie traditionnelle, demander quelqu''un en mariage, officialiser des fiançailles.'
WHERE code = 'mariage';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous planifiez un déplacement, qu''il soit court ou long ? Ce type couvre tout type de voyage : professionnel, touristique, familial, pèlerinage. La durée et le mode de transport sont pris en compte pour vous guider vers le meilleur moment de départ.

Exemples : Partir en vacances, voyager pour le travail, rendre visite à la famille, faire un pèlerinage, partir étudier à l''étranger.'
WHERE code = 'voyage';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous devez subir une intervention chirurgicale planifiée ? Ce type concerne les opérations programmées. L''énergie du jour choisi peut influencer votre récupération et le succès de l''intervention.

Exemples : Opération chirurgicale programmée, chirurgie dentaire majeure, chirurgie esthétique, césarienne planifiée.

Note : Ce type ne concerne PAS les urgences médicales. En cas d''urgence, n''attendez jamais — consultez immédiatement.'
WHERE code = 'operation_medicale';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez commencer un nouveau protocole médical ou thérapeutique ? Ce type concerne le début d''un traitement : nouveau médicament, séances de kinésithérapie, thérapie psychologique, cure, régime médical.

Exemples : Commencer un traitement médicamenteux, démarrer des séances de kiné, entamer une psychothérapie, suivre un programme de sevrage.'
WHERE code = 'debut_traitement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez adopter de nouvelles habitudes ou transformer votre routine quotidienne ? Ce type concerne les changements profonds d''hygiène de vie : arrêter le tabac, commencer le sport, modifier votre alimentation, changer de rythme.

Exemples : Commencer un régime alimentaire, adopter une routine sportive, arrêter de fumer, se lever plus tôt, méditer quotidiennement.'
WHERE code = 'changement_habitudes';

-- proces : on met aussi la description pour qu'il reste documenté
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez une procédure juridique ou êtes impliqué dans un litige ? Ce type couvre toute interaction avec le système judiciaire : intenter un procès, se défendre, déposer une plainte, soumettre des arguments devant un tribunal.

Exemples : Porter plainte, engager un avocat, se présenter au tribunal, contester une décision administrative, régler un litige foncier.

Note : Ce type est actuellement désactivé.'
WHERE code = 'proces';

-- ─── VÉRIFICATION FINALE ─────────────────────────────────

SELECT code, label, category, display_order, is_active,
       CASE WHEN detailed_description IS NOT NULL THEN '✅' ELSE '❌' END as has_detail,
       LENGTH(detailed_description) as detail_len
FROM cycle_vie_decision_types
ORDER BY display_order;
