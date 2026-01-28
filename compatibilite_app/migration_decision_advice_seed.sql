-- ================================================
-- SEED DECISION ADVICE - Conseils Mystiques
-- Basé sur "Self Mastery and Fate" de H. Spencer Lewis
-- Contenu en français, style ésotérique
-- ================================================

-- Note: Les IDs des decision_types sont récupérés dynamiquement
-- Ce script insère les conseils pour les 4 types de cycles × 7 périodes × 20 types de décisions

-- ================================================
-- FONCTION HELPER pour insertion avec lookup
-- ================================================

-- D'abord, nettoyer les anciennes données
DELETE FROM cycle_vie_decision_advice;

-- ================================================
-- CYCLE PERSONNEL (personal) - Le plus important selon Lewis
-- Basé sur le cycle annuel personnel depuis l'anniversaire
-- 7 périodes de ~52 jours chacune
-- ================================================

-- PÉRIODE 1 DU CYCLE PERSONNEL (Jours 1-52 après anniversaire)
-- Thème: Renouveau, Nouvelles Fondations, Énergie Montante
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 85,
    'Cette période marque le début de votre nouveau cycle cosmique. Les Forces Universelles soutiennent vos initiatives de location ou d''installation. L''énergie de renouveau favorise les nouveaux départs résidentiels.',
    'Évitez de vous engager trop rapidement sans avoir vérifié tous les détails du contrat.',
    'Si vous hésitez, profitez de cette période pour visiter plusieurs options et affiner vos critères.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 80,
    'Le Cosmos vous accorde une période propice aux acquisitions majeures. L''achat immobilier trouve un terrain fertile dans cette première phase de votre cycle. Les vibrations sont alignées pour établir des racines solides.',
    'L''enthousiasme du renouveau peut obscurcir votre jugement. Prenez le temps nécessaire pour les vérifications.',
    'Utilisez cette période pour les recherches actives et la préparation des dossiers.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 90,
    'Période idéale pour un déménagement. Les énergies cosmiques soutiennent les changements de lieu de vie. Votre âme cherche un nouveau point d''ancrage et l''Univers répond favorablement.',
    'Planifiez soigneusement les détails pratiques malgré l''enthousiasme.',
    'C''est le moment parfait pour initier le processus, même si le déménagement physique a lieu plus tard.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 75,
    'L''acquisition d''un véhicule en cette période bénéficie des énergies de renouveau. Le Cosmos favorise les moyens de locomotion qui symbolisent votre progression dans la vie.',
    'Ne cédez pas à l''impulsion d''acheter le premier véhicule venu.',
    'Profitez de cette période pour comparer les options et négocier les meilleures conditions.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 80,
    'Les achats importants sont favorisés en cette période de commencement. L''Univers soutient l''acquisition de biens qui amélioreront votre quotidien pour le cycle à venir.',
    'Restez dans les limites de votre budget malgré l''optimisme ambiant.',
    'Établissez une liste de priorités et procédez méthodiquement.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 70,
    'La demande de financement trouve un écho favorable auprès des forces cosmiques. Les portes s''ouvrent plus facilement en ce début de cycle personnel.',
    'Ne demandez pas plus que nécessaire. Les dettes contractées maintenant vous accompagneront tout le cycle.',
    'Préparez un dossier solide et présentez-le avec confiance.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 75,
    'La recherche de fonds bénéficie de l''énergie ascendante de cette période. Les connexions avec les sources d''argent sont facilitées par les vibrations de renouveau.',
    'Restez réaliste dans vos attentes financières.',
    'Activez votre réseau et présentez vos projets avec enthousiasme mesuré.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 65,
    'Les investissements en cette période portent la marque du renouveau. Cependant, l''énergie est plus propice aux fondations qu''aux risques financiers.',
    'Évitez les placements trop spéculatifs. Privilégiez la solidité.',
    'Constituez plutôt une réserve ou investissez dans des valeurs sûres.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 85,
    'La signature de contrat en ce début de cycle bénéficie d''excellentes vibrations. Les engagements pris maintenant portent la bénédiction cosmique du renouveau.',
    'Lisez attentivement chaque clause. L''optimisme ne doit pas remplacer la prudence.',
    'C''est le moment idéal pour formaliser des accords préparés de longue date.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 90,
    'Le lancement d''un business en cette période est hautement favorable. Les Forces Cosmiques soutiennent les nouvelles entreprises initiées au début du cycle personnel.',
    'Assurez-vous d''avoir une base solide avant de vous lancer.',
    'Même une préparation intensive sans lancement officiel est bénéfique maintenant.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 80,
    'Les partenariats conclus en ce début de cycle portent les germes de la prospérité. L''Univers favorise les alliances fondées sur des objectifs communs clairs.',
    'Définissez clairement les rôles et responsabilités de chaque partie.',
    'Prenez le temps de vraiment connaître votre futur partenaire avant de vous engager.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 85,
    'L''entretien d''embauche en cette période bénéficie de l''énergie du renouveau. Votre aura rayonne de possibilités nouvelles qui impressionneront favorablement.',
    'Ne survendez pas vos compétences. L''authenticité sera votre meilleur atout.',
    'Préparez-vous à parler de vos projets d''avenir avec enthousiasme.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 70,
    'La demande de promotion en début de cycle peut être prématurée. Les énergies favorisent plutôt la pose de fondations pour une demande ultérieure.',
    'Attendez d''avoir accumulé quelques réalisations dans ce nouveau cycle.',
    'Utilisez cette période pour clarifier vos objectifs et commencer à les documenter.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 85,
    'La démission ou le changement de carrière est très favorisé en ce moment. Les énergies de renouveau soutiennent les transitions professionnelles majeures.',
    'Assurez-vous d''avoir un plan B solide avant de partir.',
    'C''est le moment idéal pour initier des recherches actives ou annoncer votre départ.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 80,
    'Les voyages entrepris en ce début de cycle portent une signification spéciale. Ils peuvent marquer le ton de votre année à venir et ouvrir de nouvelles perspectives.',
    'Prévoyez suffisamment de temps pour intégrer les expériences vécues.',
    'Même un court voyage peut avoir des effets bénéfiques durables.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 90,
    'Le mariage ou l''engagement en ce début de cycle reçoit la bénédiction des Forces Cosmiques. L''union initiée maintenant porte les énergies du renouveau et de la croissance.',
    'Assurez-vous que cette décision est mûrement réfléchie et non impulsive.',
    'Si vous hésitez encore, cette période est idéale pour des fiançailles ou une promesse.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 85,
    'Débuter une nouvelle relation en ce moment est très auspicieux. Les connexions formées au début du cycle personnel ont le potentiel de durer et de s''approfondir.',
    'Ne vous précipitez pas vers l''intimité. Laissez la relation se développer naturellement.',
    'Ouvrez-vous aux nouvelles rencontres et aux opportunités sociales.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 75,
    'Les opérations médicales planifiées en ce début de cycle bénéficient des énergies de régénération. Le corps est plus réceptif à la guérison.',
    'Consultez votre médecin sur le timing optimal. L''aspect cosmique est un complément, pas un substitut.',
    'Si possible, programmez l''intervention dans les premières semaines de cette période.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 80,
    'Débuter un traitement en ce moment est favorable. Les énergies de renouveau soutiennent les processus de guérison et d''amélioration de la santé.',
    'Suivez scrupuleusement les prescriptions médicales.',
    'C''est aussi un bon moment pour adopter de nouvelles habitudes de vie saines.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 1, 75,
    'Cette période de renouveau offre un contexte favorable pour toute décision importante. Les vibrations cosmiques soutiennent les nouveaux commencements.',
    'Prenez le temps de bien réfléchir malgré l''élan d''enthousiasme.',
    'Faites confiance à votre intuition tout en restant ancré dans le pratique.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 2 DU CYCLE PERSONNEL (Jours 53-104)
