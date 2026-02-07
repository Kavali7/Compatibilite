-- =============================================
-- SERVICE 05 - GUIDE HORAIRE
-- Mise à jour du contenu des 7 périodes (A-G)
-- Basé sur les descriptions du livre (Chapitre 13)
-- Reformulé en ton mystique sans termes techniques
-- =============================================
-- IMPORTANT: Les horaires ne sont PAS stockés en DB.
-- La rotation jour/lettre est calculée côté Dart.
-- Les 7 lignes A-G contiennent le contenu UNIVERSEL
-- applicable quel que soit le jour de la semaine.
-- =============================================

-- Mise à jour Période A
UPDATE cycle_vie_daily_periods SET
  period_name = 'L''Élévation',
  keyword = 'Connexions influentes',
  description = 'Cette période est baignée d''une énergie d''élévation et de connexion avec les forces supérieures. C''est un moment propice pour se tourner vers ceux qui ont du pouvoir ou de l''influence, et pour nourrir vos ambitions les plus nobles. L''univers vous soutient dans vos démarches d''ascension personnelle et professionnelle.',
  activities_favorables = 'Méditer et affiner un projet en cours, Solliciter des faveurs auprès de personnes influentes, Demander une promotion ou une recommandation, Rédiger des lettres ou messages visant à renforcer votre réputation, Rencontrer des responsables ou personnalités haut placées, Travailler sur votre image ou celle de votre entreprise, Signer des testaments ou actes de transfert, Consolider votre crédibilité auprès de financeurs',
  activities_eviter = 'Lancer un nouveau projet ou une nouvelle affaire, Signer des contrats ou accords commerciaux, Acheter ou vendre des biens immobiliers, Déménager ou s''installer dans un nouveau lieu, Se marier ou faire une demande en mariage, Prêter de l''argent, Effectuer un premier investissement, Subir une opération chirurgicale, Commencer un voyage court',
  energy_level = 'high',
  color_code = '#ef4444',
  updated_at = now()
WHERE period_letter = 'A';

-- Mise à jour Période B
UPDATE cycle_vie_daily_periods SET
  period_name = 'La Création',
  keyword = 'Nouveaux départs',
  description = 'Cette période est l''une des plus favorables pour entamer de nouvelles choses. Elle porte en elle une énergie de création, de beauté et de nouveaux départs. C''est le moment idéal pour concrétiser des projets, nouer de nouvelles relations, et embrasser le changement avec confiance.',
  activities_favorables = 'Lancer un nouveau projet ou une entreprise, Profiter de l''art et de la musique, Embellir votre maison ou votre apparence, Embaucher des collaborateurs importants, Nouer de nouvelles relations fiables et durables, Partir en voyage court, Se marier ou entamer une relation, Prêter ou emprunter de l''argent, Concrétiser de nouveaux projets, Se divertir et participer à des événements sociaux, Spéculer ou investir de manière spéculative, Traiter des affaires impliquant des femmes',
  activities_eviter = 'Recruter du personnel pour des tâches subalternes, Partir en long voyage surtout par mer ou très loin, Se fier aveuglément aux impulsions intellectuelles du moment',
  energy_level = 'high',
  color_code = '#22c55e',
  updated_at = now()
WHERE period_letter = 'B';

-- Mise à jour Période C
UPDATE cycle_vie_daily_periods SET
  period_name = 'L''Intellect',
  keyword = 'Activité mentale',
  description = 'Cette période est gouvernée par l''esprit et la pensée. C''est le moment par excellence pour toute activité intellectuelle : étudier, analyser, communiquer, enseigner. Votre esprit est vif et perçant, capable de saisir des vérités profondes.',
  activities_favorables = 'Étudier et faire de la recherche, Écrire et publier des documents importants, Analyser des propositions ou contrats, Enseigner et former, Faire des contrats de courte durée, Recouvrer des créances, Nouer de nouvelles connaissances fiables, Embaucher tout type de personnel, Partir en voyage court, Travail journalistique ou publicitaire, Lancer des campagnes de communication, Commencer un traitement thérapeutique, Prêter de l''argent, Planifier de nouvelles constructions, Signer des documents importants',
  activities_eviter = 'Se marier, Traiter avec des avocats, S''occuper d''inventions ou problèmes mécaniques, Demander une promotion à des personnes influentes, Acheter ou vendre de l''immobilier, Subir une opération chirurgicale, Tenter des réconciliations difficiles, Se fier aux discours enthousiastes sans vérification',
  energy_level = 'medium',
  color_code = '#3b82f6',
  updated_at = now()
WHERE period_letter = 'C';

