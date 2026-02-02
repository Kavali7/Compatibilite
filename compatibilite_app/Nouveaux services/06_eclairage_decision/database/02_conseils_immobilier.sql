-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 1: IMMOBILIER
-- 3 types × 7 périodes = 21 conseils
-- =============================================

-- =============================================
-- LOCATION IMMOBILIER - 7 périodes
-- =============================================

-- Période 1: Initiative
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
-- cosmic_context (~80 mots)
'Les vibrations cosmiques actuelles vous placent dans une phase d''élan et de renouveau énergétique. L''univers amplifie votre capacité à percevoir les opportunités et à saisir les occasions favorables. Cette énergie d''initiative crée un terrain propice aux nouvelles recherches et aux premiers contacts. Votre intuition est particulièrement aiguisée pour détecter les bonnes affaires et les environnements qui vous correspondent.',

-- advice_text (~200 mots)
'Votre période actuelle révèle une configuration énergétique favorable à la recherche active d''un nouveau logement. Les énergies d''initiative qui vous traversent stimulent votre perception et votre réactivité face aux opportunités immobilières.

Les visites que vous effectuerez maintenant vous permettront de ressentir plus clairement si un lieu vous correspond. Votre radar intuitif fonctionne de manière optimale pour détecter les ambiances positives et repérer les environnements compatibles avec votre énergie personnelle.

Les premiers contacts avec les propriétaires ou agents seront naturellement fluides. Vous dégagez une assurance qui inspire confiance et facilite les échanges. Profitez de cette fenêtre pour multiplier les visites et élargir vos options.

Cependant, cette même énergie d''initiative peut vous pousser à vouloir conclure trop rapidement. La signature d''un bail est un engagement qui mérite réflexion. Utilisez cette période pour explorer et comparer, mais prenez le temps de vérifier tous les détails pratiques avant de vous engager formellement.',

-- recommended_actions (~100 mots)
'• Intensifiez vos recherches en ligne et consultez les nouvelles annonces quotidiennement
• Planifiez plusieurs visites cette semaine pour comparer les options
• Établissez une liste claire de vos critères prioritaires
• Prenez des photos et notes détaillées lors de chaque visite
• Posez des questions sur le voisinage, les charges et l''historique du bien
• Faites confiance à vos premières impressions lors des visites
• Constituez votre dossier locatif complet pour être prêt à candidater',

-- warnings (~80 mots)
'L''enthousiasme de cette période peut vous faire sous-estimer certains défauts. Ne négligez pas l''inspection minutieuse des équipements, de l''isolation et de l''état général. Les premiers coups de cœur sont fréquents mais méritent d''être confirmés par une seconde visite. Évitez de signer sous la pression, même si le propriétaire insiste sur l''urgence.',

-- pitfalls_to_avoid (~60 mots)
'• Se laisser emporter par l''esthétique sans vérifier les aspects pratiques
• Ignorer les signaux d''alerte (humidité, nuisances sonores)
• Négliger de lire intégralement le bail avant signature
• S''engager verbalement sans avoir exploré d''autres options',

-- optimal_timing (~40 mots)
'Les premiers jours de cette phase sont les plus dynamiques. Privilégiez les visites en début de semaine, lorsque votre énergie est à son maximum. Les matinées sont particulièrement favorables.',

-- alternatives_suggestion (~50 mots)
'Si vous devez reporter votre recherche, la troisième phase de votre cycle sera également propice aux échanges avec les propriétaires. La quatrième phase offrira une énergie d''équilibre idéale pour les signatures.',

-- closing_message (~40 mots)
'Les étoiles vous guident vers un nouveau foyer. Restez attentif aux signes et faites confiance à votre intuition. L''espace qui vous attend existe déjà quelque part.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 2: Construction
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
-- cosmic_context
'Les énergies cosmiques actuelles vous enveloppent dans une vibration de construction et de stabilisation. Cette phase favorise les fondations durables et les engagements à long terme. L''univers soutient vos efforts pour créer une base solide dans votre vie. Votre capacité à évaluer les aspects pratiques et concrets est particulièrement développée.',

-- advice_text
'Votre configuration énergétique actuelle représente l''une des périodes les plus favorables pour concrétiser un projet locatif. Les énergies de construction qui vous animent créent les conditions idéales pour signer un bail et vous engager sereinement.

Votre discernement pratique est à son apogée. Vous êtes naturellement attentif aux détails qui comptent : état des équipements, clauses du contrat, qualité de l''environnement. Cette lucidité vous protège des mauvaises surprises.

