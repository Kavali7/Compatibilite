INSERT INTO lunar_phases (phase_number, phase_name, phase_key, theme, energy_type, full_content, activities_favorables, activities_eviter, conseil) VALUES
(1, 'Nouvelle Lune', 'new_moon', 'Intentions et nouveaux départs', 'Initiation',
 '-- VOIR content --',
 ARRAY['Définir intentions', 'Méditation', 'Nouveaux projets', 'Planification', 'Rituels de manifestation'],
 ARRAY['Lancer sans préparation', 'Décisions impulsives', 'Actions publiques'],
 'Dans le silence de la Nouvelle Lune, plantez les graines de vos rêves.'),

(2, 'Premier Croissant', 'waxing_crescent', 'Action et impulsion', 'Action',
 '-- VOIR content --',
 ARRAY['Premiers pas concrets', 'Défis créatifs', 'Surmonter obstacles', 'Risques calculés'],
 ARRAY['Douter et abandonner', 'Ignorer les signes'],
 'L''élan est donné. Avancez avec courage et détermination.'),

(3, 'Premier Quartier', 'first_quarter', 'Décisions et engagement', 'Décision',
 '-- VOIR content --',
 ARRAY['Décisions importantes', 'Engagement ferme', 'Résoudre conflits', 'Ajustements stratégiques'],
 ARRAY['Hésitation', 'Procrastination'],
 'Le moment est venu de trancher. Engagez-vous pleinement.'),

(4, 'Gibbeuse Croissante', 'waxing_gibbous', 'Ajustements et patience', 'Patience',
 '-- VOIR content --',
 ARRAY['Affiner projets', 'Persévérance', 'Préparation finale', 'Analyse détails'],
 ARRAY['Précipitation', 'Négliger détails'],
 'La patience paie. Affinez les détails avant la récolte.'),

(5, 'Pleine Lune', 'full_moon', 'Culmination et célébration', 'Culmination',
 '-- VOIR content --',
 ARRAY['Célébrer accomplissements', 'Récolter fruits', 'Rituels de gratitude', 'Événements sociaux'],
 ARRAY['Nouveaux projets majeurs', 'Décisions émotionnelles', 'Conflits'],
 'Sous la lumière de la Pleine Lune, célébrez ce que vous avez accompli.'),

(6, 'Gibbeuse Décroissante', 'waning_gibbous', 'Gratitude et partage', 'Partage',
 '-- VOIR content --',
 ARRAY['Partager connaissances', 'Enseigner', 'Exprimer gratitude', 'Bilan positif'],
 ARRAY['Garder pour soi', 'Ingratitude'],
 'Ce qui a été reçu doit être partagé. La gratitude multiplie les bénédictions.'),

(7, 'Dernier Quartier', 'last_quarter', 'Lâcher-prise et pardon', 'Libération',
 '-- VOIR content --',
 ARRAY['Lâcher prise', 'Pardonner', 'Nettoyer', 'Terminer projets'],
 ARRAY['S''accrocher au passé', 'Rancune'],
 'Libérez ce qui vous retient. Le pardon ouvre la porte au renouveau.'),

(8, 'Dernier Croissant', 'waning_crescent', 'Repos et préparation', 'Repos',
 '-- VOIR content --',
 ARRAY['Repos', 'Méditation profonde', 'Introspection', 'Préparation intentions'],
 ARRAY['Nouvelles initiatives', 'Suractivité'],
 'Dans le silence qui précède le renouveau, écoutez la voix intérieure.');
