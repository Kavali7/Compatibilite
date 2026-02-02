-- =============================================
-- Service 06 - Éclairage Décision
-- CONSEILS ENRICHIS - PARTIE 2: FINANCE
-- 5 types × 7 périodes = 35 conseils
-- =============================================

-- =============================================
-- ACHAT VÉHICULE - 7 périodes
-- =============================================

-- Période 1: Initiative
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
'Les vibrations cosmiques actuelles insufflent une énergie d''élan et de renouveau. Cette phase d''initiative favorise les explorations et les premières démarches. L''enthousiasme naturel de cette période stimule vos recherches.',

'Votre configuration énergétique actuelle crée des conditions favorables pour commencer vos recherches de véhicule. Les énergies d''initiative qui vous traversent vous donnent la motivation nécessaire pour explorer le marché, visiter les concessionnaires et comparer les offres.

Cependant, cette même énergie d''impulsion peut vous pousser à conclure trop rapidement. L''achat d''un véhicule représente un engagement financier significatif qui mérite réflexion. Utilisez cette période pour les recherches préparatoires plutôt que pour la signature définitive.

Les essais que vous effectuerez maintenant vous permettront de clarifier vos besoins réels. Votre perception est aiguisée pour détecter ce qui vous convient ou non. Faites confiance à vos premières impressions lors des essais routiers.',

'• Intensifiez vos recherches en ligne et en concession
• Effectuez plusieurs essais pour comparer les modèles
• Établissez un budget réaliste incluant assurance et entretien
• Comparez les options de financement disponibles
• Constituez votre dossier si crédit nécessaire
• Listez vos critères par ordre de priorité',

'L''enthousiasme peut vous faire négliger des défauts importants. Ne signez pas sous le coup de l''impulsion, même si le vendeur insiste sur l''urgence.',

'• Signer le jour même d''une première visite
• Négliger l''historique d''un véhicule d''occasion
• Sous-estimer les coûts annexes (assurance, carburant, entretien)',

'Le début de cette phase est idéal pour les recherches. Évitez les signatures définitives.',

'La deuxième phase offrira une énergie de construction parfaite pour concrétiser l''achat.',

'Votre futur véhicule vous attend. Prenez le temps de le choisir avec discernement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 2: Construction
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les courants cosmiques vous enveloppent dans une vibration de construction et de stabilisation. Cette phase favorise les acquisitions durables et les engagements réfléchis. Votre discernement pratique est à son apogée.',

'Cette période représente une des configurations les plus favorables pour l''achat d''un véhicule. Les énergies de construction qui vous animent vous aident à faire un choix durable et intelligent.

Votre attention aux détails pratiques est maximale. Vous percevrez naturellement les points importants : fiabilité mécanique, coûts d''usage, valeur de revente. Cette lucidité vous protège des mauvaises affaires.

Les négociations aboutiront à des conditions équilibrées. Votre sérieux inspire confiance aux vendeurs qui seront plus enclins à faire des concessions raisonnables.

C''est le moment idéal pour signer si vous avez identifié le véhicule qui répond à vos besoins. Les achats réalisés maintenant correspondent généralement à des choix satisfaisants sur le long terme.',

'• Finalisez votre choix après comparaison approfondie
• Faites réaliser un contrôle technique complet si occasion
• Négociez le prix et les options avec assurance
• Vérifiez minutieusement tous les documents
• Signez le contrat d''achat avec confiance
• Planifiez les formalités administratives',

'Même dans cette période favorable, ne négligez aucune vérification technique. Une inspection professionnelle reste indispensable pour les véhicules d''occasion.',

'• Sauter l''étape du contrôle technique par confiance excessive
• Accepter des conditions de financement défavorables
• Négliger les garanties et l''après-vente',

'L''intégralité de cette phase est favorable. Le cœur de la période offre une stabilité maximale.',

'Aucune alternative nécessaire : cette période est idéale pour concrétiser.',

