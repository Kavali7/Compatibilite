-- =============================================
-- SERVICE 06 - ÉCLAIRAGE DÉCISION
-- SCRIPT 3/3 : CONSEILS POUR LES 8 NOUVEAUX TYPES
-- =============================================
-- Prérequis : Exécuter step1 et step2 AVANT
-- Ce script insère 56 lignes (8 types × 7 périodes)
-- cycle_type = 'personal' (comme les 140 existants)
-- =============================================

-- Vérification : les 8 nouveaux types doivent exister
SELECT code, label FROM cycle_vie_decision_types
WHERE code IN ('debut_relation','autre','construction_renovation','negociation_accord',
               'campagne_pub','vente_bien','inscription_formation','pelerinage_retraite')
ORDER BY display_order;
-- Attendu : 8 lignes

-- ─── TYPE: debut_relation (7 périodes) ──────────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 5,
'L''énergie d''initiative baigne votre journée d''une aura de nouveau commencement. Les forces cosmiques favorisent les ouvertures du cœur et les premiers pas vers l''autre.',
'Période exceptionnellement favorable pour déclarer vos sentiments ou proposer un premier rendez-vous. L''énergie de renouveau qui vous entoure rend vos intentions plus lumineuses et votre charisme naturellement magnifié. L''autre personne sera plus réceptive à votre approche.',
'Invitez la personne dans un cadre agréable, Soyez authentique dans votre approche, Exprimez vos intentions avec clarté',
NULL,
'Évitez de précipiter les choses malgré l''enthousiasme, Ne confondez pas attraction passagère et sentiment profond',
'Les moments en début de journée ou en fin d''après-midi sont les plus propices.',
NULL,
'Les étoiles vous sourient. Osez le premier pas avec confiance, car les énergies du moment portent la promesse de belles connexions.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 4,
'L''énergie de construction stabilise vos émotions et favorise les connexions fondées sur la solidité plutôt que la passion éphémère.',
'Bonne période pour approfondir une relation naissante. Les énergies favorisent les échanges sincères et la découverte mutuelle. Si vous envisagez de formaliser une relation, ce moment apporte la lucidité nécessaire pour faire un choix éclairé.',
'Privilégiez les activités qui permettent de vraiment connaître l''autre, Partagez vos valeurs et objectifs de vie',
'Ne vous engagez pas trop formellement trop vite.',
'Évitez de projeter des attentes irréalistes sur la personne',
'Les moments de partage calme, repas ou promenade, sont les plus révélateurs.',
NULL,
'La patience est votre alliée. Une relation construite dans la sérénité a plus de chances de durer.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 5,
'L''énergie de communication ouvre les canaux du dialogue amoureux. L''intellect et le charme verbal sont à leur apogée.',
'Excellente période pour les déclarations et les conversations profondes. Votre éloquence naturelle est renforcée, rendant vos mots plus touchants. C''est le moment idéal pour exprimer ce que vous ressentez ou pour séduire par la parole.',
'Écrivez une lettre ou un message sincère, Proposez des sorties stimulantes intellectuellement, Engagez des conversations sur vos passions communes',
'Attention à la confusion entre attirance intellectuelle et attirance du cœur.',
'Ne séduisez pas par manipulation verbale, restez sincère',
'Le début de soirée est particulièrement propice aux confidences.',
NULL,
'Les mots justes ouvrent les portes du cœur. Parlez avec votre âme, pas seulement avec votre esprit.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4,
'L''énergie d''équilibre apporte une harmonie naturelle aux relations. Le foyer et la famille sont au centre des préoccupations cosmiques.',
'Période favorable pour les relations sérieuses et les engagements à long terme. Les rencontres faites maintenant tendent vers la stabilité et le confort mutuel. Si vous cherchez une relation durable plutôt qu''une aventure, ce moment est idéal.',
'Présentez-vous tel que vous êtes vraiment, Montrez votre côté attentionné et protecteur',
NULL,
'Ne restez pas dans votre zone de confort par peur du rejet',
'Les rencontres en contexte familial ou amical sont favorisées.',
NULL,
'L''amour véritable naît dans la simplicité et l''authenticité.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2,
'L''énergie de réflexion tourne votre regard vers l''intérieur. Les élans du cœur sont freinés par l''introspection.',
'Période peu favorable pour les nouvelles relations amoureuses. L''énergie introspective crée une distance naturelle avec les autres. Vos doutes intérieurs peuvent se projeter sur l''autre personne, faussant votre jugement.',
'Travaillez d''abord sur vous-même, Clarifiez ce que vous cherchez vraiment dans une relation',
'Risque de repousser l''autre par excès d''analyse ou de distance émotionnelle.',
'Ne commencez pas une relation pour fuir votre solitude, Évitez les déclarations impulsives que vous pourriez regretter',
NULL,
'Attendez la période 6 pour un nouveau départ amoureux, ou la période 1 du prochain cycle.',
'Prenez ce temps pour mieux vous connaître. Celui qui se comprend lui-même est plus apte à aimer autrui.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3,
'L''énergie de transformation peut provoquer des rencontres inattendues mais intenses. Le destin est à l''œuvre.',
'Période ambivalente pour les nouvelles relations. Les rencontres faites maintenant sont souvent marquantes et transformatrices, mais pas toujours dans le sens espéré. Si une personne entre dans votre vie à ce moment, elle changera votre perspective.',
'Restez ouvert aux rencontres imprévues, Acceptez que l''amour puisse prendre des formes inattendues',
'Les relations commencées en période de transformation peuvent être turbulentes.',
'Ne vous attachez pas trop vite à quelqu''un qui représente un idéal plutôt qu''une réalité',
'Les rencontres spontanées et non planifiées sont les plus significatives pendant cette période.',
'Si vous hésitez, attendez la période 1 pour un début plus serein.',
'Les rencontres du destin ne se planifient pas. Laissez la vie vous surprendre.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 3,
'L''énergie de bilan clôture un cycle. Les sentiments sont teintés de nostalgie et de sagesse.',
'Période de conclusion, ni la meilleure ni la pire pour une nouvelle relation. Si vous renouez avec un ancien amour, les énergies de bilan peuvent apporter la clarté nécessaire. Pour les nouvelles rencontres, mieux vaut attendre le prochain cycle.',
'Faites le bilan de vos relations passées, Identifiez les schémas à ne pas répéter',
'Attention à la nostalgie qui pourrait vous ramener vers des relations passées toxiques.',
'Ne confondez pas nostalgie et amour véritable',
NULL,
'Attendez le début du prochain cycle (période 1) pour un vrai nouveau départ amoureux.',
'Chaque fin de cycle prépare un nouveau commencement. Utilisez cette sagesse pour mieux choisir demain.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'debut_relation';

