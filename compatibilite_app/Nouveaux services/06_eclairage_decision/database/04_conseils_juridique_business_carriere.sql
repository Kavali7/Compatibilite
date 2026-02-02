-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 3: JURIDIQUE, BUSINESS, CARRIÈRE
-- Signature Contrat(7) + Lancement Business(7) + Partenariat(7) + Carrière(21)
-- =============================================

-- =============================================
-- SIGNATURE DE CONTRAT - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 3,
'Les vibrations d''initiative stimulent l''action mais pas la réflexion approfondie que les contrats exigent.',

'Un contrat est un engagement qui vous lie souvent pour longtemps. L''énergie d''initiative actuelle vous pousse à signer rapidement, mais cette impulsivité peut être défavorable. Utilisez cette période pour négocier les termes et préparer la signature, mais attendez une phase plus propice pour parapher définitivement.',

'• Négociez les termes du contrat avec énergie\n• Faites avancer les discussions préliminaires\n• Préparez votre dossier complet\n• Sollicitez un avis juridique',

'L''impulsivité peut vous faire négliger des clauses importantes.',

'• Signer le jour de la première lecture\n• Négliger les petites clauses\n• Se laisser presser par l''autre partie',

'Cette phase convient aux négociations, pas aux signatures.',

'La deuxième ou quatrième phase sera plus favorable.',

'La prudence protège vos intérêts à long terme.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction sont parfaitement alignées avec les engagements contractuels durables.',

'Cette période est exceptionnellement favorable pour signer des contrats importants. Les énergies de construction vous guident vers des accords solides et équilibrés. Votre attention aux détails est aiguisée, et vous percevrez les clauses problématiques.',

'• Finalisez la lecture complète du contrat\n• Vérifiez chaque clause avec attention\n• Signez avec confiance si tout est en ordre\n• Conservez des copies de tous les documents',

'Même dans cette période favorable, ne négligez aucune vérification.',

'• Signer sans lecture complète\n• Négliger les conditions de sortie\n• Ignorer les petits caractères',

'L''intégralité de cette phase favorise les signatures.',

'Cette période est idéale. Profitez-en.',

'Les engagements clairs construisent des relations durables.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies de communication sont idéales pour négocier les termes contractuels.',

'Votre pouvoir de négociation est optimal. C''est le moment de discuter les clauses, d''obtenir des modifications favorables et de clarifier les points ambigus. Les signatures peuvent être envisagées si les négociations ont abouti, mais privilégiez les dernières discussions.',

'• Négociez les dernières modifications\n• Clarifiez tous les points ambigus\n• Obtenez les garanties nécessaires\n• Préparez la signature définitive',

'L''éloquence peut vous faire sous-estimer les risques.',

'• Signer sur la base de promesses verbales\n• Négliger de formaliser les accords oraux\n• Accepter des termes flous',

'Cette phase convient aux négociations finales.',

'La quatrième phase sera parfaite pour signer.',

'Les mots clairs évitent les malentendus futurs.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations d''équilibre créent les conditions idéales pour des contrats justes et durables.',

'Cette période offre une fenêtre exceptionnelle pour signer des contrats équilibrés. Les énergies vous guident vers des accords où toutes les parties trouvent leur compte, créant des relations durables et harmonieuses.',

'• Finalisez et signez les contrats en suspens\n• Vérifiez l''équilibre des obligations\n• Signez dans un état d''esprit serein\n• Célébrez les accords conclus',

'Assurez-vous que l''équilibre ne masque pas des concessions excessives.',

'• Céder trop pour préserver l''harmonie\n• Ignorer des déséquilibres par souci de conclure',

'L''intégralité de cette phase est excellente pour signer.',

'Cette période est très favorable.',

'Les contrats équilibrés prospèrent dans la durée.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute sont défavorables aux engagements contractuels.',

'Cette période n''est pas recommandée pour signer des contrats. Les doutes caractéristiques de cette phase peuvent mener à des regrets. Utilisez ce temps pour relire, analyser et questionner, mais attendez pour signer.',

'• Analysez le contrat en profondeur\n• Listez vos questions et préoccupations\n• Consultez un expert si nécessaire\n• Reportez la signature',

