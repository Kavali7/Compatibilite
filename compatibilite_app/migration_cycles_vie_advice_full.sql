-- ================================================
-- MIGRATION CYCLES DE VIE - CONSEILS DE DÉCISION
-- 140 entrées = 20 types × 7 périodes (cycle personal)
-- Utilise les codes de cycle_vie_decision_types
-- ================================================


-- ================================================
-- PÉRIODE 1 - Nouveaux Départs
-- Énergie: Énergie haute, idéal pour lancer des projets
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 1, 
  85,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Cette période de Nouveaux Départs favorise les nouvelles initiatives immobilières. C''est le moment d''explorer de nouvelles options et de vous lancer avec confiance. Vérifiez néanmoins chaque détail avant de vous engager : l''enthousiasme ne doit pas remplacer la vigilance.'
    WHEN 'achat_immobilier' THEN 'Cette période de Nouveaux Départs favorise les nouvelles initiatives immobilières. C''est le moment d''explorer de nouvelles options et de vous lancer avec confiance. Vérifiez néanmoins chaque détail avant de vous engager : l''enthousiasme ne doit pas remplacer la vigilance.'
    WHEN 'demenagement' THEN 'Cette période de Nouveaux Départs favorise les nouvelles initiatives immobilières. C''est le moment d''explorer de nouvelles options et de vous lancer avec confiance. Vérifiez néanmoins chaque détail avant de vous engager : l''enthousiasme ne doit pas remplacer la vigilance.'
    WHEN 'achat_vehicule' THEN 'L''énergie de Nouveaux Départs favorise les initiatives financières audacieuses. C''est le moment de lancer de nouveaux projets d''investissement. Appuyez votre enthousiasme sur des analyses solides.'
    WHEN 'achat_important' THEN 'L''énergie de Nouveaux Départs favorise les initiatives financières audacieuses. C''est le moment de lancer de nouveaux projets d''investissement. Appuyez votre enthousiasme sur des analyses solides.'
    WHEN 'demande_financement' THEN 'L''énergie de Nouveaux Départs favorise les initiatives financières audacieuses. C''est le moment de lancer de nouveaux projets d''investissement. Appuyez votre enthousiasme sur des analyses solides.'
    WHEN 'recherche_argent' THEN 'L''énergie de Nouveaux Départs favorise les initiatives financières audacieuses. C''est le moment de lancer de nouveaux projets d''investissement. Appuyez votre enthousiasme sur des analyses solides.'
    WHEN 'investissement' THEN 'L''énergie de Nouveaux Départs favorise les initiatives financières audacieuses. C''est le moment de lancer de nouveaux projets d''investissement. Appuyez votre enthousiasme sur des analyses solides.'
    WHEN 'signature_contrat' THEN 'L''énergie de Nouveaux Départs renforce votre position dans les négociations contractuelles. C''est le moment de finaliser des accords. Faites relire chaque document par un expert avant de signer.'
    WHEN 'lancement_business' THEN 'L''énergie de Nouveaux Départs amplifie votre leadership entrepreneurial. C''est le moment de lancer des initiatives ambitieuses. Entourez-vous d''une équipe compétente pour maximiser vos chances.'
    WHEN 'partenariat' THEN 'L''énergie de Nouveaux Départs amplifie votre leadership entrepreneurial. C''est le moment de lancer des initiatives ambitieuses. Entourez-vous d''une équipe compétente pour maximiser vos chances.'
    WHEN 'entretien_embauche' THEN 'L''énergie de Nouveaux Départs amplifie votre visibilité professionnelle. C''est le moment d''affirmer votre valeur et de demander ce que vous méritez. Appuyez vos demandes sur des réalisations concrètes.'
    WHEN 'demande_promotion' THEN 'L''énergie de Nouveaux Départs amplifie votre visibilité professionnelle. C''est le moment d''affirmer votre valeur et de demander ce que vous méritez. Appuyez vos demandes sur des réalisations concrètes.'
    WHEN 'demission_changement' THEN 'L''énergie de Nouveaux Départs amplifie votre visibilité professionnelle. C''est le moment d''affirmer votre valeur et de demander ce que vous méritez. Appuyez vos demandes sur des réalisations concrètes.'
    WHEN 'voyage' THEN 'L''énergie de Nouveaux Départs favorise les nouveaux engagements personnels. C''est le moment de commencer de nouvelles aventures relationnelles. Assurez-vous que vos proches partagent votre vision.'
    WHEN 'mariage_engagement' THEN 'L''énergie de Nouveaux Départs favorise les nouveaux engagements personnels. C''est le moment de commencer de nouvelles aventures relationnelles. Assurez-vous que vos proches partagent votre vision.'
    WHEN 'debut_relation' THEN 'L''énergie de Nouveaux Départs favorise les nouveaux engagements personnels. C''est le moment de commencer de nouvelles aventures relationnelles. Assurez-vous que vos proches partagent votre vision.'
    WHEN 'operation_medicale' THEN 'L''énergie de Nouveaux Départs soutient votre vitalité et vos initiatives de santé. C''est un bon moment pour commencer un nouveau régime ou traitement. Suivez les recommandations médicales avec discipline.'
    WHEN 'debut_traitement' THEN 'L''énergie de Nouveaux Départs soutient votre vitalité et vos initiatives de santé. C''est un bon moment pour commencer un nouveau régime ou traitement. Suivez les recommandations médicales avec discipline.'
    WHEN 'autre_decision' THEN 'L''énergie de Nouveaux Départs vous confère l''audace nécessaire pour les décisions importantes. Faites confiance à votre élan tout en vérifiant les détails. L''enthousiasme éclairé mène au succès.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 2 - Croissance
