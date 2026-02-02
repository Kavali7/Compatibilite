-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 1B: IMMOBILIER (suite)
-- Achat Immobilier (périodes 3-7) + Déménagement
-- =============================================

-- =============================================
-- ACHAT IMMOBILIER - Périodes 3 à 7
-- =============================================

-- Période 3: Expansion/Communication
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies cosmiques actuelles amplifient vos capacités d''échange et de négociation. Cette phase d''expansion favorise les interactions multiples et les connexions. Votre charisme commercial est à son apogée, facilitant les discussions avec vendeurs, agents et banquiers.',

'Votre configuration énergétique actuelle crée des conditions exceptionnelles pour toutes les négociations liées à votre projet d''achat. Les vibrations d''expansion et de communication qui vous traversent vous donnent un avantage naturel dans les échanges.

Les visites de biens seront particulièrement révélatrices. Vous poserez naturellement les bonnes questions et percevrez les non-dits des vendeurs. Votre intuition sociale est à son maximum, vous permettant de décoder les véritables motivations des parties en présence.

C''est le moment idéal pour négocier le prix d''achat. Votre éloquence peut vous valoir des remises significatives. Les vendeurs seront plus enclins à faire des concessions face à un acheteur avec qui la communication est fluide.

Cependant, évitez de vous disperser entre trop d''opportunités. L''énergie d''expansion peut vous pousser à vouloir tout voir, tout comparer, retardant ainsi votre décision.',

'• Multipliez les visites pour les biens présélectionnés
• Engagez des négociations de prix avec assurance
• Sollicitez plusieurs banques pour optimiser votre financement
• Rencontrez les voisins potentiels pour évaluer l''environnement social
• Faites jouer la concurrence entre les établissements prêteurs
• Communiquez clairement vos conditions et vos limites',

'L''abondance d''options peut créer de la confusion et retarder votre décision. Établissez des critères clairs et éliminez les biens qui ne correspondent pas à vos priorités essentielles.',

'• Papillonner entre trop de biens sans jamais se décider
• Négliger l''analyse technique au profit du relationnel
• S''emballer dans les négociations au point d''oublier ses limites budgétaires',

'Les moments d''échange en milieu de journée sont les plus propices aux négociations importantes.',

'La quatrième phase offrira une énergie d''équilibre idéale pour les signatures définitives.',

'Votre parole porte une force de conviction remarquable. Utilisez ce pouvoir pour obtenir les conditions que vous méritez.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- Période 4: Équilibre/Foyer
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations cosmiques vous baignent dans une harmonie profonde, naturellement connectée à la notion de foyer et de fondation familiale. Cette phase représente le cœur énergétique de votre cycle, un moment d''équilibre parfait pour les décisions qui structureront votre vie domestique.',

'Cette période est exceptionnellement favorable pour l''achat de votre résidence principale ou d''un bien destiné à accueillir votre famille. Les énergies d''équilibre et de foyer qui vous traversent sont parfaitement alignées avec l''acquisition d''un espace de vie harmonieux.

Votre perception des ambiances est à son apogée. Les biens que vous visiterez maintenant vous révéleront leur vraie nature. Vous ressentirez instantanément si un lieu peut devenir un véritable chez-vous, un cocon où vous pourrez vous épanouir sur le long terme.

Les négociations aboutiront naturellement à des conditions équilibrées pour toutes les parties. Votre énergie stable inspire confiance et facilite les accords gagnant-gagnant.

C''est le moment idéal pour signer un compromis ou un acte définitif. Les acquisitions réalisées durant cette phase créent généralement des situations durables, stables et satisfaisantes. Votre intuition vous guide vers ce qui est juste pour vous et vos proches.',

'• Finalisez votre décision pour le bien qui vous correspond le mieux
• Signez le compromis de vente dans un état d''esprit confiant
• Visualisez votre vie quotidienne dans ce nouveau lieu
• Considérez les besoins de tous les membres de votre foyer
• Planifiez l''aménagement et les éventuels travaux
• Célébrez cette étape importante avec vos proches',

'Même dans cette période optimale, restez vigilant sur les aspects juridiques et techniques. L''harmonie que vous recherchez doit reposer sur des fondations concrètes solides.',

'• Se laisser guider uniquement par l''émotion sans analyse pratique
• Idéaliser un bien au point d''ignorer ses défauts objectifs
• Négliger les servitudes ou les projets urbains du quartier',