-- ─── TYPE: autre (7 périodes) ───────────────────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4, 'L''énergie d''initiative ouvre un champ de possibilités. Les nouveaux départs sont soutenus par les forces cosmiques.',
'Période favorable pour toute décision impliquant un nouveau commencement. Votre élan et votre détermination vous portent. Si votre décision marque le début de quelque chose de nouveau, c''est le bon moment.',
'Prenez le temps de bien définir votre objectif, Agissez avec conviction mais sans précipitation', NULL, 'Ne vous dispersez pas entre trop d''options', 'Agissez de préférence le matin, quand l''énergie d''initiative est la plus forte.', NULL,
'Les forces vous soutiennent. Avancez avec confiance.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5, 'L''énergie de construction apporte solidité et méthode à vos décisions.',
'Excellente période pour les décisions qui engagent sur le long terme. La clarté d''esprit et la rigueur sont à leur maximum. Quel que soit votre choix, les fondations posées maintenant tiendront.',
'Documentez votre décision par écrit, Consultez les personnes de confiance', NULL, 'N''attendez pas la perfection pour agir', NULL, NULL,
'C''est le moment idéal pour construire solidement.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 4, 'L''énergie de communication facilite les échanges et la recherche de conseil.',
'Période favorable aux décisions nécessitant du dialogue ou de la recherche. Si votre choix implique de convaincre quelqu''un ou d''obtenir des informations, c''est le bon moment. Votre esprit d''analyse est aiguisé.',
'Rassemblez toutes les informations nécessaires, Parlez de votre décision à des gens de confiance', 'Attention à la suranalyse qui peut paralyser la décision.', NULL, NULL, NULL,
'L''information est le pouvoir. Armez-vous de connaissances avant d''agir.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4, 'L''énergie d''équilibre apporte la juste mesure à vos choix.',
'Bonne période pour les décisions modérées et équilibrées. Si votre choix nécessite de la sagesse et de la mesure plutôt que de l''audace, c''est le moment idéal. Les décisions familiales et domestiques sont particulièrement favorisées.',
'Pesez le pour et le contre calmement, Impliquez vos proches si la décision les concerne', NULL, 'Ne cédez pas aux pressions extérieures', NULL, NULL,
'La sagesse est de savoir quand être prudent et quand oser.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2, 'L''énergie de réflexion invite à la prudence et au report.',
'Période peu favorable aux décisions importantes. L''indécision et les doutes risquent de compromettre votre choix. Sauf urgence absolue, il est préférable de reporter toute décision majeure.',
'Prenez du recul, Notez vos réflexions pour plus tard', 'Risque de décision regrettée sous l''effet du doute.', 'Ne cédez pas à l''anxiété en prenant une décision précipitée pour « en finir »', NULL,
'Reportez si possible aux périodes 6 ou 7, ou à la période 1 du prochain cycle.',
'C''est parfois une marque de force que de savoir attendre le bon moment.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3, 'L''énergie de transformation favorise les choix qui impliquent un changement radical.',
'Période ambivalente. Favorable si votre décision implique une rupture avec le passé ou un changement profond de direction. Défavorable pour les décisions de routine ou de maintien du statu quo.',
'Si c''est un tournant de vie, foncez, Si c''est routinier, attendez', 'Les transformations mal préparées peuvent être douloureuses.', NULL, NULL,
'La période 1 ou 2 du prochain cycle sera meilleure pour les décisions conventionnelles.',
'Les plus grands changements naissent parfois des moments les plus incertains.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4, 'L''énergie de bilan éclaire vos choix d''une lumière de sagesse et de recul.',
'Bonne période pour conclure une décision déjà mûrement réfléchie. L''énergie de bilan vous donne le recul nécessaire pour trancher avec sagesse. Évitez cependant de lancer quelque chose de totalement nouveau.',
'Finalisez ce qui est en cours, Tirez les leçons du passé pour éclairer votre choix', NULL, 'Ne commencez pas un nouveau projet majeur à cette période', 'Fin de journée, quand le calme favorise la réflexion.', NULL,
'La sagesse du soir éclaire les décisions du matin.' FROM cycle_vie_decision_types dt WHERE dt.code = 'autre';

