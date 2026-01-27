-- ================================================
-- MIGRATION CYCLES DE VIE - CONSEILS DE DÉCISION
-- 280 entrées générées automatiquement
-- Formule: Affirmation + Encouragement + Sagesse
-- ================================================


-- ================================================
-- PÉRIODE 1A - Le Guerrier Noble
-- Énergie: Leadership, noblesse, ambition, décisions audacieuses
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 1, 'A', 'Votre énergie de Le Guerrier Noble renforce votre capacité à négocier et à vous imposer dans ce domaine. C''est le moment d''avancer avec assurance sur vos projets immobiliers. Vérifiez toutefois chaque détail contractuel : votre confiance ne doit pas masquer les subtilités importantes.'),
('achat_immobilier', 1, 'A', 'Votre énergie de Le Guerrier Noble renforce votre capacité à négocier et à vous imposer dans ce domaine. C''est le moment d''avancer avec assurance sur vos projets immobiliers. Vérifiez toutefois chaque détail contractuel : votre confiance ne doit pas masquer les subtilités importantes.'),
('demenagement', 1, 'A', 'Votre énergie de Le Guerrier Noble renforce votre capacité à négocier et à vous imposer dans ce domaine. C''est le moment d''avancer avec assurance sur vos projets immobiliers. Vérifiez toutefois chaque détail contractuel : votre confiance ne doit pas masquer les subtilités importantes.'),
('achat_vehicule', 1, 'A', 'L''énergie de Le Guerrier Noble soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l''audace financière doit être calculée.'),
('achat_important', 1, 'A', 'L''énergie de Le Guerrier Noble soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l''audace financière doit être calculée.'),
('demande_financement', 1, 'A', 'L''énergie de Le Guerrier Noble soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l''audace financière doit être calculée.'),
('recherche_argent', 1, 'A', 'L''énergie de Le Guerrier Noble soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l''audace financière doit être calculée.'),
('investissement', 1, 'A', 'L''énergie de Le Guerrier Noble soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l''audace financière doit être calculée.'),
('signature_contrat', 1, 'A', 'Votre énergie de Le Guerrier Noble renforce votre position dans les négociations contractuelles. C''est le moment de finaliser des accords favorables. Faites néanmoins relire chaque document par un expert : la confiance n''exclut pas la vérification.'),
('lancement_business', 1, 'A', 'L''énergie du Le Guerrier Noble amplifie votre leadership entrepreneurial. C''est le moment de lancer des initiatives ambitieuses. Entourez-vous d''une équipe compétente : même le meilleur leader a besoin de soutien.'),
('partenariat', 1, 'A', 'L''énergie du Le Guerrier Noble amplifie votre leadership entrepreneurial. C''est le moment de lancer des initiatives ambitieuses. Entourez-vous d''une équipe compétente : même le meilleur leader a besoin de soutien.'),
('entretien_embauche', 1, 'A', 'L''énergie de Le Guerrier Noble amplifie votre leadership professionnel. C''est le moment d''affirmer votre valeur et de demander la reconnaissance méritée. Appuyez vos demandes sur des réalisations concrètes.'),
('demande_promotion', 1, 'A', 'L''énergie de Le Guerrier Noble amplifie votre leadership professionnel. C''est le moment d''affirmer votre valeur et de demander la reconnaissance méritée. Appuyez vos demandes sur des réalisations concrètes.'),
('demission_changement', 1, 'A', 'L''énergie de Le Guerrier Noble amplifie votre leadership professionnel. C''est le moment d''affirmer votre valeur et de demander la reconnaissance méritée. Appuyez vos demandes sur des réalisations concrètes.'),
('voyage', 1, 'A', 'L''énergie de Le Guerrier Noble soutient les engagements personnels significatifs. C''est le moment d''affirmer vos choix de vie avec conviction. Assurez-vous que vos proches partagent votre vision.'),
('mariage_engagement', 1, 'A', 'L''énergie de Le Guerrier Noble soutient les engagements personnels significatifs. C''est le moment d''affirmer vos choix de vie avec conviction. Assurez-vous que vos proches partagent votre vision.'),
('debut_relation', 1, 'A', 'L''énergie de Le Guerrier Noble soutient les engagements personnels significatifs. C''est le moment d''affirmer vos choix de vie avec conviction. Assurez-vous que vos proches partagent votre vision.'),
('operation_medicale', 1, 'A', 'L''énergie de Le Guerrier Noble soutient votre vitalité et votre capacité de récupération. Abordez les soins avec confiance et détermination. Suivez néanmoins scrupuleusement les recommandations médicales.'),
('debut_traitement', 1, 'A', 'L''énergie de Le Guerrier Noble soutient votre vitalité et votre capacité de récupération. Abordez les soins avec confiance et détermination. Suivez néanmoins scrupuleusement les recommandations médicales.'),
('autre_decision', 1, 'A', 'L''énergie de Le Guerrier Noble vous confère le discernement et l''audace nécessaires pour toute décision importante. Faites confiance à votre leadership intérieur. Vérifiez que votre choix sert vos intérêts à long terme.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 1B - L'Artiste Déterminé
-- Énergie: Raffinement, subtilité, patience, talents artistiques
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 1, 'B', 'L''influence de L''Artiste Déterminé vous guide vers des choix réfléchis et harmonieux. Prenez le temps d''évaluer chaque option avec votre sensibilité naturelle. La patience sera votre meilleure alliée : les meilleures opportunités se révèlent à ceux qui savent attendre.'),
('achat_immobilier', 1, 'B', 'L''influence de L''Artiste Déterminé vous guide vers des choix réfléchis et harmonieux. Prenez le temps d''évaluer chaque option avec votre sensibilité naturelle. La patience sera votre meilleure alliée : les meilleures opportunités se révèlent à ceux qui savent attendre.'),
('demenagement', 1, 'B', 'L''influence de L''Artiste Déterminé vous guide vers des choix réfléchis et harmonieux. Prenez le temps d''évaluer chaque option avec votre sensibilité naturelle. La patience sera votre meilleure alliée : les meilleures opportunités se révèlent à ceux qui savent attendre.'),
('achat_vehicule', 1, 'B', 'Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d''analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.'),
('achat_important', 1, 'B', 'Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d''analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.'),
('demande_financement', 1, 'B', 'Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d''analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.'),
('recherche_argent', 1, 'B', 'Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d''analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.'),
('investissement', 1, 'B', 'Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d''analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.'),
('signature_contrat', 1, 'B', 'Votre patience vous permet de négocier des termes équilibrés et durables. Prenez le temps de comprendre chaque clause. Un contrat signé dans la sérénité est plus solide qu''un accord précipité.'),
('lancement_business', 1, 'B', 'Votre approche patiente construit des entreprises durables. Bâtissez votre projet avec soin et attention aux détails. La croissance organique surpasse souvent l''expansion forcée.'),
('partenariat', 1, 'B', 'Votre approche patiente construit des entreprises durables. Bâtissez votre projet avec soin et attention aux détails. La croissance organique surpasse souvent l''expansion forcée.'),
('entretien_embauche', 1, 'B', 'Votre approche subtile et patiente impressionne favorablement. Laissez votre travail parler de lui-même tout en sachant vous mettre en valeur. La modestie n''exclut pas la visibilité.'),
('demande_promotion', 1, 'B', 'Votre approche subtile et patiente impressionne favorablement. Laissez votre travail parler de lui-même tout en sachant vous mettre en valeur. La modestie n''exclut pas la visibilité.'),
('demission_changement', 1, 'B', 'Votre approche subtile et patiente impressionne favorablement. Laissez votre travail parler de lui-même tout en sachant vous mettre en valeur. La modestie n''exclut pas la visibilité.'),
('voyage', 1, 'B', 'Votre sensibilité vous guide vers des relations authentiques et profondes. Prenez le temps de cultiver les liens qui vous nourrissent. La qualité des relations surpasse leur quantité.'),
('mariage_engagement', 1, 'B', 'Votre sensibilité vous guide vers des relations authentiques et profondes. Prenez le temps de cultiver les liens qui vous nourrissent. La qualité des relations surpasse leur quantité.'),
('debut_relation', 1, 'B', 'Votre sensibilité vous guide vers des relations authentiques et profondes. Prenez le temps de cultiver les liens qui vous nourrissent. La qualité des relations surpasse leur quantité.'),
('operation_medicale', 1, 'B', 'Votre patience favorise une approche sereine des questions de santé. Prenez soin de vous avec douceur et constance. La guérison véritable prend le temps nécessaire.'),
('debut_traitement', 1, 'B', 'Votre patience favorise une approche sereine des questions de santé. Prenez soin de vous avec douceur et constance. La guérison véritable prend le temps nécessaire.'),
('autre_decision', 1, 'B', 'Votre sensibilité et votre patience éclairent cette décision. Prenez le temps de peser chaque aspect avec soin. La réponse juste émergera de votre réflexion approfondie.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 2A - L'Esprit Vif
-- Énergie: Voyage, changement, intellect rapide, adaptabilité
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 2, 'A', 'Votre esprit vif vous permet d''évaluer rapidement plusieurs options. Cette période favorise les visites multiples et les comparaisons efficaces. Notez vos impressions immédiatement car votre intuition première est souvent juste.'),
('achat_immobilier', 2, 'A', 'Votre esprit vif vous permet d''évaluer rapidement plusieurs options. Cette période favorise les visites multiples et les comparaisons efficaces. Notez vos impressions immédiatement car votre intuition première est souvent juste.'),
('demenagement', 2, 'A', 'Votre esprit vif vous permet d''évaluer rapidement plusieurs options. Cette période favorise les visites multiples et les comparaisons efficaces. Notez vos impressions immédiatement car votre intuition première est souvent juste.'),
('achat_vehicule', 2, 'A', 'Votre vivacité d''esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.'),
('achat_important', 2, 'A', 'Votre vivacité d''esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.'),
('demande_financement', 2, 'A', 'Votre vivacité d''esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.'),
('recherche_argent', 2, 'A', 'Votre vivacité d''esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.'),
('investissement', 2, 'A', 'Votre vivacité d''esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.'),
('signature_contrat', 2, 'A', 'Votre esprit vif repère rapidement les points problématiques. Négociez avec agilité tout en restant ferme sur l''essentiel. Votre vivacité est un atout si elle ne devient pas précipitation.'),
('lancement_business', 2, 'A', 'Votre agilité mentale vous permet de pivoter rapidement selon le marché. Restez à l''écoute des opportunités émergentes. Structurez votre vision : la flexibilité n''exclut pas la direction.'),
('partenariat', 2, 'A', 'Votre agilité mentale vous permet de pivoter rapidement selon le marché. Restez à l''écoute des opportunités émergentes. Structurez votre vision : la flexibilité n''exclut pas la direction.'),
('entretien_embauche', 2, 'A', 'Votre polyvalence est un atout précieux sur le marché du travail. Montrez votre capacité d''adaptation et d''apprentissage rapide. Démontrez aussi votre capacité à vous engager durablement.'),
('demande_promotion', 2, 'A', 'Votre polyvalence est un atout précieux sur le marché du travail. Montrez votre capacité d''adaptation et d''apprentissage rapide. Démontrez aussi votre capacité à vous engager durablement.'),
('demission_changement', 2, 'A', 'Votre polyvalence est un atout précieux sur le marché du travail. Montrez votre capacité d''adaptation et d''apprentissage rapide. Démontrez aussi votre capacité à vous engager durablement.'),
('voyage', 2, 'A', 'Votre énergie vivace enrichit vos interactions personnelles. Multipliez les rencontres tout en préservant vos liens profonds. La variété n''exclut pas la fidélité.'),
('mariage_engagement', 2, 'A', 'Votre énergie vivace enrichit vos interactions personnelles. Multipliez les rencontres tout en préservant vos liens profonds. La variété n''exclut pas la fidélité.'),
('debut_relation', 2, 'A', 'Votre énergie vivace enrichit vos interactions personnelles. Multipliez les rencontres tout en préservant vos liens profonds. La variété n''exclut pas la fidélité.'),
('operation_medicale', 2, 'A', 'Votre vivacité soutient une récupération rapide et active. Restez engagé dans votre parcours de soin. L''impatience peut toutefois compromettre la guérison : respectez les étapes.'),
('debut_traitement', 2, 'A', 'Votre vivacité soutient une récupération rapide et active. Restez engagé dans votre parcours de soin. L''impatience peut toutefois compromettre la guérison : respectez les étapes.'),
('autre_decision', 2, 'A', 'Votre esprit vif peut envisager simultanément plusieurs options. Listez les pour et les contre avec méthode. Une fois décidé, engagez-vous pleinement sans regarder en arrière.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 2B - L'Intuitif Réservé
-- Énergie: Mémoire excellente, intuition, stabilité, profondeur
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 2, 'B', 'Votre intuition profonde vous guide vers les lieux qui résonnent avec votre âme. Écoutez vos impressions subtiles lors des visites. Prenez le temps de la réflexion : la bonne décision viendra de votre for intérieur.'),
('achat_immobilier', 2, 'B', 'Votre intuition profonde vous guide vers les lieux qui résonnent avec votre âme. Écoutez vos impressions subtiles lors des visites. Prenez le temps de la réflexion : la bonne décision viendra de votre for intérieur.'),
('demenagement', 2, 'B', 'Votre intuition profonde vous guide vers les lieux qui résonnent avec votre âme. Écoutez vos impressions subtiles lors des visites. Prenez le temps de la réflexion : la bonne décision viendra de votre for intérieur.'),
('achat_vehicule', 2, 'B', 'Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.'),
('achat_important', 2, 'B', 'Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.'),
('demande_financement', 2, 'B', 'Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.'),
('recherche_argent', 2, 'B', 'Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.'),
('investissement', 2, 'B', 'Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.'),
('signature_contrat', 2, 'B', 'Votre intuition vous alerte sur les subtilités cachées. Prenez le temps de méditer sur l''engagement avant de signer. Ce que vous ressentez compte autant que ce que vous lisez.'),
('lancement_business', 2, 'B', 'Votre intuition vous guide vers des niches inexploitées. Méditez sur votre proposition de valeur unique. Les meilleures idées business émergent souvent du silence.'),
('partenariat', 2, 'B', 'Votre intuition vous guide vers des niches inexploitées. Méditez sur votre proposition de valeur unique. Les meilleures idées business émergent souvent du silence.'),
('entretien_embauche', 2, 'B', 'Votre intuition vous guide vers les opportunités alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque option. La carrière idéale résonne avec votre moi profond.'),
('demande_promotion', 2, 'B', 'Votre intuition vous guide vers les opportunités alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque option. La carrière idéale résonne avec votre moi profond.'),
('demission_changement', 2, 'B', 'Votre intuition vous guide vers les opportunités alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque option. La carrière idéale résonne avec votre moi profond.'),
('voyage', 2, 'B', 'Votre intuition vous guide vers les personnes alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque relation. Les connexions d''âme se reconnaissent au-delà des mots.'),
('mariage_engagement', 2, 'B', 'Votre intuition vous guide vers les personnes alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque relation. Les connexions d''âme se reconnaissent au-delà des mots.'),
('debut_relation', 2, 'B', 'Votre intuition vous guide vers les personnes alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque relation. Les connexions d''âme se reconnaissent au-delà des mots.'),
('operation_medicale', 2, 'B', 'Votre intuition vous guide vers les soins adaptés à votre être profond. Écoutez les signaux de votre corps avec attention. La sagesse corporelle complète l''expertise médicale.'),
('debut_traitement', 2, 'B', 'Votre intuition vous guide vers les soins adaptés à votre être profond. Écoutez les signaux de votre corps avec attention. La sagesse corporelle complète l''expertise médicale.'),
('autre_decision', 2, 'B', 'Votre intuition est particulièrement fiable en cette période. Méditez sur les options qui s''offrent à vous. La réponse profonde viendra de votre silence intérieur.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 3A - L'Aventurier
-- Énergie: Courage, exploration, prise de risque, leadership
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 3, 'A', 'L''Aventurier en vous n''a pas peur des défis immobiliers ambitieux. C''est le moment de viser haut et d''explorer des options inhabituelles. Gardez néanmoins un œil sur les risques : l''audace doit être tempérée par la prudence.'),
('achat_immobilier', 3, 'A', 'L''Aventurier en vous n''a pas peur des défis immobiliers ambitieux. C''est le moment de viser haut et d''explorer des options inhabituelles. Gardez néanmoins un œil sur les risques : l''audace doit être tempérée par la prudence.'),
('demenagement', 3, 'A', 'L''Aventurier en vous n''a pas peur des défis immobiliers ambitieux. C''est le moment de viser haut et d''explorer des options inhabituelles. Gardez néanmoins un œil sur les risques : l''audace doit être tempérée par la prudence.'),
('achat_vehicule', 3, 'A', 'L''Aventurier en vous peut découvrir des opportunités que d''autres ignorent. C''est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.'),
('achat_important', 3, 'A', 'L''Aventurier en vous peut découvrir des opportunités que d''autres ignorent. C''est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.'),
('demande_financement', 3, 'A', 'L''Aventurier en vous peut découvrir des opportunités que d''autres ignorent. C''est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.'),
('recherche_argent', 3, 'A', 'L''Aventurier en vous peut découvrir des opportunités que d''autres ignorent. C''est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.'),
('investissement', 3, 'A', 'L''Aventurier en vous peut découvrir des opportunités que d''autres ignorent. C''est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.'),
('signature_contrat', 3, 'A', 'L''Aventurier peut obtenir des conditions exceptionnelles par une négociation audacieuse. Osez demander plus tout en sachant quand conclure. Le courage sans sagesse peut mener à l''impasse.'),
('lancement_business', 3, 'A', 'L''Aventurier en vous peut créer des entreprises innovantes et disruptives. Osez bousculer les conventions du marché. Calculez vos risques : l''audace intelligente triomphe de l''audace aveugle.'),
('partenariat', 3, 'A', 'L''Aventurier en vous peut créer des entreprises innovantes et disruptives. Osez bousculer les conventions du marché. Calculez vos risques : l''audace intelligente triomphe de l''audace aveugle.'),
('entretien_embauche', 3, 'A', 'L''Aventurier peut saisir des opportunités que d''autres n''osent pas envisager. Osez proposer, demander, créer votre poste idéal. Le courage calculé ouvre des portes insoupçonnées.'),
('demande_promotion', 3, 'A', 'L''Aventurier peut saisir des opportunités que d''autres n''osent pas envisager. Osez proposer, demander, créer votre poste idéal. Le courage calculé ouvre des portes insoupçonnées.'),
('demission_changement', 3, 'A', 'L''Aventurier peut saisir des opportunités que d''autres n''osent pas envisager. Osez proposer, demander, créer votre poste idéal. Le courage calculé ouvre des portes insoupçonnées.'),
('voyage', 3, 'A', 'L''Aventurier peut vivre des expériences personnelles extraordinaires. Osez sortir de votre zone de confort relationnelle. Le courage émotionnel ouvre des mondes nouveaux.'),
('mariage_engagement', 3, 'A', 'L''Aventurier peut vivre des expériences personnelles extraordinaires. Osez sortir de votre zone de confort relationnelle. Le courage émotionnel ouvre des mondes nouveaux.'),
('debut_relation', 3, 'A', 'L''Aventurier peut vivre des expériences personnelles extraordinaires. Osez sortir de votre zone de confort relationnelle. Le courage émotionnel ouvre des mondes nouveaux.'),
('operation_medicale', 3, 'A', 'L''Aventurier peut affronter les défis de santé avec courage. Votre force intérieure soutient votre combat. Canalisez votre énergie vers la guérison plutôt que la résistance.'),
('debut_traitement', 3, 'A', 'L''Aventurier peut affronter les défis de santé avec courage. Votre force intérieure soutient votre combat. Canalisez votre énergie vers la guérison plutôt que la résistance.'),
('autre_decision', 3, 'A', 'L''Aventurier en vous n''a pas peur des choix audacieux. Osez l''option qui vous fait vibrer. Calculez les risques pour que votre audace soit intelligente.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 3B - Le Souverain
-- Énergie: Présence royale, cérémonies, reconnaissance, accomplissement
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 3, 'B', 'Votre sens du prestige vous attire vers des biens à la hauteur de vos aspirations. Cette période favorise les acquisitions qui reflètent votre statut. Assurez-vous que l''investissement correspond à vos moyens réels, pas seulement à vos ambitions.'),
('achat_immobilier', 3, 'B', 'Votre sens du prestige vous attire vers des biens à la hauteur de vos aspirations. Cette période favorise les acquisitions qui reflètent votre statut. Assurez-vous que l''investissement correspond à vos moyens réels, pas seulement à vos ambitions.'),
('demenagement', 3, 'B', 'Votre sens du prestige vous attire vers des biens à la hauteur de vos aspirations. Cette période favorise les acquisitions qui reflètent votre statut. Assurez-vous que l''investissement correspond à vos moyens réels, pas seulement à vos ambitions.'),
('achat_vehicule', 3, 'B', 'Votre sens du prestige vous oriente vers des investissements de qualité. Visez l''excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.'),
('achat_important', 3, 'B', 'Votre sens du prestige vous oriente vers des investissements de qualité. Visez l''excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.'),
('demande_financement', 3, 'B', 'Votre sens du prestige vous oriente vers des investissements de qualité. Visez l''excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.'),
('recherche_argent', 3, 'B', 'Votre sens du prestige vous oriente vers des investissements de qualité. Visez l''excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.'),
('investissement', 3, 'B', 'Votre sens du prestige vous oriente vers des investissements de qualité. Visez l''excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.'),
('signature_contrat', 3, 'B', 'Votre présence imposante renforce votre position de négociation. Demandez des termes dignes de votre valeur. Vérifiez que votre fierté ne vous empêche pas de voir les détails.'),
('lancement_business', 3, 'B', 'Votre vision royale vous oriente vers des entreprises d''excellence. Visez la qualité premium plutôt que le volume. Un business prestigieux attire une clientèle fidèle.'),
('partenariat', 3, 'B', 'Votre vision royale vous oriente vers des entreprises d''excellence. Visez la qualité premium plutôt que le volume. Un business prestigieux attire une clientèle fidèle.'),
('entretien_embauche', 3, 'B', 'Votre présence royale vous destine à des positions de leadership. Assumez votre valeur et visez les responsabilités à votre hauteur. La vraie royauté se manifeste aussi dans l''humilité.'),
('demande_promotion', 3, 'B', 'Votre présence royale vous destine à des positions de leadership. Assumez votre valeur et visez les responsabilités à votre hauteur. La vraie royauté se manifeste aussi dans l''humilité.'),
('demission_changement', 3, 'B', 'Votre présence royale vous destine à des positions de leadership. Assumez votre valeur et visez les responsabilités à votre hauteur. La vraie royauté se manifeste aussi dans l''humilité.'),
('voyage', 3, 'B', 'Votre présence attire naturellement des personnes de qualité. Entretenez des relations dignes de votre valeur. La noblesse véritable honore également ceux qui l''entourent.'),
('mariage_engagement', 3, 'B', 'Votre présence attire naturellement des personnes de qualité. Entretenez des relations dignes de votre valeur. La noblesse véritable honore également ceux qui l''entourent.'),
('debut_relation', 3, 'B', 'Votre présence attire naturellement des personnes de qualité. Entretenez des relations dignes de votre valeur. La noblesse véritable honore également ceux qui l''entourent.'),
('operation_medicale', 3, 'B', 'Votre dignité naturelle vous aide à traverser les épreuves de santé. Maintenez votre estime de vous malgré les difficultés. La royauté intérieure transcende les limitations physiques.'),
('debut_traitement', 3, 'B', 'Votre dignité naturelle vous aide à traverser les épreuves de santé. Maintenez votre estime de vous malgré les difficultés. La royauté intérieure transcende les limitations physiques.'),
('autre_decision', 3, 'B', 'Votre sens de la dignité vous guide vers des choix honorables. Décidez de manière à rester fier de vous-même. La vraie noblesse se manifeste dans chaque décision.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 4A - Le Guide Spirituel
-- Énergie: Spiritualité, enseignement, éthique, philosophie
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 4, 'A', 'Votre sagesse spirituelle éclaire vos décisions immobilières. Recherchez un lieu qui nourrit votre âme autant que vos besoins pratiques. La dimension énergétique de l''espace compte autant que ses caractéristiques matérielles.'),
('achat_immobilier', 4, 'A', 'Votre sagesse spirituelle éclaire vos décisions immobilières. Recherchez un lieu qui nourrit votre âme autant que vos besoins pratiques. La dimension énergétique de l''espace compte autant que ses caractéristiques matérielles.'),
('demenagement', 4, 'A', 'Votre sagesse spirituelle éclaire vos décisions immobilières. Recherchez un lieu qui nourrit votre âme autant que vos besoins pratiques. La dimension énergétique de l''espace compte autant que ses caractéristiques matérielles.'),
('achat_vehicule', 4, 'A', 'Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L''argent gagné en accord avec vos valeurs est plus satisfaisant.'),
('achat_important', 4, 'A', 'Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L''argent gagné en accord avec vos valeurs est plus satisfaisant.'),
('demande_financement', 4, 'A', 'Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L''argent gagné en accord avec vos valeurs est plus satisfaisant.'),
('recherche_argent', 4, 'A', 'Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L''argent gagné en accord avec vos valeurs est plus satisfaisant.'),
('investissement', 4, 'A', 'Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L''argent gagné en accord avec vos valeurs est plus satisfaisant.'),
('signature_contrat', 4, 'A', 'Votre sagesse vous guide vers des engagements alignés avec vos principes. Un contrat éthique est plus précieux qu''un accord lucratif mais contestable. Votre intégrité est votre meilleure protection.'),
('lancement_business', 4, 'A', 'Votre sagesse vous guide vers des entreprises à impact positif. Le business éthique génère une satisfaction profonde. Le profit aligné avec les valeurs est le plus durable.'),
('partenariat', 4, 'A', 'Votre sagesse vous guide vers des entreprises à impact positif. Le business éthique génère une satisfaction profonde. Le profit aligné avec les valeurs est le plus durable.'),
('entretien_embauche', 4, 'A', 'Votre sagesse vous oriente vers une carrière porteuse de sens. Recherchez l''alignement entre votre travail et vos valeurs profondes. Le succès le plus profond est celui qui vous épanouit.'),
('demande_promotion', 4, 'A', 'Votre sagesse vous oriente vers une carrière porteuse de sens. Recherchez l''alignement entre votre travail et vos valeurs profondes. Le succès le plus profond est celui qui vous épanouit.'),
('demission_changement', 4, 'A', 'Votre sagesse vous oriente vers une carrière porteuse de sens. Recherchez l''alignement entre votre travail et vos valeurs profondes. Le succès le plus profond est celui qui vous épanouit.'),
('voyage', 4, 'A', 'Votre sagesse vous oriente vers des relations porteuses de croissance mutuelle. Recherchez des compagnons de route qui élèvent votre esprit. Les amitiés spirituelles sont les plus durables.'),
('mariage_engagement', 4, 'A', 'Votre sagesse vous oriente vers des relations porteuses de croissance mutuelle. Recherchez des compagnons de route qui élèvent votre esprit. Les amitiés spirituelles sont les plus durables.'),
('debut_relation', 4, 'A', 'Votre sagesse vous oriente vers des relations porteuses de croissance mutuelle. Recherchez des compagnons de route qui élèvent votre esprit. Les amitiés spirituelles sont les plus durables.'),
('operation_medicale', 4, 'A', 'Votre sagesse spirituelle apporte une perspective élargie sur la santé. Intégrez les dimensions physiques, mentales et spirituelles. La guérison holistique est la plus profonde.'),
('debut_traitement', 4, 'A', 'Votre sagesse spirituelle apporte une perspective élargie sur la santé. Intégrez les dimensions physiques, mentales et spirituelles. La guérison holistique est la plus profonde.'),
('autre_decision', 4, 'A', 'Votre sagesse éclaire cette décision de sa lumière bienveillante. Cherchez l''option alignée avec vos valeurs les plus profondes. Un choix éthique apporte une satisfaction durable.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 4B - L'Esthète Équilibré
-- Énergie: Équilibre, harmonie, logique, beauté
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 4, 'B', 'Votre sens de l''équilibre vous guide vers des espaces harmonieux et proportionnés. Recherchez la beauté dans la fonctionnalité. Un lieu qui vous ressemble sera source de bien-être durable.'),
('achat_immobilier', 4, 'B', 'Votre sens de l''équilibre vous guide vers des espaces harmonieux et proportionnés. Recherchez la beauté dans la fonctionnalité. Un lieu qui vous ressemble sera source de bien-être durable.'),
('demenagement', 4, 'B', 'Votre sens de l''équilibre vous guide vers des espaces harmonieux et proportionnés. Recherchez la beauté dans la fonctionnalité. Un lieu qui vous ressemble sera source de bien-être durable.'),
('achat_vehicule', 4, 'B', 'Votre sens de l''équilibre vous guide vers une gestion financière saine. Cherchez l''harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.'),
('achat_important', 4, 'B', 'Votre sens de l''équilibre vous guide vers une gestion financière saine. Cherchez l''harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.'),
('demande_financement', 4, 'B', 'Votre sens de l''équilibre vous guide vers une gestion financière saine. Cherchez l''harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.'),
('recherche_argent', 4, 'B', 'Votre sens de l''équilibre vous guide vers une gestion financière saine. Cherchez l''harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.'),
('investissement', 4, 'B', 'Votre sens de l''équilibre vous guide vers une gestion financière saine. Cherchez l''harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.'),
('signature_contrat', 4, 'B', 'Recherchez des accords équilibrés où chaque partie trouve son compte. Un contrat harmonieux génère moins de conflits futurs. L''équité d''aujourd''hui prévient les litiges de demain.'),
('lancement_business', 4, 'B', 'Recherchez l''équilibre entre rentabilité et bien-être. Un business harmonieux attire naturellement clients et collaborateurs. La culture positive est un avantage compétitif.'),
('partenariat', 4, 'B', 'Recherchez l''équilibre entre rentabilité et bien-être. Un business harmonieux attire naturellement clients et collaborateurs. La culture positive est un avantage compétitif.'),
('entretien_embauche', 4, 'B', 'Recherchez l''équilibre entre ambition professionnelle et bien-être personnel. Une carrière harmonieuse soutient votre vie, elle ne la consume pas. L''équilibre est la clé de la longévité.'),
('demande_promotion', 4, 'B', 'Recherchez l''équilibre entre ambition professionnelle et bien-être personnel. Une carrière harmonieuse soutient votre vie, elle ne la consume pas. L''équilibre est la clé de la longévité.'),
('demission_changement', 4, 'B', 'Recherchez l''équilibre entre ambition professionnelle et bien-être personnel. Une carrière harmonieuse soutient votre vie, elle ne la consume pas. L''équilibre est la clé de la longévité.'),
('voyage', 4, 'B', 'Recherchez l''équilibre et la réciprocité dans vos relations. Une connexion harmonieuse nourrit les deux parties. L''équilibre relationnel est la clé du bien-être.'),
('mariage_engagement', 4, 'B', 'Recherchez l''équilibre et la réciprocité dans vos relations. Une connexion harmonieuse nourrit les deux parties. L''équilibre relationnel est la clé du bien-être.'),
('debut_relation', 4, 'B', 'Recherchez l''équilibre et la réciprocité dans vos relations. Une connexion harmonieuse nourrit les deux parties. L''équilibre relationnel est la clé du bien-être.'),
('operation_medicale', 4, 'B', 'Recherchez l''équilibre entre traitement médical et bien-être global. Un corps harmonieux résiste mieux à la maladie. L''équilibre de vie soutient la santé durable.'),
('debut_traitement', 4, 'B', 'Recherchez l''équilibre entre traitement médical et bien-être global. Un corps harmonieux résiste mieux à la maladie. L''équilibre de vie soutient la santé durable.'),
('autre_decision', 4, 'B', 'Recherchez l''équilibre entre les différentes dimensions de votre vie. Un choix harmonieux tient compte de tous les aspects. L''équilibre global surpasse l''optimisation partielle.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 5A - Le Combattant Généreux
-- Énergie: Détermination, énergie, refus de médiocrité, action
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 5, 'A', 'Votre détermination vous pousse à ne pas accepter moins que ce que vous méritez. Négociez fermement mais équitablement. Canalisez votre énergie combative en préparation minutieuse plutôt qu''en confrontation.'),
('achat_immobilier', 5, 'A', 'Votre détermination vous pousse à ne pas accepter moins que ce que vous méritez. Négociez fermement mais équitablement. Canalisez votre énergie combative en préparation minutieuse plutôt qu''en confrontation.'),
('demenagement', 5, 'A', 'Votre détermination vous pousse à ne pas accepter moins que ce que vous méritez. Négociez fermement mais équitablement. Canalisez votre énergie combative en préparation minutieuse plutôt qu''en confrontation.'),
('achat_vehicule', 5, 'A', 'Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.'),
('achat_important', 5, 'A', 'Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.'),
('demande_financement', 5, 'A', 'Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.'),
('recherche_argent', 5, 'A', 'Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.'),
('investissement', 5, 'A', 'Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.'),
('signature_contrat', 5, 'A', 'Votre détermination vous permet de défendre fermement vos intérêts. Négociez chaque point important avec constance. Sachez cependant quand le combat cède la place au compromis.'),
('lancement_business', 5, 'A', 'Votre énergie combative vous pousse à conquérir votre marché. Canalisez cette force dans une stratégie bien préparée. La bataille commerciale se gagne avec intelligence.'),
('partenariat', 5, 'A', 'Votre énergie combative vous pousse à conquérir votre marché. Canalisez cette force dans une stratégie bien préparée. La bataille commerciale se gagne avec intelligence.'),
('entretien_embauche', 5, 'A', 'Votre détermination vous pousse vers les sommets professionnels. Canalisez cette énergie dans une stratégie de carrière réfléchie. La compétition saine stimule, la rivalité épuise.'),
('demande_promotion', 5, 'A', 'Votre détermination vous pousse vers les sommets professionnels. Canalisez cette énergie dans une stratégie de carrière réfléchie. La compétition saine stimule, la rivalité épuise.'),
('demission_changement', 5, 'A', 'Votre détermination vous pousse vers les sommets professionnels. Canalisez cette énergie dans une stratégie de carrière réfléchie. La compétition saine stimule, la rivalité épuise.'),
('voyage', 5, 'A', 'Votre passion peut intensifier vos relations personnelles. Canalisez cette énergie vers la construction plutôt que le conflit. L''amour vrai est aussi un engagement quotidien.'),
('mariage_engagement', 5, 'A', 'Votre passion peut intensifier vos relations personnelles. Canalisez cette énergie vers la construction plutôt que le conflit. L''amour vrai est aussi un engagement quotidien.'),
('debut_relation', 5, 'A', 'Votre passion peut intensifier vos relations personnelles. Canalisez cette énergie vers la construction plutôt que le conflit. L''amour vrai est aussi un engagement quotidien.'),
('operation_medicale', 5, 'A', 'Votre énergie combative est un atout dans les défis de santé. Canalisez cette force vers la guérison positive. Combattez avec intelligence, pas avec acharnement.'),
('debut_traitement', 5, 'A', 'Votre énergie combative est un atout dans les défis de santé. Canalisez cette force vers la guérison positive. Combattez avec intelligence, pas avec acharnement.'),
('autre_decision', 5, 'A', 'Votre détermination vous pousse à trancher avec fermeté. Canalisez cette énergie dans une décision réfléchie. Le combattant avisé choisit ses batailles.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 5B - Le Sage Pacifique
-- Énergie: Paix intérieure, amitié, humanitaire, spiritualité
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 5, 'B', 'Votre paix intérieure vous guide vers des environnements apaisants et ressourçants. Recherchez des lieux où vous pourrez vous épanouir sereinement. La tranquillité d''un lieu vaut parfois plus que ses caractéristiques prestigieuses.'),
('achat_immobilier', 5, 'B', 'Votre paix intérieure vous guide vers des environnements apaisants et ressourçants. Recherchez des lieux où vous pourrez vous épanouir sereinement. La tranquillité d''un lieu vaut parfois plus que ses caractéristiques prestigieuses.'),
('demenagement', 5, 'B', 'Votre paix intérieure vous guide vers des environnements apaisants et ressourçants. Recherchez des lieux où vous pourrez vous épanouir sereinement. La tranquillité d''un lieu vaut parfois plus que ses caractéristiques prestigieuses.'),
('achat_vehicule', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété financière. Prenez vos décisions depuis ce lieu de calme. L''argent est un outil : ne le laissez pas troubler votre sérénité.'),
('achat_important', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété financière. Prenez vos décisions depuis ce lieu de calme. L''argent est un outil : ne le laissez pas troubler votre sérénité.'),
('demande_financement', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété financière. Prenez vos décisions depuis ce lieu de calme. L''argent est un outil : ne le laissez pas troubler votre sérénité.'),
('recherche_argent', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété financière. Prenez vos décisions depuis ce lieu de calme. L''argent est un outil : ne le laissez pas troubler votre sérénité.'),
('investissement', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété financière. Prenez vos décisions depuis ce lieu de calme. L''argent est un outil : ne le laissez pas troubler votre sérénité.'),
('signature_contrat', 5, 'B', 'Abordez les négociations depuis votre centre de paix intérieure. Votre calme déstabilise ceux qui cherchent à vous presser. La sérénité est une force dans les discussions tendues.'),
('lancement_business', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété entrepreneuriale. Prenez vos décisions business depuis ce lieu de calme. La sérénité attire les bonnes opportunités.'),
('partenariat', 5, 'B', 'Votre paix intérieure vous libère de l''anxiété entrepreneuriale. Prenez vos décisions business depuis ce lieu de calme. La sérénité attire les bonnes opportunités.'),
('entretien_embauche', 5, 'B', 'Abordez votre carrière depuis votre centre de paix intérieure. Les décisions professionnelles prises dans le calme sont plus justes. La sérénité attire les bonnes opportunités.'),
('demande_promotion', 5, 'B', 'Abordez votre carrière depuis votre centre de paix intérieure. Les décisions professionnelles prises dans le calme sont plus justes. La sérénité attire les bonnes opportunités.'),
('demission_changement', 5, 'B', 'Abordez votre carrière depuis votre centre de paix intérieure. Les décisions professionnelles prises dans le calme sont plus justes. La sérénité attire les bonnes opportunités.'),
('voyage', 5, 'B', 'Votre paix intérieure rayonne et attire des relations apaisantes. Partagez votre sérénité avec ceux qui vous entourent. Le calme relationnel est un don précieux.'),
('mariage_engagement', 5, 'B', 'Votre paix intérieure rayonne et attire des relations apaisantes. Partagez votre sérénité avec ceux qui vous entourent. Le calme relationnel est un don précieux.'),
('debut_relation', 5, 'B', 'Votre paix intérieure rayonne et attire des relations apaisantes. Partagez votre sérénité avec ceux qui vous entourent. Le calme relationnel est un don précieux.'),
('operation_medicale', 5, 'B', 'Votre paix intérieure favorise la guérison en réduisant le stress. Abordez les soins depuis ce lieu de calme. La sérénité est un médicament puissant.'),
('debut_traitement', 5, 'B', 'Votre paix intérieure favorise la guérison en réduisant le stress. Abordez les soins depuis ce lieu de calme. La sérénité est un médicament puissant.'),
('autre_decision', 5, 'B', 'Votre paix intérieure vous protège de l''anxiété décisionnelle. Prenez votre décision depuis ce lieu de calme. La sérénité clarifie le jugement.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 6A - Le Critique Éclairé
-- Énergie: Analyse, sens critique, pédagogie, discernement
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 6, 'A', 'Votre esprit critique évalue méthodiquement chaque aspect du bien. Listez les avantages et inconvénients objectivement. Votre analyse sera d''autant plus pertinente que vous aurez vérifié chaque information.'),
('achat_immobilier', 6, 'A', 'Votre esprit critique évalue méthodiquement chaque aspect du bien. Listez les avantages et inconvénients objectivement. Votre analyse sera d''autant plus pertinente que vous aurez vérifié chaque information.'),
('demenagement', 6, 'A', 'Votre esprit critique évalue méthodiquement chaque aspect du bien. Listez les avantages et inconvénients objectivement. Votre analyse sera d''autant plus pertinente que vous aurez vérifié chaque information.'),
('achat_vehicule', 6, 'A', 'Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.'),
('achat_important', 6, 'A', 'Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.'),
('demande_financement', 6, 'A', 'Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.'),
('recherche_argent', 6, 'A', 'Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.'),
('investissement', 6, 'A', 'Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.'),
('signature_contrat', 6, 'A', 'Votre esprit critique décortique chaque clause avec précision. Rien n''échappe à votre analyse méthodique. Cette rigueur vous protège des mauvaises surprises.'),
('lancement_business', 6, 'A', 'Votre esprit critique évalue objectivement chaque aspect de votre projet. Basez vos décisions sur des données vérifiées. L''analyse remplace avantageusement l''intuition aveugle.'),
('partenariat', 6, 'A', 'Votre esprit critique évalue objectivement chaque aspect de votre projet. Basez vos décisions sur des données vérifiées. L''analyse remplace avantageusement l''intuition aveugle.'),
('entretien_embauche', 6, 'A', 'Votre esprit critique évalue objectivement vos options de carrière. Comparez les avantages et inconvénients de chaque voie. L''analyse lucide prévient les regrets futurs.'),
('demande_promotion', 6, 'A', 'Votre esprit critique évalue objectivement vos options de carrière. Comparez les avantages et inconvénients de chaque voie. L''analyse lucide prévient les regrets futurs.'),
('demission_changement', 6, 'A', 'Votre esprit critique évalue objectivement vos options de carrière. Comparez les avantages et inconvénients de chaque voie. L''analyse lucide prévient les regrets futurs.'),
('voyage', 6, 'A', 'Votre esprit critique peut parfois compliquer les relations spontanées. Laissez aussi parler votre cœur dans vos choix personnels. L''analyse et l''émotion peuvent coexister.'),
('mariage_engagement', 6, 'A', 'Votre esprit critique peut parfois compliquer les relations spontanées. Laissez aussi parler votre cœur dans vos choix personnels. L''analyse et l''émotion peuvent coexister.'),
('debut_relation', 6, 'A', 'Votre esprit critique peut parfois compliquer les relations spontanées. Laissez aussi parler votre cœur dans vos choix personnels. L''analyse et l''émotion peuvent coexister.'),
('operation_medicale', 6, 'A', 'Votre esprit critique vous aide à comprendre votre situation médicale. Posez des questions et informez-vous avec rigueur. La connaissance renforce votre participation active aux soins.'),
('debut_traitement', 6, 'A', 'Votre esprit critique vous aide à comprendre votre situation médicale. Posez des questions et informez-vous avec rigueur. La connaissance renforce votre participation active aux soins.'),
('autre_decision', 6, 'A', 'Votre esprit critique décompose le problème en éléments analysables. Évaluez chaque dimension objectivement. L''analyse méthodique prévient les erreurs de jugement.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 6B - L'Antiquaire
-- Énergie: Recherche, écriture, auto-réflexion, profondeur
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 6, 'B', 'Cette période vous invite à réfléchir profondément à vos besoins réels. Qu''attendez-vous vraiment de ce lieu? La réponse sincère à cette question guidera votre choix mieux que toute analyse externe.'),
('achat_immobilier', 6, 'B', 'Cette période vous invite à réfléchir profondément à vos besoins réels. Qu''attendez-vous vraiment de ce lieu? La réponse sincère à cette question guidera votre choix mieux que toute analyse externe.'),
('demenagement', 6, 'B', 'Cette période vous invite à réfléchir profondément à vos besoins réels. Qu''attendez-vous vraiment de ce lieu? La réponse sincère à cette question guidera votre choix mieux que toute analyse externe.'),
('achat_vehicule', 6, 'B', 'Cette période vous invite à réfléchir à votre relation avec l''argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.'),
('achat_important', 6, 'B', 'Cette période vous invite à réfléchir à votre relation avec l''argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.'),
('demande_financement', 6, 'B', 'Cette période vous invite à réfléchir à votre relation avec l''argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.'),
('recherche_argent', 6, 'B', 'Cette période vous invite à réfléchir à votre relation avec l''argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.'),
('investissement', 6, 'B', 'Cette période vous invite à réfléchir à votre relation avec l''argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.'),
('signature_contrat', 6, 'B', 'Demandez-vous sincèrement si cet engagement correspond à vos aspirations profondes. La réponse intérieure guidera votre décision mieux que l''analyse externe. Écoutez votre voix intérieure.'),
('lancement_business', 6, 'B', 'Interrogez-vous sur vos motivations profondes d''entrepreneur. Pourquoi ce business? La réponse sincère déterminera votre persévérance dans les difficultés.'),
('partenariat', 6, 'B', 'Interrogez-vous sur vos motivations profondes d''entrepreneur. Pourquoi ce business? La réponse sincère déterminera votre persévérance dans les difficultés.'),
('entretien_embauche', 6, 'B', 'Interrogez-vous sur ce que vous voulez vraiment de votre vie professionnelle. La réponse sincère guidera vos choix mieux que les attentes extérieures. Votre carrière doit vous ressembler.'),
('demande_promotion', 6, 'B', 'Interrogez-vous sur ce que vous voulez vraiment de votre vie professionnelle. La réponse sincère guidera vos choix mieux que les attentes extérieures. Votre carrière doit vous ressembler.'),
('demission_changement', 6, 'B', 'Interrogez-vous sur ce que vous voulez vraiment de votre vie professionnelle. La réponse sincère guidera vos choix mieux que les attentes extérieures. Votre carrière doit vous ressembler.'),
('voyage', 6, 'B', 'Cette période vous invite à réfléchir à ce que vous attendez vraiment de vos relations. La clarté intérieure guide vers les bons choix. Connaissez-vous d''abord pour bien choisir les autres.'),
('mariage_engagement', 6, 'B', 'Cette période vous invite à réfléchir à ce que vous attendez vraiment de vos relations. La clarté intérieure guide vers les bons choix. Connaissez-vous d''abord pour bien choisir les autres.'),
('debut_relation', 6, 'B', 'Cette période vous invite à réfléchir à ce que vous attendez vraiment de vos relations. La clarté intérieure guide vers les bons choix. Connaissez-vous d''abord pour bien choisir les autres.'),
('operation_medicale', 6, 'B', 'Cette période vous invite à écouter profondément les messages de votre corps. Que vous dit votre symptôme? La compréhension intérieure complète le diagnostic externe.'),
('debut_traitement', 6, 'B', 'Cette période vous invite à écouter profondément les messages de votre corps. Que vous dit votre symptôme? La compréhension intérieure complète le diagnostic externe.'),
('autre_decision', 6, 'B', 'Cette période vous invite à une réflexion profonde avant de décider. Que veut vraiment votre être profond? La réponse intérieure est souvent la plus juste.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 7A - Le Chercheur Profond
-- Énergie: Expertise, dévotion, fiabilité, constance
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 7, 'A', 'Votre approche systématique vous protège des décisions hâtives. Établissez une liste de critères et évaluez chaque option rigoureusement. La méthode est votre force : utilisez-la pleinement.'),
('achat_immobilier', 7, 'A', 'Votre approche systématique vous protège des décisions hâtives. Établissez une liste de critères et évaluez chaque option rigoureusement. La méthode est votre force : utilisez-la pleinement.'),
('demenagement', 7, 'A', 'Votre approche systématique vous protège des décisions hâtives. Établissez une liste de critères et évaluez chaque option rigoureusement. La méthode est votre force : utilisez-la pleinement.'),
('achat_vehicule', 7, 'A', 'Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.'),
('achat_important', 7, 'A', 'Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.'),
('demande_financement', 7, 'A', 'Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.'),
('recherche_argent', 7, 'A', 'Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.'),
('investissement', 7, 'A', 'Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.'),
('signature_contrat', 7, 'A', 'Votre approche systématique garantit que rien n''est négligé. Établissez une checklist et vérifiez chaque élément. La méthode est votre meilleure assurance.'),
('lancement_business', 7, 'A', 'Votre approche structurée construit des fondations solides. Suivez votre plan tout en restant adaptable. La méthode est le socle sur lequel s''appuie l''innovation.'),
('partenariat', 7, 'A', 'Votre approche structurée construit des fondations solides. Suivez votre plan tout en restant adaptable. La méthode est le socle sur lequel s''appuie l''innovation.'),
('entretien_embauche', 7, 'A', 'Votre approche structurée construit une carrière solide. Établissez un plan de développement et suivez-le avec discipline. La progression constante surpasse les bonds désordonnés.'),
('demande_promotion', 7, 'A', 'Votre approche structurée construit une carrière solide. Établissez un plan de développement et suivez-le avec discipline. La progression constante surpasse les bonds désordonnés.'),
('demission_changement', 7, 'A', 'Votre approche structurée construit une carrière solide. Établissez un plan de développement et suivez-le avec discipline. La progression constante surpasse les bonds désordonnés.'),
('voyage', 7, 'A', 'Votre approche réfléchie peut structurer même les aspects personnels de votre vie. Restez ouvert à la spontanéité malgré votre nature organisée. L''amour surprend parfois les plus méthodiques.'),
('mariage_engagement', 7, 'A', 'Votre approche réfléchie peut structurer même les aspects personnels de votre vie. Restez ouvert à la spontanéité malgré votre nature organisée. L''amour surprend parfois les plus méthodiques.'),
('debut_relation', 7, 'A', 'Votre approche réfléchie peut structurer même les aspects personnels de votre vie. Restez ouvert à la spontanéité malgré votre nature organisée. L''amour surprend parfois les plus méthodiques.'),
('operation_medicale', 7, 'A', 'Votre approche disciplinée garantit un suivi rigoureux du traitement. Établissez une routine de soin et respectez-la. La constance est clé dans tout parcours de santé.'),
('debut_traitement', 7, 'A', 'Votre approche disciplinée garantit un suivi rigoureux du traitement. Établissez une routine de soin et respectez-la. La constance est clé dans tout parcours de santé.'),
('autre_decision', 7, 'A', 'Votre approche structurée apporte clarté à la décision. Établissez des critères et évaluez chaque option. La méthode transforme la complexité en clarté.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();


-- ================================================
-- PÉRIODE 7B - Le Mystique Dual
-- Énergie: Mysticisme, pouvoir magnétique, dualité, intuition
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 7, 'B', 'Votre sensibilité vous permet de percevoir l''énergie subtile des lieux. Fiez-vous à vos impressions inexplicables. Si un endroit vous dérange sans raison apparente, écoutez ce signal.'),
('achat_immobilier', 7, 'B', 'Votre sensibilité vous permet de percevoir l''énergie subtile des lieux. Fiez-vous à vos impressions inexplicables. Si un endroit vous dérange sans raison apparente, écoutez ce signal.'),
('demenagement', 7, 'B', 'Votre sensibilité vous permet de percevoir l''énergie subtile des lieux. Fiez-vous à vos impressions inexplicables. Si un endroit vous dérange sans raison apparente, écoutez ce signal.'),
('achat_vehicule', 7, 'B', 'Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence.'),
('achat_important', 7, 'B', 'Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence.'),
('demande_financement', 7, 'B', 'Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence.'),
('recherche_argent', 7, 'B', 'Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence.'),
('investissement', 7, 'B', 'Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence.'),
('signature_contrat', 7, 'B', 'Votre sens subtil perçoit les intentions derrière les mots. Fiez-vous à ce que vous ressentez de l''autre partie. Un malaise inexpliqué mérite d''être écouté.'),
('lancement_business', 7, 'B', 'Votre perception subtile vous connecte aux courants profonds du marché. Fiez-vous à vos intuitions sur les tendances émergentes. Le mystique averti transforme les visions en réalités.'),
('partenariat', 7, 'B', 'Votre perception subtile vous connecte aux courants profonds du marché. Fiez-vous à vos intuitions sur les tendances émergentes. Le mystique averti transforme les visions en réalités.'),
('entretien_embauche', 7, 'B', 'Votre intuition perçoit les opportunités invisibles aux autres. Fiez-vous à vos pressentiments sur les personnes et les situations. Le flair professionnel est un talent précieux.'),
('demande_promotion', 7, 'B', 'Votre intuition perçoit les opportunités invisibles aux autres. Fiez-vous à vos pressentiments sur les personnes et les situations. Le flair professionnel est un talent précieux.'),
('demission_changement', 7, 'B', 'Votre intuition perçoit les opportunités invisibles aux autres. Fiez-vous à vos pressentiments sur les personnes et les situations. Le flair professionnel est un talent précieux.'),
('voyage', 7, 'B', 'Votre sensibilité vous connecte aux dimensions subtiles des relations. Fiez-vous à vos intuitions sur les personnes. Les rencontres significatives transcendent la logique.'),
('mariage_engagement', 7, 'B', 'Votre sensibilité vous connecte aux dimensions subtiles des relations. Fiez-vous à vos intuitions sur les personnes. Les rencontres significatives transcendent la logique.'),
('debut_relation', 7, 'B', 'Votre sensibilité vous connecte aux dimensions subtiles des relations. Fiez-vous à vos intuitions sur les personnes. Les rencontres significatives transcendent la logique.'),
('operation_medicale', 7, 'B', 'Votre connexion au subtil peut faciliter la guérison à des niveaux profonds. Complétez les soins médicaux par des pratiques qui nourrissent votre âme. Le corps et l''esprit guérissent ensemble.'),
('debut_traitement', 7, 'B', 'Votre connexion au subtil peut faciliter la guérison à des niveaux profonds. Complétez les soins médicaux par des pratiques qui nourrissent votre âme. Le corps et l''esprit guérissent ensemble.'),
('autre_decision', 7, 'B', 'Votre sensibilité perçoit des dimensions invisibles à l''analyse rationnelle. Fiez-vous à vos pressentiments tout en vérifiant les faits. L''intuition et la logique sont complémentaires.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();
