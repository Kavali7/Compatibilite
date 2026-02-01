-- =============================================
-- SEED COMPLET - PARTIE 2
-- Business, Carrière, Personnel, Santé, Autre
-- =============================================

-- =============================================
-- CATÉGORIE: BUSINESS (2 types)
-- =============================================

-- === LANCEMENT BUSINESS ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour lancer une activité. L''énergie d''initiative maximale vous donne l''élan nécessaire.', 'Assurez-vous d''avoir préparé les bases avant de vous lancer.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4, 'Bonne période pour structurer un lancement. L''énergie de construction aide à poser des fondations solides.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période pour le marketing et la visibilité de lancement. Votre communication est percutante.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 3, 'Période d''équilibre moins favorable aux lancements audacieux. Préférez la consolidation.', 'Lancez seulement si vous avez déjà de solides fondations.', 'Attendez la période 1 pour le grand lancement.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable aux lancements. Risque de doutes paralysants après lancement.', 'Reportez le lancement.', 'Préparez pendant cette période, lancez en période 1.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable si le lancement est un pivot ou une réinvention totale.', 'Défavorable pour les lancements conventionnels.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 2, 'Période de bilan unfavorable aux nouveaux départs. Finalisez les préparatifs.', 'Ne lancez pas maintenant.', 'Planifiez pour la période 1 du prochain cycle.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

-- === PARTENARIAT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative favorable aux nouvelles associations. L''énergie de commencement facilite les rapprochements.', 'Vérifiez la compatibilité des visions avant de vous engager.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les partenariats durables. L''énergie de construction crée des liens solides.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Période de communication idéale pour négocier et conclure des partenariats.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre parfaite. Les partenariats signés maintenant sont harmonieux et équilibrés.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3, 'Période de réflexion. Prenez le temps d''évaluer le partenaire potentiel.', 'Évitez de signer dans cette période d''incertitude.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable pour restructurer des partenariats existants ou en sortir.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour finaliser des partenariats en négociation prolongée.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

-- =============================================
-- CATÉGORIE: CARRIÈRE (3 types)
-- =============================================

-- === ENTRETIEN D'EMBAUCHE ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour les entretiens. Votre énergie et votre enthousiasme impressionneront les recruteurs.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4, 'Bonne période pour les entretiens. Votre sérieux et votre préparation seront appréciés.', 'Préparez minutieusement vos réponses.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période pour la communication en entretien. Vous êtes éloquent et convaincant.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4, 'Période d''équilibre favorable. Votre stabilité rassure les employeurs.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable. Vos doutes peuvent transpirer en entretien.', 'Reportez si possible.', 'Attendez une période plus dynamique.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable si l''entretien concerne une reconversion.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 3, 'Période de bilan. Acceptable pour des postes de transition, moins pour des engagements long terme.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

-- === DEMANDE DE PROMOTION ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour demander une promotion. Votre assurance naturelle renforce votre demande.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4, 'Bonne période. Appuyez votre demande sur des réalisations concrètes et documentées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période pour négocier. Votre éloquence peut faire la différence.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4, 'Période d''équilibre favorable pour des demandes raisonnables et bien argumentées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable. Vos doutes affaiblissent votre position.', 'Reportez votre demande.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Acceptable si la promotion implique un changement de rôle radical.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 3, 'Période de bilan. Préparez votre demande pour la période 1 du prochain cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

-- === DÉMISSION / CHANGEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période idéale pour les nouveaux départs professionnels. L''énergie d''initiative vous porte.', 'Assurez-vous d''avoir préparé la transition.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 3, 'Période de construction moins favorable aux ruptures. Préférez consolider.', 'Évitez les décisions précipitées.', 'Attendez une période plus propice au changement.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4, 'Période d''expansion favorable si le changement ouvre de nouvelles opportunités.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 2, 'Période d''équilibre défavorable aux ruptures. Recherchez plutôt l''harmonie.', 'Évitez de démissionner maintenant sauf urgence.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 4, 'Période de réflexion favorable pour analyser si le changement est vraiment nécessaire.', 'Réfléchissez avant d''agir.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 5, 'Période de transformation parfaite pour les ruptures et changements de vie professionnelle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour clore un chapitre professionnel et préparer le suivant.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demission_changement';