'Les décisions mûries portent leurs fruits. Roulez vers l''avenir avec confiance.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 3: Expansion
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies cosmiques amplifient vos capacités de négociation et d''échange. Cette phase de communication favorise les discussions avec les vendeurs et les comparaisons multiples.',

'Votre cycle traverse une phase où votre pouvoir de négociation atteint son expression optimale. C''est le moment idéal pour discuter les prix, obtenir des options supplémentaires ou des remises significatives.

Les échanges avec les vendeurs seront fluides et productifs. Vous trouverez naturellement les arguments pour défendre vos intérêts. Votre éloquence peut vous valoir des conditions avantageuses.

Cette période est également propice pour comparer de nombreuses options. Visitez plusieurs concessionnaires, testez différents modèles, sollicitez plusieurs devis. L''énergie d''expansion favorise l''exploration du marché.

Attention cependant à ne pas vous disperser. Trop d''options peuvent créer de la confusion et retarder votre décision.',

'• Négociez activement le prix et les options
• Sollicitez plusieurs devis concurrents
• Faites jouer la concurrence entre les vendeurs
• Comparez les offres de financement
• Prenez le temps de réfléchir avant de conclure
• Discutez les conditions de reprise si applicable',

'L''abondance d''options peut créer de la confusion. Établissez des critères clairs et éliminez les choix qui ne correspondent pas à vos priorités.',

'• Papillonner entre trop de modèles sans jamais décider
• Se laisser influencer par des arguments commerciaux superficiels
• Négliger l''analyse technique au profit du relationnel',

'Les moments d''échange en milieu de journée sont les plus propices aux négociations.',

'La quatrième phase offrira une énergie d''équilibre favorable pour les décisions finales.',

'Votre parole porte une force de conviction. Utilisez-la pour obtenir le meilleur accord possible.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 4: Équilibre
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations cosmiques vous baignent dans une harmonie profonde. Cette phase d''équilibre favorise les décisions mesurées et les choix qui correspondent vraiment à vos besoins.',

'Cette période offre des conditions idéales pour l''achat d''un véhicule familial ou utilitaire au quotidien. Les énergies d''équilibre qui vous traversent vous guident vers des choix pratiques et adaptés.

Votre capacité à évaluer le rapport qualité/prix est optimale. Vous percevez naturellement si un véhicule correspond à vos besoins réels ou s''il ne s''agit que d''envies passagères. Cette lucidité vous protège des achats impulsifs.

Les transactions effectuées maintenant tendent à être équilibrées pour toutes les parties. Vendeurs et acheteurs trouvent un terrain d''entente naturel.

C''est le moment parfait pour concrétiser si vous cherchez un véhicule pour la vie quotidienne familiale. Les choix faits maintenant satisfont généralement sur la durée.',

'• Évaluez objectivement vos besoins réels de mobilité
• Choisissez un véhicule adapté à votre vie quotidienne
• Considérez les besoins de toute la famille
• Finalisez l''achat avec sérénité
• Vérifiez les aspects pratiques : volume, consommation, confort
• Signez en toute confiance',

'L''équilibre ne doit pas devenir immobilisme. Si le véhicule correspond à vos besoins, n''hésitez plus.',

'• Tergiverser indéfiniment par excès de prudence
• Rechercher la perfection au détriment du bon choix
• Ignorer vos besoins futurs prévisibles',

'L''intégralité de cette phase est favorable aux décisions d''achat équilibrées.',

'Cette période est idéale. Profitez de cette fenêtre énergétique.',

'Le bon choix est celui qui répond à vos vrais besoins. Faites confiance à votre discernement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 5: Réflexion
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 3,
'Les courants cosmiques vous invitent à l''introspection. Cette phase de réflexion favorise l''analyse mais peut créer des doutes. L''énergie présente n''est pas propice aux engagements financiers importants.',

