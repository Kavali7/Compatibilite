-- ===========================================================
-- MIGRATION ENRICHISSEMENT Service 06 — PARTIE 2/2
-- Peuplement des 5 colonnes enrichies
-- Exécuter APRÈS migration_enrichissement_part1.sql
-- ===========================================================

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 1 (Initiative)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les vibrations cosmiques actuelles vous placent dans une phase d''élan et de renouveau énergétique. L''univers amplifie votre capacité à percevoir les opportunités et à saisir les occasions favorables. Cette énergie d''initiative crée un terrain propice aux nouvelles recherches et premiers contacts. Votre intuition est particulièrement aiguisée.',
  recommended_actions = '• Définissez vos objectifs avec précision et ambition
• Lancez les démarches concrètes sans hésiter
• Multipliez les contacts et les recherches
• Faites confiance à vos premières impressions
• Documentez chaque option avec soin
• Consultez un expert si le sujet est complexe',
  pitfalls_to_avoid = '• Se laisser emporter par l''enthousiasme sans vérifier les détails
• Ignorer les signaux d''alerte par excès d''optimisme
• S''engager sous pression sans avoir exploré d''autres options
• Négliger la lecture des documents avant signature',
  optimal_timing = 'Les premiers jours de cette phase portent l''énergie la plus dynamique. Privilégiez les matinées pour les décisions importantes. Le début de semaine est idéal pour lancer de nouvelles démarches.',
  closing_message = 'L''univers soutient vos initiatives avec bienveillance. Chaque premier pas courageux vous rapproche de votre destinée. Avancez avec confiance.'
WHERE cycle_type = 'personal' AND period_number = 1;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 2 (Construction)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies cosmiques vous enveloppent dans une vibration de construction et de stabilisation. Cette phase favorise les fondations durables et les engagements à long terme. L''univers soutient vos efforts pour créer une base solide dans votre vie. Votre capacité à évaluer les aspects pratiques et concrets est développée.',
  recommended_actions = '• Finalisez les démarches et négociations en cours
• Relisez attentivement tous les documents avant engagement
• Négociez les détails avec assurance et méthode
• Préparez soigneusement la mise en œuvre pratique
• Constituez un budget réaliste incluant toutes les charges
• Documentez l''ensemble de vos décisions',
  pitfalls_to_avoid = '• S''engager sans avoir vérifié tous les aspects pratiques
• Accepter des conditions trop rigides par excès de confiance
• Négliger les formalités administratives et légales
• Sous-estimer les coûts cachés ou les charges annexes',
  optimal_timing = 'Le cœur de cette phase offre les meilleures énergies de stabilisation. Les signatures effectuées en milieu de période bénéficient d''un ancrage optimal. Les après-midis sont propices aux réflexions approfondies.',
  closing_message = 'Les fondations que vous posez maintenant porteront vos projets pendant longtemps. Construisez avec patience et confiance, l''univers bénit les bâtisseurs.'
WHERE cycle_type = 'personal' AND period_number = 2;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 3 (Communication)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les courants cosmiques amplifient vos capacités de communication et d''échange. Cette phase d''expansion sociale facilite les interactions avec autrui. Votre charisme naturel s''exprime avec fluidité, créant des connexions authentiques. Les négociations et discussions sont particulièrement favorisées.',
  recommended_actions = '• Contactez directement les interlocuteurs clés pour négocier
• Exprimez clairement vos besoins et écoutez attentivement
• Sollicitez l''avis de personnes de confiance
• Explorez les possibilités de personnalisation
• Renseignez-vous auprès de sources multiples
• Utilisez votre éloquence naturelle dans les échanges',
  pitfalls_to_avoid = '• Papillonner entre trop de possibilités sans se décider
• Faire des promesses à plusieurs parties simultanément
• S''emballer dans les discussions au point d''oublier ses besoins réels
• Disperser son énergie sur trop de fronts à la fois',
  optimal_timing = 'Les échanges en fin de matinée ou milieu d''après-midi sont les plus propices. Évitez les négociations importantes en soirée quand la fatigue brouille le jugement. Le milieu de semaine est optimal.',
  closing_message = 'Votre parole porte une force particulière en ce moment. Utilisez ce pouvoir de communication pour manifester la réalité qui correspond à votre essence profonde.'
