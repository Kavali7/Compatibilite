-- ===========================================================
-- MIGRATION ENRICHISSEMENT Service 06 — PARTIE 1/2
-- Colonnes + Descriptions détaillées
-- SAFE: Pas de DROP, pas de perte de données
-- Exécuter dans Supabase SQL Editor
-- ===========================================================

-- ─── ÉTAPE 1: AJOUTER detailed_description À decision_types ────
ALTER TABLE cycle_vie_decision_types
ADD COLUMN IF NOT EXISTS detailed_description TEXT;

-- ─── ÉTAPE 2: AJOUTER 5 COLONNES ENRICHIES À decision_advice ────
ALTER TABLE cycle_vie_decision_advice
ADD COLUMN IF NOT EXISTS cosmic_context TEXT;

ALTER TABLE cycle_vie_decision_advice
ADD COLUMN IF NOT EXISTS recommended_actions TEXT;

ALTER TABLE cycle_vie_decision_advice
ADD COLUMN IF NOT EXISTS pitfalls_to_avoid TEXT;

ALTER TABLE cycle_vie_decision_advice
ADD COLUMN IF NOT EXISTS optimal_timing TEXT;

ALTER TABLE cycle_vie_decision_advice
ADD COLUMN IF NOT EXISTS closing_message TEXT;

-- ─── ÉTAPE 3: PEUPLER detailed_description POUR TOUS LES TYPES ────

-- IMMOBILIER
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous cherchez un logement à louer ? Ce type concerne toute décision de location : appartement, maison, bureau, local commercial. L''analyse prend en compte votre cycle personnel pour déterminer le moment idéal pour signer un bail, effectuer des visites, et négocier les conditions. Le timing de la signature influence la qualité de votre expérience locative et la durabilité de votre installation.'
WHERE code = 'location_immobilier';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez d''acheter un bien immobilier ? Ce type couvre l''acquisition immobilière sous toutes ses formes : achat de terrain, de maison, d''appartement ou d''immeuble. L''analyse évalue le meilleur moment pour visiter, négocier le prix, signer le compromis et finaliser l''achat. Le timing de cette décision majeure influence la réussite de l''investissement sur le long terme.'
WHERE code = 'achat_immobilier';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous prévoyez un déménagement ? Ce type concerne le changement de lieu de vie : déménagement local, régional ou international. L''analyse identifie les périodes favorables pour organiser le départ, emballer, transporter et s''installer dans le nouveau lieu. Le bon moment peut faciliter considérablement la transition et l''adaptation au nouvel environnement.'
WHERE code = 'demenagement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez entreprendre des travaux ? Ce type concerne tout projet de construction ou rénovation : maison neuve, rénovation d''appartement, agrandissement, aménagement de local. L''analyse détermine les périodes propices pour lancer les travaux, sélectionner les artisans et superviser le chantier.'
WHERE code = 'construction_renovation';

-- FINANCE
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez l''achat d''un véhicule ? Ce type couvre l''acquisition de voiture, moto ou tout autre moyen de transport. L''analyse évalue le meilleur moment pour comparer les offres, négocier le prix, et concrétiser l''achat. Le timing influence la satisfaction à long terme et la fiabilité du véhicule choisi.'
WHERE code = 'achat_vehicule';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous prévoyez un achat conséquent ? Ce type concerne les achats majeurs : équipement professionnel, électroménager, mobilier, technologie. L''analyse identifie les périodes où votre discernement est aiguisé pour faire les choix les plus judicieux et obtenir les meilleures conditions.'
WHERE code = 'achat_important';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez demander un prêt ou un financement ? Ce type couvre les demandes de crédit, de prêt bancaire, de financement participatif ou d''aide financière. L''analyse détermine les moments où votre dossier sera le mieux perçu et où les conditions d''obtention seront les plus favorables.'
WHERE code = 'demande_financement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous êtes en quête de fonds ? Ce type concerne la recherche active de moyens financiers : levée de fonds, recherche d''investisseurs, demande de subvention, emprunt familial. L''analyse identifie les périodes où votre pouvoir de persuasion et les énergies financières sont les plus favorables.'
WHERE code = 'recherche_argent';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez un investissement financier ? Ce type couvre les placements sous toutes leurs formes : actions, obligations, immobilier locatif, crypto-monnaies, épargne. L''analyse détermine les fenêtres temporelles où votre intuition financière et votre capacité d''analyse sont optimales.'
WHERE code = 'investissement';

-- JURIDIQUE
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez signer un contrat important ? Ce type concerne les engagements contractuels : contrat de travail, bail, accord commercial, partenariat juridique. L''analyse évalue le moment idéal pour la signature afin d''assurer la solidité et la durabilité de l''engagement.'
WHERE code = 'signature_contrat';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous êtes en phase de négociation ? Ce type couvre les pourparlers formels : négociation salariale, médiation, accord amiable, arrangement familial, traité commercial. L''analyse identifie les moments où votre éloquence et votre capacité de persuasion sont les plus développées.'
WHERE code = 'negociation_accord';

-- BUSINESS
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez lancer une activité commerciale ? Ce type concerne la création d''entreprise, le lancement d''un produit ou service, l''ouverture d''un commerce. L''analyse détermine les périodes où les énergies d''initiative et de création sont les plus porteuses pour maximiser les chances de réussite.'
WHERE code = 'lancement_business';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez un partenariat ou une association ? Ce type couvre les alliances professionnelles : co-fondation, joint-venture, accord de partenariat, association commerciale. L''analyse identifie les moments propices à la formation d''alliances durables et mutuellement bénéfiques.'
WHERE code = 'partenariat';