'L''intégralité de cette phase est favorable. Les signatures en fin de période ancrent particulièrement bien les nouveaux départs.',

'Cette période est exceptionnellement favorable. N''hésitez pas à concrétiser si vous avez trouvé votre bien.',

'Votre nouveau foyer vous attend. L''univers a préparé un espace où votre famille pourra s''épanouir en paix et en harmonie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- Période 5: Réflexion/Introspection
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les courants cosmiques vous invitent à un voyage intérieur. Cette phase de réflexion profonde favorise le questionnement plutôt que l''action. L''énergie présente vous pousse à réévaluer, analyser et comprendre avant d''agir. C''est un temps de maturation qui n''est pas propice aux engagements majeurs.',

'Votre cycle traverse actuellement une phase contemplative qui n''est pas recommandée pour les engagements financiers majeurs comme l''achat immobilier. Les énergies de réflexion qui vous habitent créent un état d''esprit propice aux doutes et aux remises en question.

Les décisions d''achat prises durant cette période sont souvent suivies de regrets ou d''incertitudes prolongées. Non pas que les biens choisis soient mauvais, mais votre état énergétique ne vous permet pas d''embrasser pleinement un engagement aussi important.

Cette période est cependant précieuse pour approfondir votre réflexion. Utilisez ce temps pour clarifier vos véritables besoins, affiner vos critères, étudier le marché en profondeur. Quels sont vos non-négociables ? Que pouvez-vous vraiment vous permettre ?

L''action viendra à son heure. Laissez mûrir votre projet durant cette phase introspective.',

'• Analysez en profondeur votre capacité financière réelle
• Réfléchissez à vos besoins à 5, 10, 15 ans
• Étudiez les évolutions du marché immobilier local
• Consultez des experts (notaire, architecte) pour des avis objectifs
• Listez vos critères par ordre de priorité
• Prenez du recul par rapport à vos coups de cœur précédents',

'Les doutes qui émergent sont des guides, pas des obstacles. S''ils persistent concernant un bien, c''est un signal important. Ne forcez pas une décision dans cette période.',

'• Signer un compromis dans un moment de doute
• Ignorer les signaux intuitifs négatifs pour "en finir"
• Prendre une décision hâtive pour échapper au questionnement',

'Les moments de calme et de solitude sont favorables à la réflexion. Évitez les décisions importantes dans l''agitation.',

'La première ou deuxième phase de votre prochain cycle offrira une énergie bien plus favorable pour concrétiser. Patientez.',

'La sagesse est de savoir attendre. Votre propriété idéale mérite que vous l''accueilliez au bon moment.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- Période 6: Transformation
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies cosmiques portent une vibration puissante de transformation et de renouveau profond. Cette phase bouleverse les structures existantes pour faire place au nouveau. C''est un temps de changement radical où les décisions conventionnelles sont déstabilisées.',

'Votre cycle traverse une phase de transformation qui crée des conditions singulières pour l''achat immobilier. Cette énergie peut être favorable si votre acquisition s''inscrit dans un changement de vie majeur : divorce, héritage, reconversion, départ à l''étranger, transformation radicale de votre mode de vie.

En revanche, les achats "ordinaires" - progression naturelle, amélioration de confort sans bouleversement - sont moins soutenus par les énergies actuelles. L''instabilité de cette phase peut créer des situations où vous regrettez vos choix une fois le calme revenu.

Si votre projet immobilier accompagne une métamorphose personnelle authentique, les vibrations actuelles peuvent servir de catalyseur. L''univers soutient les passages d''une vie à une autre.

Pour les projets conventionnels, mieux vaut patienter jusqu''à une énergie plus stable.',

'• Si en transition de vie majeure : acceptez que ce bien marque une rupture
• Évaluez si l''achat est vraiment aligné avec votre nouvelle direction
• Restez ouvert aux options inhabituelles ou surprenantes
• Si achat conventionnel : reportez à une période plus stable
• Distinguez l''urgence émotionnelle de la nécessité réelle
• Consultez des proches de confiance avant toute décision',

'Cette période peut amplifier les décisions extrêmes. Un achat immobilier représente un engagement de 20-25 ans. Évitez de le prendre dans un moment de turbulence émotionnelle.',