WHERE cycle_type = 'personal' AND period_number = 3;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 4 (Équilibre)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les vibrations cosmiques vous baignent dans une énergie d''harmonie et d''équilibre profond. Cette phase est connectée aux questions de foyer, de famille et de stabilité intérieure. L''univers favorise la création d''espaces où règnent paix et sérénité. Votre sensibilité aux ambiances est à son apogée.',
  recommended_actions = '• Visitez les options en fin de journée pour ressentir l''atmosphère
• Imaginez-vous vivre quotidiennement avec cette décision
• Évaluez l''impact sur votre équilibre de vie global
• Considérez l''avis de vos proches et de votre famille
• Signez ou engagez-vous dans un état d''esprit serein
• Planifiez la mise en œuvre avec harmonie',
  pitfalls_to_avoid = '• Se laisser guider uniquement par l''émotion sans vérifier les faits
• Idéaliser une situation au point d''ignorer ses aspects négatifs
• S''engager dans quelque chose de mal adapté à vos besoins réels
• Éviter les décisions difficiles sous prétexte de maintenir la paix',
  optimal_timing = 'L''énergie d''équilibre est constante tout au long de cette phase. Les décisions prises en fin de période créent un ancrage particulièrement durable. Les moments calmes et sereins sont les plus propices.',
  closing_message = 'L''harmonie que vous cherchez est déjà en vous. Chaque décision prise dans la sérénité porte les graines d''un avenir paisible et épanouissant.'
WHERE cycle_type = 'personal' AND period_number = 4;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 5 (Réflexion)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les courants cosmiques vous invitent à un voyage intérieur profond. Cette phase de réflexion et d''introspection favorise l''analyse plutôt que l''action. L''énergie présente vous pousse à questionner, réévaluer et comprendre vos véritables besoins. C''est un temps de maturation et de sagesse.',
  recommended_actions = '• Prenez du recul avant toute décision importante
• Analysez votre situation avec objectivité et profondeur
• Discutez de votre projet avec des proches de confiance
• Enrichissez votre réflexion par la lecture et la recherche
• Établissez une liste de critères non négociables
• Méditez sur ce que vous voulez vraiment',
  pitfalls_to_avoid = '• Prendre une décision hâtive pour échapper au questionnement
• Ignorer les doutes et signaux intuitifs négatifs
• S''engager dans un moment d''incertitude ou de confusion
• Procrastiner indéfiniment en attendant une certitude absolue',
  optimal_timing = 'Les moments de calme et de solitude en début de journée favorisent la réflexion. Évitez les décisions dans l''agitation. Reportez les engagements majeurs au milieu de cette phase si possible.',
  closing_message = 'Chaque question qui émerge vous rapproche de la clarté. Honorez ce temps de préparation intérieure, car la sagesse naît de la patience.'
WHERE cycle_type = 'personal' AND period_number = 5;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 6 (Transformation)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies cosmiques portent une puissante vibration de transformation et de renouveau profond. Cette phase bouleverse les anciennes structures pour faire place au nouveau. C''est un temps de remise en question radicale où les changements majeurs de vie sont facilités mais aussi amplifiés.',
  recommended_actions = '• Acceptez que cette période est transitoire et utilisez-la
• Privilégiez les solutions flexibles aux engagements rigides
• Restez ouvert aux options inhabituelles ou inattendues
• Si en transition de vie : concentrez-vous sur l''essentiel
• Épurez vos attentes pour ne garder que le nécessaire
• Considérez chaque décision comme une étape, non une finalité',
  pitfalls_to_avoid = '• S''engager dans un bail long terme en pleine turbulence émotionnelle