'Les contrats signés dans le doute sont souvent regrettés.',

'• Signer dans un état d''incertitude\n• Ignorer vos intuitions négatives\n• Céder à la pression des délais',

'Évitez les signatures dans cette période.',

'La deuxième ou quatrième phase du prochain cycle sera plus favorable.',

'Le doute est parfois un allié. Écoutez-le.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 2,
'Les énergies de transformation sont défavorables aux engagements contractuels conventionnels.',

'Cette période d''instabilité n''est pas recommandée pour signer des contrats, sauf s''ils concernent une transformation de vie majeure (divorce, rupture de contrat, cession d''entreprise). Les engagements pris maintenant peuvent ne plus correspondre à votre situation future.',

'• Évitez les nouveaux engagements conventionnels\n• Si transformation en cours : les ruptures de contrat sont favorisées\n• Évaluez si ce contrat vous suivra après le changement',

'L''instabilité peut affecter votre jugement des clauses.',

'• S''engager longuement en période de turbulence\n• Ignorer l''évolution possible de votre situation',

'Évitez les signatures sauf pour les ruptures ou transitions.',

'La septième phase sera plus stable.',

'Les transitions demandent flexibilité, pas engagement rigide.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les énergies de conclusion favorisent la finalisation des contrats mûris depuis longtemps.',

'Cette période convient pour conclure des contrats négociés de longue date. L''énergie de bilan permet de finaliser ce qui était en suspens. Moins favorable pour initier de nouvelles négociations, elle est idéale pour les signatures qui closent un chapitre.',

'• Finalisez les contrats en négociation prolongée\n• Signez les accords mûris\n• Clôturez les dossiers en suspens\n• Préparez les prochaines négociations',

'Ne forcez pas des accords qui ne vous conviennent pas vraiment.',

'• Signer par fatigue de négocier\n• Démarrer de nouvelles négociations complexes',

'Le début de cette phase favorise les conclusions.',

'Le prochain cycle sera propice aux nouvelles négociations.',

'Chaque conclusion prépare un nouveau départ.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat';


-- =============================================
-- LANCEMENT BUSINESS - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les vibrations d''initiative sont parfaitement alignées avec les lancements d''entreprise et de projets.',

'Cette période est exceptionnellement favorable pour lancer une activité. L''énergie d''initiative qui vous traverse est la plus puissante de votre cycle pour les nouveaux départs entrepreneuriaux. Votre enthousiasme, votre audace et votre motivation sont à leur apogée.',

'• Lancez votre activité sans plus attendre\n• Communiquez avec énergie et enthousiasme\n• Prenez les premiers contacts clients\n• Officialisez votre entreprise\n• Montrez votre passion aux partenaires potentiels',

'L''enthousiasme ne remplace pas la préparation. Assurez-vous que les bases sont en place.',

'• Se lancer sans structure préalable\n• Négliger les aspects administratifs et légaux\n• Promettre plus qu''on ne peut délivrer',

'Le début de cette phase est le plus dynamique pour les lancements.',

'Cette période est idéale. C''est LE moment de lancer.',

'Les grands projets naissent de l''audace. Osez commencer.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les énergies de construction favorisent la structuration d''une nouvelle activité.',

'Cette période est très favorable pour structurer un lancement. Les énergies vous aident à poser des fondations solides : processus, organisation, structure juridique, systèmes de gestion. Un lancement effectué maintenant sera bien ancré.',

'• Structurez votre organisation\n• Mettez en place vos processus\n• Formalisez les aspects légaux et administratifs\n• Créez des bases solides pour la croissance',

'La structure ne doit pas devenir rigidité. Gardez de la flexibilité.',

'• Se perdre dans la préparation sans jamais lancer\n• Créer des structures trop complexes pour le démarrage\n• Retarder indéfiniment par perfectionnisme',

'L''intégralité de cette phase favorise les fondations solides.',

'Cette période est très favorable pour les lancements structurés.',

'Les fondations solides soutiennent la croissance durable.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication amplifient la visibilité et le marketing de lancement.',

'Cette période est excellente pour le marketing et la communication de lancement. Votre charisme et votre éloquence sont à leur apogée, ce qui maximise l''impact de vos premières apparitions publiques.',