'Votre cycle traverse une phase contemplative qui n''est pas idéale pour finaliser l''achat d''un véhicule. Les énergies de réflexion peuvent générer des incertitudes prolongées ou des regrets après signature.

Cette période est cependant précieuse pour approfondir vos recherches. Étudiez les caractéristiques techniques, lisez les avis d''utilisateurs, comparez les offres sur le papier. Le travail de documentation est favorisé.

Si vous avez déjà repéré un véhicule, prenez du recul avant de vous engager. Les doutes qui peuvent surgir sont des guides : écoutez-les. Si quelque chose vous dérange sans que vous puissiez l''identifier clairement, c''est un signal.

L''action viendra à son heure. Préparez maintenant, achetez plus tard.',

'• Approfondissez vos recherches documentaires
• Analysez les avis et témoignages d''utilisateurs
• Comparez les coûts d''usage sur plusieurs années
• Affinez vos critères de choix
• Si doute sur un véhicule : attendez avant de signer
• Constituez votre dossier de financement',

'Les doutes qui émergent ne doivent pas être ignorés. S''ils persistent, c''est un signal à prendre en compte.',

'• Signer dans un moment de doute ou d''incertitude
• Ignorer les signaux intuitifs négatifs
• Prendre une décision pour "en finir"',

'Les moments de calme sont favorables à l''analyse. Évitez les décisions dans l''agitation.',

'La deuxième phase du prochain cycle offrira une énergie de construction parfaite pour acheter.',

'La patience est une vertu. Le bon véhicule mérite le bon moment.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 6: Transformation
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies cosmiques portent une vibration de transformation. Cette phase peut être favorable si l''achat s''inscrit dans un changement de vie majeur, mais déstabilisante pour les achats conventionnels.',

'Votre cycle traverse une phase de transformation qui crée des conditions singulières pour l''achat d''un véhicule. Cette énergie est favorable si l''acquisition accompagne un changement de vie radical : nouveau travail nécessitant un véhicule, déménagement, changement familial majeur.

Pour les achats "ordinaires" - simple remplacement ou amélioration de confort - les énergies actuelles sont moins favorables. L''instabilité de cette phase peut conduire à des choix que vous regretterez une fois le calme revenu.

Si votre achat de véhicule est intimement lié à une transformation de vie en cours, les vibrations peuvent servir de catalyseur. L''univers soutient les outils qui permettent les transitions.

Pour les achats classiques, mieux vaut patienter.',

'• Si changement de vie majeur : choisissez un véhicule adapté à votre nouvelle situation
• Évaluez si l''achat est vraiment nécessaire maintenant
• Distinguez le besoin réel de l''envie de changement
• Si achat conventionnel : reportez à une période plus stable
• Restez ouvert aux options inhabituelles si transformation en cours
• Ne vous précipitez pas sous la pression du changement',

'Cette période peut amplifier les décisions extrêmes. Un véhicule inadapté peut être source de regrets prolongés.',

'• Acheter dans la précipitation d''un changement de vie
• Confondre envie de changement et besoin réel
• Choisir un véhicule inadapté à votre situation réelle',

'Les moments de clarté au sein de cette période agitée sont à privilégier.',

'La septième phase offre une énergie de bilan plus posée. La deuxième phase prochaine sera idéale.',

'Chaque transformation demande ses propres outils. Choisissez avec discernement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';

-- Période 7: Bilan
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations cosmiques portent l''énergie de l''accomplissement. Cette phase favorise la conclusion des projets mûris plutôt que les nouveaux départs. C''est un temps de finalisation.',

'Votre cycle approche de son accomplissement, créant une énergie favorable pour finaliser un projet d''achat de véhicule déjà avancé. Si vous recherchez depuis plusieurs semaines, cette période peut être propice à la conclusion.

Les décisions prises maintenant portent une énergie de maturité. Vous avez eu le temps de comparer, de réfléchir, de peser le pour et le contre. Cette réflexion aboutit naturellement à un choix éclairé.

