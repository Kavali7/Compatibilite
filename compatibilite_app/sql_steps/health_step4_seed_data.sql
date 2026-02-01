-- ============================================================
-- SERVICE 04: CYCLE SANTÉ - Step 4: Seed Data (7 périodes)
-- ============================================================

-- Période 1: Énergie Vitale
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    1,
    'Période 1 : L''Énergie Vitale',
    'Pic d''énergie et nouveaux débuts',
    'Vous entrez dans votre période de pic énergétique. Votre corps est au sommet de sa vitalité et prêt pour de nouvelles initiatives de santé. Votre système immunitaire est renforcé et votre métabolisme fonctionne efficacement.',
    ARRAY['Système cardiovasculaire — Malgré l''énergie, ne négligez pas les échauffements', 'Suractivité — Votre enthousiasme peut vous pousser à en faire trop', 'Alimentation — L''énergie abondante peut masquer des excès', 'Sommeil — Ne sacrifiez pas vos heures de repos'],
    ARRAY['Nouvelles activités sportives', 'Entraînements intensifs', 'Défis physiques', 'Programmes de transformation'],
    ARRAY['Interventions chirurgicales non urgentes', 'Régimes trop restrictifs', 'Surmenage professionnel'],
    ARRAY['Protéines de qualité : viandes maigres, poissons, légumineuses', 'Glucides complexes : céréales complètes, riz brun, quinoa', 'Hydratation renforcée : 2-3 litres d''eau par jour', 'Fruits et légumes frais : antioxydants naturels'],
    ARRAY['Excès de sucres rapides', 'Alcool qui ralentit la récupération', 'Repas trop copieux le soir'],
    'Vos besoins en sommeil peuvent sembler réduits, mais maintenez 7-8h pour optimiser la récupération. Couchez-vous à heures fixes même si vous vous sentez énergique.',
    ARRAY['Lancez ce nouveau programme sportif que vous repoussez depuis des mois', 'Planifiez vos activités physiques pour l''ensemble du cycle', 'Faites un bilan de santé pendant que vous vous sentez bien', 'Établissez de nouvelles habitudes alimentaires', 'Documentez votre état pour comparer avec les autres périodes', 'Recrutez un partenaire d''entraînement', 'Investissez dans votre équipement sportif'],
    'Mon corps est une machine merveilleuse. Je lui donne ce dont il a besoin et il me le rend au centuple. Chaque jour, je deviens plus fort(e) et plus sain(e).',
    'Cette période vous rappelle que votre corps est capable de grandes choses quand vous lui en donnez l''opportunité.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 2: Stabilisation
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    2,
    'Période 2 : La Stabilisation',
    'Renforcement et consolidation du système',
    'Votre énergie se stabilise après le pic initial. C''est le moment idéal pour consolider les habitudes prises et renforcer votre système immunitaire.',
    ARRAY['Système digestif — Attention aux excès alimentaires', 'Articulations — Évitez les mouvements brusques', 'Stress — Gérez-le avant qu''il ne s''accumule'],
    ARRAY['Maintenir les routines établies', 'Exercices de renforcement modéré', 'Yoga et étirements', 'Marche quotidienne'],
    ARRAY['Sports extrêmes', 'Changements alimentaires drastiques', 'Surcharge de travail'],
    ARRAY['Légumes verts à feuilles', 'Poissons gras riches en oméga-3', 'Probiotiques naturels : yaourt, kéfir', 'Noix et graines'],
    ARRAY['Aliments ultra-transformés', 'Excès de caféine', 'Sucres raffinés'],
    'Maintenez un rythme de sommeil régulier de 7-8h. La régularité est plus importante que la durée.',
    ARRAY['Consolidez les habitudes de la période 1', 'Introduisez des exercices de respiration', 'Faites des bilans hebdomadaires de vos progrès', 'Variez vos sources de protéines'],
    'Je construis des fondations solides pour ma santé. Chaque petite action quotidienne renforce mon bien-être.',
    'La stabilisation vous enseigne la valeur de la constance et de la patience dans votre parcours santé.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 3: Expansion
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    3,
    'Période 3 : L''Expansion',
    'Activités physiques intenses et croissance',
    'Votre corps entre dans une phase d''expansion. Votre capacité à supporter l''effort augmente et votre récupération est excellente.',
    ARRAY['Muscles — Risque de blessures par excès de confiance', 'Tendons — Échauffez-vous correctement', 'Fatigue — Ne confondez pas énergie et épuisement'],
    ARRAY['Sports d''endurance', 'Musculation progressive', 'Activités en plein air', 'Natation'],
    ARRAY['Sports de contact sans préparation', 'Régimes hypocaloriques', 'Travail de nuit prolongé'],
    ARRAY['Protéines en quantité suffisante', 'Glucides complexes pour l''énergie', 'Fruits riches en vitamine C', 'Légumes colorés variés'],
    ARRAY['Fast-food', 'Boissons sucrées', 'Alcool avant l''effort'],
    'Votre corps récupère bien, mais ne réduisez pas le sommeil. 7-8h restent nécessaires pour la reconstruction musculaire.',
    ARRAY['Augmentez progressivement l''intensité', 'Hydratez-vous abondamment', 'Incluez des jours de repos actif', 'Travaillez différents groupes musculaires', 'Étirez-vous après chaque séance'],
    'Mon corps s''épanouit et grandit en force. Je respecte ses besoins tout en le poussant à se dépasser.',
    'L''expansion vous montre vos vraies capacités physiques quand vous vous engagez pleinement.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 4: Équilibre
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    4,
    'Période 4 : L''Équilibre',
    'Harmonie corps-esprit',
    'Vous atteignez un point d''équilibre. C''est la période idéale pour les interventions médicales planifiées et les bilans de santé approfondis.',
    ARRAY['Système nerveux — Période sensible aux tensions', 'Équilibre hormonal — Soyez attentif aux signaux', 'Mental — Risque de rumination'],
    ARRAY['Méditation et mindfulness', 'Tai-chi ou Qi Gong', 'Promenades en nature', 'Rendez-vous médicaux préventifs'],
    ARRAY['Décisions importantes sous pression', 'Sports extrêmes', 'Conflits interpersonnels'],
    ARRAY['Aliments équilibrés et variés', 'Herbes apaisantes : camomille, tilleul', 'Magnésium : chocolat noir, bananes', 'Oméga-3 pour le cerveau'],
    ARRAY['Excitants en excès', 'Aliments industriels', 'Repas irréguliers'],
    'Le sommeil est crucial durant cette période. Visez 8h et créez une routine apaisante avant le coucher.',
    ARRAY['Planifiez vos rendez-vous médicaux', 'Pratiquez la gratitude quotidienne', 'Équilibrez travail et repos', 'Connectez-vous avec vos proches', 'Évaluez votre équilibre de vie global'],
    'Je suis en harmonie avec mon corps et mon esprit. L''équilibre est mon état naturel.',
    'Cette période vous enseigne l''importance de l''harmonie entre toutes les dimensions de votre être.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 5: Introspection
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    5,
    'Période 5 : L''Introspection',
    'Repos et récupération',
    'Votre énergie diminue naturellement. C''est une période de repos et de récupération nécessaire. Écoutez votre corps et ralentissez le rythme.',
    ARRAY['Fatigue — Normal durant cette période', 'Immunité légèrement réduite — Protégez-vous', 'Moral — Risque de baisse de motivation', 'Digestion — Peut être plus lente'],
    ARRAY['Repos actif', 'Lecture et relaxation', 'Bains chauds', 'Activités créatives calmes'],
    ARRAY['Sports intensifs', 'Surcharge de travail', 'Engagements sociaux excessifs', 'Voyages fatigants'],
    ARRAY['Soupes et bouillons nourrissants', 'Aliments chauds et réconfortants', 'Légumes racines', 'Thés et infusions'],
    ARRAY['Aliments froids crus', 'Excès de stimulants', 'Repas trop lourds le soir'],
    'Augmentez votre temps de sommeil à 8-9h si possible. Les siestes courtes (20min) sont bénéfiques.',
    ARRAY['Acceptez le besoin de ralentir', 'Tenez un journal de réflexion', 'Déléguez si possible', 'Pratiquez l''auto-compassion', 'Planifiez des moments de solitude ressourçante'],
    'Je m''accorde le repos dont j''ai besoin. Me ressourcer est un acte de sagesse, pas de faiblesse.',
    'L''introspection vous rappelle que le repos est essentiel à la performance durable.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 6: Purification
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    6,
    'Période 6 : La Purification',
    'Détox et élimination',
    'Votre corps entre en mode nettoyage. C''est une période favorable pour les cures détox douces et l''élimination des toxines accumulées.',
    ARRAY['Reins et foie — Sollicités durant cette période', 'Peau — Possible éruptions temporaires', 'Transit — Peut être perturbé', 'Hydratation — Essentielle'],
    ARRAY['Cures détox légères', 'Sauna et hammam', 'Drainage lymphatique', 'Jeûne intermittent doux'],
    ARRAY['Nouveaux traitements médicaux', 'Excès alimentaires', 'Alcool et tabac', 'Stress intense'],
    ARRAY['Citron et agrumes', 'Légumes verts détoxifiants', 'Eau en grande quantité', 'Herbes dépuratives : pissenlit, artichaut'],
    ARRAY['Aliments transformés', 'Graisses saturées', 'Sucres ajoutés', 'Sel en excès'],
    'Maintenez 7-8h de sommeil. Le corps se répare et élimine les toxines pendant le sommeil profond.',
    ARRAY['Buvez au moins 2L d''eau par jour', 'Essayez un jour de jeûne léger', 'Faites un tri dans votre environnement aussi', 'Évitez les nouvelles surcharges toxiques', 'Brossez votre peau à sec'],
    'Je libère ce qui ne me sert plus. Mon corps se purifie et se renouvelle naturellement.',
    'La purification vous montre l''importance de faire de la place pour le nouveau.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;