'• Lancez vos campagnes de communication\n• Présentez-vous aux médias et partenaires\n• Activez votre réseau relationnel\n• Multipliez les prises de parole\n• Soyez visible et audible',

'L''excitation de la communication ne doit pas négliger les opérations.',

'• Promettre plus qu''on ne peut délivrer\n• Négliger la substance au profit du marketing\n• Se disperser dans trop de canaux',

'Cette phase est idéale pour la visibilité de lancement.',

'Cette période est très favorable pour la communication.',

'La bonne parole au bon moment ouvre toutes les portes.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 3,
'Les énergies d''équilibre favorisent la consolidation plus que les lancements audacieux.',

'Cette période est moins favorable aux lancements de grande envergure. L''énergie d''équilibre convient mieux à la consolidation d''une activité existante qu''à l''audace d''un nouveau départ. Si vous pouvez attendre, la prochaine phase initiateur sera plus porteuse.',

'• Consolidez les préparatifs en cours\n• Finalisez les derniers détails\n• Lancez uniquement si tout est parfaitement prêt\n• Préparez le terrain pour le prochain cycle',

'Un lancement trop prudent peut manquer d''impact.',

'• Lancer sans énergie ni enthousiasme\n• Reporter indéfiniment par prudence excessive',

'Cette phase convient aux lancements soft ou aux finitions.',

'La première phase du prochain cycle sera beaucoup plus dynamique.',

'L''équilibre prépare les grands élans.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute sont très défavorables aux lancements d''activité.',

'Cette période est fortement déconseillée pour lancer une activité. Les doutes caractéristiques de cette phase peuvent miner votre motivation, affecter votre communication et créer des blocages paralysants. Préparez maintenant, lancez plus tard.',

'• Utilisez ce temps pour la réflexion stratégique\n• Affinez votre concept et votre positionnement\n• Préparez tous les éléments de lancement\n• Reportez le lancement effectif',

'Les doutes transpiraient et affecteraient la perception des autres.',

'• Lancer avec des doutes non résolus\n• Communiquer sans conviction\n• S''engager dans un projet qui ne vous convainc plus',

'Évitez tout lancement dans cette période.',

'La première phase du prochain cycle sera exceptionnelle pour lancer.',

'La patience prépare les succès durables.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation peuvent favoriser les pivots et les réinventions.',

'Cette période peut être favorable si votre lancement est un pivot radical, une réinvention complète ou une rupture avec votre passé professionnel. L''énergie de transformation soutient les changements radicaux. Pour les lancements conventionnels, elle est moins porteuse.',

'• Si pivot ou réinvention : lancez avec audace\n• Embrassez le changement radical\n• Pour lancement conventionnel : attendez une phase plus stable',

'L''instabilité peut affecter la pérennité du projet.',

'• Confondre fuite et réinvention\n• Lancer sans vision claire de la transformation visée',

'Favorable uniquement pour les transformations radicales.',

'La première phase du prochain cycle sera plus stable.',

'Les transformations authentiques portent leurs fruits.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 2,
'Les énergies de fin de cycle ne favorisent pas les nouveaux départs.',

'Cette période n''est pas favorable aux lancements. L''énergie de bilan convient à la conclusion de projets, pas à leur commencement. Utilisez ce temps pour finaliser les préparatifs et planifier un lancement en phase 1 du prochain cycle.',

'• Finalisez tous les préparatifs\n• Bouclez les derniers détails\n• Planifiez le lancement pour le prochain cycle\n• Préparez votre communication',

'Ne vous précipitez pas à lancer maintenant.',

'• Lancer en fin de cycle par impatience\n• Négliger la préparation au profit de l''action immédiate',

'Évitez les lancements en fin de phase.',

'La première phase du prochain cycle sera parfaite pour lancer.',

'Chaque fin prépare un commencement plus puissant.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'lancement_business';


-- =============================================
-- PARTENARIAT - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
'Les énergies d''initiative favorisent les nouvelles connexions professionnelles.',

'Cette période est favorable pour initier de nouveaux partenariats. L''énergie de nouveau départ facilite les premiers contacts et les rencontres d''affaires. Votre enthousiasme attire naturellement les partenaires potentiels.',