• Fuir une situation vers n''importe quelle alternative sans réflexion
• Laisser l''urgence dicter des choix que vous refuseriez en temps normal
• Prendre des décisions irréversibles sous le coup des émotions',
  optimal_timing = 'Les moments de calme au sein de cette période agitée sont les plus propices. Attendez un sentiment de relative sérénité avant de vous engager. Les décisions du matin sont plus lucides.',
  closing_message = 'Chaque fin annonce un commencement plus lumineux. La transformation que vous traversez vous prépare à accueillir ce qui vous attend de meilleur.'
WHERE cycle_type = 'personal' AND period_number = 6;

-- ─────────────────────────────────────────────
-- CYCLE PERSONAL — PÉRIODE 7 (Bilan)
-- ─────────────────────────────────────────────
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les vibrations cosmiques portent l''énergie de l''accomplissement et du bilan. Cette phase clôture un cycle complet et prépare le suivant. Les énergies favorisent la conclusion des projets en cours plutôt que les nouveaux commencements. C''est un temps de récolte, de synthèse et de gratitude.',
  recommended_actions = '• Finalisez les dossiers et négociations en cours
• Dressez le bilan de ce cycle : qu''avez-vous appris ?
• Préparez votre stratégie pour le prochain cycle
• Terminez les formalités administratives pendantes
• Concluez ce qui peut l''être, reportez le reste avec sagesse
• Célébrez vos accomplissements et tirez les leçons',
  pitfalls_to_avoid = '• S''engager dans un nouveau projet majeur en fin de cycle
• Conclure sous pression par fatigue plutôt que par conviction
• Négliger les derniers détails dans la précipitation de finir
• Démarrer quelque chose qui ne pourra pas aboutir avant le renouveau',
  optimal_timing = 'Le début de cette phase est le plus favorable aux conclusions et finalisations. Les derniers jours portent déjà l''énergie du cycle suivant. Profitez du milieu de phase pour les bilans.',
  closing_message = 'Un chapitre se ferme pour qu''un autre s''ouvre. Faites confiance au rythme de votre destinée. La sagesse acquise éclairera le prochain cycle.'
WHERE cycle_type = 'personal' AND period_number = 7;


-- ═══════════════════════════════════════════════
-- CYCLE DAILY — TOUTES PÉRIODES (1-7)
-- ═══════════════════════════════════════════════

-- DAILY P1 (Influence)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie quotidienne d''influence active votre pouvoir de persuasion et votre capacité à orienter les événements. Cette journée ouvre des portes grâce à votre magnétisme naturel. Les premiers contacts sont favorisés.',
  recommended_actions = '• Sollicitez et persuadez : cette énergie soutient l''influence positive
• Démarrez vos projets et présentez vos idées
• Prenez les devants dans les négociations
• Planifiez vos stratégies pour les jours suivants',
  pitfalls_to_avoid = '• Attendre passivement que les choses arrivent
• Procrastiner sur les décisions importantes
• Sous-estimer votre pouvoir d''influence actuel',
  optimal_timing = 'Toute la journée est favorable, avec un pic d''énergie le matin. Profitez des premières heures pour les démarches les plus ambitieuses.',
  closing_message = 'L''influence est votre alliée aujourd''hui. Utilisez-la avec sagesse et bienveillance pour façonner votre destin.'
WHERE cycle_type = 'daily' AND period_number = 1;

-- DAILY P2 (Social)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie sociale du jour amplifie vos connexions humaines. Les contacts et les échanges sont bénis par les astres. Votre charme naturel rayonne et facilite les rapprochements professionnels et personnels.',
  recommended_actions = '• Privilégiez les réunions et contacts sociaux importants
• Négociez avec grâce et diplomatie
• Renforcez vos relations clés
• Soignez votre image et votre présentation',
  pitfalls_to_avoid = '• S''isoler pour un travail solitaire intense
• Entrer en confrontation directe
• Négliger les opportunités de networking',
  optimal_timing = 'Les moments sociaux en milieu de journée sont les plus bénéfiques. Les déjeuners d''affaires et rencontres informelles portent des fruits.',
  closing_message = 'Les relations humaines sont le trésor de la vie. Cultivez-les avec sincérité et les portes s''ouvriront d''elles-mêmes.'
WHERE cycle_type = 'daily' AND period_number = 2;

