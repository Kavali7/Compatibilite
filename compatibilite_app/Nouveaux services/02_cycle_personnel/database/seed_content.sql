-- =============================================
-- SEED DATA: Cycle Personnel (7 périodes)
-- Service 02 - Cycles de Vie
-- =============================================

INSERT INTO personal_cycle_periods (
    period_number, period_name, theme_central,
    day_start, day_end, full_content,
    domaines_favorables, domaines_eviter,
    conseils, affirmation, enseignement
) VALUES
-- Période 1
(1, 'Le Nouveau Départ', 'L''Initiation',
 1, 52,
 '-- VOIR content/periode_1.md --',
 '{"tres_favorables": ["Nouveaux projets", "Rencontres", "Changements personnels", "Sports"], "favorables": ["Négociations", "Voyages", "Apprentissage", "Investissements"]}',
 '{"reporter": ["Conclusions", "Bilans", "Routines"], "attention": ["Dispersion", "Impatience", "Action impulsive"]}',
 ARRAY['Fixez 3 objectifs majeurs', 'Créez un tableau de vision', 'Rencontrez de nouvelles personnes', 'Bougez votre corps', 'Documentez vos intentions', 'Osez demander', 'Célébrez chaque petit pas'],
 'Je suis le créateur de ma réalité. Chaque jour, je plante des graines de succès et de bonheur.',
 'L''art de l''initiation et le courage de faire le premier pas'),

-- Période 2
(2, 'La Construction', 'Les Fondations',
 53, 104,
 '-- VOIR content/periode_2.md --',
 '{"tres_favorables": ["Travail méthodique", "Formation", "Questions financières", "Santé"], "favorables": ["Rénovations", "Relations familiales", "Contrats", "Organisation"]}',
 '{"reporter": ["Prises de risque majeures", "Changements impulsifs", "Dépenses inconsidérées"], "attention": ["Impatience", "Comparaison", "Manque de repos"]}',
 ARRAY['Créez un planning détaillé', 'Établissez des routines', 'Mettez de l''ordre', 'Investissez dans vos compétences', 'Prenez soin de votre corps', 'Documentez vos progrès', 'Entourez-vous de personnes fiables'],
 'Je construis ma vie brique par brique, avec patience et détermination.',
 'La valeur du travail patient'),

-- Période 3
(3, 'L''Expansion', 'La Croissance',
 105, 156,
 '-- VOIR content/periode_3.md --',
 '{"tres_favorables": ["Relations sociales", "Communication", "Voyages", "Créativité"], "favorables": ["Marketing", "Enseignement", "Collaborations", "Événements"]}',
 '{"reporter": ["Travail solitaire", "Économies strictes", "Isolement"], "attention": ["Dispersion", "Engagements superficiels", "Manque d''ancrage"]}',
 ARRAY['Participez à des événements', 'Contactez d''anciennes relations', 'Partagez votre expertise', 'Planifiez un voyage', 'Exprimez votre créativité', 'Osez vous montrer', 'Célébrez vos succès'],
 'Je m''ouvre aux opportunités infinies que l''univers m''offre.',
 'L''art de saisir les opportunités'),

-- Période 4
(4, 'La Stabilisation', 'L''Équilibre',
 157, 208,
 '-- VOIR content/periode_4.md --',
 '{"tres_favorables": ["Vie familiale", "Foyer", "Équilibre travail-vie", "Santé émotionnelle"], "favorables": ["Questions légales", "Partenariats", "Immobilier", "Arts"]}',
 '{"reporter": ["Prises de risque extrêmes", "Ruptures brusques", "Aventures solitaires"], "attention": ["Négliger les proches", "Décisions unilatérales", "Déséquilibres"]}',
 ARRAY['Faites un bilan à mi-parcours', 'Investissez dans votre foyer', 'Passez du temps de qualité en famille', 'Résolvez les conflits', 'Équilibrez vos activités', 'Prenez soin de votre santé', 'Cultivez la gratitude'],
 'Je crée l''harmonie dans ma vie. Mon foyer est mon sanctuaire de paix.',
 'L''art de l''équilibre'),

-- Période 5
(5, 'La Réflexion', 'L''Introspection',
 209, 260,
 '-- VOIR content/periode_5.md --',
 '{"tres_favorables": ["Introspection", "Études", "Santé mentale", "Planification"], "favorables": ["Retraites spirituelles", "Travail solo", "Documentation", "Résolution de problèmes"]}',
 '{"reporter": ["Lancements majeurs", "Grandes fêtes", "Décisions hâtives"], "attention": ["Isolement excessif", "Rumination négative", "Refus d''aide"]}',
 ARRAY['Tenez un journal', 'Méditez quotidiennement', 'Révisez vos objectifs', 'Passez du temps dans la nature', 'Lisez des ouvrages inspirants', 'Consultez un mentor', 'Préparez la suite'],
 'Je prends le temps de me connaître profondément. Ma sagesse intérieure me guide.',
 'L''importance de la pause réflexive'),

-- Période 6
(6, 'La Transformation', 'Le Renouveau',
 261, 312,
 '-- VOIR content/periode_6.md --',
 '{"tres_favorables": ["Changements majeurs", "Résolution de conflits", "Investissements stratégiques", "Questions légales"], "favorables": ["Thérapies profondes", "Recherches", "Négociations difficiles", "Clôture de cycles"]}',
 '{"reporter": ["Maintien du statu quo", "Nouvelles relations superficielles", "Investissements risqués court terme"], "attention": ["Résistance au changement", "Conflits inutiles", "Émotions intenses"]}',
 ARRAY['Identifiez ce qui doit partir', 'Faites le grand ménage', 'Investissez dans votre transformation', 'Affrontez vos peurs', 'Créez de nouveaux rituels', 'Acceptez les fins', 'Faites confiance au processus'],
 'Je me transforme avec grâce et puissance. Ce qui ne me sert plus quitte ma vie.',
 'L''art de la transformation consciente'),

-- Période 7
(7, 'La Récolte', 'Le Bilan et la Préparation',
 313, 365,
 '-- VOIR content/periode_7.md --',
 '{"tres_favorables": ["Bilans", "Célébrations", "Clôtures", "Transmission"], "favorables": ["Voyages de ressourcement", "Philanthropie", "Spiritualité", "Planification du prochain cycle"]}',
 '{"reporter": ["Nouveaux grands projets", "Engagements à long terme", "Décisions majeures non urgentes"], "attention": ["Précipitation", "Minimiser ses accomplissements", "Manque de repos"]}',
 ARRAY['Faites un bilan écrit', 'Célébrez vos victoires', 'Terminez les projets en cours', 'Exprimez votre gratitude', 'Reposez-vous', 'Définissez vos intentions', 'Faites un acte de générosité'],
 'Je récolte les fruits de mes efforts et je remercie l''univers pour cette année.',
 'L''art de la gratitude et du lâcher-prise');

-- =============================================
-- NOTE: Remplacer full_content par le contenu des fichiers .md
-- =============================================