-- Thème: Accumulation, Acquisition, Consolidation
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 90,
    'Période d''acquisition par excellence. Les Forces Cosmiques favorisent grandement la location et l''installation dans un nouveau logement. C''est le moment idéal pour concrétiser vos recherches.',
    'Négociez fermement mais équitablement.',
    'Si vous avez trouvé le bon endroit, n''attendez plus.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 95,
    'Cette période est la plus favorable de votre cycle pour les achats immobiliers majeurs. Le Cosmos soutient l''accumulation de biens durables et l''établissement de racines profondes.',
    'Faites toutes les vérifications nécessaires malgré l''élan favorable.',
    'C''est vraiment le meilleur moment pour finaliser une acquisition importante.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'Le déménagement en cette période consolide vos acquis. L''Univers favorise l''installation durable et la création d''un foyer stable.',
    'Organisez méticuleusement chaque étape du processus.',
    'C''est le moment de vraiment vous installer et de créer votre espace.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 90,
    'L''achat de véhicule trouve sa période la plus favorable ici. Les vibrations d''accumulation soutiennent l''acquisition de moyens de transport durables et fiables.',
    'Optez pour la qualité et la durabilité plutôt que le clinquant.',
    'C''est le moment idéal pour investir dans un véhicule qui vous servira longtemps.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 95,
    'Période optimale pour les achats importants. L''énergie cosmique d''accumulation vous guide vers des acquisitions judicieuses qui enrichiront votre vie.',
    'Restez dans vos moyens. L''accumulation sage est différente de l''excès.',
    'Faites une liste de ce qui compte vraiment et investissez-y.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Les demandes de financement sont bien soutenues. Les énergies d''acquisition facilitent l''obtention des ressources nécessaires pour vos projets.',
    'N''empruntez que ce que vous pouvez rembourser confortablement.',
    'Présentez votre demande maintenant pour maximiser vos chances.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'La recherche d''argent est particulièrement favorisée. Les flux financiers s''ouvrent plus facilement durant cette période d''accumulation.',
    'Ne dispersez pas vos efforts sur trop de pistes.',
    'Concentrez-vous sur les sources les plus prometteuses.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Les investissements trouvent un terrain fertile. L''énergie d''accumulation soutient les placements réfléchis et à long terme.',
    'Évitez les investissements trop risqués ou spéculatifs.',
    'Privilégiez les actifs tangibles et les valeurs de croissance stable.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 90,
    'La signature de contrats est très favorable. Les accords conclus maintenant portent la vibration de la stabilité et de la prospérité durable.',
    'Revérifiez tous les termes avant de signer.',
    'C''est le moment idéal pour les engagements à long terme.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Le lancement business bénéficie des énergies d''accumulation. C''est une bonne période pour développer et consolider plutôt que pour démarrer de zéro.',
    'Construisez sur des fondations solides posées en période 1.',
    'Concentrez-vous sur l''acquisition de clients et de ressources.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'Les partenariats conclus en période d''accumulation sont durables et profitables. L''Univers favorise les alliances basées sur des intérêts tangibles communs.',
    'Assurez-vous que les objectifs financiers sont alignés.',
    'Formalisez les accords avec des contrats clairs.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Les entretiens d''embauche sont favorisés, surtout pour des postes stables et bien rémunérés. Votre aura projette la stabilité et la fiabilité.',
    'Mettez en avant votre capacité à construire et accumuler des résultats.',
    'Négociez votre salaire; les énergies soutiennent l''obtention de bonnes conditions.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'La demande de promotion est très soutenue. Les énergies d''accumulation incluent l''accumulation de responsabilités et de reconnaissance.',
    'Préparez un dossier solide de vos réalisations.',
    'C''est le moment de demander ce que vous méritez.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 60,
    'La démission n''est pas favorisée en période d''accumulation. Les énergies vous encouragent à rester et à construire plutôt qu''à partir.',
    'Sauf situation vraiment insoutenable, restez encore un peu.',
    'Utilisez cette période pour améliorer votre position actuelle.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 75,
    'Les voyages en cette période sont bénéfiques s''ils servent l''accumulation: voyages d''affaires, prospection, networking.',
    'Évitez les voyages purement récréatifs coûteux.',
    'Combinez plaisir et utilité dans vos déplacements.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'Le mariage en période d''accumulation promet stabilité matérielle et construction commune. L''Univers bénit les unions qui visent à bâtir ensemble.',
    'Discutez ouvertement des aspects financiers.',
    'Planifiez votre avenir commun avec clarté.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 70,
    'Débuter une relation est possible mais les énergies favorisent les relations avec un potentiel concret plutôt que les aventures passagères.',
    'Cherchez quelqu''un qui partage vos valeurs de stabilité.',
    'Les relations commencées maintenant évolueront naturellement vers l''engagement.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Les opérations médicales en cette période bénéficient d''une bonne capacité de récupération. Le corps est en mode construction.',
    'Prévoyez une période de convalescence adéquate.',
    'C''est une bonne période pour les interventions reconstructrices.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 85,
    'Débuter un traitement de fond est très favorable. Les énergies d''accumulation soutiennent les processus de guérison progressive.',
    'Soyez patient et régulier dans votre traitement.',
    'Les résultats se cumuleront progressivement.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 2, 80,
    'Cette période favorise les décisions qui construisent et accumulent. Toute décision visant la croissance et la stabilité est soutenue.',
    'Évitez les décisions qui dispersent vos ressources.',
    'Concentrez-vous sur ce qui construit votre avenir.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 3 DU CYCLE PERSONNEL (Jours 105-156)
