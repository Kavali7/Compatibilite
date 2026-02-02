-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 4: PERSONNEL, SANTÉ, DIVERS
-- Mariage(7) + Voyage(7) + Chirurgie(7) + Régime(7) + Nouvelle Habitude(7) + Procès(7) = 42 conseils
-- =============================================

-- =============================================
-- MARIAGE - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
'Les énergies d''initiative stimulent les nouveaux commencements, y compris les unions.',

'Cette période est favorable pour commencer les préparatifs d''un mariage ou pour faire une demande. L''énergie d''initiative vous donne l''élan pour franchir le pas et vous projeter dans ce nouveau chapitre de vie. Cependant, la cérémonie elle-même sera mieux placée dans une phase de construction ou d''équilibre.',

'• Faites votre demande en mariage avec conviction\n• Lancez les préparatifs avec enthousiasme\n• Choisissez les dates et les lieux\n• Commencez à planifier',

'L''impulsivité peut précipiter des engagements. Assurez-vous de la solidité de votre relation.',

'• Se fiancer sur un coup de tête\n• Négliger les discussions importantes avant engagement',

'Cette phase favorise les demandes et les lancements.',

'La deuxième ou quatrième phase sera idéale pour la cérémonie.',

'Les unions sincères commencent par un engagement courageux.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction créent des unions solides et durables.',

'Cette période est exceptionnellement favorable pour le mariage. Les énergies de construction vous guident vers une union stable et durable. Les engagements pris maintenant reposent sur des fondations solides et ont toutes les chances de prospérer.',

'• Célébrez votre mariage avec confiance\n• Signez les contrats de mariage\n• Formalisez votre union\n• Posez les bases de votre vie commune',

'Même dans cette période favorable, n''oubliez pas les discussions pratiques.',

'• Négliger les aspects matériels et légaux\n• Éviter les sujets difficiles par romantisme',

'L''intégralité de cette phase est idéale pour le mariage.',

'Cette période est parfaite.',

'L''amour durable se construit sur des fondations solides.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies de communication favorisent les échanges sincères entre partenaires.',

'Cette période est favorable pour les discussions profondes entre futurs époux et pour la célébration sociale du mariage. Votre capacité à communiquer vos sentiments est optimale, renforçant les liens avec votre partenaire et vos invités.',

'• Discutez ouvertement de vos attentes\n• Célébrez votre union avec vos proches\n• Partagez votre bonheur\n• Résolvez les malentendus avec diplomatie',

'L''harmonie communicative ne doit pas masquer les vrais problèmes.',

'• Éviter les discussions difficiles\n• Se concentrer uniquement sur la fête sans fond',

'Cette phase favorise les célébrations communicatives.',

'La deuxième ou quatrième phase sera plus propice aux engagements formels.',

'Les mots d''amour sincères renforcent les liens.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les énergies d''équilibre créent des unions parfaitement harmonieuses.',

'Cette période est exceptionnellement favorable pour le mariage. Les énergies d''équilibre vous guident vers une union harmonieuse où les deux partenaires trouvent leur place. C''est le moment idéal pour les cérémonies et les engagements.',

'• Célébrez votre mariage en toute sérénité\n• Recherchez l''équilibre dans votre contrat de mariage\n• Unissez-vous dans l''harmonie\n• Construisez une vie équilibrée ensemble',

'L''équilibre parfait n''existe pas. Acceptez les petites imperfections.',

'• Attendre un équilibre parfait avant de s''engager\n• Négliger vos besoins individuels au profit du couple',

'L''intégralité de cette phase est idéale.',

'Cette période est parfaite.',

'L''équilibre entre deux âmes crée l''harmonie durable.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute ne sont pas propices aux engagements conjugaux.',

'Cette période n''est pas recommandée pour le mariage. Les doutes caractéristiques de cette phase peuvent affecter votre certitude et créer des hésitations malvenues lors d''un moment aussi important.',

