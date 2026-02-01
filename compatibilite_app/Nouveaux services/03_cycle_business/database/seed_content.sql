-- SEED: Cycle Business (7 périodes)

INSERT INTO business_cycle_periods (period_number, period_name, theme_central, day_start, day_end, full_content, actions_recommandees, decisions_favorables, astuce) VALUES
(1, 'Le Lancement', 'Initiative et Expansion', 1, 52, '-- VOIR content/periode_1_lancement.md --', 
 ARRAY['Lancer nouveaux produits', 'Contacter partenaires', 'Investir marketing', 'Recruter talents', 'Présenter vision', 'Signer contrats', 'Documenter objectifs'],
 ARRAY['Lancer produits/services', 'Signer partenariats', 'Investir marketing', 'Recruter'],
 'Communiquez votre vision cette période.'),

(2, 'La Consolidation', 'Structure et Rigueur', 53, 104, '-- VOIR content/periode_2_consolidation.md --',
 ARRAY['Documenter processus', 'Former équipe', 'Améliorer outils', 'Optimiser trésorerie', 'Standards qualité', 'Renforcer culture', 'Sécuriser contrats'],
 ARRAY['Investir infrastructure', 'Recruter opérationnels', 'Renégocier fournisseurs', 'KPIs'],
 'Un processus bien documenté économise 10x le temps.'),

(3, 'La Croissance', 'Expansion et Visibilité', 105, 156, '-- VOIR content/periode_3_croissance.md --',
 ARRAY['Intensifier ventes', 'Campagne marketing', 'Participer événements', 'Développer réseau', 'Témoignages clients', 'Nouveaux canaux', 'Contrats envergure'],
 ARRAY['Augmenter budgets marketing', 'Recruter commerciaux', 'Partenariats distribution', 'Lever fonds'],
 'Chaque euro marketing a un retour 2x supérieur cette période.'),

(4, 'L''Optimisation', 'Équilibre et Efficience', 157, 208, '-- VOIR content/periode_4_optimisation.md --',
 ARRAY['Analyser rentabilité', 'Identifier inefficacités', 'Optimiser pricing', 'Améliorer expérience client', 'Équilibrer charges', 'Renégocier contrats', 'Automatiser'],
 ARRAY['Optimiser processus', 'Améliorer marges', 'Investir satisfaction client', 'Renégocier'],
 'Un client fidélisé coûte 5x moins qu''un client acquis.'),

(5, 'L''Analyse', 'Réflexion et Analyse', 209, 260, '-- VOIR content/periode_5_analyse.md --',
 ARRAY['Audit performances', 'Analyser données', 'Consulter experts', 'Réviser stratégie', 'Documenter apprentissages', 'Planifier prochaines étapes', 'Prendre du recul'],
 ARRAY['Engager consultants', 'Études de marché', 'Réviser stratégie', 'Former dirigeants'],
 'Les entreprises qui survivent sont celles qui s''adaptent.'),

(6, 'La Restructuration', 'Transformation et Changement', 261, 312, '-- VOIR content/periode_6_restructuration.md --',
 ARRAY['Opérer changements', 'Arrêter non-performants', 'Réorganiser', 'Investir transformation', 'Communiquer clairement', 'Préparer prochain cycle', 'Gérer changement'],
 ARRAY['Restructurer', 'Arrêter projets non rentables', 'Renégocier contrats', 'Pivoter'],
 'Restructurez quand vous pouvez encore choisir comment.'),

(7, 'Le Bilan', 'Conclusion et Préparation', 313, 365, '-- VOIR content/periode_7_bilan.md --',
 ARRAY['Bilan financier', 'Évaluer objectifs', 'Célébrer réussites', 'Remercier parties prenantes', 'Définir objectifs', 'Préparer budget', 'Planifier lancements'],
 ARRAY['Clôturer projets', 'Définir stratégie année suivante', 'Distribuer bonus', 'Planifier investissements'],
 'Les entreprises qui réussissent prennent le temps de réfléchir.');