Les baux signés durant cette période ont de fortes chances de correspondre à des installations durables et harmonieuses. L''énergie de stabilisation favorise les locations où vous pourrez vous épanouir sur le long terme.

Si vous avez identifié un bien qui vous convient, c''est le moment idéal pour finaliser. Les négociations que vous mènerez maintenant aboutiront naturellement à des conditions équilibrées pour toutes les parties.',

-- recommended_actions
'• Finalisez les visites en cours et prenez votre décision
• Relisez attentivement chaque clause du bail avant signature
• Négociez les détails pratiques (état des lieux, petites réparations)
• Préparez votre installation : planifiez le déménagement, les raccordements
• Constituez un budget réaliste incluant toutes les charges
• Documentez l''état du logement avec photos datées',

-- warnings
'Même dans cette période favorable, restez vigilant sur les aspects légaux. Vérifiez la conformité du bail avec la législation en vigueur. Assurez-vous que les diagnostics obligatoires sont présents et lisibles. La précipitation n''est jamais conseillée pour un engagement immobilier.',

-- pitfalls_to_avoid
'• Signer sans avoir effectué d''état des lieux détaillé
• Accepter des clauses abusives par excès de confiance
• Négliger l''assurance habitation et les formalités administratives',

-- optimal_timing
'Le cœur de cette phase offre les meilleures énergies. Les signatures effectuées en milieu de période bénéficient d''un ancrage optimal.',

-- alternatives_suggestion
'Aucune alternative n''est nécessaire : cette période est idéale. Profitez pleinement de cette fenêtre énergétique exceptionnelle pour concrétiser.',

-- closing_message
'L''univers conspire à vous offrir un foyer stable et harmonieux. Saisissez cette opportunité avec confiance et gratitude.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 3: Expansion/Communication
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les courants cosmiques actuels amplifient vos capacités de communication et d''échange. Cette phase d''expansion sociale facilite les interactions avec autrui. Votre charisme naturel s''exprime avec fluidité, créant des connexions authentiques. Les négociations et les discussions sont particulièrement favorisées.',

'Votre cycle personnel traverse actuellement une phase où votre pouvoir de communication atteint son expression optimale. Cette configuration énergétique crée des conditions exceptionnelles pour toutes les négociations liées à votre projet locatif.

Les échanges avec les propriétaires, agences ou gestionnaires immobiliers seront remarquablement fluides. Vous trouverez naturellement les mots justes pour exprimer vos besoins et vos attentes. Votre capacité à écouter et à comprendre les motivations de vos interlocuteurs vous permet d''identifier des terrains d''entente.

C''est le moment idéal pour négocier le montant du loyer, les conditions du bail ou les petits aménagements que vous souhaitez. Votre éloquence naturelle peut vous valoir des concessions que vous n''auriez pas obtenues à un autre moment.

Cependant, cette même énergie expansive peut vous pousser à explorer trop d''options simultanément. Canalisez votre envie de découverte pour ne pas vous disperser.',

'• Contactez directement les propriétaires pour négocier les conditions
• Exprimez clairement vos besoins et écoutez attentivement les réponses
• Demandez des visites supplémentaires pour les biens qui vous intéressent
• Sollicitez l''avis de proches pour affiner votre choix
• Explorez les possibilités de personnalisation du logement
• Renseignez-vous sur le quartier auprès des futurs voisins',

'L''abondance d''options peut créer de la confusion. Résistez à la tentation de vouloir tout voir et tout comparer. Établissez des critères clairs et éliminez les options qui ne correspondent pas à vos priorités essentielles.',

'• Papillonner entre trop de possibilités sans jamais se décider
• Faire des promesses verbales à plusieurs propriétaires
• S''emballer dans les négociations au point d''oublier ses besoins réels',

'Les moments d''échange en fin de matinée ou en milieu d''après-midi sont les plus propices. Évitez les négociations importantes en soirée.',

'Si vous n''êtes pas prêt à vous engager, la quatrième phase apportera une énergie d''équilibre favorable aux décisions mûrement réfléchies.',

'Votre parole porte une force particulière en ce moment. Utilisez ce pouvoir pour manifester le foyer qui correspond à votre essence.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 4: Équilibre/Foyer
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations cosmiques vous baignent dans une énergie d''harmonie et d''équilibre profond. Cette phase est naturellement connectée aux questions de foyer et de vie familiale. L''univers favorise la création d''espaces où règnent paix et sérénité. Votre sensibilité aux ambiances est à son apogée.',

'Cette période représente le cœur énergétique de votre cycle, un moment d''équilibre parfait pour toutes les décisions concernant votre habitat. Les énergies qui vous traversent sont naturellement alignées avec la notion de foyer, de cocon protecteur et d''ancrage.