'• Initiez les premiers contacts\n• Présentez vos projets avec enthousiasme\n• Explorez les synergies possibles\n• Proposez des collaborations',

'Vérifiez la compatibilité des visions avant de vous engager.',

'• S''associer impulsivement avec le premier venu\n• Négliger la due diligence sur le partenaire',

'Cette phase favorise les initiations de partenariat.',

'La deuxième phase sera idéale pour formaliser.',

'Les bonnes connexions naissent souvent de l''audace de la première approche.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les énergies de construction créent des partenariats durables et solides.',

'Cette période est exceptionnellement favorable pour formaliser des partenariats. Les accords conclus maintenant reposent sur des bases solides et ont de fortes chances de durer. Les deux parties s''engagent avec sérieux et fiabilité.',

'• Formalisez les accords de partenariat\n• Définissez clairement les rôles et responsabilités\n• Signez les contrats d''association\n• Établissez des règles de gouvernance',

'La solidité ne doit pas devenir rigidité. Prévoyez des mécanismes de sortie.',

'• Négliger les clauses de sortie\n• S''associer sans accord écrit formel',

'L''intégralité de cette phase favorise les partenariats durables.',

'Cette période est idéale.',

'Les alliances bien construites multiplient les forces.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication rendent les négociations de partenariat particulièrement fluides.',

'Cette période est excellente pour négocier les termes d''un partenariat. Votre capacité à communiquer et à trouver des terrains d''entente est à son apogée. Les discussions aboutissent naturellement à des accords satisfaisants.',

'• Négociez les termes du partenariat\n• Clarifiez les attentes mutuelles\n• Discutez ouvertement des sujets sensibles\n• Trouvez les compromis gagnant-gagnant',

'L''harmonie des discussions ne garantit pas le succès futur.',

'• Se contenter d''accords verbaux\n• Éviter les sujets difficiles par souci d''harmonie',

'Cette phase est idéale pour les négociations.',

'La quatrième phase sera parfaite pour signer.',

'Les meilleures alliances naissent du dialogue ouvert.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les énergies d''équilibre créent des partenariats parfaitement équilibrés.',

'Cette période est exceptionnellement favorable pour des partenariats équilibrés. Les accords conclus maintenant respectent les intérêts de toutes les parties et créent des relations durables et harmonieuses.',

'• Finalisez les accords de partenariat\n• Vérifiez l''équilibre des apports et des gains\n• Signez les contrats avec sérénité\n• Célébrez l''alliance',

'L''équilibre parfait n''existe pas toujours. Acceptez les petits déséquilibres inévitables.',

'• Chercher un équilibre parfait au point de ne jamais conclure\n• Céder trop pour préserver l''harmonie',

'L''intégralité de cette phase favorise les partenariats équilibrés.',

'Cette période est idéale.',

'Les partenariats équilibrés sont les plus durables.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 3,
'Les énergies de réflexion invitent à évaluer avant de s''engager.',

'Cette période favorise l''évaluation approfondie d''un partenaire potentiel plutôt que l''engagement. Utilisez ce temps pour observer, questionner et analyser avant de vous associer.',

'• Évaluez soigneusement le partenaire potentiel\n• Vérifiez ses antécédents et sa réputation\n• Analysez la compatibilité de vos visions\n• Reportez la signature si des doutes persistent',

'Les doutes sont des guides. Écoutez-les.',

'• S''engager malgré des doutes persistants\n• Ignorer les signaux d''alarme',

'Cette phase convient à l''évaluation, pas à l''engagement.',

'La quatrième phase du prochain cycle sera plus favorable.',

'Mieux vaut un bon choix tardif qu''un mauvais choix hâtif.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation conviennent aux restructurations de partenariats existants.',

'Cette période peut être favorable pour restructurer ou dissoudre des partenariats existants. Pour les nouvelles associations, l''instabilité de cette phase crée des risques. Les transformations de partenariats existants sont par contre favorisées.',

'• Restructurez les partenariats qui ne fonctionnent pas\n• Renégociez les termes obsolètes\n• Envisagez les dissolutions nécessaires\n• Pour nouveau partenariat : attendez',

'L''instabilité peut affecter le jugement.',

'• S''associer dans une période de turbulence\n• Faire des choix radicaux par impulsion',