-- Thème: Communication, Contacts, Expression
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 85,
    'Les négociations immobilières sont très favorisées. Votre capacité de communication est amplifiée par le Cosmos, facilitant les discussions avec propriétaires et agents.',
    'Vérifiez tout par écrit, ne vous fiez pas aux promesses verbales.',
    'Excellent moment pour visiter beaucoup de biens et comparer les offres.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 75,
    'L''achat immobilier peut être discuté et négocié, mais la finalisation devrait attendre. C''est une période d''exploration et de négociation plutôt que de conclusion.',
    'Ne signez pas encore le compromis.',
    'Utilisez votre charisme pour obtenir de meilleures conditions.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 70,
    'Le déménagement peut être organisé mais l''énergie favorise davantage la planification que l''action. Communiquez clairement avec toutes les parties impliquées.',
    'Évitez les malentendus en confirmant tout par écrit.',
    'Préparez tout méticuleusement pour un déménagement ultérieur.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 80,
    'Période favorable pour négocier l''achat d''un véhicule. Votre pouvoir de persuasion est renforcé et vous pouvez obtenir d''excellentes conditions.',
    'Attention aux vendeurs trop bavards qui pourraient vous influencer.',
    'Faites plusieurs comparatifs et négociez fermement.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 75,
    'Les achats importants peuvent être discutés et négociés. Les vendeurs seront plus réceptifs à vos arguments.',
    'Méfiez-vous de votre propre tendance à l''impulsivité verbale.',
    'Faites des recherches approfondies avant de vous engager.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 85,
    'La demande de financement est très bien soutenue. Votre capacité à présenter votre dossier et à convaincre les banquiers est à son apogée.',
    'Préparez vos arguments soigneusement.',
    'C''est le moment idéal pour les rendez-vous bancaires.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 90,
    'La recherche d''argent par le networking et la communication est excellente. Parlez de vos projets, rencontrez des investisseurs potentiels.',
    'Ne révélez pas tous vos secrets. Gardez votre avantage stratégique.',
    'Multipliez les contacts et les présentations.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 65,
    'Les investissements nécessitent moins de communication et plus de réflexion. Cette période n''est pas la plus propice aux décisions financières majeures.',
    'Évitez de vous laisser convaincre par d''autres.',
    'Rassemblez des informations mais attendez pour agir.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 70,
    'La signature de contrat est possible mais relisez tout très attentivement. L''énergie de communication peut masquer des détails importants.',
    'Ne vous laissez pas presser. Demandez du temps pour relire.',
    'Faites relire le contrat par un tiers de confiance.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 85,
    'Le lancement business axé sur la communication, le marketing ou les services est très favorable. Faites-vous connaître, créez du buzz.',
    'Assurez-vous que le contenu suit la forme.',
    'Excellent moment pour les lancements publics et les présentations.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 90,
    'Les partenariats se négocient merveilleusement bien en cette période. Votre charisme et votre éloquence attirent les bons partenaires.',
    'Formalisez tout par écrit.',
    'Rencontrez plusieurs partenaires potentiels et comparez.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 95,
    'L''entretien d''embauche est exceptionnellement favorisé. Votre capacité à vous exprimer, à convaincre et à créer une connexion est maximale.',
    'Attention à ne pas trop parler. Écoutez aussi.',
    'C''est LE moment pour les entretiens importants.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 85,
    'La demande de promotion peut être formulée avec éloquence. Présentez vos réalisations avec clarté et conviction.',
    'Choisissez le bon moment et le bon lieu.',
    'Préparez un pitch clair et mémorable.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 75,
    'La démission peut être annoncée avec diplomatie. Les énergies de communication aident à partir en bons termes.',
    'Ne brûlez pas les ponts. Votre réseau est précieux.',
    'Utilisez cette période pour explorer d''autres opportunités par le networking.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 90,
    'Les voyages sont très favorisés, surtout ceux qui impliquent des rencontres et des échanges. Voyages d''affaires, conférences, réunions internationales.',
    'Gardez une trace de tous les contacts établis.',
    'Maximisez les opportunités de networking pendant vos déplacements.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 75,
    'Le mariage peut être discuté et planifié. C''est une bonne période pour les fiançailles et les annonces, moins pour la cérémonie elle-même.',
    'Assurez-vous que vous communiquez vraiment avec votre partenaire.',
    'Parlez de vos attentes et de vos rêves communs.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 95,
    'Débuter une relation est très favorisé. Les rencontres sont facilitées et les connexions se créent naturellement par la conversation.',
    'Ne confondez pas attirance intellectuelle et compatibilité profonde.',
    'Sortez, parlez, rencontrez du monde.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 70,
    'Les opérations médicales peuvent être discutées avec les médecins. C''est une bonne période pour les consultations et les seconds avis.',
    'L''intervention elle-même devrait être programmée à une autre période si possible.',
    'Posez toutes vos questions et obtenez des réponses claires.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 75,
    'Débuter un traitement est neutre. Discutez en profondeur avec votre praticien pour comprendre tous les aspects.',
    'Assurez-vous de bien comprendre le protocole.',
    'C''est le moment de poser des questions et de vous informer.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 3, 80,
    'Cette période favorise les décisions qui impliquent communication et négociation. Parlez, discutez, persuadez.',
    'Ne vous engagez pas trop vite verbalement.',
    'Utilisez vos talents de communication pour faire avancer vos projets.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 4 DU CYCLE PERSONNEL (Jours 157-208)