-- Mise à jour Période D
UPDATE cycle_vie_daily_periods SET
  period_name = 'Le Mouvement',
  keyword = 'Affaires générales',
  description = 'Cette période favorise les affaires générales, les déplacements et les interactions avec le grand public. C''est une énergie de mouvement et de connexion sociale. Les ambitions sont stimulées et les résultats sont généralement fructueux.',
  activities_favorables = 'Gérer toute affaire commerciale générale, Travailler dans l''éducation ou la formation, Opérations agricoles et plantations, Nouer de nouvelles connaissances, Recruter du personnel de tout type, Partir en voyage court ou long, Écrire et superviser des travaux littéraires, Se marier ou entamer une relation, Suivre un traitement médical, Étudier la philosophie et la métaphysique, Expédier des marchandises et gérer le transport, Vendre et prospecter, Subir une opération chirurgicale si nécessaire',
  activities_eviter = 'Lancer un tout nouveau projet, Signer des contrats ou documents légaux, Emprunter de l''argent ou signer des papiers financiers, Spéculer ou jouer, Écrire des lettres demandant des faveurs importantes, Intenter une action en justice',
  energy_level = 'medium',
  color_code = '#06b6d4',
  updated_at = now()
WHERE period_letter = 'D';

-- Mise à jour Période E
UPDATE cycle_vie_daily_periods SET
  period_name = 'La Persévérance',
  keyword = 'Prudence requise',
  description = 'Cette période est la plus exigeante et la plus délicate de la journée. Elle favorise les actions nécessitant de la ténacité et de l''endurance. Ce qui est commencé ou terminé pendant cette période tend à durer longtemps — pour le meilleur comme pour le pire.',
  activities_favorables = 'Actions nécessitant persévérance et endurance, Présenter vos affaires devant des juges ou magistrats, Donner de la permanence à un projet en cours, Travaux littéraires et promotionnels, Intenter une action en justice, Travailler sur des inventions ou problèmes techniques, Déménager dans une nouvelle maison, Acheter ou vendre de l''immobilier, Méditation spirituelle et poursuites scientifiques',
  activities_eviter = 'Signer des contrats ou accords (sauf immobilier), Recouvrer des créances, Opérations agricoles, Nouer de nouvelles connaissances, Recruter du personnel, Partir en long voyage surtout par mer, Se marier, Prendre des médicaments, Emprunter ou prêter de l''argent, Construire de nouveaux bâtiments, Demander des faveurs à des influents, Spéculer ou jouer, Se faire opérer, Écrire des lettres importantes, Se divertir',
  energy_level = 'low',
  color_code = '#f59e0b',
  updated_at = now()
WHERE period_letter = 'E';

-- Mise à jour Période F
UPDATE cycle_vie_daily_periods SET
  period_name = 'La Fortune',
  keyword = 'Période la plus favorable',
  description = 'C''est la période la plus favorable de la journée ! Elle baigne dans une énergie de prospérité, de succès et d''opportunité. Presque tout ce que vous entreprenez pendant cette période a de bonnes chances de réussir. C''est le moment idéal pour vos décisions les plus importantes.',
  activities_favorables = 'Lancer n''importe quel nouveau projet, Signer des contrats et documents importants, Recouvrer des créances ou lever des fonds, Activités éducatives et intellectuelles, Nouer de nouvelles connaissances durables, Partir en voyage court ou long, Traiter avec des avocats ou soumettre des dossiers, Se marier ou entamer une relation, Emprunter de l''argent, Construire de nouveaux bâtiments, Réunions de direction et business, Demander une promotion, Traiter avec des fonctionnaires ou le public, Acheter ou vendre de l''immobilier, Événements sociaux et divertissements, Demander des faveurs, Spéculer (favorable), Écrire des lettres importantes',
  activities_eviter = 'Recruter du personnel subalterne, Affaires maritimes',
  energy_level = 'high',
  color_code = '#a855f7',
  updated_at = now()
WHERE period_letter = 'F';

-- Mise à jour Période G
UPDATE cycle_vie_daily_periods SET
  period_name = 'L''Action',
  keyword = 'Énergie physique',
  description = 'Cette période favorise les activités nécessitant de l''énergie physique, de l''agressivité constructive et de l''endurance. C''est une énergie matérielle et concrète, excellente pour le travail manuel et les affaires nécessitant de la force et de la détermination.',
  activities_favorables = 'Activités nécessitant de l''énergie physique, Recouvrement d''argent ou de créances, Recruter des commerciaux et agents, Résoudre des problèmes mécaniques ou techniques, Travaux d''invention et de construction, Travaux avec le métal ou les métallurgistes, Poursuites scientifiques',
  activities_eviter = 'Recevoir ou offrir des cadeaux et faveurs, Activités humanitaires publiques, Acheter ou spéculer, Traiter avec des ennemis, Partir en long voyage, Intenter des actions en justice, Se marier ou faire la cour, Demander des faveurs, Subir une opération chirurgicale, Traiter des affaires impliquant des femmes',
  energy_level = 'medium',
  color_code = '#f97316',
  updated_at = now()
WHERE period_letter = 'G';

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT period_letter, period_name, keyword, energy_level,
       LENGTH(description) as desc_len,
       LENGTH(activities_favorables) as fav_len,
       LENGTH(activities_eviter) as eviter_len
FROM cycle_vie_daily_periods
ORDER BY period_letter;