-- Période 7: Régénération
INSERT INTO health_cycle_periods (
    period_number, period_name, theme_central, etat_energetique,
    points_vigilance, activites_recommandees, activites_moderer,
    alimentation_privilegier, alimentation_eviter, repos_sommeil,
    conseils_pratiques, affirmation_bien_etre, enseignement, avertissement
) VALUES (
    7,
    'Période 7 : La Régénération',
    'Préparation du nouveau cycle',
    'Votre corps se prépare pour un nouveau cycle. C''est une période de transition où l''énergie commence à remonter progressivement.',
    ARRAY['Patience — L''énergie revient graduellement', 'Nouveaux projets — Planifiez sans forcer', 'Immunité — En reconstruction', 'Mental — Optimisme croissant'],
    ARRAY['Planification du prochain cycle', 'Exercices doux progressifs', 'Visualisation positive', 'Préparation mentale'],
    ARRAY['Sprint vers les objectifs', 'Surengagement', 'Comparaison avec les autres', 'Impatience'],
    ARRAY['Aliments reconstructeurs', 'Protéines de qualité', 'Vitamines et minéraux', 'Superaliments : spiruline, chlorelle'],
    ARRAY['Restrictions alimentaires sévères', 'Jeûnes prolongés', 'Aliments dévitalisés'],
    'Revenez progressivement à 7-8h. Préparez votre corps pour le regain d''énergie à venir.',
    ARRAY['Faites le bilan du cycle écoulé', 'Fixez des intentions pour le prochain', 'Augmentez l''activité progressivement', 'Célébrez vos progrès', 'Préparez votre programme sportif'],
    'Je me prépare à renaître plus fort(e). Chaque fin est un nouveau commencement plein de promesses.',
    'La régénération vous enseigne que chaque cycle apporte de nouvelles opportunités de croissance.',
    'Ce conseil ne remplace pas un avis médical professionnel.'
) ON CONFLICT (period_number) DO UPDATE SET
    period_name = EXCLUDED.period_name,
    theme_central = EXCLUDED.theme_central,
    etat_energetique = EXCLUDED.etat_energetique,
    points_vigilance = EXCLUDED.points_vigilance,
    activites_recommandees = EXCLUDED.activites_recommandees,
    activites_moderer = EXCLUDED.activites_moderer,
    alimentation_privilegier = EXCLUDED.alimentation_privilegier,
    alimentation_eviter = EXCLUDED.alimentation_eviter,
    repos_sommeil = EXCLUDED.repos_sommeil,
    conseils_pratiques = EXCLUDED.conseils_pratiques,
    affirmation_bien_etre = EXCLUDED.affirmation_bien_etre,
    enseignement = EXCLUDED.enseignement;