-- ─── TYPE: construction_renovation (7 périodes) ─────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4, 'L''énergie d''initiative favorise le lancement de nouveaux projets de construction.',
'Bonne période pour démarrer des travaux ou poser la première pierre. L''élan de renouveau donne du dynamisme au projet et motive les équipes.',
'Sélectionnez vos artisans avec soin, Définissez clairement le cahier des charges', 'Ne commencez pas sans un plan détaillé.', 'Ne sous-estimez pas les délais et les coûts', NULL, NULL,
'Chaque grande construction commence par une première pierre posée au bon moment.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5, 'L''énergie de construction est en parfaite résonance avec vos travaux. Alignement cosmique idéal.',
'Période exceptionnellement favorable pour tout projet de construction ou rénovation. Les fondations posées maintenant seront solides et durables. C''est LE moment pour les grands travaux.',
'Signez les devis et contrats avec les artisans, Lancez les travaux de fondation, Investissez dans la qualité des matériaux', NULL, NULL, NULL, NULL,
'Les étoiles bâtissent avec vous. Profitez de cet alignement rare.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 3, 'L''énergie de communication favorise la planification mais pas l''exécution des travaux.',
'Période favorable pour la planification, les discussions avec architectes et artisans, et la négociation des devis. Moins propice à l''exécution physique des travaux.',
'Comparez les devis, Discutez des modifications avec votre architecte', 'Attention aux promesses trop optimistes des artisans.', 'Ne signez pas de devis sous la pression', NULL, NULL,
'Planifier avec soin, c''est déjà construire.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 5, 'L''énergie d''équilibre favorise les finitions et l''aménagement intérieur.',
'Excellente période pour les travaux d''aménagement, de décoration et de finition. Si vous cherchez à créer un espace harmonieux et chaleureux, les énergies vous accompagnent.',
'Choisissez les couleurs et matériaux de finition, Aménagez les espaces de vie, Installez le confort', NULL, NULL, NULL, NULL,
'Un foyer harmonieux est le reflet d''une âme en paix.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2, 'L''énergie de réflexion ralentit les projets matériels. Les travaux risquent de stagner.',
'Période défavorable pour les travaux de construction. Les retards, les malfaçons et les imprévus sont plus probables. Si des travaux sont en cours, redoublez de vigilance sur la qualité.',
'Inspectez les travaux en cours, Vérifiez la qualité des matériaux', 'Retards et surcoûts plus probables que d''habitude.', 'Ne lancez pas de nouveaux chantiers pendant cette période', NULL,
'Attendez la période 6 ou 7 pour reprendre les travaux, ou la période 2 du prochain cycle.',
'Mieux vaut un chantier suspendu qu''un travail bâclé.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3, 'L''énergie de transformation peut favoriser les rénovations profondes mais pas les constructions neuves.',
'Période favorable uniquement pour les rénovations qui transforment radicalement un espace. Les démolitions et les restructurations profondes sont soutenues. Les constructions neuves ou les finitions délicates sont déconseillées.',
'Démolissez ce qui doit l''être, Restructurez les espaces avec audace', NULL, 'Ne commencez pas une construction neuve', NULL, NULL,
'Parfois il faut détruire pour mieux reconstruire.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4, 'L''énergie de bilan invite à finaliser les chantiers en cours.',
'Bonne période pour terminer des travaux en cours et faire les finitions. L''énergie de clôture vous aide à boucler un projet de construction avant d''en entamer un nouveau.',
'Finalisez les derniers détails, Faites la réception des travaux, Réglez les derniers paiements', NULL, 'Ne lancez pas de nouveaux travaux', NULL, NULL,
'Un chantier bien terminé est la base d''un foyer heureux.' FROM cycle_vie_decision_types dt WHERE dt.code = 'construction_renovation';

