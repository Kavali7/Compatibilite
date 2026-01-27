"""
Générateur de conseils de décision pour Cycles de Vie
Génère 280 conseils = 20 types de décision × 14 périodes Soul Cycle
Formule: Affirmation + Encouragement + Sagesse
"""

# Types de décision avec leur catégorie
DECISION_TYPES = [
    ('location_immobilier', 'Location / Immobilier', 'immobilier'),
    ('achat_immobilier', 'Achat Immobilier', 'immobilier'),
    ('demenagement', 'Déménagement', 'immobilier'),
    ('achat_vehicule', 'Achat Véhicule', 'finance'),
    ('achat_important', 'Achat Important', 'finance'),
    ('demande_financement', 'Demande de Financement', 'finance'),
    ('recherche_argent', 'Recherche d\'Argent', 'finance'),
    ('investissement', 'Investissement', 'finance'),
    ('signature_contrat', 'Signature de Contrat', 'juridique'),
    ('lancement_business', 'Lancement Business', 'business'),
    ('partenariat', 'Partenariat / Association', 'business'),
    ('entretien_embauche', 'Entretien d\'Embauche', 'carriere'),
    ('demande_promotion', 'Demande de Promotion', 'carriere'),
    ('demission_changement', 'Démission / Changement', 'carriere'),
    ('voyage', 'Voyage', 'personnel'),
    ('mariage_engagement', 'Mariage / Engagement', 'personnel'),
    ('debut_relation', 'Début de Relation', 'personnel'),
    ('operation_medicale', 'Opération Médicale', 'sante'),
    ('debut_traitement', 'Début de Traitement', 'sante'),
    ('autre_decision', 'Autre Décision Importante', 'autre'),
]

# Périodes Soul Cycle avec leurs caractéristiques
SOUL_PERIODS = {
    (1, 'A'): {'name': 'Le Guerrier Noble', 'energy': 'Leadership, noblesse, ambition, décisions audacieuses', 'tone': 'assertif'},
    (1, 'B'): {'name': 'L\'Artiste Déterminé', 'energy': 'Raffinement, subtilité, patience, talents artistiques', 'tone': 'doux'},
    (2, 'A'): {'name': 'L\'Esprit Vif', 'energy': 'Voyage, changement, intellect rapide, adaptabilité', 'tone': 'dynamique'},
    (2, 'B'): {'name': 'L\'Intuitif Réservé', 'energy': 'Mémoire excellente, intuition, stabilité, profondeur', 'tone': 'contemplatif'},
    (3, 'A'): {'name': 'L\'Aventurier', 'energy': 'Courage, exploration, prise de risque, leadership', 'tone': 'audacieux'},
    (3, 'B'): {'name': 'Le Souverain', 'energy': 'Présence royale, cérémonies, reconnaissance, accomplissement', 'tone': 'majestueux'},
    (4, 'A'): {'name': 'Le Guide Spirituel', 'energy': 'Spiritualité, enseignement, éthique, philosophie', 'tone': 'sage'},
    (4, 'B'): {'name': 'L\'Esthète Équilibré', 'energy': 'Équilibre, harmonie, logique, beauté', 'tone': 'harmonieux'},
    (5, 'A'): {'name': 'Le Combattant Généreux', 'energy': 'Détermination, énergie, refus de médiocrité, action', 'tone': 'combatif'},
    (5, 'B'): {'name': 'Le Sage Pacifique', 'energy': 'Paix intérieure, amitié, humanitaire, spiritualité', 'tone': 'serein'},
    (6, 'A'): {'name': 'Le Critique Éclairé', 'energy': 'Analyse, sens critique, pédagogie, discernement', 'tone': 'analytique'},
    (6, 'B'): {'name': 'L\'Antiquaire', 'energy': 'Recherche, écriture, auto-réflexion, profondeur', 'tone': 'introspectif'},
    (7, 'A'): {'name': 'Le Chercheur Profond', 'energy': 'Expertise, dévotion, fiabilité, constance', 'tone': 'méthodique'},
    (7, 'B'): {'name': 'Le Mystique Dual', 'energy': 'Mysticisme, pouvoir magnétique, dualité, intuition', 'tone': 'mystique'},
}