'Favorable pour les restructurations, pas pour les créations.',

'La deuxième phase du prochain cycle sera plus stable.',

'Les alliances doivent savoir évoluer ou se clore.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les énergies de conclusion favorisent la finalisation des partenariats longuement négociés.',

'Cette période convient pour conclure des partenariats en négociation depuis longtemps. L''énergie de bilan permet de finaliser ce qui était en suspens. Les nouvelles initiations sont moins favorisées.',

'• Finalisez les partenariats en négociation\n• Signez les accords mûris\n• Clôturez les discussions prolongées\n• Préparez les prochaines alliances',

'Ne forcez pas une conclusion qui ne vous convient pas.',

'• Conclure par fatigue de négocier\n• Initier de nouvelles recherches de partenaires',

'Le début de phase favorise les conclusions.',

'Le prochain cycle sera propice aux nouvelles alliances.',

'Les partenariats mûris portent leurs fruits.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'partenariat';


-- =============================================
-- ENTRETIEN D'EMBAUCHE - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative vous donnent une présence et un dynamisme qui impressionnent en entretien.',

'Cette période est exceptionnellement favorable pour les entretiens d''embauche. L''énergie d''initiative qui vous traverse se manifeste par un enthousiasme et une assurance naturelle qui impressionnent favorablement les recruteurs.',

'• Postulez activement aux offres qui vous intéressent\n• Sollicitez des entretiens avec confiance\n• Présentez-vous avec enthousiasme\n• Montrez votre motivation et votre énergie',

'L''excès d''enthousiasme peut passer pour de l''arrogance. Restez humble.',

'• Parler trop de vous sans écouter\n• Promettre plus que vous ne pouvez tenir\n• Négliger la préparation technique',

'Le début de cette phase est particulièrement dynamique.',

'Cette période est idéale pour les entretiens.',

'Votre énergie parle pour vous. Montrez votre meilleur visage.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les énergies de construction projettent une image de fiabilité et de sérieux.',

'Cette période est favorable pour les entretiens. Vous projetez naturellement une image de sérieux et de fiabilité qui rassure les employeurs cherchant des collaborateurs stables.',

'• Mettez en avant votre fiabilité et votre engagement\n• Présentez vos réalisations concrètes\n• Montrez votre capacité à construire sur le long terme\n• Préparez minutieusement vos réponses',

'Le sérieux excessif peut paraître rigide. Montrez aussi votre personnalité.',

'• Être trop formel et distant\n• Négliger l''aspect relationnel de l''entretien',

'L''intégralité de cette phase est favorable.',

'Cette période est très propice aux entretiens.',

'La fiabilité est une qualité recherchée. Montrez la vôtre.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication vous rendent éloquent et convaincant en entretien.',

'Cette période est excellente pour les entretiens. Votre éloquence naturelle et votre capacité à communiquer sont à leur apogée, ce qui vous permet de présenter votre parcours de manière convaincante.',

'• Présentez votre parcours avec clarté\n• Répondez aux questions avec aisance\n• Posez des questions pertinentes\n• Montrez votre capacité à communiquer',

'L''éloquence ne doit pas masquer le fond. Préparez vos exemples concrets.',

'• Parler beaucoup sans substance\n• Négliger les détails techniques',

'Cette phase est idéale pour les entretiens.',

'Cette période est très favorable.',

'Les mots justes ouvrent les portes des opportunités.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 4,
'Les énergies d''équilibre projettent une image de stabilité rassurante.',

'Cette période est favorable pour les entretiens. Vous dégagez une impression de stabilité et d''équilibre qui rassure les employeurs. Votre sérénité transparaît et inspire confiance.',

'• Montrez votre stabilité et votre équilibre\n• Présentez-vous avec calme et assurance\n• Mettez en avant votre fiabilité\n• Posez des questions sur la culture et l''équipe',

'L''équilibre excessif peut sembler manquer de passion.',

'• Paraître trop détaché ou indifférent\n• Manquer d''enthousiasme visible',

'L''intégralité de cette phase est favorable.',

'Cette période est propice.',

'L''équilibre inspire la confiance des décideurs.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute peuvent affecter votre assurance en entretien.',

