-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 2B: FINANCE (suite)
-- Demande Financement, Recherche Argent, Investissement
-- =============================================

-- =============================================
-- DEMANDE DE FINANCEMENT - 7 périodes
-- =============================================

-- Période 1
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
'Les vibrations cosmiques insufflent une énergie d''initiative et de nouveau départ. Cette phase stimule l''action et la prise de contact. Votre dynamisme naturel impressionne les interlocuteurs.',

'Votre configuration énergétique actuelle crée des conditions favorables pour initier des démarches de financement. L''énergie d''initiative qui vous traverse vous donne l''assurance nécessaire pour présenter votre dossier avec conviction.

Les premiers contacts avec les établissements financiers seront naturellement dynamiques. Votre enthousiasme et votre motivation transparaissent et peuvent jouer en votre faveur auprès des conseillers.

Cependant, cette période est plus favorable aux premières démarches qu''aux signatures définitives. Utilisez cet élan pour solliciter plusieurs établissements, comparer les offres et constituer un panorama complet des possibilités.',

'• Sollicitez plusieurs établissements financiers
• Présentez votre projet avec conviction et clarté
• Constituez un dossier complet et professionnel
• Comparez les propositions reçues
• Négociez les conditions préliminaires
• Montrez votre motivation et votre sérieux',

'L''enthousiasme peut vous faire accepter trop rapidement la première offre. Ne signez pas sans comparaison approfondie.',

'• Accepter la première proposition sans comparer
• Négliger de lire les conditions détaillées
• Sous-estimer le coût total du crédit',

'Le début de cette phase est idéal pour les premiers contacts.',

'La deuxième phase sera parfaite pour signer dans les meilleures conditions.',

'Votre détermination ouvre les portes. Présentez votre projet avec assurance.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 2
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les courants cosmiques vous enveloppent dans une énergie de construction et de solidité. Cette phase inspire confiance et favorise les accords financiers durables. Votre sérieux est perçu et apprécié.',

'Cette période est exceptionnellement favorable pour obtenir un financement. Les énergies de construction qui vous animent créent une impression de solidité et de fiabilité qui rassure les prêteurs.

Votre dossier sera examiné sous un angle favorable. Les établissements financiers perçoivent votre stabilité et votre capacité à honorer vos engagements. Cette période maximise vos chances d''obtenir une réponse positive.

C''est le moment idéal pour signer votre contrat de prêt. Les accords conclus maintenant correspondent généralement à des conditions équilibrées et à des engagements que vous pourrez tenir sereinement.',

'• Finalisez la constitution de votre dossier
• Présentez votre demande aux établissements présélectionnés
• Négociez les taux et les conditions avec fermeté
• Comparez les offres définitives
• Signez le contrat de financement le plus favorable
• Vérifiez toutes les clauses avant signature',

'Même dans cette période favorable, lisez attentivement toutes les conditions. La confiance n''exclut pas la vigilance.',

'• Signer sans lecture complète du contrat
• Négliger les frais annexes et les assurances
• S''engager au-delà de votre capacité réelle de remboursement',

'L''intégralité de cette phase est favorable aux accords de financement.',

'Cette période est idéale. Profitez pleinement de cette fenêtre.',

'Les fondations solides soutiennent les projets durables. Construisez avec confiance.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 3
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies cosmiques amplifient vos capacités de persuasion et de négociation. Cette phase de communication favorise les échanges productifs avec les institutions financières.',

'Votre cycle traverse une phase où votre pouvoir de persuasion atteint son expression optimale. C''est le moment idéal pour négocier les conditions de votre financement et obtenir des améliorations significatives.

Les échanges avec les conseillers bancaires seront fluides et productifs. Votre éloquence vous permet de présenter votre situation sous le meilleur jour et de contre-argumenter efficacement les objections.

Profitez de cette période pour faire jouer la concurrence entre établissements. Votre communication convaincante peut vous valoir des taux plus bas, des frais réduits ou des conditions plus souples.',