-- Thème: Transformation, Changements Inattendus, Adaptation
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 50,
    'Période de prudence pour la location. Les changements inattendus peuvent perturber vos plans. Évitez de vous engager dans de nouveaux baux.',
    'Le logement qui semble parfait pourrait révéler des défauts cachés.',
    'Si vous devez absolument déménager, gardez une option de sortie.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 35,
    'L''achat immobilier est fortement déconseillé en cette période de turbulence cosmique. Les transactions risquent de présenter des complications imprévues.',
    'Attendez la période suivante pour les décisions majeures.',
    'Utilisez ce temps pour approfondir votre recherche sans engagement.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 45,
    'Le déménagement peut être chaotique et source de complications. Si possible, reportez à une période plus stable.',
    'Prévoyez des plans de secours pour tout.',
    'Si le déménagement est inévitable, redoublez de vigilance sur chaque détail.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 40,
    'L''achat de véhicule est risqué. Les problèmes cachés peuvent se révéler après l''achat. Attendez si possible.',
    'Méfiez-vous des bonnes affaires trop belles pour être vraies.',
    'Si urgent, optez pour une location temporaire.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 45,
    'Les achats importants peuvent vous décevoir. La qualité promise peut ne pas être au rendez-vous.',
    'Évitez les achats impulsifs.',
    'Reportez les achats non urgents à la prochaine période.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 40,
    'Les demandes de financement risquent d''être refusées ou d''aboutir à des conditions défavorables.',
    'Évitez de contracter des dettes maintenant.',
    'Attendez la période suivante pour soumettre votre dossier.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 45,
    'La recherche d''argent peut amener des sources peu fiables ou des promesses non tenues.',
    'Vérifiez scrupuleusement chaque opportunité.',
    'Concentrez-vous sur la conservation de vos ressources actuelles.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 30,
    'Les investissements en cette période sont hautement déconseillés. Les retournements de marché peuvent vous surprendre.',
    'NE PRENEZ PAS DE RISQUES FINANCIERS.',
    'Conservez vos liquidités et attendez la tempête passer.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 35,
    'La signature de contrat est très déconseillée. Les clauses problématiques peuvent vous échapper ou des changements imprévus peuvent rendre le contrat défavorable.',
    'Reportez toute signature si possible.',
    'Faites réviser tout document par un professionnel si vous ne pouvez pas attendre.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 40,
    'Le lancement business est à éviter. Les imprévus peuvent faire dérailler vos plans.',
    'Ce n''est pas le moment de se lancer.',
    'Utilisez cette période pour peaufiner votre stratégie en coulisses.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 35,
    'Les partenariats conclus maintenant risquent de mal tourner. Les intentions des autres peuvent être mal comprises.',
    'Méfiez-vous des propositions trop alléchantes.',
    'Observez vos partenaires potentiels sans vous engager.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 55,
    'Les entretiens d''embauche peuvent présenter des résultats mitigés. Soyez prudent dans vos attentes.',
    'L''emploi obtenu maintenant pourrait ne pas correspondre à vos attentes.',
    'Posez beaucoup de questions sur la réalité du poste.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 40,
    'La demande de promotion peut être mal reçue ou aboutir à des conditions décevantes.',
    'Ce n''est pas le bon moment pour cette démarche.',
    'Attendez que l''énergie soit plus favorable.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 60,
    'La démission peut être envisagée si la situation est vraiment insupportable. Les transformations sont dans l''air.',
    'Assurez-vous d''avoir un plan B solide.',
    'Si vous partez, ayez conscience que la transition sera tumultueuse.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 50,
    'Les voyages peuvent être perturbés par des imprévus. Retards, annulations, complications.',
    'Prévoyez des marges et des options de secours.',
    'Voyagez léger et flexible.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 40,
    'Le mariage ou l''engagement est déconseillé. Les unions formées en période de turbulence portent cette énergie en elles.',
    'Attendez une période plus stable pour les engagements majeurs.',
    'Confirmez votre amour sans formalité officielle pour le moment.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 50,
    'Les nouvelles relations peuvent être intenses mais instables. Elles peuvent transformer votre vie de manière inattendue.',
    'Ne vous attachez pas trop vite.',
    'Vivez les rencontres comme des expériences d''apprentissage.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 55,
    'Les opérations médicales d''urgence doivent être faites, mais les interventions électives devraient être reportées si possible.',
    'Le processus de guérison peut être plus compliqué que prévu.',
    'Consultez plusieurs avis médicaux.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 60,
    'Débuter un traitement peut être nécessaire mais les résultats peuvent être irréguliers. Ajustements fréquents possibles.',
    'Suivez de près l''évolution et communiquez avec votre médecin.',
    'Soyez patient et flexible dans votre approche.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 4, 45,
    'Cette période demande prudence et flexibilité. Les décisions importantes devraient être reportées si possible.',
    'Attendez-vous à des changements de direction.',
    'Restez adaptable et gardez vos options ouvertes.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 5 DU CYCLE PERSONNEL (Jours 209-260)