-- DAILY P3 (Connaissance)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de connaissance stimule votre intellect et favorise l''apprentissage. Votre esprit est vif et réceptif. Les informations cruciales se révèlent naturellement à vous. La clarté mentale est exceptionnelle.',
  recommended_actions = '• Consacrez du temps à la recherche et à l''analyse
• Rédigez les documents importants et correspondances
• Étudiez les dossiers complexes en profondeur
• Prenez des décisions basées sur les faits',
  pitfalls_to_avoid = '• Prendre des décisions financières majeures sous l''impulsion
• Se disperser dans trop de lectures sans synthèse
• Négliger l''aspect émotionnel des décisions',
  optimal_timing = 'Les moments de concentration en début de matinée sont optimaux. L''après-midi est propice à la rédaction et à la communication écrite.',
  closing_message = 'La connaissance est une lumière qui éclaire chaque décision. Nourrissez votre esprit et les réponses viendront naturellement.'
WHERE cycle_type = 'daily' AND period_number = 3;

-- DAILY P4 (Matériel)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie matérielle du jour oriente votre attention vers les aspects concrets et pratiques. C''est un temps pour la gestion, l''organisation et les affaires d''argent. Votre pragmatisme est votre meilleur atout.',
  recommended_actions = '• Traitez les questions financières et administratives
• Organisez et structurez vos projets en cours
• Gérez les aspects matériels en attente
• Faites le point sur votre budget et vos dépenses',
  pitfalls_to_avoid = '• Lancer de nouveaux projets créatifs ou émotionnels
• Prendre des décisions affectives importantes
• Négliger les détails bureaucratiques',
  optimal_timing = 'La journée entière est neutre mais stable. Profitez de cette constance pour les tâches méthodiques. Les heures de bureau classiques sont optimales.',
  closing_message = 'La solidité des fondations matérielles permet à l''esprit de s''élever. Prenez soin de l''essentiel aujourd''hui.'
WHERE cycle_type = 'daily' AND period_number = 4;

-- DAILY P5 (Action)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie d''action du jour vous pousse à trancher et à avancer. C''est un moment de décision, d''arbitrage et de résolution. Les projets stagnants trouvent enfin leur élan. Votre détermination est maximale.',
  recommended_actions = '• Prenez les décisions importantes sans hésiter
• Faites avancer les projets en cours de façon décisive
• Arbitrez les situations conflictuelles avec fermeté
• Résolvez les problèmes qui traînent depuis longtemps',
  pitfalls_to_avoid = '• Reporter encore ce qui doit être décidé maintenant
• Hésiter devant les choix difficiles
• Lancer de nouvelles initiatives non préparées',
  optimal_timing = 'Le pic d''énergie d''action est en milieu de journée. Les décisions prises entre 10h et 14h portent la plus grande force de réalisation.',
  closing_message = 'L''action est la clé de la manifestation. Ce que vous décidez aujourd''hui avec courage devient réalité demain.'
WHERE cycle_type = 'daily' AND period_number = 5;

-- DAILY P6 (Succès)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de succès du jour baigne vos actions dans une lumière de réussite. C''est le moment idéal pour conclure, finaliser et récolter les fruits de vos efforts. Les demandes formulées aujourd''hui trouvent des réponses favorables.',
  recommended_actions = '• Concluez les affaires et négociations en cours
• Demandez les promotions, faveurs ou signatures
• Finalisez les dossiers importants
• Profitez de cette fenêtre favorable pour les engagements',
  pitfalls_to_avoid = '• Démarrer de longs projets au lieu de conclure
• Éviter les engagements par peur du succès
• Ne pas profiter de cette fenêtre exceptionnelle',
  optimal_timing = 'Toute la journée est exceptionnellement favorable. Les signatures et conclusions en fin de matinée portent le sceau de la réussite durable.',
  closing_message = 'Le succès sourit à ceux qui sont prêts à le recevoir. Aujourd''hui, les étoiles s''alignent en votre faveur.'
WHERE cycle_type = 'daily' AND period_number = 6;