-- ─── TYPE: negociation_accord (7 périodes) ──────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4, 'L''énergie d''initiative vous donne l''avantage dans les négociations.',
'Période favorable pour ouvrir une négociation. Votre dynamisme et votre confiance impressionnent vos interlocuteurs. Bon moment pour poser vos conditions et affirmer votre position.',
'Préparez vos arguments clés, Prenez l''initiative de la discussion', 'Ne soyez pas trop agressif dans votre approche.', 'Ne révélez pas toutes vos cartes d''entrée de jeu', 'Début de journée, quand votre énergie est au plus haut.', NULL,
'Celui qui pose les termes de la négociation en contrôle souvent l''issue.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5, 'L''énergie de construction favorise les accords solides et durables.',
'Excellente période pour conclure un accord. Les parties sont disposées à trouver un terrain d''entente stable. Les accords signés maintenant tiennent dans le temps.',
'Mettez par écrit les termes convenus, Assurez-vous que chaque partie est satisfaite', NULL, NULL, NULL, NULL,
'Un bon accord est celui dont les deux parties sortent gagnantes.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 5, 'L''énergie de communication est à son apogée. Le dialogue est roi.',
'Période idéale pour les pourparlers et les échanges. Votre capacité à convaincre et à trouver les mots justes est remarquable. Les malentendus se dissipent facilement.',
'Pratiquez l''écoute active, Reformulez pour vous assurer de la compréhension mutuelle, Utilisez des arguments logiques et chiffrés', 'Attention à ne pas promettre plus que vous ne pouvez tenir.', NULL, NULL, NULL,
'Les mots justes sont la clé de tout accord réussi.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4, 'L''énergie d''équilibre favorise les compromis justes.',
'Bonne période pour trouver un juste milieu. Les deux parties sont naturellement enclines à la modération et au compromis. Idéal pour les médiations et les arbitrages.',
'Cherchez le compromis gagnant-gagnant, Faites des concessions calculées', NULL, 'Ne sacrifiez pas vos intérêts essentiels par excès de gentillesse', NULL, NULL,
'L''équilibre est la vertu des accords qui durent.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2, 'L''énergie de réflexion crée de la méfiance et des blocages dans les négociations.',
'Période défavorable pour les négociations. Les doutes et la suspicion règnent. Les parties sont sur la défensive et les concessions sont rares. Risque élevé de rupture des pourparlers.',
'Reportez si possible, Maintenez le dialogue ouvert sans forcer', 'Les accords conclus maintenant risquent d''être regrettés ou contestés.', 'Ne forcez pas un accord sous pression', NULL,
'Reportez aux périodes 6 ou 7 pour de meilleurs résultats.',
'Ce n''est pas le moment de conclure. La patience protège vos intérêts.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3, 'L''énergie de transformation peut débloquer des situations figées.',
'Période ambivalente. Les négociations bloquées depuis longtemps peuvent soudain se débloquer grâce à un changement inattendu de circonstances. Mais les accords conclus dans l''urgence transformatrice peuvent manquer de solidité.',
'Profitez d''une ouverture si elle se présente, Mais vérifiez les termes avec soin', NULL, 'Ne vous précipitez pas sous prétexte que la fenêtre d''opportunité est courte', NULL, NULL,
'Les meilleures opportunités se reconnaissent à leur parfum d''imprévu.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4, 'L''énergie de bilan permet de finaliser les accords en suspens.',
'Bonne période pour conclure des négociations qui traînent. L''énergie de clôture pousse les parties à trouver un accord avant la fin du cycle. Les dernières concessions sont plus faciles à obtenir.',
'Fixez un ultimatum raisonnable, Proposez une dernière offre engageante', NULL, 'N''acceptez pas n''importe quoi juste pour en finir', NULL, NULL,
'Savoir conclure est un art. Finissez fort.' FROM cycle_vie_decision_types dt WHERE dt.code = 'negociation_accord';