En revanche, démarrer de nouvelles recherches n''est pas optimal. L''énergie de fin de cycle ne favorise pas les explorations fraîches. Si vous n''avez pas encore trouvé, préparez le prochain cycle.

Pour ceux qui ont un choix mûri, c''est le moment de conclure avant le renouveau qui s''annonce.',

'• Finalisez les négociations en cours
• Signez le contrat d''achat pour clore ce chapitre
• Préparez les formalités administratives
• Si pas de véhicule trouvé : préparez votre stratégie future
• Terminez les comparaisons en cours
• Dressez le bilan de vos recherches',

'Ne forcez pas la conclusion si aucun véhicule ne vous convient vraiment. Reporter sera plus sage que d''acheter par fatigue.',

'• Signer par lassitude plutôt que par conviction
• Négliger les dernières vérifications dans la précipitation
• Démarrer de nouvelles recherches qui s''éterniseront',

'Le début de cette phase est plus favorable aux conclusions que la fin.',

'La première phase du prochain cycle offrira un élan parfait pour de nouvelles recherches.',

'Un chapitre se ferme pour qu''un autre s''ouvre. Faites confiance au rythme de votre destinée.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_vehicule';


-- =============================================
-- ACHAT IMPORTANT - 7 périodes
-- =============================================

-- Période 1
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 1, 4,
'Les vibrations cosmiques insufflent une énergie d''élan. Cette phase d''initiative favorise les recherches et les comparaisons actives.',

'Votre configuration énergétique stimule l''exploration des options pour vos achats importants. C''est le moment idéal pour comparer les produits, visiter les magasins et solliciter des devis.

L''enthousiasme de cette période vous donne la motivation pour entreprendre ces démarches parfois fastidieuses. Profitez de cet élan pour constituer un panorama complet des possibilités.

Cependant, gardez à l''esprit que les achats impulsifs peuvent mener à des regrets. Utilisez cette phase pour explorer et comparer, pas nécessairement pour conclure. La réflexion viendra compléter l''action.',

'• Intensifiez vos recherches et comparaisons
• Visitez les points de vente pour voir les produits
• Sollicitez plusieurs devis et offres
• Testez les produits quand c''est possible
• Établissez votre budget maximum
• Listez vos critères prioritaires',

'L''enthousiasme peut vous faire négliger la réflexion. Évitez les achats le jour même de la découverte du produit.',

'• Acheter sous l''impulsion du moment
• Négliger la comparaison des prix et des garanties
• Se laisser emporter par les arguments commerciaux',

'Le début de phase est idéal pour les recherches. Évitez les conclusions précipitées.',

'La deuxième phase offrira une énergie de construction parfaite pour acheter.',

'Chaque exploration vous rapproche du meilleur choix.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 2
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 2, 5,
'Les courants cosmiques vous enveloppent dans une énergie de construction. Cette phase favorise les achats durables et les investissements de qualité.',

'Cette période est exceptionnellement favorable pour les achats importants destinés à durer. Les énergies de construction vous guident vers des produits de qualité qui vous satisferont sur le long terme.

Votre attention aux détails pratiques est aiguisée. Vous percevrez naturellement la qualité de fabrication, la durabilité, le rapport qualité/prix. Cette lucidité vous protège des achats décevants.

C''est le moment idéal pour investir dans des équipements durables : électroménager de qualité, mobilier solide, équipement professionnel. Les achats réalisés maintenant tendent à durer et à satisfaire.',

'• Finalisez vos choix après comparaison
• Privilégiez la qualité sur le prix immédiat
• Vérifiez les garanties et le service après-vente
• Investissez dans des produits durables
• Négociez les meilleures conditions
• Effectuez vos achats avec confiance',

'Même dans cette période favorable, comparez les prix. La qualité ne justifie pas n''importe quel tarif.',