Les logements que vous visiterez maintenant vous révéleront leur vraie nature. Votre perception subtile des ambiances vous permet de ressentir si un espace peut devenir un véritable chez-vous. Faites confiance à ce ressenti profond.

C''est la période idéale pour s''installer durablement. Les baux signés durant cette phase correspondent généralement à des locations où vous pourrez créer un équilibre de vie harmonieux. Les relations avec le propriétaire ou les voisins tendent à être naturellement cordiales.

Si vous hésitez entre plusieurs options, choisissez celle qui vous procure le sentiment de paix le plus profond. L''énergie actuelle vous guide vers ce qui est juste pour vous.',

'• Visitez les logements potentiels en fin de journée pour ressentir l''atmosphère
• Imaginez-vous vivre quotidiennement dans cet espace
• Évaluez la qualité de lumière naturelle et l''orientation du bien
• Considérez la proximité de vos proches et de vos lieux de vie
• Signez le bail dans un état d''esprit serein et confiant
• Planifiez l''aménagement de votre futur espace de vie',

'Même dans cette période favorable, gardez un esprit analytique. L''harmonie que vous recherchez doit reposer sur des bases pratiques solides. Vérifiez que le logement répond à tous vos besoins concrets au-delà de l''ambiance.',

'• Se laisser guider uniquement par l''émotion sans vérifier les aspects pratiques
• Idéaliser un logement au point d''ignorer ses défauts objectifs
• S''engager dans un espace trop petit ou mal adapté à vos besoins réels',

'L''énergie d''équilibre est constante tout au long de cette phase. Les signatures en fin de période ancrent particulièrement bien les nouveaux départs.',

'Cette période est exceptionnellement favorable. Saisissez cette opportunité si vous êtes prêt à vous engager.',

'Votre nouveau foyer vous attend avec bienveillance. L''univers a préparé un espace où votre âme pourra s''épanouir en paix.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 5: Réflexion/Introspection
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 3,
'Les courants cosmiques vous invitent actuellement à un voyage intérieur. Cette phase de réflexion et d''introspection favorise l''analyse profonde plutôt que l''action. L''énergie présente vous pousse à questionner, à réévaluer, à comprendre vos véritables besoins. C''est un temps de maturation.',

'Votre cycle traverse actuellement une phase contemplative qui n''est pas idéale pour les engagements locatifs définitifs. Les énergies de réflexion qui vous habitent créent un état d''esprit propice aux questionnements, parfois aux doutes.

Cette période est précieuse pour clarifier vos besoins réels. Qu''est-ce qui compte vraiment pour vous dans un logement ? Quels sont vos critères non négociables ? Utilisez ce temps pour affiner votre vision avant de vous engager.

Si vous avez déjà identifié un bien, prenez du recul avant de signer. Les décisions prises dans cette phase peuvent être suivies de regrets ou de remises en question. Il ne s''agit pas d''un mauvais présage, mais d''une invitation à la prudence.

Profitez de cette période pour approfondir vos recherches documentaires, étudier le marché, comparer les quartiers. L''action viendra à son heure.',

'• Établissez une liste détaillée de vos critères prioritaires
• Analysez votre budget avec précision et réalisme
• Visitez des quartiers que vous ne connaissez pas pour élargir vos horizons
• Discutez de votre projet avec des proches de confiance
• Lisez des avis et témoignages sur les zones qui vous intéressent
• Prenez le temps de méditer sur ce que représente "chez vous"',

'Les doutes qui peuvent surgir ne sont pas des obstacles mais des guides. Ne les ignorez pas. Si quelque chose vous dérange dans un logement, même sans raison claire, c''est un signal à prendre en compte.',

'• Signer un bail dans un moment de doute ou d''incertitude
• Ignorer les signaux intuitifs négatifs pour "en finir"
• Prendre une décision hâtive pour échapper au questionnement',

'Les moments de calme et de solitude sont favorables à la réflexion. Évitez les décisions importantes dans l''agitation.',

'La première phase de votre prochain cycle offrira une énergie d''initiative parfaite pour concrétiser. La quatrième phase actuelle ou celle à venir sera idéale pour les signatures.',

'Chaque question qui émerge vous rapproche de la clarté. Honorez ce temps de préparation intérieure.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 6: Transformation
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies cosmiques actuelles portent une puissante vibration de transformation et de renouveau profond. Cette phase bouleverse les anciennes structures pour faire place au nouveau. C''est un temps de remise en question radicale où les changements majeurs sont facilités.',

