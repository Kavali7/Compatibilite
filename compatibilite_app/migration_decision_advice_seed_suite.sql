-- ================================================
-- MIGRATION: Conseils Décisions - Cycles Business & Health
-- Fichier: migration_decision_advice_seed_suite.sql
-- Suite du fichier principal (personal + daily déjà insérés)
-- ================================================

-- Note: Le fichier principal a déjà inséré les conseils pour:
-- - personal (7 périodes × 20 types = 140 entrées)
-- - daily (7 périodes × 20 types = 140 entrées)

-- Ce fichier ajoute les conseils pour:
-- - business (7 périodes × 20 types = 140 entrées)
-- - health (7 périodes × 20 types = 140 entrées)

-- ================================================
-- CYCLE BUSINESS - Période 1 (Jours 1-52 du cycle business)
-- Thème: Initiative, Nouveaux Projets
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Période d''initiative exceptionnelle pour les projets immobiliers professionnels. Lancez vos recherches de locaux.',
    'Comparez plusieurs options avant de vous engager.',
    'Excellent moment pour visiter de nouveaux espaces de travail.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 85,
    'Acquisition immobilière favorable pour l''expansion business. Les investissements immobiliers professionnels sont soutenus.',
    'Faites une analyse financière rigoureuse.',
    'Considérez aussi la location avec option d''achat.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 80,
    'Déménagement d''entreprise très favorable. Les changements de locaux apportent un renouveau bénéfique.',
    'Planifiez pour minimiser l''interruption d''activité.',
    'C''est le moment de repenser votre espace de travail.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 85,
    'Achat de véhicules professionnels favorisé. Renouvellement de flotte bénéfique.',
    'Comparez les options de leasing vs achat.',
    'Pensez aux véhicules électriques pour l''image.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Investissements en équipement très favorables. Modernisez vos outils de production.',
    'Priorisez les achats à forte valeur ajoutée.',
    'C''est le moment d''investir dans la technologie.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Période idéale pour les demandes de financement business. Les banques sont réceptives à vos projets.',
    'Présentez un business plan solide.',
    'Multipliez les sources de financement.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 95,
    'Levée de fonds exceptionnellement favorable. Les investisseurs sont attirés par votre énergie d''initiative.',
    'Préparez votre pitch avec soin.',
    'Contactez plusieurs investisseurs en parallèle.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 85,
    'Investissements stratégiques favorisés. Plantez les graines de la croissance future.',
    'Diversifiez vos placements.',
    'Investissez dans des secteurs en croissance.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Signatures de contrats commerciaux très favorables. Initiez de nouveaux partenariats.',
    'Lisez attentivement toutes les clauses.',
    'Négociez des conditions flexibles pour la croissance.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 95,
    'Période idéale pour lancer un nouveau business ou produit! Les énergies d''initiative sont à leur maximum.',
    'Assurez-vous d''être prêt à 100%.',
    'Lancez avec un minimum viable product d''abord.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Formation de partenariats stratégiques très favorable. Alliez-vous aux meilleurs.',
    'Choisissez des partenaires complémentaires.',
    'Formalisez les accords par écrit.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 85,
    'Excellent moment pour les recrutements stratégiques. Attirez les meilleurs talents.',
    'Soyez sélectif sur les compétences clés.',
    'Offrez des packages attractifs.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 85,
    'Demandes de promotion ou d''augmentation favorables. Votre valeur est reconnue.',
    'Justifiez avec des résultats concrets.',
    'Proposez de nouvelles responsabilités.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 80,
    'Si vous quittez, c''est pour créer mieux. Transition favorable vers l''entrepreneuriat.',
    'Assurez vos arrières financièrement.',
    'Préparez votre projet avant de partir.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 80,
    'Voyages d''affaires pour expansion très favorables. Prospectez de nouveaux marchés.',
    'Planifiez des rencontres concrètes.',
    'Combinez prospection et networking.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 70,
    'Engagements personnels possibles si le business le permet. Équilibrez vie pro/perso.',
    'Ne sacrifiez pas votre vie personnelle.',
    'Déléguez pour vous libérer du temps.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 70,
    'Nouvelles relations networking très favorables. Développez votre réseau professionnel.',
    'Restez focus sur les contacts stratégiques.',
    'Participez à des événements sectoriels.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 65,
    'Période d''énergie intense, pas idéale pour les interventions médicales non urgentes.',
    'Reportez si possible pour rester opérationnel.',
    'Privilégiez les check-ups préventifs.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 70,
    'Traitements énergisants favorisés. Maintenez votre forme pour supporter le rythme intense.',
    'Ne négligez pas votre santé.',
    'Adoptez des routines de bien-être.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 1, 90,
    'Période d''initiative business exceptionnelle. Lancez vos projets ambitieux.',
    'Agissez avec vision stratégique.',
    'C''est le moment de passer à l''action.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- CYCLE BUSINESS - Période 2 (Croissance et Consolidation)
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Période de croissance pour les projets immobiliers. Élargissez vos espaces de travail.',
    'Anticipez les besoins de croissance.',
    'Négociez des baux flexibles.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 75,
    'Acquisition immobilière pour la croissance. Pensez à long terme.',
    'Analysez le retour sur investissement.',
    'Considérez les zones à fort potentiel.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 75,
    'Déménagement vers des espaces plus grands favorisé.',
    'Planifiez la transition soigneusement.',
    'Profitez pour optimiser les flux de travail.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Achat de véhicules supplémentaires pour accompagner la croissance.',
    'Évaluez les besoins réels.',
    'Optez pour des solutions évolutives.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Investissements pour la croissance très favorables. Augmentez vos capacités.',
    'Investissez dans ce qui génère plus de revenus.',
    'Automatisez les processus répétitifs.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Demandes de financement pour expansion favorables.',
    'Montrez vos résultats de croissance.',
    'Diversifiez vos sources de financement.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Recherche d''investisseurs pour la série suivante favorable.',
    'Mettez en avant vos métriques de croissance.',
    'Préparez des projections réalistes.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Investissements de croissance favorisés. Réinvestissez les bénéfices.',
    'Gardez des réserves de sécurité.',
    'Diversifiez vos investissements.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Contrats de croissance et d''expansion favorables.',
    'Négociez des conditions évolutives.',
    'Prévoyez des clauses de révision.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Lancement de nouvelles lignes de produits favorable.',
    'Appuyez-vous sur vos succès existants.',
    'Testez avant de déployer massivement.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Partenariats de croissance très favorables. Alliez-vous pour grandir plus vite.',
    'Choisissez des partenaires qui grandissent aussi.',
    'Définissez clairement les objectifs communs.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Recrutements pour accompagner la croissance. Structurez vos équipes.',
    'Recrutez pour les besoins projetés.',
    'Investissez dans la formation.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Promotions basées sur les résultats favorables.',
    'Évaluez la performance réelle.',
    'Proposez des plans de carrière.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 70,
    'Transition possible vers un rôle plus stratégique.',
    'Assurez la continuité.',
    'Formez votre successeur.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Voyages d''affaires pour consolidation et expansion favorables.',
    'Visitez vos clients clés.',
    'Renforcez les relations existantes.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 70,
    'Période de travail intense. Engagements personnels à équilibrer.',
    'Ne négligez pas votre vie personnelle.',
    'Planifiez du temps de qualité.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 80,
    'Relations professionnelles pour la croissance favorables.',
    'Cultivez votre réseau.',
    'Participez aux événements sectoriels.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 65,
    'Interventions médicales à reporter si possible.',
    'Restez opérationnel.',
    'Programmez pendant les périodes creuses.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 70,
    'Traitements régénérants pour soutenir le rythme.',
    'Maintenez votre énergie.',
    'Investissez dans votre bien-être.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 2, 85,
    'Période de croissance business. Investissez dans l''expansion.',
    'Consolidez tout en grandissant.',
    'Gardez le cap sur vos objectifs.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- CYCLE BUSINESS - Périodes 3 à 7 (Conseils condensés)