-- DAILY P7 (Réflexion)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de réflexion du jour invite au repos et à l''introspection. C''est un temps pour recharger les batteries, méditer sur les prochaines étapes et laisser décanter les décisions récentes. La sagesse naît dans le silence.',
  recommended_actions = '• Consacrez du temps à la méditation et à la réflexion
• Planifiez les prochaines étapes sans agir immédiatement
• Reposez-vous physiquement et mentalement
• Évaluez les résultats de vos actions récentes',
  pitfalls_to_avoid = '• Lancer de nouvelles initiatives majeures
• Prendre des décisions irréversibles sous la fatigue
• Faire des efforts intenses qui épuisent vos réserves',
  optimal_timing = 'Les heures calmes du matin sont propices à la méditation. Évitez les décisions importantes après 15h quand l''énergie décline naturellement.',
  closing_message = 'Le repos est aussi un acte de courage. Dans le silence intérieur, votre prochaine grande inspiration prend forme.'
WHERE cycle_type = 'daily' AND period_number = 7;


-- ═══════════════════════════════════════════════
-- CYCLE BUSINESS — TOUTES PÉRIODES (1-7)
-- ═══════════════════════════════════════════════

-- BUSINESS P1 (Initiative)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies d''initiative business sont à leur maximum. Cette phase favorise les lancements, les premiers contacts commerciaux et l''audace entrepreneuriale. L''univers soutient les pionniers et les créateurs.',
  recommended_actions = '• Lancez vos projets ambitieux et prenez l''initiative
• Prospectez de nouveaux marchés et opportunités
• Préparez vos business plans et stratégies
• Contactez les partenaires et investisseurs potentiels',
  pitfalls_to_avoid = '• Agir sans business plan ni vision stratégique
• Sous-estimer les ressources nécessaires
• Ignorer les études de marché préliminaires',
  optimal_timing = 'Le début de cette phase porte l''énergie la plus entrepreneuriale. Lancez vos initiatives dans les premiers jours pour profiter de l''élan maximal.',
  closing_message = 'L''esprit d''entreprise est une flamme sacrée. Nourrissez-la avec vision et les étoiles illumineront votre chemin commercial.'
WHERE cycle_type = 'business' AND period_number = 1;

-- BUSINESS P2 (Croissance)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies de croissance et de consolidation business sont actives. Cette phase soutient l''expansion réfléchie et le renforcement des acquis. L''univers favorise la construction méthodique du succès.',
  recommended_actions = '• Consolidez et développez les résultats obtenus
• Structurez vos équipes et processus
• Réinvestissez les bénéfices stratégiquement
• Renforcez les partenariats existants',
  pitfalls_to_avoid = '• Grandir trop vite sans consolider les bases
• Négliger les équipes actuelles au profit de la croissance
• Ignorer les signes de fatigue organisationnelle',
  optimal_timing = 'Le milieu de cette phase offre la meilleure stabilité pour la croissance. Les décisions d''expansion en début de semaine sont les plus porteuses.',
  closing_message = 'La croissance durable naît de fondations solides. Chaque pas méthodique vous rapproche du sommet.'
WHERE cycle_type = 'business' AND period_number = 2;

-- BUSINESS P3 (Communication)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies de communication et marketing sont à leur apogée. Cette phase favorise les présentations, les pitchs et les campagnes. Votre éloquence professionnelle atteint son expression optimale.',
  recommended_actions = '• Lancez vos campagnes de communication et marketing
• Préparez et donnez vos meilleures présentations
• Négociez avec éloquence et conviction
• Développez votre visibilité et votre marque',
  pitfalls_to_avoid = '• Communiquer sans message clair ni stratégie
• Promettre plus que ce que vous pouvez livrer
• Disperser votre message sur trop de canaux',
  optimal_timing = 'Les présentations en fin de matinée captent la meilleure attention. Les campagnes lancées en milieu de phase ont le plus grand impact.',
  closing_message = 'Votre voix porte la force de votre vision. Communiquez avec authenticité et le monde écoutera.'
WHERE cycle_type = 'business' AND period_number = 3;