-- Énergie: Développement des initiatives, construction
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 2, 
  75,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Durant cette phase de Croissance, vos projets immobiliers peuvent se développer harmonieusement. Consolidez vos recherches et affinez vos critères. La patience dans la préparation garantit de meilleures décisions.'
    WHEN 'achat_immobilier' THEN 'Durant cette phase de Croissance, vos projets immobiliers peuvent se développer harmonieusement. Consolidez vos recherches et affinez vos critères. La patience dans la préparation garantit de meilleures décisions.'
    WHEN 'demenagement' THEN 'Durant cette phase de Croissance, vos projets immobiliers peuvent se développer harmonieusement. Consolidez vos recherches et affinez vos critères. La patience dans la préparation garantit de meilleures décisions.'
    WHEN 'achat_vehicule' THEN 'Cette phase de Croissance soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d''une croissance stable. La discipline financière porte ses fruits.'
    WHEN 'achat_important' THEN 'Cette phase de Croissance soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d''une croissance stable. La discipline financière porte ses fruits.'
    WHEN 'demande_financement' THEN 'Cette phase de Croissance soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d''une croissance stable. La discipline financière porte ses fruits.'
    WHEN 'recherche_argent' THEN 'Cette phase de Croissance soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d''une croissance stable. La discipline financière porte ses fruits.'
    WHEN 'investissement' THEN 'Cette phase de Croissance soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d''une croissance stable. La discipline financière porte ses fruits.'
    WHEN 'signature_contrat' THEN 'Cette phase de Croissance favorise les accords durables et équilibrés. Prenez le temps de bien comprendre chaque clause. Un contrat bien réfléchi évite les conflits futurs.'
    WHEN 'lancement_business' THEN 'Cette phase de Croissance favorise le développement progressif de votre activité. Consolidez vos acquis avant d''étendre votre portée. La croissance organique est plus durable.'
    WHEN 'partenariat' THEN 'Cette phase de Croissance favorise le développement progressif de votre activité. Consolidez vos acquis avant d''étendre votre portée. La croissance organique est plus durable.'
    WHEN 'entretien_embauche' THEN 'Cette phase de Croissance favorise le développement de vos compétences. Investissez dans votre formation et votre expertise. La compétence reconnue ouvre les portes.'
    WHEN 'demande_promotion' THEN 'Cette phase de Croissance favorise le développement de vos compétences. Investissez dans votre formation et votre expertise. La compétence reconnue ouvre les portes.'
    WHEN 'demission_changement' THEN 'Cette phase de Croissance favorise le développement de vos compétences. Investissez dans votre formation et votre expertise. La compétence reconnue ouvre les portes.'
    WHEN 'voyage' THEN 'Cette phase de Croissance favorise la construction de relations durables. Investissez du temps dans les liens qui comptent vraiment. La qualité prime sur la quantité.'
    WHEN 'mariage_engagement' THEN 'Cette phase de Croissance favorise la construction de relations durables. Investissez du temps dans les liens qui comptent vraiment. La qualité prime sur la quantité.'
    WHEN 'debut_relation' THEN 'Cette phase de Croissance favorise la construction de relations durables. Investissez du temps dans les liens qui comptent vraiment. La qualité prime sur la quantité.'
    WHEN 'operation_medicale' THEN 'Cette phase de Croissance favorise les soins réguliers et progressifs. Construisez de bonnes habitudes de santé pas à pas. La constance est la clé du bien-être durable.'
    WHEN 'debut_traitement' THEN 'Cette phase de Croissance favorise les soins réguliers et progressifs. Construisez de bonnes habitudes de santé pas à pas. La constance est la clé du bien-être durable.'
    WHEN 'autre_decision' THEN 'Cette phase de Croissance favorise les décisions réfléchies et durables. Prenez le temps de peser chaque aspect avec soin. La patience dans le choix garantit la satisfaction.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 3 - Succès
