-- =============================================
-- SERVICE 06 - ÉCLAIRAGE DÉCISION
-- Ajout de la colonne detailed_description
-- et insertion des 8 nouveaux types de décision
-- =============================================

-- 1. Ajouter la colonne detailed_description si elle n'existe pas
ALTER TABLE cycle_vie_decision_types
ADD COLUMN IF NOT EXISTS detailed_description TEXT;

-- 2. Mettre à jour les descriptions détaillées des 20 types existants
-- (descriptions riches avec exemples pour que l'utilisateur ne se trompe pas)

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

-- Note: le code peut être 'demission' ou 'demission_changement' selon ce qui est en DB
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de quitter votre poste ou changer radicalement de voie ? Ce type couvre la rupture professionnelle volontaire : démission, reconversion, changement d''employeur. C''est une décision qui mérite d''être prise au bon moment.

Exemples : Démissionner, quitter une entreprise, vous reconvertir professionnellement, abandonner un projet pour en démarrer un autre.'
WHERE code IN ('demission', 'demission_changement');

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous planifiez un déplacement, qu''il soit court ou long ? Ce type couvre tout type de voyage : professionnel, touristique, familial, pèlerinage. La durée et le mode de transport sont pris en compte pour vous guider vers le meilleur moment de départ.

Exemples : Partir en vacances, voyager pour le travail, rendre visite à la famille, faire un pèlerinage, partir étudier à l''étranger.'
WHERE code = 'voyage';

-- Note: le code peut être 'mariage' ou 'mariage_engagement' selon ce qui est en DB
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de vous marier ou de formaliser votre engagement ? Ce type concerne l''union matrimoniale ou tout engagement sentimental formel : cérémonie, fiançailles, demande en mariage. Le choix de la date peut influencer l''harmonie de votre union.

Exemples : Fixer la date du mariage civil, organiser la cérémonie traditionnelle, demander quelqu''un en mariage, officialiser des fiançailles.'
WHERE code IN ('mariage', 'mariage_engagement');

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous vous apprêtez à démarrer une nouvelle relation amoureuse ? Ce type concerne le commencement d''une relation romantique : premier rendez-vous, déclaration de sentiments. Différent du mariage, il s''agit de l''étape initiale.

Exemples : Inviter quelqu''un à un premier rendez-vous, déclarer vos sentiments, officialiser une relation naissante, renouer avec un ancien amour.'
WHERE code = 'debut_relation';

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
'Votre décision ne correspond à aucune des catégories proposées ? Ce type convient à toute décision majeure qui ne trouve pas sa place ailleurs. Recevez un éclairage général basé sur l''énergie du moment choisi.

Exemples : Adopter un enfant, changer de religion, prendre une année sabbatique, s''engager dans une cause, démarrer un projet artistique personnel.'
WHERE code = 'autre';

-- =============================================
-- 3. Insertion des 8 NOUVEAUX types de décision
-- =============================================

INSERT INTO cycle_vie_decision_types (code, label, category, icon_name, description, detailed_description, display_order, is_active) VALUES

-- Type 21: Action en Justice
('action_justice', 'Action en Justice', 'juridique', 'gavel',
 'Procédure juridique ou litige à résoudre par voie légale',
 'Vous envisagez une procédure juridique ou êtes impliqué dans un litige ? Ce type couvre toute interaction avec le système judiciaire : intenter un procès, se défendre, déposer une plainte, soumettre des arguments devant un tribunal.

Exemples : Porter plainte, engager un avocat, se présenter au tribunal, contester une décision administrative, régler un litige foncier, divorcer par voie judiciaire.',
 21, true),

-- Type 22: Recrutement
('recrutement', 'Recrutement / Embauche', 'carriere', 'person_add',
 'Recruter quelqu''un pour un poste ou une mission',
 'Vous devez recruter quelqu''un pour un poste ou une mission ? Ce type concerne les décisions de recrutement quand vous êtes l''employeur : embaucher un collaborateur, un employé de maison, un agent commercial. Le moment du recrutement influence la fiabilité de la personne choisie.

Exemples : Embaucher un assistant, recruter un commercial, engager une aide ménagère, choisir un prestataire de longue durée, recruter un associé technique.',
 22, true),

-- Type 23: Demander une Faveur
('demande_faveur', 'Demander une Faveur', 'personnel', 'handshake',
 'Solliciter l''aide ou la bienveillance d''une personne influente',
 'Vous devez solliciter l''aide ou la bienveillance de quelqu''un d''influent ? Ce type couvre toute demande de faveur auprès de personnes en position d''autorité : patron, fonctionnaire, personnalité, membre influent de la famille.

Exemples : Demander un passe-droit, solliciter un appui politique, demander une recommandation à votre ancien patron, solliciter l''intervention d''un proche influent.',
 23, true),

-- Type 24: Examen / Concours
('examen', 'Examen / Concours', 'carriere', 'school',
 'Passer un examen, un concours ou une épreuve intellectuelle',
 'Vous allez passer un examen, un concours ou une épreuve intellectuelle ? Ce type concerne les épreuves académiques ou professionnelles : examens scolaires, concours d''entrée, certifications, tests de compétence.

Exemples : Passer le baccalauréat, un concours de la fonction publique, une certification professionnelle, un test de langue, un examen d''entrée à l''université.',
 24, true),

-- Type 25: Campagne Publicitaire
('campagne_pub', 'Campagne Pub / Marketing', 'business', 'campaign',
 'Lancer une campagne de communication ou de publicité',
 'Vous allez lancer une campagne de communication ou de publicité ? Ce type concerne le lancement d''actions promotionnelles : campagne publicitaire, réseaux sociaux, envoi de prospectus, lancement de site web. Le timing influence la réception de votre message par le public.

Exemples : Lancer une campagne Facebook/Instagram, publier une annonce, distribuer des flyers, envoyer un emailing commercial, inaugurer votre page de vente.',
 25, true),

-- Type 26: Vente d'un Bien
('vente_bien', 'Vente d''un Bien', 'finance', 'sell',
 'Vendre un bien, un produit ou un service important',
 'Vous souhaitez vendre un bien, un produit ou un service important ? Ce type concerne la mise en vente et la conclusion d''une transaction : vendre un terrain, une voiture, un stock de marchandises. Le moment de la vente peut influencer le prix obtenu.

Exemples : Vendre votre voiture, céder un terrain, liquider un stock, vendre du bétail, conclure une vente commerciale importante.',
 26, true),

-- Type 27: Prêt d'Argent
('pret_argent', 'Prêt d''Argent', 'finance', 'money_off',
 'Prêter de l''argent à quelqu''un',
 'Vous envisagez de prêter de l''argent à quelqu''un ? Ce type concerne l''acte de prêter : à un proche, un ami, un collègue, ou un partenaire commercial. Le bon moment peut influencer la probabilité de remboursement.

Exemples : Prêter de l''argent à un ami, avancer de l''argent à un membre de la famille, financer temporairement un collègue, consentir un prêt à un associé.',
 27, true),

-- Type 28: Recouvrement de Dette
('recouvrement_dette', 'Recouvrement de Dette', 'finance', 'request_quote',
 'Récupérer de l''argent qui vous est dû',
 'Quelqu''un vous doit de l''argent et vous souhaitez le récupérer ? Ce type concerne les démarches pour récupérer une dette : rappeler un emprunteur, envoyer une mise en demeure, négocier un remboursement.

Exemples : Rappeler un ami qu''il vous doit de l''argent, envoyer une mise en demeure, engager un huissier, réclamer un impayé commercial.',
 28, true)

ON CONFLICT (code) DO NOTHING;  -- Ne pas écraser si déjà existant

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT code, label, category, display_order, is_active,
       CASE WHEN detailed_description IS NOT NULL THEN '✅' ELSE '❌' END as has_detail
FROM cycle_vie_decision_types
ORDER BY display_order;