-- ─── TYPE: campagne_pub (7 périodes) ────────────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 5, 'L''énergie d''initiative propulse vos messages vers un large public.',
'Période exceptionnelle pour lancer une campagne. L''énergie de nouveau départ amplifie l''impact de vos messages. Votre créativité publicitaire est à son comble.',
'Lancez votre campagne dès maintenant, Misez sur l''originalité et l''impact visuel, Ciblez votre audience avec précision', NULL, NULL, 'Les lancements en début de semaine captent plus d''attention.', NULL,
'Frappez fort maintenant, les astres portent votre voix.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 4, 'L''énergie de construction favorise les campagnes méthodiques et structurées.',
'Bonne période pour les campagnes à long terme et les stratégies marketing élaborées. Les contenus pédagogiques et informatifs performent mieux que les contenus purement émotionnels.',
'Structurez votre planning de publication, Investissez dans du contenu de qualité durable', NULL, 'Ne négligez pas la cohérence de votre message', NULL, NULL,
'La régularité est la mère du succès publicitaire.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 5, 'L''énergie de communication est en parfaite harmonie avec le marketing. Alignement idéal.',
'Période idéale pour toute communication commerciale. Vos messages sont percutants, votre créativité rédactionnelle est à son apogée. Les réseaux sociaux répondent particulièrement bien.',
'Publiez vos meilleurs contenus, Engagez la conversation avec votre audience, Testez de nouveaux canaux de communication', NULL, NULL, NULL, NULL,
'Quand les mots sont justes, le message porte loin.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 3, 'L''énergie d''équilibre favorise la fidélisation plutôt que la conquête.',
'Période modérée pour les nouvelles campagnes. Mieux adaptée à la communication de fidélisation qu''à la conquête de nouveaux clients. Les messages rassurants et familiaux performent bien.',
'Concentrez-vous sur vos clients existants, Envoyez des newsletters de fidélisation', NULL, 'Ne dépensez pas trop en acquisition de nouveaux clients', NULL, NULL,
'Fidéliser un client coûte moins cher que d''en conquérir un nouveau.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2, 'L''énergie de réflexion réduit la réceptivité du public à vos messages.',
'Période défavorable pour les lancements de campagne. Le public est moins réceptif et plus critique. Les taux de conversion sont naturellement plus bas.',
'Analysez les performances de vos campagnes passées, Préparez du contenu pour plus tard', 'Budget publicitaire risque d''être mal investi pendant cette période.', 'Ne lancez pas une grande campagne payante', NULL,
'Attendez la période 1 ou 3 pour un meilleur retour sur investissement.',
'Parfois le silence est plus puissant que le bruit.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 4, 'L''énergie de transformation favorise les campagnes audacieuses et disruptives.',
'Période favorable pour les communications qui bousculent les codes. Les campagnes virales et provocatrices ont plus de chances de décoller. Le buzz est possible.',
'Osez l''originalité, Misez sur le storytelling émotionnel, Testez des formats innovants', 'Le buzz peut être positif ou négatif — maîtrisez votre message.', NULL, NULL, NULL,
'L''audace est souvent récompensée en marketing.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 3, 'L''énergie de bilan invite au bilan marketing plutôt qu''au lancement.',
'Période favorable pour analyser vos résultats et préparer la prochaine campagne. Moins propice au lancement, mais idéale pour optimiser et ajuster.',
'Analysez vos KPIs, Identifiez ce qui a fonctionné, Préparez le prochain cycle', NULL, 'Ne lancez pas une nouvelle campagne majeure', NULL, NULL,
'Le meilleur stratège est celui qui apprend de chaque bataille.' FROM cycle_vie_decision_types dt WHERE dt.code = 'campagne_pub';