-- Énergie: Expansion sociale, faveurs et voyages
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 3, 
  90,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Cette période de Succès ouvre des portes et facilite les contacts. Les opportunités immobilières peuvent venir de votre réseau. Restez ouvert aux propositions tout en gardant vos critères essentiels.'
    WHEN 'achat_immobilier' THEN 'Cette période de Succès ouvre des portes et facilite les contacts. Les opportunités immobilières peuvent venir de votre réseau. Restez ouvert aux propositions tout en gardant vos critères essentiels.'
    WHEN 'demenagement' THEN 'Cette période de Succès ouvre des portes et facilite les contacts. Les opportunités immobilières peuvent venir de votre réseau. Restez ouvert aux propositions tout en gardant vos critères essentiels.'
    WHEN 'achat_vehicule' THEN 'Durant cette période de Succès, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.'
    WHEN 'achat_important' THEN 'Durant cette période de Succès, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.'
    WHEN 'demande_financement' THEN 'Durant cette période de Succès, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.'
    WHEN 'recherche_argent' THEN 'Durant cette période de Succès, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.'
    WHEN 'investissement' THEN 'Durant cette période de Succès, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.'
    WHEN 'signature_contrat' THEN 'Durant cette période de Succès, les conditions de négociation vous sont favorables. Vous pouvez obtenir des termes avantageux. Restez néanmoins attentif aux engagements à long terme.'
    WHEN 'lancement_business' THEN 'Durant cette période de Succès, votre réseau peut catalyser votre développement. Les partenariats stratégiques sont favorisés. Soyez ouvert aux collaborations inattendues.'
    WHEN 'partenariat' THEN 'Durant cette période de Succès, votre réseau peut catalyser votre développement. Les partenariats stratégiques sont favorisés. Soyez ouvert aux collaborations inattendues.'
    WHEN 'entretien_embauche' THEN 'Durant cette période de Succès, votre réseau professionnel est un atout majeur. Les opportunités peuvent venir de contacts inattendus. Cultivez vos relations avec sincérité.'
    WHEN 'demande_promotion' THEN 'Durant cette période de Succès, votre réseau professionnel est un atout majeur. Les opportunités peuvent venir de contacts inattendus. Cultivez vos relations avec sincérité.'
    WHEN 'demission_changement' THEN 'Durant cette période de Succès, votre réseau professionnel est un atout majeur. Les opportunités peuvent venir de contacts inattendus. Cultivez vos relations avec sincérité.'
    WHEN 'voyage' THEN 'Durant cette période de Succès, votre cercle social peut s''enrichir. Les rencontres significatives sont favorisées. Restez ouvert aux connexions authentiques.'
    WHEN 'mariage_engagement' THEN 'Durant cette période de Succès, votre cercle social peut s''enrichir. Les rencontres significatives sont favorisées. Restez ouvert aux connexions authentiques.'
    WHEN 'debut_relation' THEN 'Durant cette période de Succès, votre cercle social peut s''enrichir. Les rencontres significatives sont favorisées. Restez ouvert aux connexions authentiques.'
    WHEN 'operation_medicale' THEN 'Durant cette période de Succès, votre énergie vitale peut être élevée. Profitez-en pour explorer de nouvelles approches de bien-être. Restez à l''écoute de votre corps.'
    WHEN 'debut_traitement' THEN 'Durant cette période de Succès, votre énergie vitale peut être élevée. Profitez-en pour explorer de nouvelles approches de bien-être. Restez à l''écoute de votre corps.'
    WHEN 'autre_decision' THEN 'Durant cette période de Succès, les options peuvent se multiplier. Restez ouvert aux opportunités tout en gardant vos critères. L''abondance de choix demande du discernement.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 4 - Stabilité