'• Acheter pour fuir une situation plutôt que pour construire
• S''engager sous la pression d''un changement de vie sans recul
• Sous-estimer l''impact émotionnel de cette période sur votre jugement',

'Les moments de calme au sein de cette période agitée sont les plus propices. Attendez un sentiment de relative sérénité.',

'La septième phase offre une énergie de bilan plus posée. La deuxième phase du prochain cycle sera idéale pour les engagements durables.',

'Chaque transformation porte en elle les graines du renouveau. Le bon moment viendra pour ancrer votre nouvelle vie.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- Période 7: Bilan/Accomplissement
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations cosmiques portent l''énergie de l''accomplissement et du bilan. Cette phase clôture un cycle et prépare le suivant. Les énergies favorisent la conclusion des projets mûris plutôt que les nouveaux commencements. C''est un temps de récolte et de synthèse.',

'Votre cycle approche de son accomplissement, créant une énergie favorable pour finaliser un projet d''achat immobilier déjà bien avancé. Si vous recherchez depuis plusieurs mois, que vous avez comparé, réfléchi et mûri votre décision, c''est le moment de conclure.

Les achats réalisés maintenant portent une énergie de maturité et de sagesse. Vous avez eu le temps de peser le pour et le contre, d''évaluer toutes les options, de vous projeter dans l''avenir. Cette décision mûrie s''inscrit naturellement dans la conclusion de ce cycle.

En revanche, démarrer une nouvelle recherche maintenant n''est pas optimal. L''énergie de fin de cycle ne favorise pas les explorations à partir de zéro. Si vous n''avez pas encore trouvé le bien idéal, il sera plus judicieux d''attendre le renouveau énergétique du prochain cycle.

Pour ceux qui ont un dossier avancé, c''est le moment de signer l''acte définitif avant le nouveau chapitre qui s''annonce.',

'• Finalisez les négociations et les procédures en cours
• Signez l''acte d''achat pour clore ce chapitre de recherche
• Préparez méticuleusement votre emménagement à venir
• Terminez toutes les formalités administratives et bancaires
• Si pas de bien trouvé : préparez votre stratégie pour le prochain cycle
• Dressez le bilan de vos recherches et affinez vos critères',

'Ne vous sentez pas obligé de conclure à tout prix. Si aucun bien ne vous convient vraiment, reporter à la prochaine phase favorable sera plus sage que d''acheter par fatigue.',

'• Signer par lassitude de chercher plutôt que par conviction
• Négliger les dernières vérifications dans la précipitation de conclure
• Démarrer une nouvelle recherche qui s''éternisera jusqu''au prochain cycle',

'Le début de cette phase est le plus favorable aux conclusions. Les derniers jours portent déjà l''énergie du cycle suivant.',

'La deuxième phase du prochain cycle offrira une énergie de construction parfaite pour les nouveaux projets.',

'Un chapitre se ferme pour qu''un autre s''ouvre. La propriété qui vous attend mérite le bon timing.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier';


-- =============================================
-- DÉMÉNAGEMENT - 7 périodes
-- =============================================

-- Période 1: Initiative
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 5,
'Les vibrations cosmiques actuelles insufflent une énergie puissante de nouveau départ et d''élan. Cette phase d''initiative est naturellement alignée avec les changements de lieu de vie. L''univers soutient les transitions et les nouveaux commencements.',

'Cette période est exceptionnellement favorable pour effectuer un déménagement. Les énergies d''initiative qui vous traversent sont parfaitement alignées avec l''acte de quitter un lieu pour en rejoindre un autre, de tourner une page pour en commencer une nouvelle.

L''enthousiasme naturel de cette phase vous donne l''énergie nécessaire pour accomplir toutes les tâches physiques et organisationnelles que représente un déménagement. Vous trouverez la motivation pour trier, emballer, transporter, déballer et vous installer.

Les débuts dans votre nouveau logement seront marqués par une énergie positive et dynamique. Cette impulsion initiale marquera l''ambiance des premiers mois dans votre nouvel espace de vie.

C''est le moment idéal pour faire le grand saut si vous hésitez. L''élan actuel vous portera à travers les difficultés logistiques inévitables.',