-- Thème: Expansion, Croissance, Publicité
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'L''Univers soutient votre expansion résidentielle. Cherchez plus grand, plus beau, plus adapté à votre croissance.',
    'Ne vous surendiez pas financièrement dans l''euphorie.',
    'C''est le moment de viser haut dans vos recherches de logement.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'L''achat immobilier pour l''expansion est favorisé. Investissez dans un bien qui vous permettra de grandir.',
    'Évaluez bien votre capacité de remboursement à long terme.',
    'Pensez à l''avenir et à vos besoins futurs.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'Le déménagement vers un espace plus grand est très favorisé. L''Univers accompagne votre croissance.',
    'Assumez ce changement avec enthousiasme.',
    'C''est le moment de concrétiser vos rêves d''espace.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'L''achat d''un véhicule plus performant ou plus spacieux est soutenu. Investissez dans la mobilité.',
    'Choisissez un véhicule qui accompagnera votre expansion.',
    'C''est le bon moment pour changer de catégorie.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 90,
    'Les achats importants qui soutiennent votre croissance sont très favorisés. Investissez dans ce qui vous fait progresser.',
    'Gardez le cap sur vos objectifs d''expansion.',
    'Achetez ce qui vous projette vers l''avenir.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'Les demandes de financement pour l''expansion sont très bien reçues. Les institutions voient votre potentiel de croissance.',
    'Présentez un plan de croissance réaliste.',
    'Demandez ce dont vous avez besoin pour décoller.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 90,
    'La recherche d''argent porte ses fruits. Les investisseurs sont réceptifs à vos visions de croissance.',
    'Ne soyez pas trop gourmand dans vos demandes.',
    'Présentez votre vision avec passion et clarté.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'Les investissements en croissance sont favorisés. Placez dans ce qui peut s''apprécier significativement.',
    'Diversifiez vos placements.',
    'Pensez long terme et potentiel de croissance.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'La signature de contrats d''expansion est très favorable. Engagements commerciaux, partenariats de croissance.',
    'Vérifiez les clauses d''évolution et d''adaptation.',
    'Signez des accords qui permettent la flexibilité.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 95,
    'Le lancement business est extrêmement favorisé. Les Forces Cosmiques amplifient votre visibilité et votre impact.',
    'Assurez-vous d''avoir les ressources pour gérer la croissance.',
    'Lancez-vous maintenant avec un marketing puissant.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'Les partenariats d''expansion sont très favorisés. Alliez-vous à ceux qui peuvent amplifier votre croissance.',
    'Choisissez des partenaires partageant votre vision de croissance.',
    'Formez des alliances stratégiques ambitieuses.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'Les entretiens d''embauche sont favorisés, surtout pour des postes avec potentiel d''évolution rapide.',
    'Négociez des clauses de progression.',
    'Visez des entreprises en croissance.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 90,
    'La demande de promotion est très bien soutenue. Vos réalisations rayonnent et les décideurs le voient.',
    'Demandez avec confiance ce que vous méritez.',
    'C''est LE moment pour cette démarche.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'La démission pour saisir de meilleures opportunités est soutenue. L''expansion appelle parfois un changement de cadre.',
    'Assurez-vous que la nouvelle opportunité est vraiment meilleure.',
    'Partez vers quelque chose de plus grand.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 90,
    'Les voyages d''expansion sont excellents. Conférences, prospection internationale, exploration de nouveaux marchés.',
    'Documentez tout ce que vous apprenez.',
    'Voyagez avec des objectifs de croissance clairs.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'Le mariage ou l''engagement qui permet l''expansion commune est favorisé. Une union qui vous fait tous deux grandir.',
    'Partagez vos visions d''avenir.',
    'Planifiez une cérémonie qui reflète vos ambitions communes.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 80,
    'Les nouvelles relations peuvent s''épanouir rapidement. L''énergie d''expansion touche aussi le domaine sentimental.',
    'Laissez la relation se développer naturellement.',
    'Soyez ouvert aux connexions significatives.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 70,
    'Les opérations médicales sont possibles avec une bonne récupération attendue. Le corps est en mode croissance.',
    'Prévoyez une période de récupération active.',
    'Choisissez des praticiens de qualité.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 75,
    'Débuter un traitement d''amélioration est favorable. Les traitements visant la vitalité et l''énergie sont soutenus.',
    'Suivez le protocole avec régularité.',
    'Adoptez une approche holistique de votre santé.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 5, 85,
    'Cette période favorise toute décision qui vous fait grandir et vous projette vers l''avant.',
    'Ne vous dispersez pas dans trop de directions.',
    'Concentrez votre expansion sur vos priorités.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 6 DU CYCLE PERSONNEL (Jours 261-312)
-- Thème: Prudence, Conservation, Réflexion
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 55,
    'Période de prudence pour les engagements résidentiels. Les énergies favorisent la conservation plutôt que les nouveaux départs.',
    'Évitez les engagements à long terme.',
    'Si vous devez déménager, optez pour des solutions temporaires.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 45,
    'L''achat immobilier est déconseillé. C''est une période de conservation, pas d''acquisition majeure.',
    'Reportez les décisions d''achat importantes.',
    'Utilisez ce temps pour épargner et préparer un futur achat.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'Le déménagement n''est pas recommandé sauf nécessité absolue. Les énergies favorisent la stabilité.',
    'Les complications sont plus probables.',
    'Si possible, attendez la prochaine période.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'L''achat de véhicule devrait être reporté. Entretenez plutôt votre véhicule actuel.',
    'Les achats maintenant peuvent s''avérer décevants.',
    'Faites les réparations nécessaires sur l''existant.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 45,
    'Les achats importants sont à éviter. C''est le moment de conserver vos ressources.',
    'La période favorise l''économie, pas la dépense.',
    'Reportez les achats non essentiels.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 40,
    'Évitez de contracter de nouvelles dettes. C''est une période de prudence financière.',
    'Les conditions obtenues risquent d''être défavorables.',
    'Remboursez plutôt vos dettes existantes.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'La recherche d''argent nécessite patience et diplomatie. Les résultats peuvent tarder.',
    'Ne forcez pas les choses.',
    'Maintenez vos contacts mais sans insister.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 35,
    'Les investissements sont fortement déconseillés. Protégez votre capital existant.',
    'Risque de pertes élevé.',
    'Conservez vos liquidités en sécurité.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'Évitez de signer des contrats importants. Les termes peuvent ne pas vous être favorables.',
    'Relisez tout très attentivement.',
    'Négociez des clauses de sortie.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 45,
    'Le lancement business devrait être reporté. Les énergies ne soutiennent pas les nouvelles initiatives.',
    'Les résultats seront décevants.',
    'Peaufinez votre projet en coulisses.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'Les nouveaux partenariats sont à éviter. Consolidez les relations existantes.',
    'Les nouvelles alliances peuvent être instables.',
    'Renforcez vos partenariats actuels.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 60,
    'Les entretiens d''embauche peuvent aboutir mais avec des conditions moins favorables.',
    'Ne négociez pas trop agressivement.',
    'Acceptez une position comme tremplin.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 50,
    'La demande de promotion peut être mal reçue. C''est une période de consolidation.',
    'Attendez un moment plus favorable.',
    'Préparez votre dossier pour plus tard.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 55,
    'La démission est neutre. Si la situation est vraiment intenable, partez, sinon attendez.',
    'La période suivante offrira de meilleures opportunités.',
    'Préparez votre sortie si elle est inévitable.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 60,
    'Les voyages de réflexion et de ressourcement sont bénéfiques. Évitez les voyages d''affaires risqués.',
    'Privilégiez les destinations calmes.',
    'C''est le moment de se ressourcer.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 55,
    'Le mariage devrait être reporté à une période plus dynamique. Les énergies sont trop conservatrices.',
    'L''union manquerait de dynamisme.',
    'Planifiez pour la période 7 ou le prochain cycle.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 55,
    'Les nouvelles relations progressent lentement. Ne forcez pas les choses.',
    'La patience est de mise.',
    'Laissez les choses évoluer naturellement.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 65,
    'Les opérations médicales de routine sont acceptables. Le corps est en mode conservation.',
    'Prévoyez une récupération plus longue.',
    'Optez pour des approches conservatrices.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 70,
    'Les traitements de maintien sont favorisés. C''est le moment de stabiliser plutôt que de chercher des changements drastiques.',
    'Suivez les protocoles établis.',
    'Consolidez les progrès déjà faits.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 6, 55,
    'Cette période favorise la réflexion et la prudence. Évitez les décisions impulsives.',
    'Prenez le temps de tout considérer.',
    'Préparez-vous pour agir dans la prochaine période.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- PÉRIODE 7 DU CYCLE PERSONNEL (Jours 313-365)