'• Utilisez ce temps pour réfléchir à votre relation\n• Reportez la cérémonie si possible\n• Si doutes profonds : questionnez-vous honnêtement\n• Préparatifs discrets acceptables',

'Les doutes sur le mariage méritent d''être écoutés.',

'• Se marier malgré des doutes persistants\n• Ignorer les signaux d''alarme intérieurs',

'Évitez les cérémonies et engagements formels.',

'La deuxième ou quatrième phase du prochain cycle sera plus favorable.',

'Les unions durables naissent de la certitude, pas du doute.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation conviennent aux unions qui marquent un changement de vie radical.',

'Cette période peut être favorable si le mariage s''inscrit dans une transformation de vie majeure : après un divorce, un deuil, une expatriation ou un changement de vie radical. L''énergie de transformation soutient ces passages.',

'• Si transformation de vie : célébrez votre union\n• Embrassez ce nouveau chapitre avec votre partenaire\n• Pour mariage conventionnel : préférez une autre période',

'L''instabilité peut affecter la cérémonie et le début de la vie commune.',

'• Se marier pour fuir une situation\n• Confondre changement et engagement sincère',

'Favorable pour les unions de transformation.',

'La deuxième phase du prochain cycle sera plus stable.',

'Les transformations de vie peuvent être embrassées à deux.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de conclusion conviennent aux unions qui closent un chapitre de vie.',

'Cette période peut convenir aux mariages qui s''inscrivent dans la conclusion d''une longue relation ou d''un chemin de vie. L''énergie de bilan permet de formaliser ce qui existe déjà depuis longtemps.',

'• Si relation longue : formalisez votre union\n• Célébrez l''aboutissement de votre histoire\n• Préparez la prochaine étape de votre vie commune',

'Ne forcez pas un mariage pour clore un chapitre.',

'• Se marier par convention ou pression\n• Formaliser une relation qui devrait plutôt se terminer',

'Favorable pour les unions de longue durée.',

'La deuxième phase du prochain cycle sera excellente.',

'Les unions mûries ont leur propre beauté.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage';


-- =============================================
-- VOYAGE - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative sont parfaitement alignées avec les voyages d''exploration.',

'Cette période est exceptionnellement favorable pour les voyages. L''énergie d''initiative vous donne l''élan parfait pour partir à l''aventure, explorer de nouveaux horizons et vivre des expériences enrichissantes.',

'• Réservez et partez sans hésiter\n• Explorez des destinations nouvelles\n• Vivez l''aventure avec enthousiasme\n• Saisissez les opportunités de découverte',

'L''enthousiasme ne doit pas faire négliger la préparation.',

'• Partir sans préparation adéquate\n• Négliger les aspects pratiques et sécuritaires',

'Le début de cette phase est idéal pour les départs.',

'Cette période est parfaite.',

'Les voyages d''exploration élargissent l''âme.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les énergies de construction favorisent les voyages planifiés et les déplacements professionnels.',

'Cette période est favorable pour les voyages bien planifiés, les déplacements d''affaires et les visites qui construisent quelque chose (patrimoine, relations, projets). Les voyages effectués maintenant tendent à être productifs et satisfaisants.',

'• Effectuez vos voyages professionnels\n• Visitez des proches ou des sites avec intention\n• Profitez de voyages bien organisés\n• Construisez des souvenirs durables',

'La planification ne doit pas tuer la spontanéité.',

'• Surplanifier au point de ne pas profiter\n• Négliger les découvertes imprévues',

'L''intégralité de cette phase favorise les voyages organisés.',

'Cette période est très favorable.',

'Les voyages bien préparés portent leurs fruits.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication font des voyages des moments de connexion exceptionnels.',

'Cette période est excellente pour les voyages, particulièrement ceux qui impliquent des rencontres, des échanges culturels ou des visites familiales. Votre capacité à communiquer enrichit chaque interaction sur votre chemin.',