-- BUSINESS P4 (Travail)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies de travail et de structure dominent cette phase. C''est le temps de la production, de l''exécution et de l''optimisation des processus. L''univers récompense la discipline et la méthode.',
  recommended_actions = '• Concentrez-vous sur la production et la livraison
• Optimisez vos processus et workflows
• Résolvez les problèmes opérationnels en suspens
• Formez et encadrez vos équipes',
  pitfalls_to_avoid = '• Lancer de nouveaux projets au détriment de l''existant
• Négliger la qualité au profit de la quantité
• Prendre des risques financiers non calculés',
  optimal_timing = 'Les heures de bureau classiques sont les plus productives. Planifiez les tâches exigeantes le matin quand l''énergie de concentration est maximale.',
  closing_message = 'Le travail assidu est la fondation invisible du succès. Produisez avec excellence et les résultats parleront d''eux-mêmes.'
WHERE cycle_type = 'business' AND period_number = 4;

-- BUSINESS P5 (Expansion)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies d''expansion et d''opportunités business sont intenses. Cette phase offre des ouvertures exceptionnelles pour la croissance et les partenariats stratégiques. L''univers amplifie votre capacité à attirer les opportunités.',
  recommended_actions = '• Saisissez les opportunités d''expansion qui se présentent
• Élargissez votre réseau et vos marchés
• Négociez les contrats et partenariats avantageux
• Investissez dans la croissance à long terme',
  pitfalls_to_avoid = '• Laisser passer les opportunités par timidité
• S''éparpiller sur trop de fronts simultanément
• Oublier les fondamentaux au profit de l''expansion',
  optimal_timing = 'Toute cette phase est fertile pour les opportunités. Les moments de rencontre informelle peuvent générer les meilleures connexions business.',
  closing_message = 'L''expansion est le mouvement naturel du succès. Grandissez avec sagesse et les portes ne cesseront de s''ouvrir.'
WHERE cycle_type = 'business' AND period_number = 5;

-- BUSINESS P6 (Consolidation)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies de consolidation et de prudence business dominent cette phase. C''est le moment d''optimiser l''existant et de préparer le terrain pour la prochaine expansion. L''univers vous invite à la sagesse stratégique.',
  recommended_actions = '• Optimisez votre trésorerie et réduisez les dépenses inutiles
• Renforcez les relations clients et partenaires existantes
• Formez vos équipes et documentez vos processus
• Préparez la stratégie pour le prochain cycle d''expansion',
  pitfalls_to_avoid = '• Prendre des risques financiers importants en période de consolidation
• Lancer de nouveaux projets coûteux sans marge de sécurité
• Ignorer les signaux de ralentissement du marché',
  optimal_timing = 'Les bilans et analyses sont optimaux en début de phase. Les ajustements stratégiques en milieu de période portent leurs fruits rapidement.',
  closing_message = 'La prudence n''est pas la peur mais la sagesse. Consolidez vos acquis et préparez le terrain pour une nouvelle floraison.'
WHERE cycle_type = 'business' AND period_number = 6;

-- BUSINESS P7 (Bilan)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'Les énergies de bilan et de préparation business closent ce cycle. C''est le temps de la récolte, de l''évaluation et de la planification stratégique. L''univers honore ceux qui savent faire le point avant de repartir.',
  recommended_actions = '• Dressez le bilan complet de ce cycle business
• Finalisez les contrats et projets en cours
• Évaluez les performances de vos équipes et processus
• Planifiez les objectifs du prochain cycle stratégique',
  pitfalls_to_avoid = '• Commencer de nouveaux projets importants en fin de cycle
• Négliger le bilan par empressement vers le futur
• Laisser traîner des dossiers non résolus',
  optimal_timing = 'Le début de cette phase est optimal pour les conclusions. Le milieu est idéal pour les bilans. La fin prépare naturellement le renouveau.',
  closing_message = 'Chaque fin de cycle porte en elle la semence du suivant. Récoltez avec gratitude et semez avec vision pour demain.'
WHERE cycle_type = 'business' AND period_number = 7;