'• Négociez activement les taux d''intérêt
• Demandez des réductions sur les frais de dossier
• Comparez les offres de plusieurs établissements
• Utilisez les propositions concurrentes comme levier
• Présentez votre projet avec clarté et conviction
• Sollicitez des conditions personnalisées',

'L''excès de confiance peut vous faire promettre plus que vous ne pouvez tenir. Restez réaliste dans vos engagements.',

'• Surestimer vos capacités de remboursement pour impressionner
• Omettre des informations importantes dans votre dossier
• Négliger de formaliser les accords oraux par écrit',

'Les moments d''échange en milieu de journée sont les plus propices.',

'Cette période est très favorable. Saisissez l''opportunité de négocier.',

'Votre parole porte une force de conviction remarquable. Utilisez-la avec sagesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 4
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 4,
'Les vibrations cosmiques vous baignent dans une harmonie favorable aux accords équilibrés. Cette phase favorise les arrangements justes pour toutes les parties.',

'Cette période offre des conditions favorables pour finaliser un accord de financement équilibré. Les énergies d''équilibre vous guident vers des engagements que vous pourrez honorer sereinement.

Votre capacité à évaluer le juste montant à emprunter est optimale. Vous percevrez naturellement si les mensualités correspondent à vos moyens réels sans sacrifier votre qualité de vie.

Les accords conclus maintenant tendent à être satisfaisants pour toutes les parties : des conditions correctes pour vous, une sécurité pour le prêteur. Cet équilibre favorise une relation durable et sereine.',

'• Évaluez objectivement votre capacité de remboursement
• Choisissez des mensualités adaptées à votre budget
• Finalisez l''accord dans un esprit d''équilibre
• Vérifiez que le prêt ne déséquilibre pas votre vie
• Signez avec sérénité et confiance
• Prévoyez une marge de sécurité dans votre budget',

'L''équilibre ne signifie pas accepter le minimum. Négociez toujours pour de meilleures conditions.',

'• Accepter des conditions défavorables par souci de ne pas déranger
• Sous-évaluer vos besoins réels pour minimiser l''emprunt
• Ignorer les imprévus possibles dans votre budget',

'L''intégralité de cette phase est favorable aux accords équilibrés.',

'Cette période est très favorable pour les signatures.',

'L''équilibre financier est la base de la sérénité. Construisez-le avec sagesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 5
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les courants cosmiques vous invitent à l''introspection. Cette phase de réflexion n''est pas propice aux engagements financiers majeurs. Les doutes peuvent fausser votre jugement.',

'Votre cycle traverse une phase contemplative qui n''est pas recommandée pour souscrire un financement. Les énergies de réflexion peuvent générer des doutes paralysants ou des engagements regrettés ultérieurement.

Cette période est cependant précieuse pour analyser en profondeur votre situation financière. Avez-vous vraiment besoin de ce financement ? Le montant est-il approprié ? Les conditions sont-elles les meilleures possibles ?

Si vous avez une offre en main, accordez-vous un délai de réflexion supplémentaire. Les doutes qui surgissent peuvent être des signaux importants à ne pas ignorer.',

'• Analysez en profondeur votre situation financière
• Questionnez la nécessité réelle du financement
• Étudiez les alternatives à l''emprunt
• Affinez vos calculs de capacité de remboursement
• Si doutes persistants : reportez la signature
• Consultez un conseiller indépendant',

'Les engagements pris dans cette période peuvent être sources de regrets. Écoutez vos doutes.',

'• Signer un contrat de prêt dans un moment d''incertitude
• Ignorer les signaux de malaise
• Se laisser presser par les délais imposés',

'Les moments de calme favorisent l''analyse. Évitez les décisions sous pression.',

'La deuxième ou quatrième phase du prochain cycle sera bien plus favorable.',

'La réflexion précède l''action éclairée. Honorez ce temps de préparation.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 6
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 2,
'Les énergies cosmiques portent une vibration d''instabilité transformatrice. Cette phase n''est pas favorable aux engagements financiers à long terme.',

'Votre cycle traverse une phase de transformation qui n''est pas recommandée pour souscrire un financement. L''instabilité de cette période peut affecter votre situation future de manière imprévisible.