'• Voyagez pour rencontrer des gens\n• Échangez avec les locaux\n• Visitez famille et amis\n• Participez à des événements sociaux',

'Les interactions sociales ne doivent pas épuiser.',

'• Surcharger votre programme social\n• Négliger le temps de repos',

'Cette phase est idéale pour les voyages communicatifs.',

'Cette période est parfaite.',

'Les voyages enrichissent l''âme par les rencontres.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 4,
'Les énergies d''équilibre favorisent les voyages reposants et équilibrés.',

'Cette période est favorable pour les voyages de détente et de ressourcement. Les séjours équilibrés entre activité et repos vous apporteront une vraie régénération.',

'• Optez pour des destinations reposantes\n• Équilibrez activités et détente\n• Rechargez vos batteries\n• Profitez du calme et de la beauté',

'L''équilibre peut manquer de piquant pour les aventuriers.',

'• Choisir une destination trop calme si vous aimez l''aventure',

'L''intégralité de cette phase favorise la détente.',

'Cette période est favorable.',

'Les voyages de ressourcement préparent les grandes actions.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 3,
'Les énergies de réflexion conviennent aux voyages introspectifs et aux retraites.',

'Cette période peut être favorable pour les voyages de retraite, de méditation ou d''introspection. Les destinations calmes et les séjours solitaires ou spirituels sont particulièrement indiqués.',

'• Choisissez des destinations propices à la réflexion\n• Optez pour des retraites spirituelles\n• Profitez de la solitude constructive\n• Méditez sur votre chemin de vie',

'L''introspection ne doit pas devenir rumination négative.',

'• Voyager seul si vous êtes dans un état dépressif\n• Fuir vos problèmes par le voyage',

'Cette phase favorise les voyages spirituels.',

'La première phase du prochain cycle sera plus dynamique.',

'Les voyages intérieurs sont parfois les plus transformateurs.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 4,
'Les énergies de transformation sont propices aux voyages qui changent la vie.',

'Cette période peut être excellente pour les voyages transformateurs : année sabbatique, tour du monde, expatriation exploratoire. L''énergie de transformation soutient les voyages qui changent profondément.',

'• Osez les voyages de transformation\n• Partez pour un long périple si possible\n• Laissez le voyage vous changer\n• Explorez des destinations hors des sentiers battus',

'La transformation par le voyage doit être souhaitée, pas subie.',

'• Fuir ses problèmes par le voyage\n• Confondre évasion et transformation',

'Favorable pour les voyages transformateurs.',

'Cette période convient aux grandes aventures.',

'Certains voyages changent qui nous sommes à jamais.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de conclusion conviennent aux voyages de bilan et de clôture.',

'Cette période peut convenir aux voyages qui closent un chapitre : retour aux sources, pèlerinage familial, visite d''adieu. L''énergie de bilan permet de terminer ce qui doit l''être.',

'• Visitez des lieux significatifs de votre passé\n• Faites des voyages de mémoire\n• Clôturez des chapitres par le voyage\n• Préparez-vous pour les prochaines aventures',

'Ne voyagez pas par nostalgie excessive.',

'• Se complaire dans le passé pendant le voyage\n• Reporter les voyages de demain',

'Favorable pour les voyages de conclusion.',

'Le prochain cycle sera propice aux nouvelles explorations.',

'Certains voyages ferment des boucles essentielles.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage';


-- =============================================
-- CHIRURGIE - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 3,
'Les énergies d''initiative peuvent précipiter des décisions chirurgicales.',

'Cette période n''est pas idéale pour les chirurgies programmées. L''énergie d''initiative peut vous pousser à décider trop vite. Utilisez ce temps pour consulter des spécialistes et préparer votre dossier médical.',

'• Consultez plusieurs spécialistes\n• Préparez votre dossier médical\n• Évaluez toutes les options\n• Reportez l''intervention si possible',

'La précipitation dans les décisions médicales est risquée.',