-- ═══════════════════════════════════════════════
-- CYCLE HEALTH — TOUTES PÉRIODES (1-7)
-- ═══════════════════════════════════════════════

-- HEALTH P1 (Vitalité)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie vitale est à son maximum. Votre corps est résistant, votre récupération rapide. Les forces cosmiques soutiennent les projets nécessitant vigueur physique et mentale. C''est le moment de mettre votre vitalité au service de vos ambitions.',
  recommended_actions = '• Profitez de cette énergie pour les activités physiquement exigeantes
• Lancez les programmes sportifs ou de remise en forme
• Commencez les traitements nécessitant un corps résistant
• Planifiez les interventions non urgentes dans cette fenêtre',
  pitfalls_to_avoid = '• Se surmener par excès de confiance en sa vitalité
• Négliger le sommeil et la récupération
• Ignorer les petits signaux du corps',
  optimal_timing = 'Les matinées offrent le pic d''énergie vitale. Les activités physiques et les consultations sont idéales le matin. Le début de cette phase est le plus vigoureux.',
  closing_message = 'Votre vitalité est un don précieux. Utilisez cette force avec sagesse pour poser les fondations d''une santé durable.'
WHERE cycle_type = 'health' AND period_number = 1;

-- HEALTH P2 (Équilibre)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie d''équilibre et de récupération domine cette phase. Le corps cherche l''harmonie et accepte favorablement les soins de rééquilibrage. C''est un temps propice à la modération et aux ajustements doux.',
  recommended_actions = '• Maintenez une routine de vie saine et régulière
• Équilibrez effort et repos dans toutes vos activités
• Privilégiez les approches douces et naturelles
• Accordez-vous des moments de détente et de ressourcement',
  pitfalls_to_avoid = '• Se surmener en ignorant les signaux de fatigue
• Prendre des décisions stressantes qui perturbent l''équilibre
• Négliger l''alimentation et l''hydratation',
  optimal_timing = 'Le milieu de cette phase est idéal pour les soins de rééquilibrage. Les activités de bien-être sont optimales en fin d''après-midi.',
  closing_message = 'L''équilibre est la clé de la longévité. Prenez soin de vous avec tendresse, votre corps vous le rendra au centuple.'
WHERE cycle_type = 'health' AND period_number = 2;

-- HEALTH P3 (Consultation)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie mentale et communicative stimule la clarté de pensée sur les questions de santé. C''est le moment idéal pour les consultations, les seconds avis et la recherche d''informations médicales. Votre capacité à comprendre les enjeux de santé est amplifiée.',
  recommended_actions = '• Consultez les spécialistes et posez toutes vos questions
• Recherchez des informations fiables sur vos préoccupations santé
• Discutez ouvertement de votre état avec vos proches
• Demandez des seconds avis si nécessaire',
  pitfalls_to_avoid = '• Chercher obsessionnellement des diagnostics en ligne
• Ignorer les avis professionnels au profit de l''auto-diagnostic
• Négliger l''aspect émotionnel de votre santé',
  optimal_timing = 'Les consultations du matin permettent la meilleure concentration. Les rendez-vous en milieu de semaine sont les plus productifs.',
  closing_message = 'La connaissance est un puissant remède. Comprenez votre corps et il deviendra votre meilleur allié de guérison.'
WHERE cycle_type = 'health' AND period_number = 3;

-- HEALTH P4 (Vulnérabilité)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de vulnérabilité invite à la prudence. Le corps est plus sensible et nécessite une attention particulière. C''est un temps pour ménager ses forces et être à l''écoute des besoins profonds de l''organisme.',
  recommended_actions = '• Ménagez-vous et réduisez les activités intenses
• Reportez les efforts physiques générateurs de stress
• Privilégiez une alimentation nutritive et légère
• Dormez suffisamment et respectez vos rythmes',
  pitfalls_to_avoid = '• Pusher son corps au-delà de ses limites actuelles
• Programmer des interventions non urgentes
• Ignorer les signaux de fatigue et de fragilité',
  optimal_timing = 'Les activités douces le matin sont favorables. Évitez les efforts après-midi. Le repos en fin de journée est essentiel.',
  closing_message = 'La fragilité n''est pas une faiblesse mais un appel à la bienveillance envers soi. Écoutez votre corps avec compassion.'