'Cette période est défavorable pour les entretiens. Les doutes caractéristiques de cette phase peuvent transpirer et affecter négativement votre performance. Reportez si possible.',

'• Si entretien inévitable : préparez intensivement\n• Travaillez sur votre confiance\n• Répétez vos réponses\n• Reportez si vous le pouvez',

'Le manque de confiance est perceptible par les recruteurs.',

'• Passer un entretien important dans le doute\n• Montrer vos hésitations',

'Évitez les entretiens importants dans cette période.',

'La première phase du prochain cycle sera beaucoup plus favorable.',

'Mieux vaut reporter que se présenter sans conviction.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation conviennent aux entretiens de reconversion.',

'Cette période peut être favorable si l''entretien concerne une reconversion ou un changement de carrière radical. L''énergie de transformation soutient ces passages. Pour les postes conventionnels, l''instabilité peut affecter votre performance.',

'• Si reconversion : montrez votre motivation pour le changement\n• Expliquez votre parcours de transformation\n• Pour poste classique : soyez particulièrement préparé',

'L''instabilité intérieure peut se refléter dans votre présentation.',

'• Paraître déstabilisé ou confus\n• Ne pas savoir expliquer votre parcours atypique',

'Favorable pour les reconversions.',

'La première phase du prochain cycle sera plus stable.',

'Les reconversions réussies inspirent le respect.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de bilan conviennent aux entretiens de transition.',

'Cette période est acceptable pour les entretiens, particulièrement pour des postes de transition ou de fin de carrière. L''énergie de bilan vous permet de présenter votre parcours avec maturité. Moins favorable pour les débuts de carrière dynamiques.',

'• Présentez votre expérience avec maturité\n• Montrez ce que vous avez accompli\n• Mettez en avant votre sagesse acquise\n• Préparez-vous pour le prochain cycle si possible',

'L''énergie de conclusion peut manquer de dynamisme pour certains postes.',

'• Paraître en fin de parcours pour un poste dynamique\n• Manquer d''enthousiasme pour l''avenir',

'Cette phase convient aux transitions mûries.',

'La première phase du prochain cycle sera plus dynamique.',

'L''expérience est un trésor à faire valoir.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche';


-- =============================================
-- DEMANDE DE PROMOTION - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative vous donnent l''assurance idéale pour demander une promotion.',

'Cette période est exceptionnellement favorable pour demander une promotion. L''énergie d''initiative qui vous traverse renforce votre assurance naturelle et vous permet de formuler votre demande avec conviction.',

'• Préparez votre argumentaire de promotion\n• Demandez un rendez-vous avec votre supérieur\n• Présentez vos réalisations avec assurance\n• Formulez clairement votre demande',

'L''assurance ne doit pas devenir arrogance. Restez diplomate.',

'• Exiger plutôt que demander\n• Négliger de valoriser votre contribution\n• Manquer de timing dans l''approche',

'Le début de cette phase est particulièrement favorable.',

'Cette période est idéale pour les demandes.',

'Qui ne demande rien n''a rien. Osez demander ce que vous méritez.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les énergies de construction favorisent les demandes appuyées sur des réalisations concrètes.',

'Cette période est favorable pour les demandes de promotion basées sur des accomplissements tangibles. Documentez vos réalisations et présentez des preuves concrètes de votre valeur ajoutée.',

'• Documentez vos réalisations chiffrées\n• Présentez un dossier solide\n• Montrez votre contribution à l''entreprise\n• Proposez un plan pour le nouveau rôle',

'La solidité du dossier ne remplace pas la communication efficace.',

'• Se reposer uniquement sur les faits sans conviction\n• Négliger l''aspect relationnel de la demande',

'L''intégralité de cette phase favorise les demandes solides.',

'Cette période est très favorable.',

'Les preuves concrètes parlent plus fort que les mots.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 5,
'Les énergies de communication rendent votre demande particulièrement persuasive.',

'Cette période est excellente pour négocier une promotion. Votre éloquence naturelle vous permet de présenter votre demande de manière convaincante et de trouver les arguments qui toucheront votre interlocuteur.',

'• Préparez votre présentation avec soin\n• Adaptez vos arguments à votre interlocuteur\n• Négociez avec éloquence\n• Soyez à l''écoute des contre-arguments',