'• Décider d''une chirurgie sur un coup de tête\n• Négliger les seconds avis médicaux',

'Cette phase convient aux consultations préparatoires.',

'La deuxième ou quatrième phase sera plus favorable.',

'La santé mérite réflexion et préparation.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction favorisent les interventions qui réparent et reconstruisent.',

'Cette période est très favorable pour les chirurgies programmées. Les énergies de construction soutiennent la guérison et la reconstruction du corps. Les interventions réalisées maintenant tendent à bien cicatriser et à donner de bons résultats.',

'• Programmez votre intervention dans cette période\n• Préparez-vous sereinement à l''opération\n• Suivez les protocoles préopératoires\n• Faites confiance au processus de guérison',

'Même dans cette période favorable, suivez scrupuleusement les conseils médicaux.',

'• Négliger la préparation préopératoire\n• Ignorer les instructions du chirurgien',

'L''intégralité de cette phase est favorable aux interventions.',

'Cette période est idéale.',

'Le corps reconstruit avec sagesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 3,
'Les énergies de communication favorisent les échanges avec l''équipe médicale.',

'Cette période est adaptée pour consulter et communiquer avec votre équipe médicale. Les discussions sur les options, les risques et les bénéfices seront particulièrement productives. L''intervention elle-même sera mieux placée ailleurs.',

'• Discutez en détail avec vos médecins\n• Posez toutes vos questions\n• Obtenez les informations nécessaires\n• Préparez-vous psychologiquement',

'Les échanges ne remplacent pas la préparation technique.',

'• Se satisfaire des explications sans vérifier\n• Négliger les préparations matérielles',

'Cette phase convient aux consultations détaillées.',

'La quatrième phase sera plus favorable pour opérer.',

'La communication avec l''équipe médicale rassure et prépare.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les énergies d''équilibre favorisent une guérison harmonieuse.',

'Cette période est très favorable pour les chirurgies programmées. Les énergies d''équilibre soutiennent une récupération harmonieuse et complète. Le corps trouve naturellement son chemin vers la guérison.',

'• Programmez votre intervention avec sérénité\n• Préparez un environnement de récupération calme\n• Suivez les protocoles de soin\n• Faites confiance à votre guérison',

'L''équilibre demande aussi du repos post-opératoire.',

'• Précipiter la reprise des activités\n• Négliger la convalescence',

'L''intégralité de cette phase est favorable.',

'Cette période est idéale.',

'L''équilibre du corps favorise la guérison complète.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute ne sont pas propices aux interventions chirurgicales.',

'Cette période n''est pas recommandée pour les chirurgies programmées. Les doutes caractéristiques de cette phase peuvent affecter votre état d''esprit préopératoire et possiblement la récupération.',

'• Reportez l''intervention si possible\n• Si urgence : préparez-vous mentalement\n• Travaillez sur votre confiance\n• Consultez pour apaiser vos doutes',

'L''anxiété préopératoire peut affecter la récupération.',

'• Opérer dans un état de doute intense\n• Ignorer vos appréhensions légitimes',

'Évitez les chirurgies programmées.',

'La deuxième ou quatrième phase du prochain cycle sera meilleure.',

'La sérénité préopératoire aide la guérison.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation peuvent convenir aux chirurgies de changement.',

'Cette période peut être favorable pour les chirurgies transformatrices : chirurgie réparatrice après accident, chirurgie de changement important. L''énergie de transformation soutient ces passages. Pour les interventions conventionnelles, attendez.',

'• Si chirurgie transformatrice : procédez avec confiance\n• Préparez-vous au changement\n• Pour chirurgie conventionnelle : reportez',

'L''instabilité peut affecter la récupération.',

'• Choisir une chirurgie dans un état émotionnel instable',

'Favorable pour les transformations corporelles.',

'La période suivante sera plus stable.',

'Certaines chirurgies sont des passages vers une nouvelle vie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les énergies de conclusion favorisent la clôture des parcours de soin.',