-- Thème: Récolte, Bilan, Préparation au Renouveau
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'Période favorable pour finaliser des processus de location entamés. Récoltez les fruits de vos recherches précédentes.',
    'Finalisez plutôt que de commencer.',
    'Excellent pour conclure des négociations en cours.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'L''achat immobilier peut aboutir si le processus était déjà engagé. Nouvelle recherche déconseillée.',
    'Concluez les affaires en cours.',
    'Finalisez ou reportez au nouveau cycle.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 65,
    'Le déménagement peut se faire si tout est déjà organisé. Nouvelles initiatives à reporter.',
    'Terminez ce qui est commencé.',
    'Organisez-vous pour un nouveau départ au prochain cycle.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 65,
    'L''achat de véhicule est possible si la décision était mûrie. Évitez les impulsions.',
    'Concluez les comparaisons en cours.',
    'Attendez le nouveau cycle si vous n''êtes pas prêt.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'Les achats planifiés de longue date peuvent être finalisés. Nouvelles dépenses déconseillées.',
    'N''ajoutez pas de nouveaux achats.',
    'Faites le bilan de vos besoins pour le prochain cycle.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 60,
    'Les financements peuvent être conclus si le dossier était déjà constitué. Nouvelles demandes à reporter.',
    'Ne contractez pas de nouvelles dettes avant le nouveau cycle.',
    'Planifiez vos besoins financiers futurs.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 65,
    'La recherche d''argent peut aboutir si les contacts étaient établis. C''est le temps de la récolte.',
    'Ne négociez pas trop agressivement.',
    'Récoltez les fruits de vos efforts passés.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 55,
    'Les investissements restent prudents. Prenez des bénéfices si possible.',
    'Ne prenez pas de nouveaux risques.',
    'Faites le bilan de votre portefeuille.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 80,
    'La signature de contrats préparés est très favorable. C''est le moment de conclure.',
    'Ne signez que ce qui est bien négocié.',
    'Excellent pour finaliser les accords en suspens.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 65,
    'Le lancement business devrait attendre le nouveau cycle. Finalisez les préparatifs.',
    'Tout doit être prêt pour un lancement au nouveau cycle.',
    'Utilisez ce temps pour peaufiner votre stratégie.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'Les partenariats négociés peuvent être conclus. Nouvelles négociations à reporter.',
    'Finalisez les accords en cours.',
    'Préparez de nouvelles alliances pour le cycle suivant.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'Les entretiens d''embauche sont bons pour des postes qui commenceront au nouveau cycle.',
    'Négociez une date de démarrage favorable.',
    'Préparez-vous pour un nouveau départ.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'La demande de promotion peut être faite pour prendre effet au nouveau cycle.',
    'Planifiez stratégiquement.',
    'Demandez une date d''effet favorable.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'La démission peut être annoncée pour un départ au nouveau cycle. Bonne période pour les transitions.',
    'Partez en bons termes.',
    'Planifiez votre sortie avec grâce.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 80,
    'Les voyages de bilan et de ressourcement sont excellents. Préparez-vous au renouveau.',
    'Utilisez ce temps pour réfléchir.',
    'Voyages spirituels ou de réflexion très favorisés.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'Le mariage peut être planifié pour le début du nouveau cycle. C''est une période de finalisation.',
    'Terminez les préparatifs.',
    'La cérémonie au nouveau cycle sera bénie.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'Les relations amorcées peuvent se stabiliser. L''heure est au bilan relationnel.',
    'Évaluez la qualité de vos connexions.',
    'Préparez-vous à des engagements plus profonds au nouveau cycle.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 70,
    'Les opérations médicales peuvent se faire si prévues. Le corps se prépare au renouveau.',
    'La récupération sera bonne.',
    'Planifiez pour être en forme au nouveau cycle.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'Les traitements peuvent être ajustés ou renouvelés. Faites le bilan de votre santé.',
    'Préparez un plan santé pour le nouveau cycle.',
    'Consultez pour optimiser votre bien-être.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'personal', 7, 75,
    'Cette période est idéale pour les conclusions et les bilans. Récoltez et préparez le renouveau.',
    'Finissez ce qui est en cours.',
    'Planifiez votre prochaine année avec sagesse.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- CYCLE QUOTIDIEN (daily) - Périodes A à G
-- Conseils généraux par période quotidienne
-- ================================================