-- COMMERCE
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez lancer une campagne de communication ? Ce type concerne les actions promotionnelles : publicité, réseaux sociaux, prospectus, lancement de site web. L''analyse détermine les périodes où votre message aura le plus d''impact et sera le mieux reçu par votre audience.'
WHERE code = 'campagne_pub';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez vendre un bien important ? Ce type concerne la mise en vente : terrain, voiture, stock de marchandises, propriété intellectuelle. L''analyse identifie les moments où les énergies de transaction sont les plus favorables pour obtenir le meilleur prix.'
WHERE code = 'vente_bien';

-- CARRIÈRE
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous passez un entretien d''embauche ? Ce type concerne les rendez-vous professionnels décisifs : entretien de recrutement, audition, présentation de projet devant un jury. L''analyse évalue le moment idéal pour donner la meilleure impression et maximiser vos chances de succès.'
WHERE code = 'entretien_embauche';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez demander une promotion ou une augmentation ? Ce type couvre les demandes d''évolution professionnelle : promotion, augmentation de salaire, changement de poste. L''analyse identifie le bon moment pour formuler votre demande et maximiser les chances d''une réponse favorable.'
WHERE code = 'demande_promotion';

-- Support both old and new code names for démission
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez de quitter votre emploi actuel ? Ce type concerne la démission, le changement de poste ou la reconversion professionnelle. L''analyse détermine les moments propices pour effectuer cette transition en minimisant les risques et en maximisant les opportunités qui s''offrent à vous.'
WHERE code IN ('demission', 'demission_changement');

-- ÉDUCATION
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez vous inscrire à une formation ou un programme éducatif ? Ce type concerne tout engagement éducatif : inscription universitaire, formation professionnelle, cours en ligne, certification, programme de coaching. L''analyse identifie les périodes où votre capacité d''apprentissage et votre motivation sont optimales.'
WHERE code = 'inscription_formation';

-- PERSONNEL
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous planifiez un voyage important ? Ce type couvre les déplacements significatifs : vacances, voyage d''affaires, expatriation, visite familiale à l''étranger. L''analyse détermine les périodes les plus favorables pour le départ et l''ensemble du séjour.'
WHERE code = 'voyage';

-- Support both old and new code names
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez un mariage ou un engagement formel ? Ce type concerne les unions officielles : mariage civil, religieux, PACS, fiançailles. L''analyse évalue la date choisie en fonction de votre cycle personnel pour favoriser l''harmonie et la durabilité du couple.'
WHERE code IN ('mariage', 'mariage_engagement');

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous commencez une nouvelle relation amoureuse ? Ce type concerne le commencement d''une relation : premier rendez-vous, déclaration de sentiments, officialisation du couple. L''analyse identifie les moments où votre charisme relationnel et votre ouverture émotionnelle sont les plus développés.'
WHERE code = 'debut_relation';

-- SANTÉ
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous devez planifier une opération ou intervention médicale ? Ce type concerne les actes médicaux programmés : chirurgie, intervention dentaire, procédure esthétique. L''analyse détermine les périodes où votre corps est le plus résistant et la récupération sera la plus rapide.'
WHERE code = 'operation_medicale';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous allez commencer un nouveau traitement médical ? Ce type couvre le démarrage de soins : début de médicaments, thérapie, rééducation, cure thermale. L''analyse identifie les moments où votre organisme sera le plus réceptif au traitement.'
WHERE code = 'debut_traitement';

UPDATE cycle_vie_decision_types SET detailed_description =
'Vous souhaitez changer vos habitudes de vie ? Ce type concerne les transformations personnelles : régime alimentaire, programme sportif, arrêt du tabac, méditation. L''analyse détermine les périodes où votre volonté et votre capacité d''adaptation sont les plus fortes.'
WHERE code = 'changement_habitudes';

-- SPIRITUEL
UPDATE cycle_vie_decision_types SET detailed_description =
'Vous envisagez un pèlerinage ou une retraite spirituelle ? Ce type concerne les déplacements à vocation spirituelle : pèlerinage religieux, retraite de méditation, voyage initiatique. L''analyse identifie les moments où votre réceptivité spirituelle est la plus intense.'
WHERE code = 'pelerinage_retraite';

-- AUTRE
UPDATE cycle_vie_decision_types SET detailed_description =
'Votre décision ne correspond à aucune des catégories proposées ? Ce type convient à toute décision majeure qui ne trouve pas sa place dans les autres catégories : démarche administrative importante, choix de vie complexe, décision familiale. L''analyse évalue le moment optimal en fonction de votre cycle personnel.'
WHERE code IN ('autre', 'autre_decision');

-- ─── VÉRIFICATION ────
SELECT '=== MIGRATION PARTIE 1 TERMINÉE ===' AS status;
SELECT code, label,
  CASE WHEN detailed_description IS NOT NULL THEN '✅' ELSE '❌' END AS has_detail,
  LENGTH(detailed_description) AS detail_len
FROM cycle_vie_decision_types
ORDER BY display_order;

-- Vérifier les colonnes enrichies sur decision_advice
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'cycle_vie_decision_advice'
  AND column_name IN ('cosmic_context', 'recommended_actions', 'pitfalls_to_avoid', 'optimal_timing', 'closing_message')
ORDER BY ordinal_position;