'• Négliger la comparaison des prix par confiance excessive
• Acheter sans vérifier les conditions de garantie
• Ignorer les avis d''autres utilisateurs',

'L''intégralité de cette phase est favorable aux achats durables.',

'Cette période est idéale. Profitez-en pleinement.',

'Les investissements de qualité créent le confort durable.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 3
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 3, 4,
'Les énergies cosmiques amplifient vos capacités de négociation. Cette phase de communication favorise les discussions de prix et les comparaisons.',

'Votre cycle traverse une phase où vos capacités de négociation sont optimales. C''est le moment idéal pour obtenir remises, options supplémentaires ou conditions avantageuses.

Les échanges avec les vendeurs seront fluides. Votre charisme commercial naturel vous permet d''obtenir des concessions que vous n''auriez pas eues à un autre moment.

Profitez également pour comparer de nombreuses options. L''énergie d''expansion favorise l''exploration du marché et la découverte d''alternatives intéressantes.',

'• Négociez activement les prix
• Demandez des remises et des offres spéciales
• Comparez plusieurs vendeurs
• Faites jouer la concurrence
• Sollicitez les meilleures conditions de livraison
• Discutez les garanties étendues',

'L''abondance d''options peut créer de la confusion. Gardez vos critères prioritaires en tête.',

'• Se disperser entre trop de possibilités
• Acheter uniquement parce que le prix est bon
• Négliger la qualité au profit de la négociation',

'Les moments de négociation en milieu de journée sont les plus favorables.',

'La quatrième phase offrira une énergie d''équilibre pour les décisions finales.',

'Votre parole porte une force de persuasion. Utilisez-la pour obtenir le meilleur.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 4
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 4, 5,
'Les vibrations cosmiques vous baignent dans une harmonie profonde. Cette phase d''équilibre favorise les achats pour le foyer et la vie quotidienne.',

'Cette période est idéale pour les achats destinés à améliorer votre confort domestique et familial. Les énergies d''équilibre vous guident vers des choix adaptés à vos besoins réels.

Votre capacité à évaluer le rapport qualité/prix est optimale. Vous percevrez naturellement si un produit vaut son prix et s''il correspond à votre usage prévu.

C''est le moment parfait pour l''électroménager, le mobilier, les équipements du foyer. Les achats effectués maintenant s''intègreront harmonieusement à votre quotidien.',

'• Évaluez objectivement vos besoins réels
• Choisissez des produits adaptés à votre usage
• Considérez les besoins de toute la famille
• Finalisez vos achats avec sérénité
• Vérifiez la compatibilité avec votre espace
• Privilégiez le confort pratique',

'L''équilibre ne doit pas devenir indécision. Si le produit convient, passez à l''action.',

'• Tergiverser indéfiniment par excès de prudence
• Rechercher la perfection au détriment du bon choix
• Acheter plus que nécessaire',

'L''intégralité de cette phase est favorable aux achats équilibrés.',

'Cette période est idéale. Saisissez cette opportunité.',

'Le bon achat est celui qui améliore votre quotidien.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 5
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 5, 2,
'Les courants cosmiques vous invitent à la réflexion. Cette phase d''introspection n''est pas propice aux achats impulsifs ou aux engagements financiers significatifs.',

'Votre cycle traverse une phase contemplative qui n''est pas recommandée pour les achats importants. Les énergies de réflexion peuvent générer des doutes prolongés ou des regrets après achat.

Cette période est précieuse pour approfondir vos recherches documentaires. Étudiez les caractéristiques techniques, lisez les comparatifs et les avis. Préparez votre décision future.

Si un produit vous tente, accordez-vous un délai de réflexion supplémentaire. Les doutes qui surgissent sont des guides à écouter.',

'• Approfondissez vos recherches documentaires
• Analysez les avis et comparatifs
• Affinez vos critères de choix
• Reportez les achats significatifs si possible
• Constituez un dossier complet sur les options
• Prenez du recul par rapport aux envies immédiates',