'Cette période peut être favorable pour les interventions qui closent un parcours de soin : dernière opération d''une série, intervention finale d''un traitement. L''énergie de conclusion soutient ces finalisations.',

'• Finalisez les parcours de soin en cours\n• Closez les traitements commencés\n• Préparez la récupération finale\n• Planifiez la suite si nouveau parcours',

'Ne précipitez pas une conclusion pour en finir.',

'• Forcer une intervention pour clore un dossier',

'Favorable pour les conclusions de traitement.',

'Le prochain cycle sera excellent pour de nouvelles interventions.',

'Chaque guérison achevée est une victoire.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'chirurgie';


-- =============================================
-- RÉGIME / CHANGEMENT HABITUDE ALIMENTAIRE - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative sont parfaitement alignées avec les nouveaux départs alimentaires.',

'Cette période est exceptionnellement favorable pour commencer un régime ou changer vos habitudes alimentaires. L''énergie d''initiative vous donne la motivation et la détermination nécessaires pour transformer vos comportements.',

'• Lancez votre nouveau régime avec conviction\n• Videz vos placards des tentations\n• Achetez les aliments de votre nouveau régime\n• Commencez avec enthousiasme',

'L''enthousiasme initial ne dure pas. Préparez les phases difficiles.',

'• Se lancer dans un régime trop restrictif\n• Négliger l''aspect progressif du changement',

'Le début de cette phase est idéal pour commencer.',

'Cette période est parfaite.',

'Les transformations alimentaires commencent par un premier pas déterminé.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction aident à ancrer les nouvelles habitudes alimentaires.',

'Cette période est excellente pour ancrer un régime ou de nouvelles habitudes alimentaires. Les énergies de construction vous aident à transformer les nouvelles pratiques en habitudes durables.',

'• Renforcez vos nouvelles habitudes\n• Créez des routines alimentaires\n• Structurez vos repas et courses\n• Construisez un environnement favorable',

'La structure ne doit pas devenir rigidité obsessionnelle.',

'• Être trop strict au point de créer des troubles\n• Négliger le plaisir de manger',

'L''intégralité de cette phase favorise l''ancrage des habitudes.',

'Cette période est très favorable.',

'Les bonnes habitudes alimentaires se construisent jour après jour.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 3,
'Les énergies de communication peuvent faciliter les régimes en groupe.',

'Cette période favorise les régimes pratiqués en groupe ou avec un accompagnement. Les échanges avec d''autres personnes en démarche similaire ou avec un nutritionniste seront particulièrement productifs.',

'• Rejoignez un groupe de soutien\n• Travaillez avec un nutritionniste\n• Partagez votre expérience\n• Apprenez des autres',

'L''énergie sociale peut aussi favoriser les écarts collectifs.',

'• Se laisser entraîner par la convivialité à faire des écarts\n• Comparer excessivement ses progrès aux autres',

'Cette phase convient aux démarches accompagnées.',

'La quatrième phase sera excellente pour consolider.',

'La solidarité renforce la motivation.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les énergies d''équilibre favorisent les régimes équilibrés et durables.',

'Cette période est exceptionnellement favorable pour adopter une alimentation équilibrée et durable. Les énergies vous guident naturellement vers des choix alimentaires sains et harmonieux.',

'• Adoptez une alimentation équilibrée\n• Trouvez votre juste mesure\n• Écoutez les signaux de votre corps\n• Stabilisez vos nouvelles habitudes',

'L''équilibre alimentaire n''est pas la perfection.',

'• Être obsédé par l''équilibre parfait\n• Se culpabiliser pour les petits écarts',

'L''intégralité de cette phase est idéale.',

'Cette période est parfaite.',

'L''équilibre alimentaire nourrit corps et âme.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute fragilisent la motivation pour les régimes.',

'Cette période est défavorable pour maintenir un régime ou en commencer un nouveau. Les doutes peuvent miner votre motivation et favoriser les écarts. Soyez patient avec vous-même.',