WHERE cycle_type = 'health' AND period_number = 4;

-- HEALTH P5 (Force)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de force et de résistance revient en puissance. Le corps est robuste et supporte bien les traitements actifs. C''est le retour de la vitalité et de la capacité de récupération. Les interventions sont bien tolérées.',
  recommended_actions = '• Profitez de cette force pour les activités sportives
• Programmez les interventions ou traitements reportés
• Lancez les programmes de remise en forme ambitieux
• Commencez les habitudes saines que vous souhaitez ancrer',
  pitfalls_to_avoid = '• Oublier que la force est cyclique et temporaire
• Se surmener sous prétexte de bien-être retrouvé
• Abandonner les routines de soin une fois l''énergie revenue',
  optimal_timing = 'Le milieu de cette phase offre le pic de résistance physique. Les matinées sont optimales pour les exercices et traitements intensifs.',
  closing_message = 'La force vitale coule en vous comme un fleuve puissant. Canalisez-la avec sagesse pour bâtir une santé de fer.'
WHERE cycle_type = 'health' AND period_number = 5;

-- HEALTH P6 (Repos)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de repos et de régénération invite au retrait. Le corps a besoin de récupérer et de se ressourcer en profondeur. C''est un temps sacré de guérison passive où la nature fait son œuvre de réparation.',
  recommended_actions = '• Repos et récupération sont vos priorités absolues
• Reportez les efforts physiques intenses
• Favorisez les thérapies douces et le repos
• Accordez à votre corps tout le sommeil qu''il demande',
  pitfalls_to_avoid = '• Programmer des interventions ou traitements lourds
• Ignorer la fatigue et forcer la machine
• Culpabiliser de ne pas être actif',
  optimal_timing = 'Les soins de récupération en fin de matinée sont les plus bénéfiques. Le repos en après-midi régénère le corps en profondeur.',
  closing_message = 'Le repos est l''antidote le plus puissant. Dans le silence du repos, votre corps accomplit des miracles de guérison.'
WHERE cycle_type = 'health' AND period_number = 6;

-- HEALTH P7 (Bilan santé)
UPDATE cycle_vie_decision_advice SET
  cosmic_context = 'L''énergie de bilan santé clôt ce cycle. C''est le moment idéal pour les check-ups, les ajustements de traitements et l''évaluation de votre état général. L''univers vous invite à faire le point avant le renouveau.',
  recommended_actions = '• Faites vos bilans de santé et check-ups complets
• Ajustez les traitements en cours avec votre médecin
• Évaluez l''efficacité de vos routines bien-être
• Préparez vos objectifs santé pour le prochain cycle',
  pitfalls_to_avoid = '• Reporter les examens de contrôle par négligence
• Commencer de nouveaux traitements lourds en fin de cycle
• Ignorer les résultats de bilan qui nécessitent un suivi',
  optimal_timing = 'Les consultations bilan en début de phase sont optimales. Le milieu de période est idéal pour les ajustements thérapeutiques.',
  closing_message = 'Chaque cycle vous enseigne à mieux connaître votre corps. Cette sagesse acquise sera votre meilleur atout pour le cycle à venir.'
WHERE cycle_type = 'health' AND period_number = 7;


-- ═══════════════════════════════════════════════
-- VÉRIFICATION FINALE
-- ═══════════════════════════════════════════════
SELECT '=== MIGRATION PARTIE 2 TERMINÉE ===' AS status;

SELECT cycle_type, period_number,
  COUNT(*) AS total_rows,
  COUNT(cosmic_context) AS with_cosmic,
  COUNT(recommended_actions) AS with_actions,
  COUNT(pitfalls_to_avoid) AS with_pitfalls,
  COUNT(optimal_timing) AS with_timing,
  COUNT(closing_message) AS with_closing
FROM cycle_vie_decision_advice
GROUP BY cycle_type, period_number
ORDER BY cycle_type, period_number;
