-- =============================================
-- SEED COMPLET: Conseils de Décision par Période
-- 20 types de décision × 7 périodes = 140 entrées
-- =============================================

-- Note: Ce script génère les conseils pour le cycle_type = 'daily'
-- Les scores de favorabilité vont de 1 (défavorable) à 5 (très favorable)

-- =============================================
-- CATÉGORIE: IMMOBILIER (3 types)
-- =============================================

-- === LOCATION IMMOBILIER ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4,
'Période favorable pour rechercher un nouveau logement. L''énergie d''initiative vous aide à trouver rapidement des opportunités intéressantes. Les visites et premiers contacts avec les propriétaires sont bien aspects.',
'Attention à ne pas vous précipiter sous l''enthousiasme du moment. Prenez le temps de vérifier les détails du bail.',
'Si vous devez reporter, la période 3 sera également favorable pour la communication avec les propriétaires.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5,
'Excellente période pour signer un bail ou s''engager dans une location. L''énergie de construction favorise les engagements à long terme. Vous êtes plus attentif aux détails pratiques.',
'Vérifiez bien l''état des lieux et les conditions du contrat.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4,
'Période propice aux échanges et négociations avec les propriétaires. Votre communication est fluide et vous pouvez obtenir de bonnes conditions.',
'Ne vous dispersez pas en visitant trop de biens différents.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5,
'Période d''équilibre idéale pour les questions de logement. C''est le moment parfait pour s''installer durablement et créer un foyer harmonieux.',
NULL,
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3,
'Période de réflexion. Prenez le temps d''analyser vos besoins réels avant de vous engager. Les recherches sont favorables, les signatures moins.',
'Évitez de signer dans la précipitation pendant cette période introspective.',
'Attendez la période 6 ou 1 pour finaliser une signature.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3,
'Période de transformation. Si vous cherchez un changement de logement radical ou un déménagement lié à une nouvelle vie, c''est le bon moment.',
'Les engagements standards sont moins favorables. Privilégiez les situations transitoires.',
'La période 7 sera meilleure pour les décisions définitives.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4,
'Bonne période pour conclure une recherche de logement. L''énergie de bilan vous aide à faire le bon choix avant un nouveau cycle.',
'Ne démarrez pas une nouvelle recherche, finalisez plutôt ce qui est en cours.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';

-- === ACHAT IMMOBILIER ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 3,
'L''énergie d''initiative est présente mais l''achat immobilier demande réflexion. Période favorable pour commencer les recherches, pas pour signer.',
'Ne signez pas sous l''impulsion du moment. L''enthousiasme peut vous faire négliger des défauts.',
'Utilisez cette période pour les visites et recherches. Signez en période 2 ou 4.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5,
'Excellente période pour un achat immobilier. L''énergie de construction et de fondation est parfaitement alignée avec cet engagement majeur.',
'Vérifiez minutieusement tous les aspects techniques et juridiques.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4,
'Période favorable aux négociations et à la communication avec les vendeurs et agents. Bon moment pour visiter et comparer.',
'Attention à la dispersion. Concentrez-vous sur les biens qui correspondent vraiment à vos critères.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5,
'Période d''équilibre parfaite pour l''achat d''une résidence principale. Les énergies favorisent la création d''un foyer stable et harmonieux.',
'Assurez-vous que l''achat correspond à vos besoins familiaux sur le long terme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2,
'Période de réflexion peu favorable aux engagements majeurs. Les doutes peuvent surgir après signature. Mieux vaut observer et analyser.',
'Reportez la signature si possible. Des regrets sont possibles si vous signez maintenant.',
'Attendez la période 6 ou 7 pour une meilleure clarté.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3,
'Période de transformation. Favorable si l''achat représente un changement de vie majeur (nouvelle ville, nouveau départ), sinon patience.',
'Les achats routiniers sont défavorisés. Seulement si c''est un vrai tournant de vie.',
'La période 2 du prochain cycle sera idéale.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4,
'Bonne période pour conclure un achat en cours. L''énergie de bilan aide à finaliser les dossiers avant un nouveau cycle.',
'Ne commencez pas de nouvelles recherches. Finalisez ce qui est déjà en cours.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';

-- === DÉMÉNAGEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5,
'Excellente période pour un déménagement. L''énergie de nouveau départ est parfaitement alignée. Tout nouveau commencement est favorisé.',
'Prenez le temps de bien organiser malgré l''enthousiasme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4,
'Bonne période pour un déménagement bien organisé. L''énergie de construction aide à vous installer solidement.',
'Planifiez méthodiquement. C''est le moment d''être rigoureux.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 3,
'Période d''expansion sociale. Déménager maintenant peut disperser votre énergie. Favorable si le déménagement est lié à une opportunité d''expansion.',
'Risque de complications logistiques dues à la dispersion.',
'Si possible, attendez la période 4 pour plus de sérénité.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5,
'Période idéale pour s''installer dans un nouveau foyer. L''équilibre énergétique favorise l''harmonie de l''installation.',
NULL,
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2,
'Période de réflexion défavorable aux déménagements. Risque de regrets et de nostalgie du lieu quitté.',
'Reportez si possible. L''énergie introspective ne favorise pas les changements concrets majeurs.',
'La période 1 du prochain cycle sera beaucoup plus favorable.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4,
'Période de transformation favorable si le déménagement marque une rupture nécessaire avec le passé.',
'Favorable uniquement pour les déménagements liés à une transformation de vie.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 3,
'Période de bilan. Déménager maintenant clôt un cycle. Acceptable si c''est pour préparer un nouveau départ.',
'Préférez finaliser les préparatifs et déménager effectivement en période 1.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';