-- =============================================
-- CATÉGORIE: PERSONNEL (3 types)
-- =============================================

-- === VOYAGE ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour partir à l''aventure. L''énergie d''initiative favorise les découvertes.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 3, 'Période de construction moins propice aux voyages. Préférez rester et travailler.', 'Reportez si le voyage n''est pas nécessaire.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période pour voyager. L''expansion et la communication sont favorisées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4, 'Période d''équilibre favorable aux voyages en famille ou avec proches.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 4, 'Période de réflexion favorable aux retraites et voyages spirituels.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable si le voyage marque une transition de vie.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour un voyage de ressourcement avant un nouveau cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

-- === MARIAGE / ENGAGEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative favorable pour se fiancer ou planifier un mariage.', 'L''enthousiasme est bon, mais vérifiez que c''est mûrement réfléchi.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les engagements durables. L''énergie de construction crée des unions solides.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4, 'Période de communication favorable pour les célébrations et réceptions.', 'Attention aux dépenses excessives.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre parfaite. Les unions célébrées maintenant sont harmonieuses.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 2, 'Période de réflexion défavorable. Risque de doutes qui perturbent l''engagement.', 'Reportez si possible.', 'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 3, 'Période de transformation. Favorable si le mariage marque un renouveau de vie.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour conclure une union avant un nouveau cycle de vie commune.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage_engagement';

-- === DÉBUT DE RELATION ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour commencer une nouvelle relation. L''énergie de nouveau départ est idéale.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 4, 'Bonne période pour des relations qui se construisent progressivement.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 5, 'Excellente période sociale pour les rencontres et les débuts de relations.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre favorable aux relations harmonieuses et équilibrées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3, 'Période de réflexion. Les relations qui commencent peuvent être profondes mais incertaines.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation favorable aux relations qui marquent un tournant.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 3, 'Période de bilan. Les relations qui commencent peuvent être karmiques.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

-- =============================================
-- CATÉGORIE: SANTÉ (2 types)
-- =============================================

-- === OPÉRATION MÉDICALE ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''énergie favorable à la récupération. Bonne vitalité post-opératoire.', 'Suivez scrupuleusement les consignes médicales.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les interventions planifiées. Récupération stable et solide.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 3, 'Période d''expansion moins favorable au repos post-opératoire. Risque de complications.', 'Reportez si non urgent.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre idéale. Le corps récupère harmonieusement.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3, 'Période de réflexion. Le mental peut affecter la récupération. Support émotionnel recommandé.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation favorable aux interventions réparatrices ou transformatives.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour les interventions qui préparent un nouveau cycle de santé.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'operation_medicale';

-- === DÉBUT DE TRAITEMENT ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 5, 'Période parfaite pour commencer un nouveau traitement. L''énergie d''initiative soutient le changement.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour établir une routine de traitement durable.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 3, 'Période d''expansion. Risque de négligence du traitement due aux activités sociales.', 'Maintenez la discipline.', NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 5, 'Période d''équilibre idéale pour les traitements qui visent l''harmonie du corps.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 4, 'Période de réflexion favorable aux traitements psychologiques et introspectifs.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation favorable aux traitements détox et purificateurs.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour commencer un traitement de préparation au nouveau cycle.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_traitement';

-- === AUTRE DÉCISION ===
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 1, 4, 'Période d''initiative favorable aux nouveaux commencements de toute nature.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 2, 5, 'Excellente période pour les décisions qui demandent réflexion et construction.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 3, 4, 'Période de communication favorable aux décisions impliquant d''autres personnes.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 4, 4, 'Période d''équilibre favorable aux décisions équilibrées et mesurées.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 5, 3, 'Période de réflexion. Prenez le temps d''analyser avant de décider.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 6, 4, 'Période de transformation favorable aux décisions de changement.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'daily', 7, 4, 'Bonne période pour les décisions de conclusion et de bilan.', NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'autre_decision';

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Conseils de décision insérés:' AS status;
SELECT COUNT(*) AS total_conseils FROM cycle_vie_decision_advice;
SELECT decision_type_id, COUNT(*) AS nb_periodes 
FROM cycle_vie_decision_advice 
WHERE cycle_type = 'daily'
GROUP BY decision_type_id;