-- Énergie: Routine, attention aux détails, préservation
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 4, 
  60,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Cette phase de Stabilité favorise les transactions sûres et prévisibles. Privilégiez les options bien établies aux aventures risquées. C''est le moment de sécuriser plutôt que d''innover.'
    WHEN 'achat_immobilier' THEN 'Cette phase de Stabilité favorise les transactions sûres et prévisibles. Privilégiez les options bien établies aux aventures risquées. C''est le moment de sécuriser plutôt que d''innover.'
    WHEN 'demenagement' THEN 'Cette phase de Stabilité favorise les transactions sûres et prévisibles. Privilégiez les options bien établies aux aventures risquées. C''est le moment de sécuriser plutôt que d''innover.'
    WHEN 'achat_vehicule' THEN 'Cette phase de Stabilité favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.'
    WHEN 'achat_important' THEN 'Cette phase de Stabilité favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.'
    WHEN 'demande_financement' THEN 'Cette phase de Stabilité favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.'
    WHEN 'recherche_argent' THEN 'Cette phase de Stabilité favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.'
    WHEN 'investissement' THEN 'Cette phase de Stabilité favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.'
    WHEN 'signature_contrat' THEN 'Cette phase de Stabilité favorise les contrats à termes prévisibles et sécurisés. Privilégiez les accords clairs sans zones d''ombre. La simplicité contractuelle est une force.'
    WHEN 'lancement_business' THEN 'Cette phase de Stabilité favorise la consolidation de votre activité. Renforcez vos processus et fidélisez vos clients. La stabilité opérationnelle précède l''expansion.'
    WHEN 'partenariat' THEN 'Cette phase de Stabilité favorise la consolidation de votre activité. Renforcez vos processus et fidélisez vos clients. La stabilité opérationnelle précède l''expansion.'
    WHEN 'entretien_embauche' THEN 'Cette phase de Stabilité favorise la consolidation de votre position. Renforcez votre expertise dans votre domaine. La stabilité professionnelle se construit sur la fiabilité.'
    WHEN 'demande_promotion' THEN 'Cette phase de Stabilité favorise la consolidation de votre position. Renforcez votre expertise dans votre domaine. La stabilité professionnelle se construit sur la fiabilité.'
    WHEN 'demission_changement' THEN 'Cette phase de Stabilité favorise la consolidation de votre position. Renforcez votre expertise dans votre domaine. La stabilité professionnelle se construit sur la fiabilité.'
    WHEN 'voyage' THEN 'Cette phase de Stabilité favorise la stabilité relationnelle. Renforcez les liens existants plutôt que d''en créer de nouveaux. La fidélité nourrit la confiance.'
    WHEN 'mariage_engagement' THEN 'Cette phase de Stabilité favorise la stabilité relationnelle. Renforcez les liens existants plutôt que d''en créer de nouveaux. La fidélité nourrit la confiance.'
    WHEN 'debut_relation' THEN 'Cette phase de Stabilité favorise la stabilité relationnelle. Renforcez les liens existants plutôt que d''en créer de nouveaux. La fidélité nourrit la confiance.'
    WHEN 'operation_medicale' THEN 'Cette phase de Stabilité favorise le maintien de votre équilibre de santé. Évitez les changements brusques dans vos habitudes. La stabilité corporelle se cultive au quotidien.'
    WHEN 'debut_traitement' THEN 'Cette phase de Stabilité favorise le maintien de votre équilibre de santé. Évitez les changements brusques dans vos habitudes. La stabilité corporelle se cultive au quotidien.'
    WHEN 'autre_decision' THEN 'Cette phase de Stabilité favorise les décisions sûres et prévisibles. Privilégiez les options éprouvées aux aventures risquées. La prudence est une forme de sagesse.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 5 - Changement