'• Maintenez le cap sans pression excessive\n• Soyez indulgent avec vos écarts\n• Ne commencez pas de nouveau régime\n• Préparez la phase suivante mentalement',

'Le doute peut mener à l''abandon. Restez bienveillant avec vous-même.',

'• Abandonner complètement par découragement\n• Se punir pour les écarts',

'Évitez de commencer un régime dans cette période.',

'La première phase du prochain cycle sera parfaite pour recommencer.',

'Les phases difficiles sont normales. La persévérance paie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 4,
'Les énergies de transformation peuvent favoriser les changements alimentaires radicaux.',

'Cette période peut être favorable pour les transformations alimentaires importantes : devenir végétarien, éliminer une catégorie d''aliments, changer radicalement son rapport à la nourriture. L''énergie de transformation soutient ces passages.',

'• Osez les changements alimentaires profonds\n• Transformez votre relation à la nourriture\n• Libérez-vous des habitudes néfastes\n• Embrassez une nouvelle approche',

'Les transformations radicales demandent accompagnement.',

'• Changer trop brutalement sans suivi\n• Confondre transformation et restriction excessive',

'Favorable pour les transformations profondes.',

'Cette période convient aux changements radicaux.',

'Les transformations alimentaires peuvent changer la vie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de conclusion conviennent au bilan des régimes terminés.',

'Cette période convient pour faire le bilan d''un régime terminé et préparer la suite. L''énergie de conclusion permet d''évaluer ce qui a fonctionné et ce qui doit être ajusté.',

'• Faites le bilan de votre démarche\n• Identifiez ce qui a fonctionné\n• Préparez votre prochaine approche\n• Consolidez les acquis',

'Ne relâchez pas complètement après un régime réussi.',

'• Revenir aux anciennes habitudes par fatigue\n• Négliger le maintien des acquis',

'Cette phase convient aux bilans.',

'La première phase du prochain cycle sera parfaite pour un nouveau départ.',

'Chaque régime enseigne des leçons pour le suivant.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'regime';