'• Planifiez votre déménagement pour les prochains jours
• Triez vos affaires avec détermination : jetez, donnez, vendez
• Réservez les services nécessaires (déménageurs, véhicule)
• Effectuez tous les changements d''adresse administratifs
• Préparez votre nouveau logement pour l''arrivée
• Célébrez ce nouveau chapitre de vie avec enthousiasme',

'L''énergie d''initiative peut vous pousser à négliger l''organisation. Même dans cet élan, prenez le temps de planifier correctement pour éviter les oublis et les complications.',

'• Se précipiter sans organisation préalable
• Oublier des démarches administratives importantes
• Sous-estimer le temps et les ressources nécessaires
• Emporter des objets inutiles par manque de tri',

'Le début de cette phase est particulièrement dynamique pour les déménagements. Les premières semaines portent l''énergie maximale de nouveau départ.',

'Aucune alternative nécessaire : cette période est idéale pour déménager. Profitez pleinement de cette fenêtre.',

'Chaque déménagement est une renaissance. Votre nouvelle vie vous attend avec toutes ses promesses.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 2: Construction
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 4,
'Les courants cosmiques vous enveloppent dans une vibration de construction et de stabilisation. Cette phase favorise l''établissement de bases solides et l''organisation méthodique. L''énergie présente soutient les installations durables.',

'Cette période est favorable pour un déménagement bien organisé et méthodique. Les énergies de construction qui vous animent vous aident à établir votre nouveau foyer sur des bases solides et structurées.

Vous serez naturellement attentif à l''aspect pratique de l''installation : rangement optimal, organisation des espaces, mise en place de routines fonctionnelles. Cette rigueur vous servira sur le long terme.

Les déménagements effectués durant cette phase tendent à créer des installations durables. Vous prendrez le temps de bien faire les choses, de ranger correctement, d''aménager avec soin.

L''énergie est moins spontanée que lors de la phase précédente, mais plus structurée. C''est le moment de planifier minutieusement si vous n''avez pas encore déménagé.',

'• Organisez votre déménagement avec méthode et planification
• Créez un calendrier détaillé des tâches à accomplir
• Rangez et organisez chaque espace avec soin
• Installez tous les équipements de manière réfléchie
• Établissez les nouvelles routines domestiques
• Documentez l''état du nouveau logement avec photos',

'La rigueur ne doit pas devenir rigidité. Laissez-vous une marge d''adaptation et acceptez que tout ne soit pas parfait immédiatement.',

'• Vouloir tout organiser parfaitement avant de s''installer
• Retarder le déménagement à cause de détails non résolus
• S''épuiser dans l''organisation au détriment de l''essentiel',

'Le cœur de cette phase offre la meilleure énergie pour les installations méthodiques. Évitez les déménagements précipités.',

'La quatrième phase offrira une énergie d''équilibre également favorable pour s''établir harmonieusement.',

'Les fondations que vous posez maintenant soutiendront votre quotidien. Construisez avec patience et attention.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 3: Expansion
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 3,
'Les énergies cosmiques actuelles amplifient vos interactions sociales et votre envie d''expansion. Cette phase de communication et de connexion peut disperser votre énergie si elle est consacrée à des tâches pratiques intensives comme un déménagement.',

'Votre cycle traverse une phase d''expansion sociale qui n''est pas idéalement alignée avec l''effort concentré que demande un déménagement. Les énergies qui vous traversent vous poussent vers les échanges et les interactions plutôt que vers les tâches solitaires d''emballage et d''installation.

Un déménagement effectué maintenant risque d''être perturbé par des obligations sociales, des imprévus relationnels, ou simplement un manque de motivation pour les aspects fastidieux du processus.

Cependant, si le déménagement est inévitable, cette période peut faciliter l''aspect relationnel : communication avec les déménageurs, coordination avec les proches qui vous aident, échanges avec les nouveaux voisins.

Dans l''idéal, reportez à la phase suivante qui offrira une énergie plus favorable à l''installation domestique.',

'• Si déménagement incontournable : sollicitez l''aide de votre réseau
• Déléguez les tâches pratiques à d''autres si possible
• Concentrez-vous sur la coordination et la communication
• Profitez pour faire connaissance avec vos nouveaux voisins
• Organisez un événement de pendaison de crémaillère
• Si possible, reportez les aspects les plus lourds',

'L''énergie de dispersion peut créer des complications logistiques. Les oublis et les retards sont plus probables. Redoublez de vigilance sur l''organisation.',