-- ─── TYPE: vente_bien (7 périodes) ──────────────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4, 'L''énergie d''initiative attire des acheteurs dynamiques et décidés.',
'Bonne période pour mettre en vente. Les acheteurs potentiels sont dans un état d''esprit favorable aux nouvelles acquisitions. Votre bien attire l''attention.',
'Publiez vos annonces, Faites visiter votre bien, Mettez en valeur ses points forts', NULL, 'Ne bradez pas, restez ferme sur votre prix', NULL, NULL,
'Le bon moment pour vendre est quand les acheteurs sont prêts à acheter.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5, 'L''énergie de construction favorise les transactions solides et bien négociées.',
'Excellente période pour conclure une vente. Les acheteurs sont sérieux et les négociations aboutissent à des accords équitables. Le prix obtenu sera juste.',
'Acceptez les offres raisonnables, Finalisez les formalités administratives', NULL, NULL, NULL, NULL,
'Une vente réussie est celle où vendeur et acheteur sont satisfaits.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 4, 'L''énergie de communication facilite les négociations commerciales.',
'Période favorable à la négociation du prix. Votre capacité à convaincre est renforcée. Bon moment pour contrer les offres trop basses avec des arguments solides.',
'Préparez vos arguments de vente, Mettez en avant les atouts uniques de votre bien', 'Attention aux acheteurs trop insistants.', NULL, NULL, NULL,
'Celui qui vend bien est celui qui sait présenter la valeur de ce qu''il offre.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4, 'L''énergie d''équilibre favorise les transactions justes et équilibrées.',
'Bonne période pour une vente au juste prix. Les transactions sont harmonieuses. Les biens immobiliers et familiaux se vendent particulièrement bien.',
'Fixez un prix juste basé sur le marché, Soyez transparent sur l''état du bien', NULL, 'Ne surévaluez pas votre bien sous prétexte d''attachement sentimental', NULL, NULL,
'La vérité est la meilleure stratégie de vente.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 2, 'L''énergie de réflexion décourage les acheteurs et ralentit les transactions.',
'Période défavorable pour vendre. Les acheteurs potentiels hésitent, négocient trop à la baisse, ou reportent leur décision. Les ventes conclues maintenant se font souvent à des prix inférieurs.',
'Maintenez la visibilité de vos annonces, Mais ne baissez pas votre prix sous la pression', 'Risque de vendre en dessous de la valeur réelle.', 'Ne cédez pas au découragement', NULL,
'Attendez la période 1 ou 2 du prochain cycle pour relancer la vente.',
'La patience est une vertu lucrative en matière de vente.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 3, 'L''énergie de transformation peut provoquer des ventes rapides mais inhabituelles.',
'Période ambivalente. Une vente urgente ou liée à un changement de vie peut aboutir rapidement. Les conditions peuvent être inhabituelles mais acceptables.',
'Soyez ouvert aux propositions atypiques, Considérez les échanges ou les conditions particulières', NULL, 'Ne vendez pas par désespoir', NULL, NULL,
'Les circonstances inhabituelles mènent parfois aux meilleures transactions.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4, 'L''énergie de bilan favorise la conclusion des ventes en cours.',
'Bonne période pour finaliser une vente en négociation. Les parties sont enclines à conclure avant la fin du cycle. Les derniers ajustements se font facilement.',
'Proposez une offre finale attractive, Fixez une date de clôture', NULL, 'N''entamez pas de nouvelle mise en vente', NULL, NULL,
'Conclure avec élégance est la marque des grands commerçants.' FROM cycle_vie_decision_types dt WHERE dt.code = 'vente_bien';