-- Énergie: Adaptation, flexibilité et pivots potentiels
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 5, 
  65,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Durant cette période de Changement, restez flexible dans vos recherches immobilières. Les plans peuvent changer, et c''est normal. L''adaptabilité vous mènera vers des options inattendues mais intéressantes.'
    WHEN 'achat_immobilier' THEN 'Durant cette période de Changement, restez flexible dans vos recherches immobilières. Les plans peuvent changer, et c''est normal. L''adaptabilité vous mènera vers des options inattendues mais intéressantes.'
    WHEN 'demenagement' THEN 'Durant cette période de Changement, restez flexible dans vos recherches immobilières. Les plans peuvent changer, et c''est normal. L''adaptabilité vous mènera vers des options inattendues mais intéressantes.'
    WHEN 'achat_vehicule' THEN 'Durant cette période de Changement, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d''incertitude.'
    WHEN 'achat_important' THEN 'Durant cette période de Changement, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d''incertitude.'
    WHEN 'demande_financement' THEN 'Durant cette période de Changement, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d''incertitude.'
    WHEN 'recherche_argent' THEN 'Durant cette période de Changement, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d''incertitude.'
    WHEN 'investissement' THEN 'Durant cette période de Changement, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d''incertitude.'
    WHEN 'signature_contrat' THEN 'Durant cette période de Changement, intégrez des clauses de flexibilité dans vos accords. Les circonstances peuvent évoluer, prévoyez-le. Un contrat adaptable résiste mieux au temps.'
    WHEN 'lancement_business' THEN 'Durant cette période de Changement, restez agile dans votre stratégie d''entreprise. Le marché évolue, adaptez votre offre. La flexibilité est un avantage compétitif.'
    WHEN 'partenariat' THEN 'Durant cette période de Changement, restez agile dans votre stratégie d''entreprise. Le marché évolue, adaptez votre offre. La flexibilité est un avantage compétitif.'
    WHEN 'entretien_embauche' THEN 'Durant cette période de Changement, soyez ouvert aux évolutions de carrière. Les changements peuvent être des opportunités déguisées. L''adaptabilité est une qualité recherchée.'
    WHEN 'demande_promotion' THEN 'Durant cette période de Changement, soyez ouvert aux évolutions de carrière. Les changements peuvent être des opportunités déguisées. L''adaptabilité est une qualité recherchée.'
    WHEN 'demission_changement' THEN 'Durant cette période de Changement, soyez ouvert aux évolutions de carrière. Les changements peuvent être des opportunités déguisées. L''adaptabilité est une qualité recherchée.'
    WHEN 'voyage' THEN 'Durant cette période de Changement, les relations peuvent évoluer. Acceptez les changements comme des opportunités de croissance. La flexibilité relationnelle est une force.'
    WHEN 'mariage_engagement' THEN 'Durant cette période de Changement, les relations peuvent évoluer. Acceptez les changements comme des opportunités de croissance. La flexibilité relationnelle est une force.'
    WHEN 'debut_relation' THEN 'Durant cette période de Changement, les relations peuvent évoluer. Acceptez les changements comme des opportunités de croissance. La flexibilité relationnelle est une force.'
    WHEN 'operation_medicale' THEN 'Durant cette période de Changement, soyez attentif aux signaux de votre corps. Adaptez vos soins selon vos besoins réels. La flexibilité dans l''approche favorise le bien-être.'
    WHEN 'debut_traitement' THEN 'Durant cette période de Changement, soyez attentif aux signaux de votre corps. Adaptez vos soins selon vos besoins réels. La flexibilité dans l''approche favorise le bien-être.'
    WHEN 'autre_decision' THEN 'Durant cette période de Changement, restez flexible dans votre approche. Les circonstances peuvent évoluer, adaptez-vous. La souplesse décisionnelle est une force.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 6 - Récolte