'L''éloquence ne remplace pas la substance. Ayez des preuves.',

'• Se fier uniquement à la parole sans faits\n• Négliger de préparer les réponses aux objections',

'Cette phase est idéale pour les négociations de promotion.',

'Cette période est très favorable.',

'Les mots justes au bon moment font toute la différence.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

-- Périodes 4-7 de demande_promotion (condensées)
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 4,
'Les énergies d''équilibre favorisent les demandes raisonnables et bien argumentées.',

'Cette période favorise les demandes de promotion équilibrées et réalistes. Vous obtiendrez probablement ce qui est juste et mérité, ni moins, ni excessivement plus.',

'• Formulez une demande réaliste\n• Valorisez votre contribution équitablement\n• Soyez ouvert à la négociation',

'L''équilibre peut limiter vos ambitions. Demandez ce que vous méritez vraiment.',

'• Demander moins que votre valeur par modestie excessive',

'Cette phase favorise les demandes équilibrées.',

'Cette période est favorable.',

'La justesse de la demande facilite son acceptation.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les énergies de doute affaiblissent votre position lors d''une demande de promotion.',

'Cette période est défavorable pour demander une promotion. Vos doutes peuvent transparaître et affaiblir votre demande. Préparez votre dossier maintenant, demandez plus tard.',

'• Préparez votre argumentaire pour plus tard\n• Collectez les preuves de vos réalisations\n• Reportez la demande formelle',

'Le manque de conviction se perçoit et nuit à la demande.',

'• Demander sans conviction\n• Montrer vos doutes à votre supérieur',

'Évitez les demandes de promotion.',

'La première phase du prochain cycle sera beaucoup plus favorable.',

'La préparation patiente porte ses fruits.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies de transformation conviennent aux demandes de changement de rôle radical.',

'Cette période peut favoriser une demande qui implique une transformation de rôle plutôt qu''une simple progression. Si vous visez un changement de département ou de fonction, les énergies peuvent vous soutenir.',

'• Si changement radical : formulez votre demande\n• Expliquez votre vision de transformation\n• Pour progression classique : attendez',

'L''instabilité peut affecter la perception de votre demande.',

'• Demander une évolution classique en période de turbulence',

'Favorable pour les transformations de rôle.',

'La première phase du prochain cycle sera plus stable.',

'Les transformations de carrière créent de nouvelles opportunités.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les énergies de bilan conviennent pour préparer une demande future.',

'Cette période est plus adaptée à la préparation d''une demande qu''à la demande elle-même. Utilisez ce temps pour constituer votre dossier et planifier votre demande pour le prochain cycle.',

'• Faites le bilan de vos réalisations\n• Préparez votre argumentaire\n• Planifiez votre demande pour la phase 1 du prochain cycle',

'Ne précipitez pas une demande en fin de cycle.',

'• Demander par impatience en fin de cycle',

'Cette phase convient à la préparation.',

'La première phase du prochain cycle sera parfaite.',

'La préparation mûrie précède le succès.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demande_promotion';


-- =============================================
-- DÉMISSION - 7 périodes
-- =============================================

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les énergies d''initiative sont parfaitement alignées avec les nouveaux départs professionnels.',

'Cette période est idéale pour quitter un emploi et commencer quelque chose de nouveau. L''énergie d''initiative vous donne l''élan nécessaire pour franchir le pas et vous projeter vers de nouveaux horizons.',

'• Annoncez votre démission avec assurance\n• Préparez votre transition\n• Communiquez positivement avec votre employeur\n• Lancez vos recherches ou projets suivants',

'Assurez-vous d''avoir préparé la suite avant de partir.',

'• Démissionner sur un coup de tête sans plan\n• Brûler les ponts inutilement',

'Cette phase est idéale pour les nouveaux départs.',

'Cette période est très favorable.',

'Chaque fin est un nouveau commencement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 3,
'Les énergies de construction favorisent la stabilité plus que les ruptures.',

'Cette période est moins favorable aux ruptures professionnelles. L''énergie de construction vous invite à consolider plutôt qu''à partir. Si possible, repor tez votre démission à une phase plus propice aux changements.',