-- ─── TYPE: inscription_formation (7 périodes) ───────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 5, 'L''énergie d''initiative est parfaitement alignée avec le début d''un parcours éducatif.',
'Période exceptionnelle pour s''inscrire à une formation ou une école. L''élan d''apprentissage est naturel et votre motivation sera durable. Les premières impressions seront excellentes.',
'Finalisez votre inscription, Préparez vos documents, Contactez l''établissement', NULL, NULL, NULL, NULL,
'Apprendre est le plus bel investissement que vous puissiez faire en vous-même.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 5, 'L''énergie de construction soutient les apprentissages structurés et méthodiques.',
'Excellente période pour les formations longues et les programmes structurés. Votre capacité à assimiler et organiser les connaissances est renforcée.',
'Inscrivez-vous aux formations certifiantes, Choisissez des programmes reconnus', NULL, NULL, NULL, NULL,
'Les fondations solides d''aujourd''hui forment l''expertise de demain.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 5, 'L''énergie de communication et d''intellect est en parfaite harmonie avec l''apprentissage.',
'Période idéale pour tout ce qui touche à l''éducation et à la formation. Votre esprit est vif et réceptif. Les cours, les examens et les inscriptions sont tous favorisés.',
'Inscrivez-vous sans hésiter, Explorez de nouveaux domaines, Participez activement aux discussions', NULL, NULL, NULL, NULL,
'L''esprit qui apprend ne vieillit jamais.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4, 'L''énergie d''équilibre favorise les formations en rapport avec la vie domestique ou familiale.',
'Bonne période pour les formations pratiques et utiles au quotidien. Les cursus en lien avec la famille, la santé ou le bien-être sont particulièrement favorisés.',
'Choisissez des formations qui amélioreront concrètement votre quotidien', NULL, 'Ne vous inscrivez pas par obligation', NULL, NULL,
'Le savoir pratique est celui qui change véritablement votre vie.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 3, 'L''énergie de réflexion favorise l''introspection éducative.',
'Période favorable pour réfléchir à vos besoins de formation mais moins pour s''inscrire concrètement. Bon moment pour évaluer les options et comparer les programmes.',
'Recherchez les formations disponibles, Lisez les avis d''anciens étudiants', 'Ne vous inscrivez pas sous l''effet d''une impulsion.', NULL, NULL,
'Attendez la période 1 ou 3 pour finaliser votre inscription.',
'Réfléchir avant d''agir n''est pas de l''hésitation, c''est de la sagesse.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 4, 'L''énergie de transformation favorise les reconversions et les changements de cap éducatif.',
'Période favorable pour les inscriptions liées à une reconversion professionnelle. Si vous changez de carrière, cette énergie soutient votre transformation.',
'Inscrivez-vous si c''est un changement de cap, Osez une discipline totalement nouvelle', NULL, NULL, NULL, NULL,
'Le courage de recommencer est la plus grande forme d''intelligence.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 3, 'L''énergie de bilan invite à évaluer vos compétences actuelles.',
'Période de bilan éducatif. Évaluez ce que vous savez et ce qu''il vous reste à apprendre. Bonne période pour les évaluations de compétences, moins pour les nouvelles inscriptions.',
'Faites un bilan de compétences, Identifiez vos lacunes', NULL, 'Ne vous inscrivez pas à trop de formations à la fois', NULL,
'La période 1 du prochain cycle sera idéale pour démarrer un nouveau parcours.',
'Connaître ses limites est le premier pas vers leur dépassement.' FROM cycle_vie_decision_types dt WHERE dt.code = 'inscription_formation';