-- Énergie: Moisson des efforts, responsabilités accrues
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 6, 
  80,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Cette phase de Récolte vous permet de récolter les fruits de vos efforts précédents. Si vous avez bien préparé, c''est le moment de conclure. Finalisez vos projets en cours avec détermination.'
    WHEN 'achat_immobilier' THEN 'Cette phase de Récolte vous permet de récolter les fruits de vos efforts précédents. Si vous avez bien préparé, c''est le moment de conclure. Finalisez vos projets en cours avec détermination.'
    WHEN 'demenagement' THEN 'Cette phase de Récolte vous permet de récolter les fruits de vos efforts précédents. Si vous avez bien préparé, c''est le moment de conclure. Finalisez vos projets en cours avec détermination.'
    WHEN 'achat_vehicule' THEN 'Cette phase de Récolte permet de récolter les bénéfices de vos investissements. C''est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.'
    WHEN 'achat_important' THEN 'Cette phase de Récolte permet de récolter les bénéfices de vos investissements. C''est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.'
    WHEN 'demande_financement' THEN 'Cette phase de Récolte permet de récolter les bénéfices de vos investissements. C''est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.'
    WHEN 'recherche_argent' THEN 'Cette phase de Récolte permet de récolter les bénéfices de vos investissements. C''est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.'
    WHEN 'investissement' THEN 'Cette phase de Récolte permet de récolter les bénéfices de vos investissements. C''est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.'
    WHEN 'signature_contrat' THEN 'Cette phase de Récolte permet de conclure des négociations en cours. Finalisez les accords préparés avec détermination. C''est le moment de transformer les discussions en engagements.'
    WHEN 'lancement_business' THEN 'Cette phase de Récolte permet de concrétiser vos projets en résultats. C''est le moment de transformer les efforts en revenus. Concentrez-vous sur la finalisation.'
    WHEN 'partenariat' THEN 'Cette phase de Récolte permet de concrétiser vos projets en résultats. C''est le moment de transformer les efforts en revenus. Concentrez-vous sur la finalisation.'
    WHEN 'entretien_embauche' THEN 'Cette phase de Récolte permet de récolter les fruits de vos efforts professionnels. C''est le moment de demander une promotion ou de finaliser un projet. N''attendez pas pour concrétiser.'
    WHEN 'demande_promotion' THEN 'Cette phase de Récolte permet de récolter les fruits de vos efforts professionnels. C''est le moment de demander une promotion ou de finaliser un projet. N''attendez pas pour concrétiser.'
    WHEN 'demission_changement' THEN 'Cette phase de Récolte permet de récolter les fruits de vos efforts professionnels. C''est le moment de demander une promotion ou de finaliser un projet. N''attendez pas pour concrétiser.'
    WHEN 'voyage' THEN 'Cette phase de Récolte permet de concrétiser vos engagements personnels. C''est le moment de passer à l''étape suivante dans vos relations. Transformez les intentions en actions.'
    WHEN 'mariage_engagement' THEN 'Cette phase de Récolte permet de concrétiser vos engagements personnels. C''est le moment de passer à l''étape suivante dans vos relations. Transformez les intentions en actions.'
    WHEN 'debut_relation' THEN 'Cette phase de Récolte permet de concrétiser vos engagements personnels. C''est le moment de passer à l''étape suivante dans vos relations. Transformez les intentions en actions.'
    WHEN 'operation_medicale' THEN 'Cette phase de Récolte peut voir les résultats de vos efforts de santé. C''est le moment de consolider les acquis. Maintenez les bonnes habitudes qui fonctionnent.'
    WHEN 'debut_traitement' THEN 'Cette phase de Récolte peut voir les résultats de vos efforts de santé. C''est le moment de consolider les acquis. Maintenez les bonnes habitudes qui fonctionnent.'
    WHEN 'autre_decision' THEN 'Cette phase de Récolte permet de concrétiser vos intentions. C''est le moment de transformer la réflexion en action. Ne laissez pas les opportunités mûries passer.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();