'• Évaluez s''il est vraiment nécessaire de partir maintenant\n• Consolidez votre position si possible\n• Préparez en silence votre départ futur',

'L''énergie peut vous retenir dans une situation inadaptée.',

'• Rester par confort alors que le départ est nécessaire',

'Cette phase favorise la consolidation.',

'La sixième phase sera plus favorable aux ruptures.',

'Parfois construire signifie préparer sa sortie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies de communication facilitent les annonces de départ.',

'Cette période favorise la communication autour d''un départ. Votre capacité à présenter votre décision de manière positive est optimale, ce qui préserve les relations professionnelles.',

'• Annoncez votre départ de manière positive\n• Expliquez vos motivations avec diplomatie\n• Maintenez de bonnes relations\n• Activez votre réseau pour la suite',

'L''éloquence ne remplace pas la préparation pratique.',

'• Annoncer sans avoir préparé la suite\n• Se disperser dans les au-revoir',

'Cette phase favorise les annonces bien communiquées.',

'Cette période est favorable pour les départs préparés.',

'Une séparation bien communiquée préserve les ponts.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 2,
'Les énergies d''équilibre ne favorisent pas les ruptures.',

'Cette période est défavorable aux ruptures professionnelles. L''énergie d''équilibre vous invite à préserver l''harmonie de votre situation actuelle. Si votre départ n''est pas urgent, reportez-le.',

'• Recherchez l''équilibre dans votre situation actuelle\n• Évaluez s''il est vraiment nécessaire de partir\n• Préparez votre départ pour une phase plus favorable',

'L''équilibre peut créer de l''inertie dans une situation toxique.',

'• Rester dans une situation néfaste par souci d''harmonie',

'Cette phase ne favorise pas les ruptures.',

'La sixième phase sera bien plus favorable.',

'L''harmonie ne doit pas devenir prison.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 4,
'Les énergies de réflexion permettent d''analyser si le départ est vraiment nécessaire.',

'Cette période favorise la réflexion sur votre situation professionnelle. Est-ce vraiment le moment de partir ? L''analyse approfondie vous permettra de prendre la bonne décision, quelle qu''elle soit.',

'• Analysez objectivement votre situation\n• Pesez le pour et le contre du départ\n• Consultez des personnes de confiance\n• Préparez votre décision pour plus tard',

'Les doutes peuvent retarder une décision nécessaire.',

'• Rester paralysé par l''analyse indéfiniment',

'Cette phase convient à la réflexion.',

'La sixième phase sera favorable pour agir.',

'La réflexion éclaire la décision.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 5,
'Les énergies de transformation sont parfaitement alignées avec les ruptures professionnelles.',

'Cette période est exceptionnellement favorable pour démissionner et changer de vie professionnelle. L''énergie de transformation soutient les ruptures nécessaires et les nouveaux départs radicaux.',

'• Annoncez votre démission avec détermination\n• Embrassez le changement professionnel\n• Préparez votre nouvelle vie\n• Laissez derrière vous ce qui ne vous sert plus',

'La transformation ne doit pas être une fuite.',

'• Fuir une situation sans plan pour la suite\n• Confondre changement impulsif et transformation réfléchie',

'Cette phase est idéale pour les ruptures.',

'Cette période est très favorable.',

'Les fins courageuses ouvrent les portes des nouvelles vies.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les énergies de conclusion favorisent les départs qui closent un chapitre professionnel.',

'Cette période convient pour conclure un chapitre professionnel et préparer le suivant. L''énergie de bilan vous permet de partir en tirant les leçons de cette expérience.',

'• Clôturez proprement votre poste\n• Tirez les leçons de cette expérience\n• Préparez la transition sereinement\n• Partez en bons termes',

'Ne prolongez pas artificiellement un départ nécessaire.',

'• Étirer la conclusion par nostalgie',

'Cette phase favorise les conclusions mûries.',

'Cette période est favorable pour les départs préparés.',

'Chaque chapitre qui se ferme prépare le suivant.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demission';

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Conseils JURIDIQUE/BUSINESS/CARRIÈRE insérés:' AS status;
SELECT dt.category, dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category IN ('juridique', 'business', 'carriere')
GROUP BY dt.category, dt.label
ORDER BY dt.category, dt.label;
