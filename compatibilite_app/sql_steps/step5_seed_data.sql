-- =============================================
-- ÉTAPE 5: Insérer les données des 7 périodes
-- =============================================

-- Supprimer les données existantes pour éviter les doublons
DELETE FROM business_cycle_periods;

-- Période 1: Lancement
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    1,
    'Lancement',
    'Initiation et nouveaux projets',
    'C''est le moment idéal pour démarrer de nouveaux projets, lancer des initiatives et poser les fondations de votre année business.',
    'Énergie d''initiative, de créativité et d''audace. Les idées fusent et l''enthousiasme est à son maximum.',
    '{"points": ["Lancement de nouveaux produits — Les conditions sont optimales", "Prospection commerciale — Forte réceptivité du marché", "Création de partenariats — Période propice aux alliances"]}',
    ARRAY['Finaliser et lancer les projets en attente', 'Contacter les prospects et relancer les leads dormants', 'Définir les objectifs trimestriels', 'Investir dans le marketing de lancement'],
    ARRAY['Reporter les décisions importantes', 'Attendre la "période parfaite"', 'Négliger la planification dans l''euphorie'],
    '[{"kpi": "Nombre de nouveaux leads", "raison": "Mesure l''efficacité de la prospection"}, {"kpi": "Taux de conversion initial", "raison": "Évalue la qualité du ciblage"}]',
    ARRAY['Lancer une campagne marketing', 'Signer de nouveaux contrats', 'Recruter des talents clés'],
    ARRAY['Reporter un lancement prévu', 'Réduire le budget marketing', 'Ignorer les opportunités de partenariat'],
    'Ne laissez pas la peur de l''échec freiner vos initiatives. Cette période récompense l''audace.'
);

-- Période 2: Consolidation
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    2,
    'Consolidation',
    'Stabilisation et renforcement',
    'Période de stabilisation des acquis. Renforcez vos processus, optimisez vos opérations et solidifiez vos positions.',
    'Énergie de persévérance et de méthodologie. Le travail de fond porte ses fruits.',
    '{"points": ["Optimisation des processus — Améliorer l''existant", "Formation des équipes — Investir dans les compétences", "Fidélisation clients — Renforcer les relations"]}',
    ARRAY['Auditer et améliorer les processus internes', 'Renforcer la formation des équipes', 'Développer les programmes de fidélisation', 'Consolider les partenariats existants'],
    ARRAY['Se lancer dans de nouveaux projets risqués', 'Négliger les clients existants', 'Sous-estimer l''importance de la documentation'],
    '[{"kpi": "Taux de rétention client", "raison": "Mesure la satisfaction et la fidélité"}, {"kpi": "Efficacité opérationnelle", "raison": "Évalue l''optimisation des processus"}]',
    ARRAY['Améliorer les processus existants', 'Investir dans la formation', 'Renégocier les contrats fournisseurs'],
    ARRAY['Lancer un nouveau produit majeur', 'Changer radicalement de stratégie', 'Négliger le support client'],
    'Profitez de cette période stable pour documenter vos processus et créer des procédures réplicables.'
);

-- Période 3: Croissance
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    3,
    'Croissance',
    'Expansion et développement',
    'Phase d''expansion naturelle. C''est le moment de grandir, d''élargir votre marché et d''augmenter votre impact.',
    'Énergie d''expansion, d''ambition et de mouvement. La croissance est organique et fluide.',
    '{"points": ["Expansion géographique — Explorer de nouveaux marchés", "Augmentation capacité — Investir dans les ressources", "Nouveaux segments — Diversifier la clientèle"]}',
    ARRAY['Augmenter la capacité de production', 'Explorer de nouveaux marchés', 'Lancer des campagnes d''acquisition', 'Recruter pour supporter la croissance'],
    ARRAY['Croître trop vite sans structure', 'Négliger la qualité pour la quantité', 'Ignorer les signaux de surcharge'],
    '[{"kpi": "Taux de croissance du CA", "raison": "Mesure l''expansion commerciale"}, {"kpi": "Coût d''acquisition client", "raison": "Évalue l''efficacité du marketing"}]',
    ARRAY['Investir dans l''acquisition client', 'Étendre l''équipe commerciale', 'Explorer de nouveaux canaux de distribution'],
    ARRAY['Réduire les dépenses marketing', 'Rester dans sa zone de confort', 'Ignorer les opportunités d''expansion'],
    'La croissance durable nécessite des fondations solides. Croissez, mais gardez un œil sur la qualité.'
);