-- =============================================
-- CATÉGORIE: FINANCE (5 types)
-- =============================================

-- === ACHAT VÉHICULE ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4,
'Bonne période pour acquérir un nouveau véhicule. L''énergie d''initiative favorise les nouveaux achats et les nouveaux départs.',
'Comparez plusieurs offres malgré l''enthousiasme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5,
'Excellente période pour un achat de véhicule. L''énergie de construction favorise les décisions durables et bien réfléchies.',
'Vérifiez minutieusement l''état technique.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4,
'Période favorable aux négociations. Excellent moment pour obtenir une bonne affaire grâce à votre communication.',
'Évitez de vous laisser séduire par un vendeur trop persuasif.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4,
'Bonne période pour un achat familial ou un véhicule destiné au quotidien. L''équilibre favorise les choix rationnels.',
NULL,
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3,
'Période de réflexion. Bon moment pour comparer et analyser, moins favorable pour signer.',
'Reportez l''achat final si possible.',
'La période 6 ou 7 sera plus favorable pour conclure.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 2,
'Période de transformation peu favorable aux achats standards. Risque de regrets.',
'Reportez sauf nécessité absolue.',
'Attendez la période 1 ou 2 du prochain cycle.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4,
'Acceptable pour conclure un achat déjà préparé. Évitez de commencer de nouvelles recherches.',
NULL,
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- === ACHAT IMPORTANT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative favorable aux achats majeurs. L''énergie vous pousse à investir dans la nouveauté.', 'Ne confondez pas envie et besoin réel.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les achats durables. L''énergie de construction garantit des choix judicieux.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 3, 'Période d''expansion. Risque de dépenses excessives dues à l''enthousiasme social.', 'Attention aux achats impulsifs.', 'Réfléchissez 24h avant tout achat majeur.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre parfaite pour les achats domestiques et familiaux.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion. Évitez les achats majeurs. Analysez plutôt vos besoins.', 'Risque de regret après achat.', 'Reportez à la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable uniquement pour les achats liés à un changement de vie.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour finaliser des achats planifiés. Évitez les nouvelles tentations.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- === DEMANDE DE FINANCEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative. Votre énergie et votre enthousiasme séduiront les banquiers. Premier contact favorable.', 'Préparez bien votre dossier avant le rendez-vous.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les demandes de prêt. L''énergie de construction rassure les prêteurs sur votre sérieux.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4, 'Période de communication favorable. Vos argumentaires seront convaincants. Bon moment pour négocier les taux.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre idéale. Les prêteurs perçoivent votre stabilité. Excellent pour les prêts immobiliers.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable. Vos doutes se perçoivent et inquiètent les prêteurs.', 'Reportez votre demande si possible.', 'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable si le financement est lié à un changement de vie majeur.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour conclure une demande déjà initiée. Finalisez avant le nouveau cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- === RECHERCHE D'ARGENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative favorable. Votre dynamisme attire les opportunités financières.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4, 'Période de construction. Les recherches méthodiques portent leurs fruits.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période pour le networking et la recherche de financements. Votre réseau s''active.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4, 'Période d''équilibre. Les sources stables et familiales sont favorisées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3, 'Période de réflexion. Analysez vos options plutôt que de vous précipiter.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation. Les financements liés à un pivot ou une restructuration sont favorables.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 3, 'Période de bilan. Finalisez les pistes en cours plutôt que d''en ouvrir de nouvelles.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

-- === INVESTISSEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 3, 'Période d''initiative. Favorable pour commencer à s''intéresser à un investissement, pas pour signer.', 'L''enthousiasme peut vous faire négliger les risques.', 'Étudiez maintenant, investissez en période 2.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour investir. L''énergie de construction favorise les placements à long terme.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 3, 'Période d''expansion. Risque de surinvestissement ou de diversification excessive.', 'Attention aux promesses trop belles.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre idéale. Investissements immobiliers et placements sécurisés favorisés.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable aux investissements. Risque de mauvais timing.', 'Reportez toute décision d''investissement.', 'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation. Favorable pour les restructurations de portefeuille et les pivots stratégiques.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour récolter les fruits d''investissements passés ou repositionner avant le nouveau cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

-- =============================================
-- CATÉGORIE: JURIDIQUE (1 type)
-- =============================================

-- === SIGNATURE DE CONTRAT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative. Favorable pour les contrats de démarrage et d''engagement initial.', 'Lisez bien toutes les clauses malgré l''enthousiasme.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour signer. L''énergie de construction garantit des engagements solides.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4, 'Période de communication favorable aux négociations finales et ajustements de clauses.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre parfaite. Les contrats signés maintenant sont équilibrés et durables.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion déconseillée pour les signatures. Risque de regrets.', 'Reportez si possible.', 'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable pour les contrats de rupture ou de restructuration.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour finaliser des contrats en négociation. Clôturez avant le nouveau cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';