-- PÉRIODE A (Influence, Planification) - Lundi commence par A
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85,
    'Période d''Influence - Excellent moment pour négocier un bail ou contacter un propriétaire. Votre pouvoir de persuasion est amplifié.',
    'N''attendez pas passivement.',
    'Initiez les contacts maintenant.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 80,
    'Période A favorable aux démarches d''achat immobilier. Planifiez vos visites et sollicitez les agents.',
    'Soyez proactif.',
    'C''est le moment de lancer vos recherches.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Période propice à la planification du déménagement. Organisez et coordonnez.', 'Initiez les contacts avec les déménageurs.', 'Excellent pour établir des plans.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 80, 'Bon moment pour négocier l''achat d''un véhicule. Votre influence est forte.', 'Soyez persuasif.', 'Visitez les concessionnaires.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 80, 'Période favorable aux négociations d''achats importants.', 'Marchandez.', 'Comparez et négociez.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Excellent moment pour présenter une demande de financement. Votre dossier sera bien reçu.', 'Préparez vos arguments.', 'Sollicitez les banques maintenant.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 90, 'Période idéale pour la recherche de fonds. Votre pouvoir de persuasion est maximal.', 'Profitez de cette fenêtre.', 'Contactez investisseurs et banques.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 70, 'Moment de planification plutôt que d''action pour les investissements.', 'Ne précipitez pas les décisions.', 'Analysez les options.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Période favorable pour négocier et préparer les termes d''un contrat.', 'Lisez attentivement.', 'Négociez les clauses importantes.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 90, 'Moment idéal pour lancer ou annoncer un business. L''influence cosmique amplifie votre message.', 'Maximisez votre visibilité.', 'Faites des présentations.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Excellent pour négocier des partenariats. Votre charisme est au maximum.', 'Proposez des termes gagnant-gagnant.', 'Initiez les discussions.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 90, 'Période idéale pour les entretiens d''embauche. Votre énergie persuasive impressionne.', 'Parlez avec confiance.', 'Demandez des entretiens maintenant.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Bon moment pour demander une promotion. Présentez vos réalisations.', 'Soyez direct mais respectueux.', 'Sollicitez un rendez-vous.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 75, 'Annoncez votre démission avec diplomatie en période A.', 'Restez professionnel.', 'Préparez votre transition.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 80, 'Planifiez vos voyages en période A.', 'Organisez les détails.', 'Réservez et planifiez.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 80, 'Période favorable aux déclarations et engagements amoureux.', 'Parlez avec le cœur.', 'Exprimez vos sentiments.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Excellent pour initier une nouvelle relation. Votre charisme attire.', 'Soyez authentique.', 'Faites le premier pas.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 70, 'Période de planification pour les questions médicales.', 'Prenez rendez-vous.', 'Consultez un spécialiste.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 75, 'Bon moment pour consulter et planifier un traitement.', 'Discutez avec votre médecin.', 'Prenez des rendez-vous.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 1, 85, 'Période A idéale pour initier des projets et influencer les autres.', 'Agissez avec intention.', 'Lancez vos initiatives.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE B (Social, Raffinement) - Corresponde aux mardis
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 80, 'Période sociale favorable aux visites de logements avec accompagnement.', 'Prenez des avis extérieurs.', 'Visitez en bonne compagnie.'
FROM cycle_vie_decision_types WHERE code = 'location_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Bon moment pour discuter d''achats immobiliers en famille ou avec un conseiller.', 'Écoutez les avis.', 'Consultez vos proches.'
FROM cycle_vie_decision_types WHERE code = 'achat_immobilier';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Déménagement en équipe favorisé.', 'Coordonnez avec les autres.', 'Organisez une aide collective.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 70, 'Discutez de l''achat véhicule avec vos proches.', 'Prenez des conseils.', 'Consultez avant de décider.'
FROM cycle_vie_decision_types WHERE code = 'achat_vehicule';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Achats importants en compagnie conseillés.', 'Deux avis valent mieux qu''un.', 'Faites-vous accompagner.'
FROM cycle_vie_decision_types WHERE code = 'achat_important';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 70, 'Discutez de vos options de financement avec un conseiller.', 'Écoutez les recommandations.', 'Consultez un expert.'
FROM cycle_vie_decision_types WHERE code = 'demande_financement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 80, 'Période favorable au networking pour trouver de l''argent.', 'Utilisez votre réseau social.', 'Participez à des événements.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 65, 'Discutez d''investissements avec des experts, mais ne décidez pas encore.', 'Collectez les avis.', 'Consultez des conseillers.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Bon moment pour des réunions de négociation de contrat.', 'Soyez diplomate.', 'Réunissez les parties.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Période favorable pour les lancements avec partenaires ou équipe.', 'Collaborez.', 'Lancez en équipe.'
FROM cycle_vie_decision_types WHERE code = 'lancement_business';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 85, 'Excellent moment pour rencontrer des partenaires potentiels.', 'Soyez ouvert.', 'Multipliez les rencontres.'
FROM cycle_vie_decision_types WHERE code = 'partenariat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 80, 'Entretiens d''embauche en panel ou avec plusieurs personnes favorisés.', 'Connectez avec chacun.', 'Montrez vos qualités relationnelles.'
FROM cycle_vie_decision_types WHERE code = 'entretien_embauche';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 75, 'Demande de promotion lors d''un moment convivial.', 'Choisissez un contexte détendu.', 'Évitez les confrontations.'
FROM cycle_vie_decision_types WHERE code = 'demande_promotion';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 70, 'Démission annoncée avec tact et diplomatie.', 'Restez élégant.', 'Préservez les relations.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 90, 'Voyages sociaux et en groupe très favorisés.', 'Profitez de la compagnie.', 'Voyagez avec des amis.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 85, 'Période idéale pour une cérémonie ou une fête de fiançailles.', 'Célébrez en groupe.', 'Invitez vos proches.'
FROM cycle_vie_decision_types WHERE code = 'mariage_engagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 90, 'Excellent pour les rencontres sociales et les nouveaux liens.', 'Sortez et mêlez-vous.', 'Participez à des événements.'
FROM cycle_vie_decision_types WHERE code = 'debut_relation';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 65, 'Consultations médicales avec accompagnement d''un proche.', 'Faites-vous accompagner.', 'Prenez un soutien.'
FROM cycle_vie_decision_types WHERE code = 'operation_medicale';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 70, 'Discutez de traitements avec famille ou groupe de soutien.', 'Partagez vos préoccupations.', 'Cherchez du soutien.'
FROM cycle_vie_decision_types WHERE code = 'debut_traitement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 2, 80, 'Période B favorise les décisions prises en concertation.', 'Écoutez les autres.', 'Décidez en groupe.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE C à G - Ajoutés de manière condensée pour compléter
-- (Chaque période a 20 conseils = 100 entrées supplémentaires)