-- =============================================
-- NOUVELLE HABITUDE - 7 périodes (condensées)
-- =============================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative sont parfaites pour commencer de nouvelles habitudes.',
'Cette période est idéale pour démarrer une nouvelle habitude. L''énergie d''initiative maximise votre motivation et votre détermination.',
'• Commencez votre nouvelle habitude aujourd''hui\n• Définissez clairement votre objectif\n• Préparez votre environnement\n• Engagez-vous publiquement si possible',
'L''enthousiasme initial ne dure pas. Préparez les phases difficiles.',
'• Viser trop haut dès le début\n• Négliger la progressivité',
'Le début de cette phase est parfait pour commencer.',
'Cette période est idéale.',
'Les grandes transformations commencent par de petits gestes quotidiens.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction ancrent les nouvelles habitudes.',
'Cette période est excellente pour transformer une nouvelle pratique en habitude durable. Les énergies de construction vous aident à créer des automatismes.',
'• Renforcez votre routine quotidienne\n• Créez des rappels et des déclencheurs\n• Mesurez vos progrès\n• Célébrez les petites victoires',
'La routine ne doit pas devenir obsession.',
'• Être trop rigide dans l''application\n• Se décourager au moindre écart',
'L''intégralité de cette phase favorise l''ancrage.',
'Cette période est très favorable.',
'La répétition transforme l''effort en automatisme.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 4,
'Les énergies de communication favorisent les habitudes sociales.',
'Cette période favorise les nouvelles habitudes qui impliquent d''autres personnes : sport en groupe, activités sociales, pratiques partagées.',
'• Rejoignez un groupe pratiquant la même habitude\n• Trouvez un partenaire de responsabilité\n• Partagez vos progrès',
'L''aspect social ne doit pas devenir une dépendance.',
'• Dépendre entièrement du groupe pour sa motivation',
'Cette phase convient aux habitudes collectives.',
'Cette période est favorable.',
'La solidarité renforce les bonnes habitudes.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4,
'Les énergies d''équilibre favorisent les habitudes de vie équilibrées.',
'Cette période favorise les habitudes qui améliorent votre équilibre de vie : exercice modéré, alimentation équilibrée, méditation.',
'• Adoptez des habitudes équilibrées\n• Écoutez les signaux de votre corps\n• Trouvez votre juste mesure',
'L''équilibre n''est pas la modération forcée.',
'• Se contenter du minimum par souci d''équilibre',
'L''intégralité de cette phase est favorable.',
'Cette période convient à l''équilibre.',
'L''équilibre de vie est la plus précieuse des habitudes.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute fragilisent les nouvelles habitudes.',
'Cette période est défavorable pour maintenir ou commencer de nouvelles habitudes. Les doutes peuvent miner votre motivation. Soyez patient.',
'• Maintenez le cap sans pression\n• Soyez indulgent avec les écarts\n• Ne commencez pas de nouvelle habitude',
'Le doute peut mener à l''abandon.',
'• Abandonner complètement\n• Se culpabiliser',
'Évitez de commencer une habitude.',
'La première phase du prochain cycle sera parfaite.',
'Les phases difficiles sont normales. Persévérez.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 4,
'Les énergies de transformation favorisent les changements d''habitudes radicaux.',
'Cette période peut favoriser les transformations profondes de vos habitudes : arrêter une addiction, changer radicalement votre mode de vie.',
'• Osez les changements profonds\n• Libérez-vous des mauvaises habitudes\n• Transformez-vous',
'Les changements radicaux demandent un accompagnement.',
'• Changer trop brutalement sans soutien',
'Favorable pour les transformations profondes.',
'Cette période convient aux changements radicaux.',
'Les transformations profondes changent la vie.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de conclusion conviennent au bilan des habitudes adoptées.',
'Cette période convient pour évaluer les habitudes que vous avez tenté d''adopter et préparer la prochaine étape.',
'• Faites le bilan de vos tentatives\n• Identifiez ce qui a fonctionné\n• Préparez votre prochaine approche',
'Ne relâchez pas les habitudes acquises.',
'• Revenir aux anciennes habitudes',
'Cette phase convient aux bilans.',
'La première phase sera parfaite pour un nouveau départ.',
'Chaque tentative enseigne des leçons.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'nouvelle_habitude';