'Votre cycle traverse une phase de transformation qui peut être particulièrement porteuse si votre recherche de logement s''inscrit dans un changement de vie plus global. Déménagement lié à une séparation, un nouveau travail, une transition de vie majeure ? Les énergies actuelles soutiennent ces ruptures.

En revanche, les locations "ordinaires" - simples changements de confort sans transformation profonde - sont moins favorisées. L''énergie présente est trop intense pour les situations banales.

Si vous cherchez un logement temporaire, une solution de transition, ou si votre déménagement accompagne une métamorphose personnelle, cette période peut s''avérer favorable. L''univers soutient les passages d''une vie à une autre.

Pour les recherches conventionnelles sans enjeu transformateur, mieux vaut attendre une énergie plus stable.',

'• Si en transition de vie : acceptez que ce logement soit temporaire
• Privilégiez les solutions flexibles aux engagements de longue durée
• Restez ouvert aux options inhabituelles ou inattendues
• Si déménagement de rupture : concentrez-vous sur l''essentiel
• Épurez vos attentes et vos exigences pour l''essentiel
• Considérez ce logement comme une étape, non une destination',

'Cette période peut amplifier les décisions extrêmes. Évitez les engagements que vous pourriez regretter une fois la tempête passée. Les transformations sont positives mais nécessitent discernement.',

'• S''engager dans un bail long terme dans un moment de turbulence émotionnelle
• Fuir une situation vers n''importe quel logement sans réflexion
• Laisser l''urgence dicter des choix que vous auriez autrement refusés',

'Les moments de calme au sein de cette période agitée sont les plus propices. Attendez un sentiment de relative sérénité avant de signer.',

'La septième phase offre une énergie de bilan plus posée. La première phase du prochain cycle apportera l''élan pour un nouveau départ dans de meilleures conditions.',

'Chaque fin annonce un commencement. L''espace que vous cherchez fait partie de la nouvelle vie qui vous attend.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- Période 7: Bilan/Accomplissement
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations cosmiques actuelles portent l''énergie de l''accomplissement et du bilan. Cette phase clôture un cycle et prépare le suivant. Les énergies favorisent la conclusion des projets en cours plutôt que les nouveaux commencements. C''est un temps de récolte et de synthèse.',

'Votre cycle approche de son accomplissement, créant une énergie favorable pour finaliser une recherche de logement déjà bien avancée. Si vous avez identifié un bien après des semaines ou mois de recherche, c''est le moment de conclure.

Les signatures effectuées maintenant portent une énergie de maturité. Vous avez eu le temps de réfléchir, de comparer, de peser le pour et le contre. Cette décision mûrie s''inscrit naturellement dans la conclusion de ce cycle.

En revanche, démarrer une nouvelle recherche maintenant n''est pas optimal. L''énergie de bilan ne favorise pas les explorationsà partir de zéro. Si vous n''avez pas encore trouvé, il sera plus judicieux d attendre la première phase du prochain cycle pour repartir avec une énergie fraîche.

Pour ceux qui ont un dossier en cours, c''est le moment de le finaliser avec soin avant le renouveau qui s''annonce.',

'• Finalisez les négociations ou les dossiers en cours
• Signez le bail pour clore ce chapitre de recherche
• Préparez minutieusement votre installation à venir
• Terminez les formalités administratives dans leur intégralité
• Si pas de bien trouvé : préparez votre stratégie pour le prochain cycle
• Dressez le bilan de vos recherches : qu''avez-vous appris sur vos besoins ?',

'Ne vous sentez pas obligé de conclure à tout prix. Si aucun logement ne vous convient vraiment, il vaut mieux reporter plutôt que de signer un bail insatisfaisant sous la pression de la fin de cycle.',

'• Signer un bail par fatigue de chercher plutôt que par conviction
• Négliger les derniers détails dans la précipitation de conclure
• Démarrer une toute nouvelle recherche qui s''éternisera',

'Le début de cette phase est le plus favorable aux conclusions. Les derniers jours portent déjà l''énergie du cycle suivant.',

'La première phase du prochain cycle offrira une magnifique énergie d''initiative pour les nouvelles recherches. Patientez si vous n''avez pas trouvé.',

'Un chapitre se ferme pour qu''un autre s''ouvre. Faites confiance au rythme de votre destinée.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier';


-- =============================================
-- ACHAT IMMOBILIER - 7 périodes
-- =============================================

-- Période 1: Initiative
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 3,
'Les vibrations cosmiques actuelles insufflent une énergie d''initiative et de nouveau départ. L''élan est présent, la motivation est forte. Cependant, l''achat immobilier est une décision majeure qui requiert davantage de maturation que cette énergie impulsive ne le permet naturellement.',