Les engagements pris maintenant risquent de ne plus correspondre à votre situation une fois la transformation achevée. Un crédit souscrit dans la turbulence peut devenir un fardeau une fois le calme revenu.

Si le financement est absolument nécessaire, optez pour les formules les plus flexibles : durées courtes, possibilités de remboursement anticipé sans pénalités.',

'• Évaluez si le financement peut attendre
• Si indispensable : choisissez des conditions flexibles
• Prévoyez des options de sortie anticipée
• Ne vous engagez pas sur de très longues durées
• Anticipez les changements possibles de situation
• Consultez un conseiller avant de signer',

'Cette période peut amplifier les décisions regrettables. Un crédit est un engagement à long terme.',

'• Souscrire un crédit important dans une période instable
• S''engager sur de longues durées sans flexibilité
• Ignorer les possibles changements de situation',

'Les moments de relative stabilité sont à privilégier si décision inévitable.',

'La septième phase puis le prochain cycle offriront plus de stabilité.',

'Les transitions demandent prudence. Vos engagements doivent résister aux changements.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';

-- Période 7
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les vibrations cosmiques portent l''énergie de conclusion. Cette phase peut convenir pour finaliser un dossier déjà avancé, moins pour initier de nouvelles démarches.',

'Votre cycle approche de son accomplissement, créant une énergie mitigée pour les demandes de financement. Cette phase est adaptée pour conclure un dossier préparé de longue date, pas pour démarrer un nouveau processus.

Si votre demande est en cours et que l''accord est imminent, l''énergie de conclusion peut aider à finaliser. Les dernières formalités peuvent être accomplies favorablement.

En revanche, initier une nouvelle demande n''est pas recommandé. L''énergie de fin de cycle ne favorise pas les nouveaux départs financiers.',

'• Finalisez les dossiers déjà en cours
• Signez les accords qui attendent votre décision
• Terminez les formalités nécessaires
• Si nouveau projet : préparez pour le prochain cycle
• Ne démarrez pas de nouvelles démarches
• Clôturez ce chapitre de recherche de financement',

'Ne forcez pas une conclusion si les conditions ne vous conviennent pas pleinement.',

'• Signer par fatigue de négocier
• Accepter des conditions défavorables pour en finir
• Démarrer un nouveau processus qui s''éternisera',

'Le début de cette phase est plus favorable aux conclusions.',

'Le prochain cycle offrira de meilleures conditions pour de nouvelles demandes.',

'Chaque fin prépare un nouveau commencement. Patientez avec sagesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_financement';


-- =============================================
-- RECHERCHE D'ARGENT - 7 périodes  
-- =============================================

-- Période 1
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les vibrations cosmiques insufflent une énergie d''initiative et de nouveau départ. Cette phase stimule l''action et la recherche active. Votre dynamisme ouvre des portes.',

'Cette période est particulièrement favorable pour entreprendre des démarches visant à obtenir de l''argent. L''énergie d''initiative qui vous traverse vous donne l''audace nécessaire pour solliciter, négocier et demander.

Que vous cherchiez une augmentation de salaire, des investisseurs pour votre projet, ou simplement à récupérer de l''argent qui vous est dû, les énergies actuelles soutiennent vos démarches. Votre détermination et votre assurance impressionnent favorablement.

C''est le moment idéal pour prendre contact, présenter vos demandes et ouvrir des négociations. L''élan de cette période peut déclencher des opportunités inattendues.',

'• Sollicitez les personnes ou institutions concernées
• Présentez vos demandes avec assurance
• Négociez les termes avec conviction
• Explorez plusieurs pistes simultanément
• Montrez votre valeur et vos mérites
• Saisissez les opportunités qui se présentent',

'L''énergie d''initiative peut vous faire demander plus que raisonnable. Calibrez vos demandes intelligemment.',

'• Demander des montants irréalistes
• Brûler les ponts par excès d''audace
• Négliger de préparer vos arguments',

'Le début de cette phase est particulièrement dynamique pour les premières démarches.',

'Cette période est très favorable. N''hésitez pas à agir.',

'L''audace ouvre les portes de l''abondance. Osez demander ce que vous méritez.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