-- ================================================
-- PÉRIODE 7 - Préparation
-- Énergie: Repos, introspection, bilan avant nouveau cycle
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)
SELECT dt.id, 'personal', 7, 
  50,
  CASE dt.code
    WHEN 'location_immobilier' THEN 'Cette période de Préparation invite à la réflexion avant l''action. Prenez le temps d''évaluer vos véritables besoins immobiliers. Un temps de recul maintenant évite les regrets futurs.'
    WHEN 'achat_immobilier' THEN 'Cette période de Préparation invite à la réflexion avant l''action. Prenez le temps d''évaluer vos véritables besoins immobiliers. Un temps de recul maintenant évite les regrets futurs.'
    WHEN 'demenagement' THEN 'Cette période de Préparation invite à la réflexion avant l''action. Prenez le temps d''évaluer vos véritables besoins immobiliers. Un temps de recul maintenant évite les regrets futurs.'
    WHEN 'achat_vehicule' THEN 'Cette période de Préparation invite à réfléchir à votre relation avec l''argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions.'
    WHEN 'achat_important' THEN 'Cette période de Préparation invite à réfléchir à votre relation avec l''argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions.'
    WHEN 'demande_financement' THEN 'Cette période de Préparation invite à réfléchir à votre relation avec l''argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions.'
    WHEN 'recherche_argent' THEN 'Cette période de Préparation invite à réfléchir à votre relation avec l''argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions.'
    WHEN 'investissement' THEN 'Cette période de Préparation invite à réfléchir à votre relation avec l''argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions.'
    WHEN 'signature_contrat' THEN 'Cette période de Préparation invite à la prudence contractuelle. Prenez le temps de lire et relire avant de signer. Une décision différée vaut mieux qu''un regret permanent.'
    WHEN 'lancement_business' THEN 'Cette période de Préparation invite à la réflexion stratégique. Prenez du recul sur votre vision d''entreprise. Un bilan honnête prépare les succès futurs.'
    WHEN 'partenariat' THEN 'Cette période de Préparation invite à la réflexion stratégique. Prenez du recul sur votre vision d''entreprise. Un bilan honnête prépare les succès futurs.'
    WHEN 'entretien_embauche' THEN 'Cette période de Préparation invite à réfléchir à vos aspirations profondes. Votre carrière correspond-elle à vos valeurs? La clarté intérieure guide les meilleurs choix.'
    WHEN 'demande_promotion' THEN 'Cette période de Préparation invite à réfléchir à vos aspirations profondes. Votre carrière correspond-elle à vos valeurs? La clarté intérieure guide les meilleurs choix.'
    WHEN 'demission_changement' THEN 'Cette période de Préparation invite à réfléchir à vos aspirations profondes. Votre carrière correspond-elle à vos valeurs? La clarté intérieure guide les meilleurs choix.'
    WHEN 'voyage' THEN 'Cette période de Préparation invite à la réflexion sur vos relations. Quelles connexions vous nourrissent vraiment? La clarté émotionnelle précède les bons choix.'
    WHEN 'mariage_engagement' THEN 'Cette période de Préparation invite à la réflexion sur vos relations. Quelles connexions vous nourrissent vraiment? La clarté émotionnelle précède les bons choix.'
    WHEN 'debut_relation' THEN 'Cette période de Préparation invite à la réflexion sur vos relations. Quelles connexions vous nourrissent vraiment? La clarté émotionnelle précède les bons choix.'
    WHEN 'operation_medicale' THEN 'Cette période de Préparation invite à l''écoute profonde de votre corps. Prenez le temps du repos et de la récupération. La santé se nourrit aussi de pauses.'
    WHEN 'debut_traitement' THEN 'Cette période de Préparation invite à l''écoute profonde de votre corps. Prenez le temps du repos et de la récupération. La santé se nourrit aussi de pauses.'
    WHEN 'autre_decision' THEN 'Cette période de Préparation invite à la réflexion avant l''engagement. Prenez le recul nécessaire pour voir clairement. Une décision différée vaut mieux qu''un choix précipité.'
    ELSE 'Conseil générique pour cette période.'
  END
FROM cycle_vie_decision_types dt
WHERE dt.code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat', 'entretien_embauche', 'demande_promotion', 'demission_changement', 'voyage', 'mariage_engagement', 'debut_relation', 'operation_medicale', 'debut_traitement', 'autre_decision')
ON CONFLICT (decision_type_id, cycle_type, period_number)
DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();