-- PÉRIODE C (Connaissance) - score moyen 70-80 pour recherche et apprentissage
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 75, 'Période de recherche et d''analyse. Étudiez vos options de logement.', 'Prenez des notes.', 'Faites vos recherches.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 80, 'Excellente période pour l''étude de dossiers financiers.', 'Analysez en profondeur.', 'Faites des comparatifs.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent', 'investissement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 75, 'Relisez et analysez les contrats avec attention.', 'Étudiez chaque clause.', 'Consultez un expert.'
FROM cycle_vie_decision_types WHERE code = 'signature_contrat';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 70, 'Période de planification et d''étude pour le business.', 'Faites des études de marché.', 'Analysez la concurrence.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 80, 'Période favorable pour préparer les entretiens et étudier l''entreprise.', 'Faites vos recherches.', 'Documentez-vous.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 85, 'Voyages éducatifs et de découverte très favorisés.', 'Apprenez en voyageant.', 'Visitez des musées et sites culturels.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 70, 'Réfléchissez profondément à vos engagements.', 'Ne précipitez pas.', 'Prenez du recul.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 80, 'Période idéale pour rechercher des informations médicales.', 'Documentez-vous.', 'Posez des questions aux spécialistes.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 3, 80, 'Période C favorise l''analyse et la réflexion.', 'Étudiez avant d''agir.', 'Prenez le temps de comprendre.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE D (Matériel) - Neutre, bon pour les affaires administratives
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 70, 'Période neutre. Bon moment pour les tâches administratives.', 'Restez pratique.', 'Gérez la paperasse.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'investissement', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 75, 'Période favorable pour les questions d''argent pratiques.', 'Soyez méthodique.', 'Organisez vos finances.'
FROM cycle_vie_decision_types WHERE code = 'recherche_argent';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 65, 'Période moins favorable aux lancements créatifs.', 'Restez concret.', 'Gérez l''administratif du business.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 70, 'Période neutre pour les entretiens. Focus sur le concret.', 'Parlez résultats.', 'Mettez en avant vos réalisations tangibles.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 60, 'Voyages d''affaires pratiques favorisés. Évitez le tourisme.', 'Restez efficace.', 'Concentrez-vous sur les objectifs.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 60, 'Période moins romantique. Questions pratiques du couple.', 'Discutez finances.', 'Abordez les aspects matériels.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 70, 'Bon moment pour gérer les aspects administratifs de la santé.', 'Organisez vos dossiers.', 'Gérez l''assurance et les rendez-vous.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 4, 70, 'Période D : neutre et pratique. Gérez le quotidien.', 'Soyez efficace.', 'Occupez-vous des détails.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE E (Action) - Haute énergie, décisions et avancement
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 90, 'Période d''Action! Excellente pour conclure et avancer.', 'Agissez maintenant.', 'C''est le moment de décider.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 85, 'Soumettez vos demandes maintenant pour des résultats rapides.', 'Soyez direct.', 'Passez à l''action.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 80, 'Période favorable aux décisions d''investissement rapides.', 'Ayez déjà fait vos recherches.', 'Le moment est venu d''agir.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 90, 'Lancez votre business pendant la période E!', 'L''énergie vous propulse.', 'C''est maintenant ou jamais.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 90, 'Période idéale pour les entretiens décisifs et les promotions.', 'Montrez votre dynamisme.', 'Demandez ce que vous voulez.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 85, 'Voyages d''action et d''affaires très productifs.', 'Maximisez votre temps.', 'Soyez efficace.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 80, 'Faites votre demande ou votre déclaration !', 'Le courage est de mise.', 'Passez à l''action amoureuse.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 75, 'Période énergique pour les interventions et les traitements actifs.', 'Le corps est prêt.', 'Agissez sur votre santé.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 5, 90, 'Période E: passez à l''action! Tranchez et décidez.', 'N''hésitez plus.', 'Le moment est venu.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE F (Succès) - Très favorable pour conclure
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 95, 'Période de Succès! Idéale pour signer et conclure.', 'Finalisez maintenant.', 'C''est le moment de la récolte.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'achat_vehicule', 'achat_important', 'signature_contrat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 85, 'Déménagements conclus avec succès.', 'Tout se passe bien.', 'Finalisez votre installation.'
FROM cycle_vie_decision_types WHERE code = 'demenagement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 90, 'Demandes de financement approuvées. Obtenez ce que vous voulez.', 'La faveur est de votre côté.', 'Demandez maintenant.'
FROM cycle_vie_decision_types WHERE code IN ('demande_financement', 'recherche_argent');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 85, 'Investissements conclus avec de bons termes.', 'Finalisez les transactions.', 'Concluez vos placements.'
FROM cycle_vie_decision_types WHERE code = 'investissement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 90, 'Succès business! Lancez ou concluez des partenariats.', 'L''énergie du succès vous accompagne.', 'Signez les accords.'
FROM cycle_vie_decision_types WHERE code IN ('lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 95, 'Offres d''emploi reçues! Promotions accordées!', 'Le succès vous sourit.', 'Acceptez les offres favorables.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 80, 'Transition réussie si vous partez.', 'Sortez en gagnant.', 'Négociez vos conditions.'
FROM cycle_vie_decision_types WHERE code = 'demission_changement';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 90, 'Voyages couronnés de succès. Objectifs atteints.', 'Profitez du moment.', 'Célébrez vos réussites.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 95, 'Oui sera la réponse! Période idéale pour les engagements.', 'Demandez maintenant.', 'Les unions sont bénies.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 80, 'Interventions médicales réussies. Bonne récupération.', 'Résultats positifs attendus.', 'Programmez pendant cette période.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 6, 95, 'Période F: le succès vous attend. Concluez vos affaires.', 'Saisissez le moment.', 'La fortune favorise les audacieux.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- PÉRIODE G (Réflexion) - Repos et méditation
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 50, 'Période de repos. Évitez les nouvelles initiatives.', 'Reposez-vous.', 'Reportez les décisions à demain.'
FROM cycle_vie_decision_types WHERE code IN ('location_immobilier', 'achat_immobilier', 'demenagement', 'achat_vehicule', 'achat_important', 'demande_financement', 'recherche_argent', 'investissement', 'signature_contrat', 'lancement_business', 'partenariat');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 55, 'Réfléchissez à votre carrière sans prendre de décision.', 'Méditez sur vos options.', 'Planifiez mentalement.'
FROM cycle_vie_decision_types WHERE code IN ('entretien_embauche', 'demande_promotion', 'demission_changement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 70, 'Voyages de repos et de méditation favorisés.', 'Ressourcez-vous.', 'Retraites spirituelles idéales.'
FROM cycle_vie_decision_types WHERE code = 'voyage';

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 60, 'Réfléchissez à vos relations en silence.', 'Ne provoquez pas de confrontations.', 'Contemplez vos sentiments.'
FROM cycle_vie_decision_types WHERE code IN ('mariage_engagement', 'debut_relation');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 60, 'Période de repos pour le corps. Évitez les traitements intensifs.', 'Laissez le corps récupérer.', 'Repos et méditation.'
FROM cycle_vie_decision_types WHERE code IN ('operation_medicale', 'debut_traitement');

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT id, 'daily', 7, 55, 'Période G: méditez et reposez-vous. Évitez les décisions majeures.', 'Demain sera plus propice.', 'Rechargez vos énergies.'
FROM cycle_vie_decision_types WHERE code = 'autre_decision';

-- ================================================
-- VÉRIFICATION FINALE
-- ================================================
SELECT 'Conseils Decision Advice insérés avec succès!' AS status;
SELECT cycle_type, period_number, COUNT(*) as nb_conseils 
FROM cycle_vie_decision_advice 
GROUP BY cycle_type, period_number 
ORDER BY cycle_type, period_number;