-- Période 2
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les courants cosmiques vous enveloppent dans une énergie de construction. Cette phase favorise les approches méthodiques et les résultats durables.',

'Cette période offre des conditions favorables pour structurer votre recherche d''argent de manière méthodique. Les énergies de construction vous aident à bâtir des dossiers solides et convaincants.

C''est le moment d''élaborer une stratégie claire : quelles sources solliciter, quels arguments présenter, quelles conditions proposer. Votre approche organisée inspire confiance et sérieux.

Les résultats obtenus pendant cette phase tendent à être durables. Les accords conclus créent des situations stables et satisfaisantes.',

'• Structurez votre stratégie de recherche
• Préparez des dossiers professionnels et complets
• Documentez vos demandes avec des preuves concrètes
• Suivez méthodiquement chaque piste
• Construisez des arguments solides
• Finalisez les accords en cours',

'La méthode ne doit pas devenir rigidité. Restez ouvert aux opportunités imprévues.',

'• Se perdre dans la préparation au détriment de l''action
• Refuser les approches non conventionnelles
• Négliger les opportunités informelles',

'L''intégralité de cette phase favorise les approches structurées.',

'La troisième phase amplifiera vos capacités de négociation.',

'Les fondations solides soutiennent l''abondance durable.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

-- Période 3
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies cosmiques amplifient vos capacités de persuasion et de réseautage. Cette phase de communication ouvre de nombreuses portes.',

'Votre cycle traverse une phase exceptionnellement favorable pour la recherche d''argent à travers les relations et la communication. Vos capacités de persuasion et votre charisme social sont à leur apogée.

Les négociations salariales, les levées de fonds, les demandes de prêts familiaux ou les récupérations de créances : toutes ces démarches bénéficient de votre éloquence naturelle.

C''est le moment idéal pour activer votre réseau, solliciter des contacts, et présenter vos besoins. Les portes s''ouvrent facilement devant votre capacité à communiquer.',

'• Activez votre réseau de contacts
• Négociez avec éloquence et conviction
• Présentez vos demandes de manière claire
• Multipliez les sollicitations
• Utilisez les recommandations et introductions
• Participez aux événements de réseautage',

'L''abondance des contacts peut disperser vos efforts. Restez concentré sur vos priorités.',

'• Se disperser entre trop de pistes
• Promettre plus que vous ne pouvez offrir
• Négliger de donner suite aux contacts établis',

'Les moments d''échange social sont les plus propices.',

'Cette période est excellente. Maximisez vos interactions.',

'Votre parole attire l''abondance. Parlez de vos besoins sans honte.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

-- Périodes 4-7 pour recherche_argent (condensées)
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 3,
'Les vibrations cosmiques favorisent l''équilibre. Cette phase est moins dynamique pour la recherche active mais propice aux arrangements harmonieux.',

'Cette période favorise les arrangements équilibrés plutôt que les gains maximaux. Si vous cherchez un accord juste qui satisfait toutes les parties, les énergies actuelles le soutiennent. Pour une recherche agressive de revenus, l''énergie est moins porteuse.',

'• Recherchez des arrangements équilibrés\n• Privilégiez la durabilité sur le gain immédiat\n• Consolidez les acquis plutôt que de chercher plus',

'L''équilibre peut limiter les gains potentiels. Évaluez vos priorités.',

'• Accepter moins que votre valeur par souci d''harmonie\n• Renoncer à des opportunités légitimes',

'Cette phase convient aux arrangements harmonieux.',

'La première phase du prochain cycle sera plus dynamique.',

'L''équilibre financier est une forme de richesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les courants cosmiques invitent à la réflexion. Cette phase de doute n''est pas propice aux demandes d''argent.',

'Votre cycle traverse une phase contemplative défavorable à la recherche active d''argent. Les doutes peuvent miner votre assurance et affaiblir vos demandes. Attendez une période plus dynamique.',

'• Analysez votre situation financière\n• Préparez vos futures démarches\n• Réfléchissez à vos stratégies',

'Le manque de confiance transparaît. Reportez les demandes importantes.',