-- =============================================
-- PROCÈS / ACTION EN JUSTICE - 7 périodes (condensées)
-- =============================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4,
'Les énergies d''initiative donnent l''élan pour lancer une action en justice.',
'Cette période est favorable pour initier une action en justice si vous avez l''avantage. L''énergie offensive de cette phase soutient les démarches judiciaires proactives.',
'• Consultez un avocat si ce n''est pas fait\n• Lancez les procédures si votre dossier est solide\n• Rassemblez vos preuves\n• Préparez votre argumentaire',
'L''impulsivité peut nuire à votre cause. Préparez soigneusement.',
'• Agir impulsivement sans stratégie\n• Négliger le conseil juridique',
'Cette phase favorise les lancements de procédure.',
'La troisième phase sera idéale pour les négociations.',
'La justice demande préparation et patience.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 4,
'Les énergies de construction favorisent la préparation solide d''un dossier.',
'Cette période est excellente pour constituer un dossier juridique solide. Les énergies vous aident à rassembler méthodiquement les preuves et à construire votre argumentation.',
'• Constituez un dossier complet\n• Documentez tous les faits\n• Travaillez étroitement avec votre avocat\n• Préparez les témoignages',
'La préparation ne doit pas retarder indéfiniment l''action.',
'• Se perdre dans la préparation sans agir\n• Attendre le dossier parfait',
'L''intégralité de cette phase favorise la préparation.',
'La troisième phase sera propice aux audiences.',
'Un dossier bien préparé est à moitié gagné.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication sont idéales pour les audiences et négociations.',
'Cette période est excellente pour les audiences, les plaidoiries et les négociations. Votre éloquence et votre capacité à convaincre sont à leur apogée.',
'• Présentez votre cas avec clarté\n• Négociez avec assurance\n• Écoutez les arguments adverses\n• Trouvez des compromis si possible',
'L''éloquence ne remplace pas les preuves.',
'• Se fier uniquement à la parole sans faits\n• Négliger les aspects techniques',
'Cette phase est idéale pour les audiences.',
'Cette période est très favorable.',
'La parole juste au bon moment change le cours des choses.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4,
'Les énergies d''équilibre favorisent les règlements à l''amiable.',
'Cette période est très favorable pour les accords à l''amiable et les médiations. Les énergies vous guident vers des solutions équilibrées qui satisfont les deux parties.',
'• Recherchez un accord à l''amiable\n• Acceptez la médiation\n• Trouvez des compromis équilibrés\n• Préservez les relations si possible',
'L''équilibre ne doit pas devenir capitulation.',
'• Céder trop pour avoir la paix\n• Accepter un accord inéquitable',
'L''intégralité de cette phase favorise les accords.',
'Cette période est propice aux médiations.',
'La paix équilibrée vaut mieux que le conflit prolongé.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute sont défavorables aux actions judiciaires.',
'Cette période n''est pas recommandée pour les démarches judiciaires actives. Les doutes peuvent affecter votre confiance et votre présentation.',
'• Reportez les audiences si possible\n• Utilisez ce temps pour réfléchir\n• Questionnez vos motivations profondes\n• Consultez pour apaiser vos incertitudes',
'Le doute peut affaiblir votre position.',
'• Aller en audience dans le doute\n• Abandonner par découragement',
'Évitez les audiences importantes.',
'La troisième phase du prochain cycle sera meilleure.',
'Le doute demande réflexion, pas action.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation conviennent aux procédures de rupture.',
'Cette période peut favoriser les procédures liées à des ruptures : divorce, dissolution, liquidation. L''énergie de transformation soutient ces passages difficiles mais nécessaires.',
'• Si rupture nécessaire : procédez avec détermination\n• Préparez les documents de dissolution\n• Acceptez la transformation en cours',
'L''instabilité peut affecter le jugement.',
'• Prendre des décisions radicales sur un coup de tête\n• Fuir par la rupture',
'Favorable pour les procédures de rupture.',
'La quatrième phase sera plus équilibrée.',
'Certaines ruptures légales libèrent pour un nouveau départ.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4,
'Les énergies de conclusion favorisent les jugements finaux.',
'Cette période convient pour recevoir ou attendre des jugements finaux, clore des procédures longues, finaliser des accords.',
'• Acceptez les conclusions en cours\n• Finalisez les accords\n• Clôturez les dossiers\n• Tirez les leçons de l''expérience',
'Ne prolongez pas artificiellement les procédures.',
'• Faire appel par principe sans fondement\n• Prolonger les conflits inutilement',
'Cette phase favorise les conclusions.',
'Cette période convient aux fins de procédure.',
'Chaque conclusion judiciaire permet de tourner la page.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'proces';


-- =============================================
-- VÉRIFICATION FINALE
-- =============================================
SELECT 'Conseils PERSONNEL/SANTÉ/DIVERS insérés:' AS status;
SELECT dt.category, dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category IN ('personnel', 'sante', 'divers')
GROUP BY dt.category, dt.label
ORDER BY dt.category, dt.label;

-- RÉCAPITULATIF GLOBAL
SELECT '=== RÉCAPITULATIF GLOBAL ===' AS message;
SELECT dt.category, COUNT(a.id) as total_conseils 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
GROUP BY dt.category
ORDER BY dt.category;

SELECT 'TOTAL CONSEILS:' AS message, COUNT(*) as total FROM cycle_vie_decision_advice;