'Les doutes persistants sont des signaux. Ne forcez pas une décision qui ne vous convainc pas pleinement.',

'• Acheter dans un moment d''incertitude
• Ignorer les signaux de doute
• Forcer une décision pour "en finir"',

'Les moments de calme favorisent l''analyse. Évitez les décisions impulsives.',

'La deuxième phase du prochain cycle sera beaucoup plus favorable.',

'La patience est une vertu. Le bon moment viendra.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 6
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 6, 3,
'Les énergies cosmiques portent une vibration de transformation. Cette phase peut être favorable pour les achats liés à un changement de vie, moins pour les achats conventionnels.',

'Votre cycle traverse une phase de transformation qui crée des conditions singulières. Cette énergie convient si l''achat accompagne un changement majeur : équipement pour une nouvelle activité, mobilier pour un nouveau logement, outils pour une reconversion.

Pour les achats "ordinaires" sans dimension transformatrice, les énergies sont moins favorables. L''instabilité peut conduire à des choix inadaptés une fois le calme revenu.

Évaluez honnêtement la nature de votre achat avant de conclure.',

'• Si changement de vie : choisissez l''équipement adapté
• Distinguez le besoin réel de l''envie de changement
• Si achat conventionnel : reportez si possible
• Restez ouvert aux options inhabituelles si transformation
• Ne précipitez pas sous l''effet du changement
• Évaluez vos besoins futurs réels',

'Cette période peut amplifier les décisions extrêmes. Un achat inadapté sera source de regrets.',

'• Acheter dans la précipitation du changement
• Confondre envie de nouveauté et besoin réel
• Choisir sans réflexion approfondie',

'Les moments de clarté au sein de cette période sont à privilégier.',

'La septième phase sera plus posée. Le prochain cycle offrira de meilleures opportunités.',

'Chaque transformation demande ses propres outils, au bon moment.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- Période 7
INSERT INTO cycle_vie_decision_advice (
  decision_type_id, cycle_type, period_number, favorability_score,
  cosmic_context, advice_text, recommended_actions, warnings,
  pitfalls_to_avoid, optimal_timing, alternatives_suggestion, closing_message
)
SELECT dt.id, 'personal', 7, 4,
'Les vibrations cosmiques portent l''énergie de l''accomplissement. Cette phase favorise la finalisation des projets d''achat mûris depuis longtemps.',

'Votre cycle approche de son accomplissement, créant une énergie favorable pour conclure un projet d''achat réfléchi depuis longtemps. Si vous comparez et analysez depuis plusieurs semaines, c''est le moment de trancher.

Les décisions prises maintenant portent une énergie de maturité. Vous avez eu le temps de la réflexion, et votre choix sera éclairé.

En revanche, démarrer de nouvelles recherches n''est pas optimal. Préparez le terrain pour le prochain cycle si vous n''avez pas encore trouvé.',

'• Finalisez les choix mûris
• Effectuez les achats préparés de longue date
• Terminez les comparaisons en cours
• Préparez vos prochaines recherches si nécessaire
• Ne démarrez pas de nouvelles explorations
• Clôturez ce chapitre de décision',

'Ne forcez pas la conclusion si aucune option ne vous satisfait vraiment.',

'• Acheter par fatigue de chercher
• Négliger les dernières vérifications
• Démarrer de nouvelles recherches qui s''éterniseront',

'Le début de cette phase est plus favorable aux conclusions.',

'Le prochain cycle offrira un élan frais pour de nouvelles recherches.',

'Chaque fin annonce un commencement.'

FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_important';

-- =============================================
-- VÉRIFICATION PARTIELLE
-- =============================================
SELECT 'Conseils FINANCE (partie 1) insérés:' AS status;
SELECT dt.label, COUNT(a.id) as nb_periodes 
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
WHERE dt.category = 'finance'
GROUP BY dt.label
ORDER BY dt.label;