'• Solliciter dans un état de doute\n• Accepter des conditions défavorables par manque d''assurance',

'Évitez les démarches importantes dans cette période.',

'La première phase du prochain cycle sera beaucoup plus favorable.',

'La réflexion prépare l''action éclairée.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation peuvent créer des opportunités inattendues mais aussi de l''instabilité.',

'Cette période peut générer des opportunités financières liées à des changements majeurs : prime de départ, héritage, opportunité de reconversion. L''argent lié aux transformations de vie est favorisé. Les recherches conventionnelles le sont moins.',

'• Soyez ouvert aux opportunités liées au changement\n• Évaluez les propositions inhabituelles\n• Distinguez opportunité de piège',

'L''instabilité peut mener à des décisions précipitées.',

'• Accepter impulsivement des propositions risquées\n• Confondre changement et opportunité',

'Les opportunités de transformation peuvent surgir à tout moment.',

'La septième phase apportera plus de stabilité.',

'Les transformations portent parfois des trésors cachés.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations de conclusion favorisent la récolte des efforts passés.',

'Cette période est favorable pour récolter les fruits des efforts passés : bonus de fin d''année, commissions, héritages attendus, remboursements. Moins favorable pour initier de nouvelles recherches, elle convient pour recevoir ce qui est dû.',

'• Finalisez les demandes en cours\n• Réclamez ce qui vous est dû\n• Récoltez les résultats de vos efforts\n• Préparez le prochain cycle',

'Ne forcez pas de nouvelles démarches qui s''éterniseront.',

'• Démarrer de nouvelles recherches complexes\n• Forcer des résultats qui ne viennent pas',

'Cette phase convient aux conclusions et finalisations.',

'Le prochain cycle offrira un élan neuf pour de nouvelles recherches.',

'Récoltez ce que vous avez semé avec gratitude.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'recherche_argent';


-- =============================================
-- INVESTISSEMENT - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 3,
'Les vibrations d''initiative peuvent pousser à l''impulsivité. Cette énergie convient aux recherches mais pas aux engagements financiers majeurs.',

'L''investissement demande réflexion. Cette période dynamique est excellente pour explorer les opportunités, étudier les marchés et solliciter des conseils. Évitez cependant de placer des sommes importantes sous l''impulsion du moment. Préparez maintenant, investissez plus tard.',

'• Explorez les opportunités d''investissement\n• Sollicitez des conseils professionnels\n• Étudiez les marchés et les options\n• Constituez votre stratégie',

'L''enthousiasme peut mener à des placements impulsifs regrettables.',

'• Investir impulsivement\n• Négliger la due diligence\n• Se fier aux promesses de gains rapides',

'Cette phase convient à la recherche et l''exploration.',

'La deuxième ou quatrième phase sera plus favorable aux placements.',

'La préparation précède le succès.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction favorisent les placements durables et les stratégies à long terme.',

'Cette période est exceptionnellement favorable pour les investissements à long terme. Les énergies de construction vous guident vers des placements solides et durables. Votre discernement est aiguisé pour distinguer les opportunités réelles des mirages.',

'• Finalisez vos décisions d''investissement mûries\n• Privilégiez les placements à long terme\n• Choisissez des actifs de qualité\n• Diversifiez intelligemment votre portefeuille',

'Même favorisée, cette période exige la due diligence habituelle.',

'• Investir sans analyse approfondie\n• Mettre tous ses œufs dans le même panier\n• Ignorer les risques par excès de confiance',

'L''intégralité de cette phase favorise les investissements durables.',

'Cette période est idéale. Profitez-en.',

'Les investissements réfléchis construisent l''avenir.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 3,
'Les énergies d''expansion favorisent la découverte mais peuvent disperser l''attention.',

'Cette période stimule l''exploration de nombreuses options d''investissement. Votre réseau peut vous apporter des opportunités intéressantes. Cependant, l''abondance de possibilités peut créer de la confusion. Collectez les informations maintenant, décidez plus tard.',

'• Explorez les opportunités via votre réseau\n• Collectez des informations sur diverses options\n• Évitez les décisions définitives\n• Comparez méthodiquement',

