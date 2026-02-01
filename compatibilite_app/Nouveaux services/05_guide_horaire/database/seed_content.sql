INSERT INTO daily_time_slots (slot_number, slot_name, hour_start, hour_end, energy_type, activities_optimales, conseil) VALUES
(1, 'L''Aube', 5, 8, 'Initiation', ARRAY['Méditation', 'Journaling', 'Exercice léger', 'Planification'], 'Les premières heures définissent le reste de la journée'),
(2, 'Le Matin', 8, 11, 'Concentration', ARRAY['Travail profond', 'Analyses', 'Écriture', 'Problèmes complexes'], 'Protégez ce créneau pour vos tâches importantes'),
(3, 'Midi', 11, 14, 'Communication', ARRAY['Réunions', 'Déjeuners affaires', 'Networking'], 'Le moment des échanges'),
(4, 'Après-midi 1', 14, 17, 'Créativité', ARRAY['Brainstorming', 'Travail créatif', 'Collaboration'], 'Laissez libre cours à l''imagination'),
(5, 'Après-midi 2', 17, 20, 'Réflexion', ARRAY['Bilan journée', 'Préparation lendemain', 'Transition'], 'Préparez demain aujourd''hui'),
(6, 'Soir', 20, 23, 'Détente', ARRAY['Famille', 'Loisirs', 'Relaxation'], 'Déconnectez du travail'),
(7, 'Nuit', 23, 5, 'Repos', ARRAY['Sommeil profond', 'Récupération'], 'Le sommeil est productif');