'• S''engager dans trop d''activités sociales au détriment du déménagement
• Négliger l''aspect pratique au profit du relationnel
• Compter sur une aide qui pourrait faire défaut',

'Les moments de calme au sein de cette période sociale sont à privilégier pour les tâches pratiques.',

'La quatrième phase offrira une énergie d''équilibre et de foyer beaucoup plus favorable.',

'Même dans la dispersion, gardez le cap vers votre nouveau foyer. Chaque effort vous en rapproche.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 4: Équilibre
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations cosmiques vous baignent dans une harmonie profonde, naturellement connectée à la notion de foyer et de vie domestique. Cette phase d''équilibre est idéalement alignée avec l''établissement dans un nouveau lieu de vie.',

'Cette période est exceptionnellement favorable pour s''installer dans un nouveau foyer. Les énergies d''équilibre et de foyer qui vous traversent créent les conditions idéales pour transformer un logement en véritable chez-vous.

L''installation effectuée maintenant sera empreinte d''harmonie. Vous trouverez naturellement les bons placements pour vos meubles, les bonnes couleurs, la bonne organisation. Votre intuition domestique est à son apogée.

Les premiers jours dans votre nouveau logement seront marqués par un sentiment de "être chez soi" qui se développera naturellement. L''espace vous accueille avec bienveillance.

C''est le moment idéal pour créer un cocon où vous pourrez vous épanouir sur le long terme. Les installations faites maintenant tendent à durer et à satisfaire.',

'• Effectuez votre déménagement avec soin et sérénité
• Prenez le temps d''organiser chaque espace harmonieusement
• Créez des ambiances propices au bien-être dans chaque pièce
• Installez les objets qui ont une valeur sentimentale
• Établissez des rituels pour "sacraliser" votre nouvel espace
• Invitez vos proches à découvrir votre nouveau foyer',

'Ne négligez pas l''aspect pratique dans la recherche d''harmonie. L''équilibre inclut la fonctionnalité au quotidien.',

'• Privilégier l''esthétique au détriment du pratique
• Vouloir tout parfait immédiatement sans laisser le temps
• Ignorer les ajustements nécessaires pour le confort réel',

'L''intégralité de cette phase est favorable à l''installation. Le cœur de la période offre la sérénité maximale.',

'Cette période est idéale. Saisissez cette opportunité pour vous établir harmonieusement.',

'Votre nouveau foyer vous accueille avec amour. Laissez-le devenir le sanctuaire de votre épanouissement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 5: Réflexion
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les courants cosmiques vous invitent à un voyage intérieur. Cette phase de réflexion et d''introspection n''est pas propice aux grands bouleversements physiques. L''énergie présente favorise le questionnement et l''analyse plutôt que l''action.',

'Votre cycle traverse actuellement une phase contemplative qui n''est pas recommandée pour effectuer un déménagement. Les énergies de réflexion qui vous habitent peuvent créer des doutes, de la nostalgie, voire une résistance émotionnelle au changement.

Un déménagement effectué maintenant risque d''être vécu difficilement. Vous pourriez ressentir un attachement excessif à votre ancien logement, une mélancolie par rapport à ce que vous quittez, des incertitudes sur la pertinence de ce changement.

Les premiers temps dans votre nouveau logement pourraient être marqués par un sentiment de n''être pas vraiment chez vous, de décalage avec ce nouvel environnement.

Si le déménagement est inévitable, accordez-vous du temps pour le deuil du lieu que vous quittez et soyez patient avec vous-même dans le processus d''adaptation.',

'• Si déménagement incontournable : prenez le temps de dire au revoir
• Créez un rituel de clôture pour votre ancien logement
• Emportez des objets chargés de souvenirs positifs
• Accordez-vous le droit de ressentir la nostalgie
• Préparez-vous mentalement à une période d''adaptation
• Si possible, reportez à une phase plus favorable',

'Les regrets sont possibles après un déménagement dans cette période. Soyez conscient que ces sentiments passeront avec le temps.',

'• Déménager sous la pression sans être émotionnellement prêt
• Couper brutalement les liens avec l''ancien lieu
• Ignorer les signaux émotionnels de résistance',

'Si déménagement incontournable, les moments de calme intérieur sont à privilégier.',

'La première phase du prochain cycle offrira une énergie d''initiative parfaite pour les nouveaux départs.',