-- ================================================

-- Période 3 (Communication et Marketing)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 75, 'Période de communication et marketing. Négociez vos espaces avec éloquence.', 'Soignez votre image.', 'Utilisez les réseaux sociaux.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 80, 'Excellente période pour les présentations et pitchs. Communiquez votre vision.', 'Préparez vos supports.', 'Faites des présentations percutantes.'
FROM cycle_vie_decision_types WHERE code IN ('achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 85, 'Négociations de contrats favorisées. Votre éloquence est au maximum.', 'Écoutez aussi l''autre partie.', 'Trouvez des accords gagnant-gagnant.'
FROM cycle_vie_decision_types WHERE code IN ('investissement', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 90, 'Lancements marketing exceptionnels! Faites du bruit autour de votre offre.', 'Maximisez la visibilité.', 'Investissez dans la publicité.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 85, 'Entretiens et négociations salariales favorisés.', 'Communiquez votre valeur.', 'Préparez vos arguments.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 80, 'Voyages pour conférences et présentations très favorables.', 'Préparez vos interventions.', 'Soyez visible.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 75, 'Communications relationnelles favorables.', 'Exprimez vos sentiments.', 'Dialoguez ouvertement.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 70, 'Consultations médicales favorables. Discutez avec les spécialistes.', 'Posez toutes vos questions.', 'Comprenez bien les options.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 3, 80, 'Période de communication. Faites passer vos messages.', 'Soyez clair et concis.', 'Utilisez tous les canaux.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Période 4 (Travail et Structure)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 70, 'Période de travail intense. Focus sur les opérations.', 'Restez méthodique.', 'Optimisez vos processus.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 65, 'Demandes de financement moins favorables. Attendez ou préparez mieux.', 'Les banquiers sont exigeants.', 'Solidifiez vos fondamentaux.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 70, 'Contrats opérationnels à signer. Focus sur l''exécution.', 'Vérifiez les détails techniques.', 'Assurez la faisabilité.'
FROM cycle_vie_decision_types WHERE code IN ('signature_contrat', 'lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 70, 'Recrutements opérationnels favorisés.', 'Cherchez des profils opérationnels.', 'Testez les compétences pratiques.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 60, 'Voyages limités aux nécessités opérationnelles.', 'Restez focalisé sur le travail.', 'Privilégiez les réunions virtuelles.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 60, 'Période de travail intense, peu propice aux grandes décisions personnelles.', 'Équilibrez vie pro/perso.', 'Planifiez du temps pour vous.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 4, 70, 'Période de travail. Produisez, exécutez, livrez.', 'Maintenez le rythme.', 'Déléguez pour optimiser.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Période 5 (Expansion et Opportunités)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 85, 'Période d''expansion! Saisissez les opportunités immobilières.', 'Évaluez les risques.', 'Grandissez intelligemment.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 90, 'Financements pour expansion très favorables!', 'Profitez de cette fenêtre.', 'Négociez les meilleures conditions.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 90, 'Contrats d''expansion et partenariats très favorables!', 'Signez maintenant.', 'Élargissez votre portée.'
FROM cycle_vie_decision_types WHERE code IN ('signature_contrat', 'lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 85, 'Recrutement de talents pour l''expansion.', 'Attirez les meilleurs.', 'Offrez des perspectives de croissance.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 85, 'Voyages d''expansion très favorables. Conquérez de nouveaux marchés.', 'Explorez les opportunités.', 'Rencontrez de nouveaux partenaires.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 75, 'Équilibre possible entre expansion et vie personnelle.', 'Ne sacrifiez pas tout.', 'Incluez vos proches dans le succès.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 5, 85, 'Période d''expansion business. Soyez ambitieux!', 'Pensez grand.', 'Saisissez les opportunités.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Période 6 (Consolidation et Prudence)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 55, 'Période de consolidation. Évitez les nouvelles implantations.', 'Optimisez l''existant.', 'Renégociez les baux actuels.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 50, 'Financements à reporter. Consolidez votre trésorerie.', 'Réduisez les dépenses.', 'Préservez votre cash.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 60, 'Contrats de maintenance et renouvellement uniquement.', 'Évitez les engagements risqués.', 'Renforcez les relations existantes.'
FROM cycle_vie_decision_types WHERE code IN ('signature_contrat', 'lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 55, 'Période moins favorable aux recrutements.', 'Optimisez vos effectifs.', 'Formez les équipes actuelles.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 55, 'Voyages limités à l''essentiel.', 'Réduisez les coûts.', 'Privilégiez le virtuel.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 65, 'Période propice au ressourcement personnel.', 'Prenez du recul.', 'Reposez-vous pour repartir.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 6, 55, 'Période de consolidation. Prudence dans les décisions.', 'Évitez les risques.', 'Préparez la prochaine expansion.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Période 7 (Bilan et Préparation)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 70, 'Période de bilan. Finalisez les projets immobiliers en cours.', 'Ne commencez rien de nouveau.', 'Préparez le prochain cycle.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 65, 'Finalisez les financements en cours. Nouveaux à reporter.', 'Faites le bilan financier.', 'Préparez le budget du prochain cycle.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 75, 'Conclusion des contrats en cours favorable.', 'Réglez les affaires pendantes.', 'Préparez les nouveaux accords.'
FROM cycle_vie_decision_types WHERE code IN ('signature_contrat', 'lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 70, 'Bilan des équipes. Préparez les évolutions pour le prochain cycle.', 'Évaluez les performances.', 'Planifiez la formation.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 70, 'Voyages de bilan et séminaires stratégiques.', 'Réfléchissez à l''avenir.', 'Planifiez le prochain cycle.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 75, 'Période propice aux engagements et bilans personnels.', 'Équilibrez vie pro/perso.', 'Célébrez les réussites.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'business', 7, 70, 'Période de bilan business. Récoltez et préparez.', 'Finissez ce qui est commencé.', 'Vision stratégique pour le futur.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- CYCLE HEALTH - Toutes Périodes
-- ================================================

-- Période 1 (Énergie et Vitalité)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 85, 'Période de haute énergie. Votre vitalité soutient les projets actifs.', 'Profitez de cette énergie.', 'Lancez des projets physiquement exigeants.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 80, 'Énergie mentale favorable aux décisions financières complexes.', 'Restez actif physiquement.', 'L''exercice booste la clarté mentale.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 85, 'Énergie maximale pour les lancements et négociations intenses.', 'Utilisez bien cette période.', 'Planifiez les activités exigeantes.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 90, 'Voyages sportifs et actifs très favorables. Explorez!', 'Profitez de votre vitalité.', 'Combinez voyage et activité physique.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 85, 'Énergie positive pour les engagements. Vitalité relationnelle.', 'Partagez votre dynamisme.', 'Activités en couple favorisées.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 75, 'Récupération rapide après intervention. Corps résilient.', 'Bon moment pour la chirurgie élective.', 'Le corps se régénère bien.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 85, 'Traitements intensifs bien tolérés. Corps résistant.', 'Commencez les cures maintenant.', 'Le corps répond positivement.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 1, 85, 'Haute énergie santé. Période favorable à l''action.', 'Profitez de cette vitalité.', 'Lancez vos projets santé.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Période 2 (Équilibre et Récupération)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 75, 'Période d''équilibre. Projets modérés favorisés.', 'Maintenez une routine saine.', 'Équilibrez effort et repos.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 70, 'Décisions financières à prendre calmement.', 'Ne vous stressez pas.', 'Prenez le temps de réfléchir.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 75, 'Lancez des projets équilibrés. Évitez le surmenage.', 'Gérez votre énergie.', 'Déléguez si nécessaire.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 80, 'Voyages détente et bien-être favorisés.', 'Ressourcez-vous.', 'Spas et retraites recommandés.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 80, 'Relations équilibrées et harmonieuses.', 'Cultivez la sérénité.', 'Activités calmes en couple.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 80, 'Opérations de rééquilibrage favorables.', 'Le corps accepte bien les soins.', 'Chirurgie reconstructive idéale.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 80, 'Traitements d''équilibre et récupération favorables.', 'Corps réceptif.', 'Cures de rééquilibrage idéales.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 2, 75, 'Période d''équilibre santé. Modérez les excès.', 'Maintenez l''harmonie.', 'Prenez soin de vous.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- Périodes 3-7 (Conseils condensés selon les thèmes santé)
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 3, 80, 'Période mentale favorable. Communication santé excellente.', 'Exprimez vos besoins.', 'Consultez des spécialistes.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 3, 75, 'Période de consultation. Parlez à vos médecins.', 'Posez toutes vos questions.', 'Prenez des seconds avis.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement', 'autre_decision');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 4, 65, 'Période de vulnérabilité. Soyez prudent.', 'Ménagez-vous.', 'Reportez les efforts intenses.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 4, 60, 'Évitez les interventions si possible.', 'Corps plus fragile.', 'Reportez les chirurgies non urgentes.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement', 'autre_decision');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 5, 85, 'Période de force. Corps résistant.', 'Profitez de cette énergie.', 'Bon moment pour le sport.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 5, 80, 'Interventions bien tolérées. Récupération rapide.', 'Corps en forme.', 'Traitements actifs favorisés.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement', 'autre_decision');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 6, 55, 'Période de repos. Conservez votre énergie.', 'Ne vous surmenez pas.', 'Repos et récupération.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 6, 65, 'Traitements de repos favorisés. Évitez les interventions.', 'Laissez le corps se régénérer.', 'Cures de récupération.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement', 'autre_decision');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 7, 70, 'Période de bilan santé. Faites vos check-ups.', 'Évaluez votre état.', 'Préparez le prochain cycle.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'health', 7, 75, 'Bilans médicaux très favorables. Ajustez les traitements.', 'Préparez l''année suivante.', 'Optimisez votre santé.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement', 'autre_decision');

-- ================================================
-- VÉRIFICATION FINALE
-- ================================================
SELECT 'Conseils Business & Health insérés avec succès!' AS status;
SELECT cycle_type, period_number, COUNT(*) as nb_conseils 
FROM cycle_vie_decision_advice 
GROUP BY cycle_type, period_number 
ORDER BY cycle_type, period_number;