# Templates par catégorie de décision et énergie de période
def generate_advice(decision_code: str, decision_label: str, category: str, period_num: int, polarity: str) -> str:
    period = SOUL_PERIODS[(period_num, polarity)]
    period_name = period['name']
    energy = period['energy']
    tone = period['tone']
    
    # Dictionnaire des conseils par catégorie et période
    # Format: Affirmation + Encouragement + Sagesse
    
    advices = {
        # IMMOBILIER
        'immobilier': {
            'assertif': f"Votre énergie de {period_name} renforce votre capacité à négocier et à vous imposer dans ce domaine. C'est le moment d'avancer avec assurance sur vos projets immobiliers. Vérifiez toutefois chaque détail contractuel : votre confiance ne doit pas masquer les subtilités importantes.",
            'doux': f"L'influence de {period_name} vous guide vers des choix réfléchis et harmonieux. Prenez le temps d'évaluer chaque option avec votre sensibilité naturelle. La patience sera votre meilleure alliée : les meilleures opportunités se révèlent à ceux qui savent attendre.",
            'dynamique': f"Votre esprit vif vous permet d'évaluer rapidement plusieurs options. Cette période favorise les visites multiples et les comparaisons efficaces. Notez vos impressions immédiatement car votre intuition première est souvent juste.",
            'contemplatif': f"Votre intuition profonde vous guide vers les lieux qui résonnent avec votre âme. Écoutez vos impressions subtiles lors des visites. Prenez le temps de la réflexion : la bonne décision viendra de votre for intérieur.",
            'audacieux': f"L'Aventurier en vous n'a pas peur des défis immobiliers ambitieux. C'est le moment de viser haut et d'explorer des options inhabituelles. Gardez néanmoins un œil sur les risques : l'audace doit être tempérée par la prudence.",
            'majestueux': f"Votre sens du prestige vous attire vers des biens à la hauteur de vos aspirations. Cette période favorise les acquisitions qui reflètent votre statut. Assurez-vous que l'investissement correspond à vos moyens réels, pas seulement à vos ambitions.",
            'sage': f"Votre sagesse spirituelle éclaire vos décisions immobilières. Recherchez un lieu qui nourrit votre âme autant que vos besoins pratiques. La dimension énergétique de l'espace compte autant que ses caractéristiques matérielles.",
            'harmonieux': f"Votre sens de l'équilibre vous guide vers des espaces harmonieux et proportionnés. Recherchez la beauté dans la fonctionnalité. Un lieu qui vous ressemble sera source de bien-être durable.",
            'combatif': f"Votre détermination vous pousse à ne pas accepter moins que ce que vous méritez. Négociez fermement mais équitablement. Canalisez votre énergie combative en préparation minutieuse plutôt qu'en confrontation.",
            'serein': f"Votre paix intérieure vous guide vers des environnements apaisants et ressourçants. Recherchez des lieux où vous pourrez vous épanouir sereinement. La tranquillité d'un lieu vaut parfois plus que ses caractéristiques prestigieuses.",
            'analytique': f"Votre esprit critique évalue méthodiquement chaque aspect du bien. Listez les avantages et inconvénients objectivement. Votre analyse sera d'autant plus pertinente que vous aurez vérifié chaque information.",
            'introspectif': f"Cette période vous invite à réfléchir profondément à vos besoins réels. Qu'attendez-vous vraiment de ce lieu? La réponse sincère à cette question guidera votre choix mieux que toute analyse externe.",
            'méthodique': f"Votre approche systématique vous protège des décisions hâtives. Établissez une liste de critères et évaluez chaque option rigoureusement. La méthode est votre force : utilisez-la pleinement.",
            'mystique': f"Votre sensibilité vous permet de percevoir l'énergie subtile des lieux. Fiez-vous à vos impressions inexplicables. Si un endroit vous dérange sans raison apparente, écoutez ce signal."
        },
        
        # FINANCE
        'finance': {
            'assertif': f"L'énergie de {period_name} soutient vos démarches financières ambitieuses. Votre assurance naturelle impressionne favorablement les interlocuteurs. Appuyez votre confiance sur des chiffres solides : l'audace financière doit être calculée.",
            'doux': f"Votre approche patiente et réfléchie porte ses fruits dans les décisions financières. Prenez le temps d'analyser chaque option avec soin. Les investissements durables valent mieux que les gains rapides mais risqués.",
            'dynamique': f"Votre vivacité d'esprit vous permet de saisir rapidement les opportunités financières. Restez agile tout en gardant une vision à long terme. La diversification protège contre votre tendance au changement.",
            'contemplatif': f"Votre intuition financière est particulièrement aiguisée en cette période. Méditez sur vos décisions monétaires importantes. La réponse juste émergera de votre réflexion profonde.",
            'audacieux': f"L'Aventurier en vous peut découvrir des opportunités que d'autres ignorent. C'est le moment des investissements innovants mais réfléchis. Limitez les risques à ce que vous pouvez vous permettre de perdre.",
            'majestueux': f"Votre sens du prestige vous oriente vers des investissements de qualité. Visez l'excellence plutôt que la quantité. Les actifs de valeur résistent mieux aux aléas du temps.",
            'sage': f"Votre sagesse vous protège des tentations de richesse rapide. Investissez dans ce qui a un sens profond pour vous. L'argent gagné en accord avec vos valeurs est plus satisfaisant.",
            'harmonieux': f"Votre sens de l'équilibre vous guide vers une gestion financière saine. Cherchez l'harmonie entre sécurité et croissance. Un portefeuille équilibré reflète une vie équilibrée.",
            'combatif': f"Votre énergie vous pousse à conquérir de nouvelles sources de revenus. Canalisez cette force dans des projets bien préparés. La victoire financière va aux stratèges, pas aux impulsifs.",
            'serein': f"Votre paix intérieure vous libère de l'anxiété financière. Prenez vos décisions depuis ce lieu de calme. L'argent est un outil : ne le laissez pas troubler votre sérénité.",
            'analytique': f"Votre esprit critique évalue objectivement chaque opportunité financière. Comparez les chiffres sans vous laisser séduire par les promesses. Les faits sont plus fiables que les projections optimistes.",
            'introspectif': f"Cette période vous invite à réfléchir à votre relation avec l'argent. Quelles sont vos véritables motivations financières? La clarté intérieure précède les bonnes décisions extérieures.",
            'méthodique': f"Votre rigueur est votre meilleure protection financière. Analysez chaque investissement selon des critères définis. La discipline constante surpasse les coups de chance occasionnels.",
            'mystique': f"Votre intuition peut percevoir des opportunités invisibles aux analystes. Fiez-vous à vos pressentiments tout en vérifiant les faits. Le mystique avisé allie intuition et prudence."
        },
        
        # JURIDIQUE
        'juridique': {
            'assertif': f"Votre énergie de {period_name} renforce votre position dans les négociations contractuelles. C'est le moment de finaliser des accords favorables. Faites néanmoins relire chaque document par un expert : la confiance n'exclut pas la vérification.",
            'doux': f"Votre patience vous permet de négocier des termes équilibrés et durables. Prenez le temps de comprendre chaque clause. Un contrat signé dans la sérénité est plus solide qu'un accord précipité.",
            'dynamique': f"Votre esprit vif repère rapidement les points problématiques. Négociez avec agilité tout en restant ferme sur l'essentiel. Votre vivacité est un atout si elle ne devient pas précipitation.",
            'contemplatif': f"Votre intuition vous alerte sur les subtilités cachées. Prenez le temps de méditer sur l'engagement avant de signer. Ce que vous ressentez compte autant que ce que vous lisez.",
            'audacieux': f"L'Aventurier peut obtenir des conditions exceptionnelles par une négociation audacieuse. Osez demander plus tout en sachant quand conclure. Le courage sans sagesse peut mener à l'impasse.",
            'majestueux': f"Votre présence imposante renforce votre position de négociation. Demandez des termes dignes de votre valeur. Vérifiez que votre fierté ne vous empêche pas de voir les détails.",
            'sage': f"Votre sagesse vous guide vers des engagements alignés avec vos principes. Un contrat éthique est plus précieux qu'un accord lucratif mais contestable. Votre intégrité est votre meilleure protection.",
            'harmonieux': f"Recherchez des accords équilibrés où chaque partie trouve son compte. Un contrat harmonieux génère moins de conflits futurs. L'équité d'aujourd'hui prévient les litiges de demain.",
            'combatif': f"Votre détermination vous permet de défendre fermement vos intérêts. Négociez chaque point important avec constance. Sachez cependant quand le combat cède la place au compromis.",
            'serein': f"Abordez les négociations depuis votre centre de paix intérieure. Votre calme déstabilise ceux qui cherchent à vous presser. La sérénité est une force dans les discussions tendues.",
            'analytique': f"Votre esprit critique décortique chaque clause avec précision. Rien n'échappe à votre analyse méthodique. Cette rigueur vous protège des mauvaises surprises.",
            'introspectif': f"Demandez-vous sincèrement si cet engagement correspond à vos aspirations profondes. La réponse intérieure guidera votre décision mieux que l'analyse externe. Écoutez votre voix intérieure.",
            'méthodique': f"Votre approche systématique garantit que rien n'est négligé. Établissez une checklist et vérifiez chaque élément. La méthode est votre meilleure assurance.",
            'mystique': f"Votre sens subtil perçoit les intentions derrière les mots. Fiez-vous à ce que vous ressentez de l'autre partie. Un malaise inexpliqué mérite d'être écouté."
        },
        
        # BUSINESS
        'business': {
            'assertif': f"L'énergie du {period_name} amplifie votre leadership entrepreneurial. C'est le moment de lancer des initiatives ambitieuses. Entourez-vous d'une équipe compétente : même le meilleur leader a besoin de soutien.",
            'doux': f"Votre approche patiente construit des entreprises durables. Bâtissez votre projet avec soin et attention aux détails. La croissance organique surpasse souvent l'expansion forcée.",
            'dynamique': f"Votre agilité mentale vous permet de pivoter rapidement selon le marché. Restez à l'écoute des opportunités émergentes. Structurez votre vision : la flexibilité n'exclut pas la direction.",
            'contemplatif': f"Votre intuition vous guide vers des niches inexploitées. Méditez sur votre proposition de valeur unique. Les meilleures idées business émergent souvent du silence.",
            'audacieux': f"L'Aventurier en vous peut créer des entreprises innovantes et disruptives. Osez bousculer les conventions du marché. Calculez vos risques : l'audace intelligente triomphe de l'audace aveugle.",
            'majestueux': f"Votre vision royale vous oriente vers des entreprises d'excellence. Visez la qualité premium plutôt que le volume. Un business prestigieux attire une clientèle fidèle.",
            'sage': f"Votre sagesse vous guide vers des entreprises à impact positif. Le business éthique génère une satisfaction profonde. Le profit aligné avec les valeurs est le plus durable.",
            'harmonieux': f"Recherchez l'équilibre entre rentabilité et bien-être. Un business harmonieux attire naturellement clients et collaborateurs. La culture positive est un avantage compétitif.",
            'combatif': f"Votre énergie combative vous pousse à conquérir votre marché. Canalisez cette force dans une stratégie bien préparée. La bataille commerciale se gagne avec intelligence.",
            'serein': f"Votre paix intérieure vous libère de l'anxiété entrepreneuriale. Prenez vos décisions business depuis ce lieu de calme. La sérénité attire les bonnes opportunités.",
            'analytique': f"Votre esprit critique évalue objectivement chaque aspect de votre projet. Basez vos décisions sur des données vérifiées. L'analyse remplace avantageusement l'intuition aveugle.",
            'introspectif': f"Interrogez-vous sur vos motivations profondes d'entrepreneur. Pourquoi ce business? La réponse sincère déterminera votre persévérance dans les difficultés.",
            'méthodique': f"Votre approche structurée construit des fondations solides. Suivez votre plan tout en restant adaptable. La méthode est le socle sur lequel s'appuie l'innovation.",
            'mystique': f"Votre perception subtile vous connecte aux courants profonds du marché. Fiez-vous à vos intuitions sur les tendances émergentes. Le mystique averti transforme les visions en réalités."
        },
        
        # CARRIERE
        'carriere': {
            'assertif': f"L'énergie de {period_name} amplifie votre leadership professionnel. C'est le moment d'affirmer votre valeur et de demander la reconnaissance méritée. Appuyez vos demandes sur des réalisations concrètes.",
            'doux': f"Votre approche subtile et patiente impressionne favorablement. Laissez votre travail parler de lui-même tout en sachant vous mettre en valeur. La modestie n'exclut pas la visibilité.",
            'dynamique': f"Votre polyvalence est un atout précieux sur le marché du travail. Montrez votre capacité d'adaptation et d'apprentissage rapide. Démontrez aussi votre capacité à vous engager durablement.",
            'contemplatif': f"Votre intuition vous guide vers les opportunités alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque option. La carrière idéale résonne avec votre moi profond.",
            'audacieux': f"L'Aventurier peut saisir des opportunités que d'autres n'osent pas envisager. Osez proposer, demander, créer votre poste idéal. Le courage calculé ouvre des portes insoupçonnées.",
            'majestueux': f"Votre présence royale vous destine à des positions de leadership. Assumez votre valeur et visez les responsabilités à votre hauteur. La vraie royauté se manifeste aussi dans l'humilité.",
            'sage': f"Votre sagesse vous oriente vers une carrière porteuse de sens. Recherchez l'alignement entre votre travail et vos valeurs profondes. Le succès le plus profond est celui qui vous épanouit.",
            'harmonieux': f"Recherchez l'équilibre entre ambition professionnelle et bien-être personnel. Une carrière harmonieuse soutient votre vie, elle ne la consume pas. L'équilibre est la clé de la longévité.",
            'combatif': f"Votre détermination vous pousse vers les sommets professionnels. Canalisez cette énergie dans une stratégie de carrière réfléchie. La compétition saine stimule, la rivalité épuise.",
            'serein': f"Abordez votre carrière depuis votre centre de paix intérieure. Les décisions professionnelles prises dans le calme sont plus justes. La sérénité attire les bonnes opportunités.",
            'analytique': f"Votre esprit critique évalue objectivement vos options de carrière. Comparez les avantages et inconvénients de chaque voie. L'analyse lucide prévient les regrets futurs.",
            'introspectif': f"Interrogez-vous sur ce que vous voulez vraiment de votre vie professionnelle. La réponse sincère guidera vos choix mieux que les attentes extérieures. Votre carrière doit vous ressembler.",
            'méthodique': f"Votre approche structurée construit une carrière solide. Établissez un plan de développement et suivez-le avec discipline. La progression constante surpasse les bonds désordonnés.",
            'mystique': f"Votre intuition perçoit les opportunités invisibles aux autres. Fiez-vous à vos pressentiments sur les personnes et les situations. Le flair professionnel est un talent précieux."
        },
        
        # PERSONNEL
        'personnel': {
            'assertif': f"L'énergie de {period_name} soutient les engagements personnels significatifs. C'est le moment d'affirmer vos choix de vie avec conviction. Assurez-vous que vos proches partagent votre vision.",
            'doux': f"Votre sensibilité vous guide vers des relations authentiques et profondes. Prenez le temps de cultiver les liens qui vous nourrissent. La qualité des relations surpasse leur quantité.",
            'dynamique': f"Votre énergie vivace enrichit vos interactions personnelles. Multipliez les rencontres tout en préservant vos liens profonds. La variété n'exclut pas la fidélité.",
            'contemplatif': f"Votre intuition vous guide vers les personnes alignées avec votre essence. Écoutez ce que vous ressentez vraiment pour chaque relation. Les connexions d'âme se reconnaissent au-delà des mots.",
            'audacieux': f"L'Aventurier peut vivre des expériences personnelles extraordinaires. Osez sortir de votre zone de confort relationnelle. Le courage émotionnel ouvre des mondes nouveaux.",
            'majestueux': f"Votre présence attire naturellement des personnes de qualité. Entretenez des relations dignes de votre valeur. La noblesse véritable honore également ceux qui l'entourent.",
            'sage': f"Votre sagesse vous oriente vers des relations porteuses de croissance mutuelle. Recherchez des compagnons de route qui élèvent votre esprit. Les amitiés spirituelles sont les plus durables.",
            'harmonieux': f"Recherchez l'équilibre et la réciprocité dans vos relations. Une connexion harmonieuse nourrit les deux parties. L'équilibre relationnel est la clé du bien-être.",
            'combatif': f"Votre passion peut intensifier vos relations personnelles. Canalisez cette énergie vers la construction plutôt que le conflit. L'amour vrai est aussi un engagement quotidien.",
            'serein': f"Votre paix intérieure rayonne et attire des relations apaisantes. Partagez votre sérénité avec ceux qui vous entourent. Le calme relationnel est un don précieux.",
            'analytique': f"Votre esprit critique peut parfois compliquer les relations spontanées. Laissez aussi parler votre cœur dans vos choix personnels. L'analyse et l'émotion peuvent coexister.",
            'introspectif': f"Cette période vous invite à réfléchir à ce que vous attendez vraiment de vos relations. La clarté intérieure guide vers les bons choix. Connaissez-vous d'abord pour bien choisir les autres.",
            'méthodique': f"Votre approche réfléchie peut structurer même les aspects personnels de votre vie. Restez ouvert à la spontanéité malgré votre nature organisée. L'amour surprend parfois les plus méthodiques.",
            'mystique': f"Votre sensibilité vous connecte aux dimensions subtiles des relations. Fiez-vous à vos intuitions sur les personnes. Les rencontres significatives transcendent la logique."
        },
        
        # SANTE
        'sante': {
            'assertif': f"L'énergie de {period_name} soutient votre vitalité et votre capacité de récupération. Abordez les soins avec confiance et détermination. Suivez néanmoins scrupuleusement les recommandations médicales.",
            'doux': f"Votre patience favorise une approche sereine des questions de santé. Prenez soin de vous avec douceur et constance. La guérison véritable prend le temps nécessaire.",
            'dynamique': f"Votre vivacité soutient une récupération rapide et active. Restez engagé dans votre parcours de soin. L'impatience peut toutefois compromettre la guérison : respectez les étapes.",
            'contemplatif': f"Votre intuition vous guide vers les soins adaptés à votre être profond. Écoutez les signaux de votre corps avec attention. La sagesse corporelle complète l'expertise médicale.",
            'audacieux': f"L'Aventurier peut affronter les défis de santé avec courage. Votre force intérieure soutient votre combat. Canalisez votre énergie vers la guérison plutôt que la résistance.",
            'majestueux': f"Votre dignité naturelle vous aide à traverser les épreuves de santé. Maintenez votre estime de vous malgré les difficultés. La royauté intérieure transcende les limitations physiques.",
            'sage': f"Votre sagesse spirituelle apporte une perspective élargie sur la santé. Intégrez les dimensions physiques, mentales et spirituelles. La guérison holistique est la plus profonde.",
            'harmonieux': f"Recherchez l'équilibre entre traitement médical et bien-être global. Un corps harmonieux résiste mieux à la maladie. L'équilibre de vie soutient la santé durable.",
            'combatif': f"Votre énergie combative est un atout dans les défis de santé. Canalisez cette force vers la guérison positive. Combattez avec intelligence, pas avec acharnement.",
            'serein': f"Votre paix intérieure favorise la guérison en réduisant le stress. Abordez les soins depuis ce lieu de calme. La sérénité est un médicament puissant.",
            'analytique': f"Votre esprit critique vous aide à comprendre votre situation médicale. Posez des questions et informez-vous avec rigueur. La connaissance renforce votre participation active aux soins.",
            'introspectif': f"Cette période vous invite à écouter profondément les messages de votre corps. Que vous dit votre symptôme? La compréhension intérieure complète le diagnostic externe.",
            'méthodique': f"Votre approche disciplinée garantit un suivi rigoureux du traitement. Établissez une routine de soin et respectez-la. La constance est clé dans tout parcours de santé.",
            'mystique': f"Votre connexion au subtil peut faciliter la guérison à des niveaux profonds. Complétez les soins médicaux par des pratiques qui nourrissent votre âme. Le corps et l'esprit guérissent ensemble."
        },
        
        # AUTRE
        'autre': {
            'assertif': f"L'énergie de {period_name} vous confère le discernement et l'audace nécessaires pour toute décision importante. Faites confiance à votre leadership intérieur. Vérifiez que votre choix sert vos intérêts à long terme.",
            'doux': f"Votre sensibilité et votre patience éclairent cette décision. Prenez le temps de peser chaque aspect avec soin. La réponse juste émergera de votre réflexion approfondie.",
            'dynamique': f"Votre esprit vif peut envisager simultanément plusieurs options. Listez les pour et les contre avec méthode. Une fois décidé, engagez-vous pleinement sans regarder en arrière.",
            'contemplatif': f"Votre intuition est particulièrement fiable en cette période. Méditez sur les options qui s'offrent à vous. La réponse profonde viendra de votre silence intérieur.",
            'audacieux': f"L'Aventurier en vous n'a pas peur des choix audacieux. Osez l'option qui vous fait vibrer. Calculez les risques pour que votre audace soit intelligente.",
            'majestueux': f"Votre sens de la dignité vous guide vers des choix honorables. Décidez de manière à rester fier de vous-même. La vraie noblesse se manifeste dans chaque décision.",
            'sage': f"Votre sagesse éclaire cette décision de sa lumière bienveillante. Cherchez l'option alignée avec vos valeurs les plus profondes. Un choix éthique apporte une satisfaction durable.",
            'harmonieux': f"Recherchez l'équilibre entre les différentes dimensions de votre vie. Un choix harmonieux tient compte de tous les aspects. L'équilibre global surpasse l'optimisation partielle.",
            'combatif': f"Votre détermination vous pousse à trancher avec fermeté. Canalisez cette énergie dans une décision réfléchie. Le combattant avisé choisit ses batailles.",
            'serein': f"Votre paix intérieure vous protège de l'anxiété décisionnelle. Prenez votre décision depuis ce lieu de calme. La sérénité clarifie le jugement.",
            'analytique': f"Votre esprit critique décompose le problème en éléments analysables. Évaluez chaque dimension objectivement. L'analyse méthodique prévient les erreurs de jugement.",
            'introspectif': f"Cette période vous invite à une réflexion profonde avant de décider. Que veut vraiment votre être profond? La réponse intérieure est souvent la plus juste.",
            'méthodique': f"Votre approche structurée apporte clarté à la décision. Établissez des critères et évaluez chaque option. La méthode transforme la complexité en clarté.",
            'mystique': f"Votre sensibilité perçoit des dimensions invisibles à l'analyse rationnelle. Fiez-vous à vos pressentiments tout en vérifiant les faits. L'intuition et la logique sont complémentaires."
        }
    }
    
    # Sélectionner le conseil approprié
    cat_advices = advices.get(category, advices['autre'])
    return cat_advices.get(tone, cat_advices['assertif'])