'Votre cycle traverse une phase d''énergie dynamique qui favorise les recherches et les explorations, mais qui n''est pas optimale pour les engagements financiers majeurs comme l''achat d''un bien immobilier.

L''enthousiasme qui vous anime peut vous faire percevoir les opportunités sous un angle excessivement positif. Vous pourriez minimiser les défauts d''un bien ou surestimer votre capacité financière dans l''excitation du moment.

Cette période est en revanche excellente pour démarrer vos recherches, visiter de nombreux biens, et constituer votre dossier de financement. L''énergie d''initiative vous donne la motivation nécessaire pour entreprendre ces démarches préparatoires.

Gardez à l''esprit que l''achat final devrait idéalement attendre une phase plus propice aux engagements à long terme, comme la deuxième ou la quatrième phase de votre cycle.',

'• Intensifiez vos recherches de biens correspondant à vos critères
• Visitez un maximum de propriétés pour affiner votre vision
• Rencontrez des banques pour évaluer votre capacité d''emprunt
• Constituez votre dossier de financement complet
• Explorez différents quartiers et types de biens
• Documentez chaque visite avec photos et notes détaillées',

'L''impulsivité peut vous coûter cher dans l''immobilier. Un coup de cœur n''est pas une raison suffisante pour un engagement de 20 ou 25 ans. Les défauts que vous ignorez maintenant vous dérangeront pendant des années.',

'• Signer un compromis sous le coup de l''enthousiasme
• Négliger l''inspection technique approfondie du bien
• Sous-estimer les travaux nécessaires par optimisme
• S''engager avant d''avoir une offre de prêt ferme',

'Le début de cette phase est idéal pour lancer vos recherches. Évitez les décisions définitives vers la fin de la période.',

'La deuxième phase offrira une énergie de construction parfaite pour signer. La quatrième phase sera également optimale pour les engagements durables.',

'Votre future propriété existe quelque part. Prenez le temps de la trouver sans précipitation.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- Période 2: Construction
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les courants cosmiques vous enveloppent dans une vibration puissante de construction et de fondation. Cette phase est naturellement alignée avec les grands projets de vie qui s''inscrivent dans la durée. L''énergie présente soutient la création de bases solides et les engagements structurants.',

'Cette période représente l''une des configurations énergétiques les plus favorables pour l''achat immobilier. Les vibrations de construction qui vous traversent sont parfaitement alignées avec l''acquisition d''un bien qui deviendra le fondement de votre vie pour les années à venir.

Votre discernement pratique est aiguisé. Vous percevez naturellement les aspects concrets qui comptent : structure du bâtiment, qualité des matériaux, potentiel d''évolution du quartier. Cette lucidité vous protège des erreurs de jugement coûteuses.

Les négociations que vous mènerez aboutiront naturellement à des conditions justes. Votre énergie stable inspire confiance aux vendeurs et aux banques. Les offres que vous formulerez seront perçues sérieusement.

Si vous avez identifié un bien qui vous correspond, n''hésitez plus. Les achats réalisés durant cette phase créent généralement des situations durables et satisfaisantes. C''est véritablement le moment de concrétiser.',

'• Finalisez la sélection du bien après comparaison approfondie
• Faites réaliser tous les diagnostics et expertises nécessaires
• Négociez le prix et les conditions de vente avec assurance
• Signez le compromis et constituez votre dossier bancaire définitif
• Planifiez les éventuels travaux avec méthodologie
• Visualisez votre vie dans ce nouveau lieu',

'Même dans cette période optimale, ne négligez aucune vérification. Faites réaliser une inspection technique complète. Étudiez les servitudes, les nuisances potentielles, les projets urbains du quartier.',

'• Se précipiter sur le premier bien correct sans comparaison
• Négliger les aspects juridiques sous prétexte de confiance
• S''endetter au-delà de sa capacité réelle de remboursement',

'L''intégralité de cette phase est favorable. Le cœur de la période offre une stabilité maximale pour les signatures importantes.',

'Aucune alternative nécessaire : cette période est exceptionnellement favorable. Profitez pleinement de cette fenêtre cosmique.',

'Les fondations que vous posez maintenant soutiendront votre vie pendant des décennies. Construisez avec confiance.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- (Parties 3-7 de achat_immobilier à suivre...)

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Conseils IMMOBILIER (partie 1) insérés:' AS status;
SELECT dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category = 'immobilier'
GROUP BY dt.label
ORDER BY dt.label;