-- ─── TYPE: pelerinage_retraite (7 périodes) ─────────────

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 1, 4, 'L''énergie d''initiative soutient les départs spirituels et les quêtes intérieures.',
'Bonne période pour entamer un voyage spirituel. L''élan de renouveau apporte une motivation profonde et un sens clair à votre quête. Les pèlerinages commencés maintenant portent une énergie de révélation.',
'Préparez votre itinéraire avec intention, Définissez votre objectif spirituel, Partez avec un cœur ouvert', NULL, 'Ne partez pas sans une intention claire', NULL, NULL,
'Le voyage le plus long commence par un premier pas conscient.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 2, 4, 'L''énergie de construction apporte discipline et structure à votre pratique spirituelle.',
'Période favorable pour les retraites structurées. Les programmes avec un cadre défini (horaires de méditation, enseignements) sont particulièrement bénéfiques. Votre discipline intérieure est renforcée.',
'Inscrivez-vous à une retraite organisée, Suivez un programme structuré', NULL, 'Ne négligez pas la préparation matérielle du voyage', NULL, NULL,
'La discipline spirituelle est le chemin vers la liberté intérieure.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 3, 3, 'L''énergie de communication peut disperser la concentration spirituelle.',
'Période modérée pour les retraites spirituelles. L''énergie mentale est forte mais peut créer du « bruit intérieur » qui gêne la méditation. Les échanges avec un guide spirituel sont cependant très fructueux.',
'Échangez avec un maître ou un guide, Lisez des textes sacrés, Mais limitez les distractions sociales', 'L''agitation mentale peut perturber votre recueillement.', NULL, NULL, NULL,
'L''esprit agité est comme un lac troublé — attendez qu''il se calme pour y voir clair.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 4, 4, 'L''énergie d''équilibre apporte la paix intérieure nécessaire à toute pratique spirituelle.',
'Bonne période pour les retraites de méditation et les pèlerinages contemplatifs. L''harmonie entre le corps et l''esprit est naturelle. Les lieux saints vous accueilleront avec une douceur particulière.',
'Méditez dans la nature, Visitez des lieux sacrés, Pratiquez la gratitude', NULL, NULL, 'Les moments d''aube et de crépuscule sont les plus propices à la prière.', NULL,
'La paix intérieure est le plus grand des trésors.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 5, 5, 'L''énergie de réflexion est en parfaite harmonie avec la quête spirituelle. Alignement rare.',
'Période exceptionnellement favorable pour toute retraite spirituelle. L''introspection naturelle de cette période amplifie les bienfaits de la méditation et de la prière. Les révélations intérieures sont possibles.',
'Isolez-vous du monde matériel, Pratiquez le silence, Méditez profondément, Jeûnez si votre tradition le permet', NULL, NULL, NULL, NULL,
'Dans le silence, l''âme parle et Dieu répond.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 6, 4, 'L''énergie de transformation favorise les expériences spirituelles profondes et les conversions.',
'Période favorable pour les voyages spirituels transformateurs. Si vous cherchez un changement profond dans votre vie spirituelle — une conversion, un engagement, un renouveau de foi — les énergies vous soutiennent.',
'Engagez-vous dans une pratique nouvelle, Acceptez les changements intérieurs, Laissez mourir ce qui doit mourir en vous', NULL, 'Ne forcez pas une transformation qui n''est pas prête', NULL, NULL,
'La transformation spirituelle est la plus haute forme de renaissance.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, cosmic_context, advice_text, recommended_actions, warnings, pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message)
SELECT dt.id, 'personal', 7, 4, 'L''énergie de bilan spirituel clôture un cycle de croissance.',
'Bonne période pour un pèlerinage de gratitude ou une retraite de bilan. L''heure est au remerciement, au pardon et à la préparation du prochain cycle spirituel.',
'Faites un bilan de votre chemin spirituel, Remerciez pour les leçons reçues, Pardonnez à ceux qui vous ont blessé', NULL, NULL, NULL, NULL,
'La gratitude est la prière la plus puissante. Remerciez et avancez avec confiance.' FROM cycle_vie_decision_types dt WHERE dt.code = 'pelerinage_retraite';

-- ─── VÉRIFICATION FINALE ────────────────────────────────

-- Nombre total de conseils attendu : 140 + 56 = 196
SELECT 'Nombre total de conseils' as label, COUNT(*) as total FROM cycle_vie_decision_advice;

-- Couverture par type
SELECT dt.label, dt.code, dt.is_active,
       COUNT(da.id) as nb_conseils,
       string_agg(DISTINCT da.period_number::text, ', ' ORDER BY da.period_number::text) as periods
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice da ON da.decision_type_id = dt.id
GROUP BY dt.label, dt.code, dt.is_active, dt.display_order
ORDER BY dt.display_order;
-- Attendu : 28 types, chacun avec 7 conseils (sauf 'proces' qui a 7 mais is_active=false)