-- Période 4: Optimisation
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    4,
    'Optimisation',
    'Efficacité et rentabilité',
    'Focus sur l''efficacité et la rentabilité. Optimisez vos ressources, améliorez vos marges et maximisez le ROI.',
    'Énergie analytique et pragmatique. Chaque décision doit être mesurée et justifiée.',
    '{"points": ["Réduction des coûts — Identifier les inefficacités", "Amélioration des marges — Optimiser le pricing", "Automatisation — Réduire les tâches manuelles"]}',
    ARRAY['Analyser et réduire les coûts non essentiels', 'Automatiser les processus répétitifs', 'Réviser la politique de pricing', 'Renegocier les contrats fournisseurs'],
    ARRAY['Couper dans les investissements stratégiques', 'Sacrifier la qualité pour réduire les coûts', 'Ignorer les besoins de l''équipe'],
    '[{"kpi": "Marge bénéficiaire", "raison": "Mesure la rentabilité"}, {"kpi": "ROI des investissements", "raison": "Évalue l''efficacité des dépenses"}]',
    ARRAY['Automatiser les processus', 'Renégocier les contrats', 'Optimiser le pricing'],
    ARRAY['Réduire les effectifs sans analyse', 'Couper le budget R&D', 'Négliger l''expérience client'],
    'L''optimisation n''est pas synonyme de réduction. C''est faire mieux avec ce que vous avez.'
);

-- Période 5: Analyse
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    5,
    'Analyse',
    'Réflexion stratégique',
    'Période de recul et d''analyse. Évaluez vos performances, comprenez les tendances et préparez les ajustements.',
    'Énergie de réflexion, d''introspection et de clarté. Les insights émergent naturellement.',
    '{"points": ["Analyse des données — Exploiter le data", "Veille concurrentielle — Comprendre le marché", "Feedback client — Écouter les retours"]}',
    ARRAY['Analyser en profondeur les KPIs', 'Mener des études de satisfaction client', 'Faire une veille concurrentielle complète', 'Identifier les tendances émergentes'],
    ARRAY['Prendre des décisions hâtives', 'Ignorer les données au profit de l''intuition', 'Négliger le feedback négatif'],
    '[{"kpi": "NPS (Net Promoter Score)", "raison": "Mesure la satisfaction client"}, {"kpi": "Part de marché", "raison": "Évalue la position concurrentielle"}]',
    ARRAY['Commander des études de marché', 'Organiser des sessions de brainstorming', 'Consulter des experts'],
    ARRAY['Lancer un nouveau projet sans données', 'Ignorer les signaux du marché', 'Prendre des décisions stratégiques impulsives'],
    'Les meilleures décisions sont basées sur des données, pas sur des suppositions.'
);

-- Période 6: Restructuration
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    6,
    'Restructuration',
    'Transformation et adaptation',
    'Phase de transformation. C''est le moment d''ajuster, de pivoter si nécessaire et de préparer le prochain cycle.',
    'Énergie de changement, de flexibilité et de renouveau. Le lâcher-prise ouvre de nouvelles portes.',
    '{"points": ["Réorganisation — Ajuster la structure", "Pivot stratégique — Changer de direction si besoin", "Gestion du changement — Accompagner les équipes"]}',
    ARRAY['Évaluer et ajuster la structure organisationnelle', 'Identifier ce qui doit être abandonné', 'Préparer les équipes au changement', 'Pivoter les stratégies non performantes'],
    ARRAY['Résister au changement nécessaire', 'Changer trop de choses à la fois', 'Négliger la communication interne'],
    '[{"kpi": "Adoption du changement", "raison": "Mesure l''adhésion des équipes"}, {"kpi": "Performance post-restructuration", "raison": "Évalue l''impact des changements"}]',
    ARRAY['Réorganiser les équipes', 'Abandonner les projets non rentables', 'Lancer un programme de transformation'],
    ARRAY['Maintenir le statu quo', 'Ignorer les signaux d''alerte', 'Restructurer sans plan clair'],
    'Le changement est inconfortable mais nécessaire. Communiquez clairement et accompagnez vos équipes.'
);

-- Période 7: Bilan
INSERT INTO business_cycle_periods (
    period_number, period_name, theme_central, focus_strategique, energie_business,
    fenetre_strategique, actions_recommandees, risques_eviter, indicateurs_cles,
    decisions_favorables, decisions_defavorables, astuce_strategique
) VALUES (
    7,
    'Bilan',
    'Conclusion et préparation',
    'Phase finale du cycle. Faites le bilan de l''année, célébrez les succès et préparez le prochain cycle.',
    'Énergie de clôture, de gratitude et de vision. C''est le temps de la synthèse et de la projection.',
    '{"points": ["Bilan annuel — Évaluer les performances", "Célébration — Reconnaître les réussites", "Planification — Préparer le cycle suivant"]}',
    ARRAY['Réaliser le bilan financier complet', 'Reconnaître et récompenser les performances', 'Définir la vision pour le prochain cycle', 'Clôturer proprement les projets en cours'],
    ARRAY['Ignorer les échecs', 'Négliger la reconnaissance des équipes', 'Se précipiter vers le nouveau cycle'],
    '[{"kpi": "Atteinte des objectifs annuels", "raison": "Mesure la performance globale"}, {"kpi": "Engagement des équipes", "raison": "Évalue la motivation"}]',
    ARRAY['Organiser un événement de célébration', 'Partager les résultats avec transparence', 'Préparer le budget du prochain cycle'],
    ARRAY['Sauter l''étape de bilan', 'Oublier de remercier les équipes', 'Ne pas documenter les leçons apprises'],
    'Le bilan n''est pas une formalité, c''est le socle de votre succès futur.'
);

-- Vérification finale
SELECT period_number, period_name, theme_central FROM business_cycle_periods ORDER BY period_number;