'Chaque transition demande son temps. Honorez votre rythme intérieur avec douceur et patience.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 6: Transformation
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 4,
'Les énergies cosmiques portent une vibration puissante de transformation et de renouveau. Cette phase facilite les ruptures avec le passé et les transitions vers une nouvelle vie. C''est un temps de métamorphose profonde.',

'Cette période peut être favorable pour un déménagement qui s''inscrit dans une transformation de vie majeure. Les énergies qui vous traversent soutiennent les ruptures, les changements radicaux, les passages d''une existence à une autre.

Si votre déménagement accompagne un divorce, un nouveau travail dans une autre ville, le début d''une nouvelle vie radicalement différente, les vibrations actuelles peuvent servir de catalyseur positif. L''univers soutient les métamorphoses authentiques.

En revanche, les déménagements "ordinaires" - simples changements pratiques sans dimension transformatrice - ne bénéficient pas particulièrement de cette énergie. L''instabilité de cette phase peut créer des complications inutiles.

Distinguez bien si votre déménagement est un acte de transformation ou une simple commodité. L''alignement avec l''énergie actuelle dépend de cette distinction.',

'• Si déménagement transformationnel : embrassez pleinement le changement
• Laissez derrière vous ce qui appartient à l''ancienne vie
• Triez radicalement : ne gardez que ce qui vous suit dans le nouveau chapitre
• Créez un rituel de passage pendant le déménagement
• Si déménagement ordinaire : reportez si possible
• Évaluez honnêtement la nature de ce changement',

'L''énergie de transformation peut amplifier les émotions. Évitez de prendre des décisions radicales qui ne sont pas vraiment nécessaires.',

'• Confondre fuite et transformation
• Se débarrasser d''objets importants dans l''élan de rupture
• Agir sous le coup d''émotions intenses sans réflexion',

'Les moments de clarté au sein de cette période intense sont à privilégier pour les décisions pratiques.',

'La septième phase offre une énergie de bilan plus posée si le déménagement peut attendre.',

'Chaque transformation est un pont vers une nouvelle version de vous-même. Traversez-le avec conscience.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- Période 7: Bilan
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 3,
'Les vibrations cosmiques portent l''énergie de l''accomplissement et du bilan. Cette phase clôture un cycle et prépare le suivant. Les énergies favorisent la conclusion plutôt que les nouveaux commencements.',

'Votre cycle approche de son accomplissement, créant une énergie mitigée pour un déménagement. Cette phase est plus adaptée à la conclusion de ce qui est en cours qu''au démarrage de quelque chose de nouveau.

Si votre déménagement est déjà planifié et préparé de longue date, l''énergie de conclusion peut aider à finaliser le processus. Vous êtes dans un état d''esprit propice à "boucler les boucles" et à clore un chapitre.

En revanche, démarrer un projet de déménagement maintenant n''est pas optimal. L''énergie de fin de cycle ne soutient pas les grandes initiatives. Il serait plus judicieux de préparer le terrain maintenant et de déménager effectivement lors de la première phase du prochain cycle.

Cette période peut être utilisée pour les préparatifs : tri, emballage, organisation logistique. L''action principale - le déménagement lui-même - gagnerait à être reportée.',

'• Finalisez les préparatifs de déménagement en cours
• Terminez le tri et l''emballage de vos affaires
• Effectuez les démarches administratives préalables
• Préparez votre nouveau logement pour l''arrivée
• Si possible, déménagez physiquement au début du prochain cycle
• Clôturez proprement ce chapitre de vie',

'Ne vous sentez pas obligé de tout terminer maintenant. Un déménagement légèrement reporté en phase 1 sera énergétiquement plus favorable.',

'• Forcer l''achèvement par fatigue ou impatience
• Déménager dans la précipitation de fin de cycle
• Négliger la préparation au profit de l''action immédiate',

'Le début de cette phase est plus favorable aux finalisations que la fin, qui porte déjà l''énergie naissante du cycle suivant.',

'La première phase du prochain cycle offrira une énergie d''initiative parfaite pour le déménagement effectif.',

'Un chapitre se prépare à se clore. Honorez ce temps de transition avec patience et sagesse.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement';


-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Conseils IMMOBILIER (complet) insérés:' AS status;
SELECT dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category = 'immobilier'
GROUP BY dt.label
ORDER BY dt.label;