def generate_all_advices():
    """Génère toutes les combinaisons de conseils"""
    sql_output = []
    
    sql_output.append("-- ================================================")
    sql_output.append("-- MIGRATION CYCLES DE VIE - CONSEILS DE DÉCISION")
    sql_output.append("-- 280 entrées générées automatiquement")
    sql_output.append("-- Formule: Affirmation + Encouragement + Sagesse")
    sql_output.append("-- ================================================\n")
    
    for period_num in range(1, 8):
        for polarity in ['A', 'B']:
            period_info = SOUL_PERIODS[(period_num, polarity)]
            sql_output.append(f"\n-- ================================================")
            sql_output.append(f"-- PÉRIODE {period_num}{polarity} - {period_info['name']}")
            sql_output.append(f"-- Énergie: {period_info['energy']}")
            sql_output.append(f"-- ================================================\n")
            
            sql_output.append("INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)")
            sql_output.append("VALUES")
            
            values = []
            for code, label, category in DECISION_TYPES:
                advice = generate_advice(code, label, category, period_num, polarity)
                # Échapper les apostrophes pour SQL
                advice_escaped = advice.replace("'", "''")
                values.append(f"('{code}', {period_num}, '{polarity}', '{advice_escaped}')")
            
            sql_output.append(",\n".join(values))
            sql_output.append("ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity)")
            sql_output.append("DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();\n")
    
    return "\n".join(sql_output)

if __name__ == "__main__":
    sql = generate_all_advices()
    with open("migration_cycles_vie_advice_full.sql", "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"✅ Généré {len(DECISION_TYPES) * len(SOUL_PERIODS)} conseils")
    print("📁 Fichier: migration_cycles_vie_advice_full.sql")