'L''excès d''options peut mener à de mauvais choix ou à l''immobilisme.',

'• Se disperser entre trop de possibilités\n• Investir sur un simple conseil informel\n• Négliger l''analyse au profit des relations',

'Cette phase convient à la collecte d''information.',

'La quatrième phase sera plus propice aux décisions.',

'L''abondance d''options est une richesse si bien gérée.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations d''équilibre favorisent les portefeuilles diversifiés et les stratégies équilibrées.',

'Cette période est très favorable pour les investissements équilibrés et diversifiés. Les énergies vous guident vers des choix mesurés qui répartissent intelligemment risques et opportunités. C''est le moment idéal pour construire ou rééquilibrer un portefeuille.',

'• Équilibrez votre portefeuille d''investissements\n• Diversifiez entre différentes classes d''actifs\n• Privilégiez les stratégies équilibrées\n• Finalisez vos décisions avec sérénité',

'L''équilibre ne doit pas devenir immobilisme face aux opportunités.',

'• Éviter tout risque par excès de prudence\n• Manquer des opportunités par souci d''équilibre parfait',

'L''intégralité de cette phase favorise les investissements équilibrés.',

'Cette période est très favorable.',

'L''équilibre est la clé de la croissance durable.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de réflexion génèrent des doutes qui peuvent fausser le jugement d''investissement.',

'Cette période n''est pas favorable aux décisions d''investissement. Les doutes et incertitudes caractéristiques de cette phase peuvent mener à des choix inadaptés ou à des occasions manquées par excès de prudence. Utilisez ce temps pour l''analyse et la recherche, pas pour l''action.',

'• Analysez votre portefeuille existant\n• Étudiez les performances passées\n• Réfléchissez à votre stratégie à long terme\n• Reportez les nouvelles décisions',

'Les investissements décidés dans le doute sont souvent regrettés.',

'• Investir dans un état d''incertitude\n• Vendre impulsivement par peur\n• Prendre des décisions sous pression',

'Évitez les décisions d''investissement majeures.',

'La deuxième phase du prochain cycle sera beaucoup plus favorable.',

'La patience est souvent la meilleure stratégie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 2,
'Les énergies de transformation créent de l''instabilité, défavorable aux investissements conventionnels.',

'Cette période d''instabilité n''est pas recommandée pour les investissements conventionnels. Les marchés peuvent sembler attractifs mais les choix faits dans la turbulence sont souvent regrettés. Les seules exceptions concernent les investissements liés à une transformation personnelle majeure.',

'• Protégez votre capital existant\n• Évitez les nouveaux engagements\n• Si transformation personnelle : investissez dans votre nouvelle vie\n• Attendez le retour de la stabilité',

'L''instabilité personnelle affecte le jugement financier.',

'• Investir des sommes importantes en période de turbulence\n• Réagir émotionnellement aux fluctuations de marché',

'Évitez les décisions d''investissement majeures.',

'La septième phase ou le prochain cycle sera plus stable.',

'Protéger son capital est parfois la meilleure stratégie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations de conclusion favorisent le bilan des investissements et la récolte des gains.',

'Cette période est favorable pour faire le bilan de vos investissements et récolter les gains mûrs. C''est le moment de prendre des profits sur les positions gagnantes, de clôturer les investissements qui ont atteint leurs objectifs. Moins favorable pour les nouveaux placements.',

'• Faites le bilan de votre portefeuille\n• Prenez les profits sur les positions gagnantes\n• Clôturez les investissements mûrs\n• Préparez votre stratégie pour le prochain cycle',

'Ne forcez pas de nouvelles positions qui devront mûrir longuement.',

'• Démarrer de nouveaux investissements à long terme\n• Ignorer les opportunités de prise de profit',

'Cette phase favorise la récolte et le bilan.',

'Le prochain cycle offrira de meilleures conditions pour les nouveaux placements.',

'Récoltez avec gratitude les fruits de votre patience.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement';


-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Conseils FINANCE (complet) insérés:' AS status;
SELECT dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category = 'finance'
GROUP BY dt.label
ORDER BY dt.label;
