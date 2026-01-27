-- ================================================
-- MIGRATION CYCLES DE VIE - PARTIE 3/4
-- Données initiales (seed)
-- Exécuter après migration_cycles_vie_pricing.sql
-- ================================================

-- ================================================
-- 1. SEED DES PÉRIODES SOUL CYCLE
-- 14 entrées = 7 périodes × 2 polarités
-- Les textes complets seront rédigés via le panneau admin
-- ================================================

INSERT INTO cycle_vie_soul_periods (period_number, polarity, date_start, date_end, period_name, period_title, description_general, traits_positifs, traits_vigilance, professions_favorables, sante_vigilance)
VALUES
    -- Période 1: Les Leaders (22 mars - 12 mai)
    (1, 'A', '03-22', '04-17', 'Les Leaders', 'Le Guerrier Noble', 
     'Vous êtes né sous le signe de la noblesse et de l''aspiration. Votre nature profonde vous pousse vers les positions élevées et le respect d''autrui.',
     'Leadership naturel, présence charismatique, parole donnée respectée, aspirations pratiques',
     'Tendance à vouloir dominer, impatience envers ceux qui n''aspirent pas à s''élever',
     'Direction, management, droit, architecture, design de métaux précieux',
     'Cœur et cerveau (surmenage), yeux, fièvres'),
    
    (1, 'B', '04-17', '05-12', 'Les Leaders', 'L''Artiste Déterminé', 
     'Vous atteignez vos objectifs avec subtilité et patience plutôt que par la force. Vous êtes attiré par les arts, le théâtre et la musique.',
     'Raffinement, gentillesse, détermination tranquille, talents artistiques',
     'Entêtement parfois excessif',
     'Arts, théâtre, musique, design',
     'Cœur et cerveau, yeux, fièvres'),
    
    -- Période 2: Les Voyageurs (13 mai - 3 juillet)
    (2, 'A', '05-13', '06-08', 'Les Voyageurs', 'L''Esprit Vif', 
     'Vous avez un amour profond du voyage et du changement. L''intellect vif et les mains agiles sont vos atouts.',
     'Intellect rapide, langue agile, mains habiles, capacité à mener deux occupations',
     'Peut paraître inconstant ou frivole',
     'Représentation commerciale, secrétariat, art, vente, journalisme, théâtre',
     'Vessie, rhumatismes, rhumes (estomac/pieds)'),
    
    (2, 'B', '06-08', '07-03', 'Les Voyageurs', 'L''Intuitif Réservé', 
     'Votre intellect est plus réservé mais profond. Vous possédez une mémoire excellente et des sens intuitifs développés.',
     'Mémoire excellente, intuition prophétique, stabilité relative',
     'Tendance à la procrastination intellectuelle',
     'Secrétariat de direction, conseil, recherche',
     'Vessie, rhumatismes, rhumes'),
    
    -- Période 3: Les Maîtres de Soi (4 juillet - 24 août)
    (3, 'A', '07-04', '07-31', 'Les Maîtres de Soi', 'L''Aventurier', 
     'Vous êtes naturellement aventurier et explorateur. Le risque ne vous effraie pas, vous cherchez à repousser les limites.',
     'Aventure, exploration, courage, capacité à mener des troupes',
     'Prise de risques excessive, double vie possible',
     'Leadership militaire, exploration, politique, mouvements de réforme',
     'Maladies du sang (eczéma, furoncles), calculs biliaires, régime carnée'),
    
    (3, 'B', '07-31', '08-24', 'Les Maîtres de Soi', 'Le Souverain', 
     'Vous avez des instincts royaux naturels. Vous aimez les cérémonies, la lumière des projecteurs et l''approbation du public.',
     'Présence royale, sens du spectacle, capacité à atteindre les plus hautes fonctions',
     'Besoin excessif de reconnaissance',
     'Haute fonction politique, gouvernance, direction d''organisation',
     'Maladies du sang, calculs biliaires'),
    
    -- Période 4: Les Érudits (25 août - 15 octobre)
    (4, 'A', '08-25', '09-20', 'Les Érudits', 'Le Guide Spirituel', 
     'Vous avez une inclination naturelle vers les choses spirituelles. L''enseignement de l''éthique et de la philosophie vous attire.',
     'Génialité, bonne humeur, culture, inclinations artistiques et musicales',
     'Imagination parfois excessive, tendance à la surétude',
     'Enseignement musical, arts, clergé, éthique, philosophie, médecine, magistrature',
     'Vertiges, fatigue cérébrale, bégaiement léger, toux sèche, rhumes'),
    
    (4, 'B', '09-20', '10-15', 'Les Érudits', 'L''Esthète Équilibré', 
     'Vous excellez dans le raisonnement logique et les décisions équilibrées. Vous recherchez l''harmonie en toutes choses.',
     'Équilibre mental, amour du beau, mécénat des arts, capacité de décision',
     'Peut être trop théorique',
     'Art, écriture, contes fantastiques moraux, direction d''enfants',
     'Vertiges, fatigue cérébrale, rhumes'),
    
    -- Période 5: Les Philosophes (16 octobre - 6 décembre)
    (5, 'A', '10-16', '11-11', 'Les Philosophes', 'Le Combattant Généreux', 
     'Vous êtes agressif dans vos affaires car rempli de détermination et d''énergie. Vous refusez la médiocrité.',
     'Détermination, énergie, capacité à accomplir des choses difficiles',
     'Tendance aux accidents, précipitation',
     'Gouvernement, droit, plaidoirie, arguments de principes',
     'Inflammations, problèmes sanguins, maladies de peau, apoplexie'),
    
    (5, 'B', '11-11', '12-06', 'Les Philosophes', 'Le Sage Pacifique', 
     'Votre esprit guerrier est apaisé. Vous préférez éviter les querelles et croyez que tout finit par s''ajuster naturellement.',
     'Paix intérieure, amitié fidèle, leadership humanitaire, attunement spirituel',
     'Évitement parfois excessif des conflits',
     'Mouvements humanitaires, aide aux démunis, enseignement mystique',
     'Inflammations, problèmes de peau, apoplexie'),
    
    -- Période 6: Les Artistes (7 décembre - 27 janvier)
    (6, 'A', '12-07', '01-01', 'Les Artistes', 'Le Critique Éclairé', 
     'Vous tendez à enseigner et promulguer vos idées esthétiques. Vous pouvez analyser et pointer les erreurs que d''autres ne voient pas.',
     'Analyse fine, sens critique constructif, capacité pédagogique',
     'Tendance excessive à la critique',
     'Critique d''art/théâtre/musique, réforme éducative, philosophie, éthique',
     'Nervosité, suppression des fonctions naturelles, vessie, reins, intestins'),
    
    (6, 'B', '01-01', '01-27', 'Les Artistes', 'L''Antiquaire', 
     'Vous êtes critique à l''extrême envers vous-même. Vous aimez fouiller les vieilles librairies et les musées.',
     'Recherche passionnée, conversation captivante, capacité d''écriture',
     'Changements d''opinion impulsifs, auto-critique excessive',
     'Écriture de pièces, drames, scénarios, antiquariat',
     'Nervosité, problèmes abdominaux'),
    
    -- Période 7: Les Âmes Anciennes (28 janvier - 21 mars)
    (7, 'A', '01-28', '02-23', 'Les Âmes Anciennes', 'Le Chercheur Profond', 
     'Vous êtes souvent mené vers des occupations inhabituelles: expertise chimique, criminologie, archéologie, géologie.',
     'Profondeur de connaissance, dévotion, fiabilité, constance',
     'Réserve excessive, manque d''intérêt pour les divertissements',
     'Expertise chimique, criminologie, recherche historique, archéologie',
     'Oreilles, dents, yeux, voies respiratoires'),
    
    (7, 'B', '02-23', '03-21', 'Les Âmes Anciennes', 'Le Mystique Dual', 
     'Vous avez une tendance marquée vers le mysticisme et l''occultisme. Vous pouvez vivre une vie duale: public souriant, privé méditatif.',
     'Pouvoir magnétique, lecture de pensées, projection de conscience, amour de l''eau',
     'Dissociation entre vie publique et privée',
     'Direction d''organisation, voyages d''étude, recherche humaine',
     'Oreilles, dents, yeux, tuberculose, pneumonie, jaunisse')
ON CONFLICT (period_number, polarity) DO UPDATE SET
    date_start = EXCLUDED.date_start,
    date_end = EXCLUDED.date_end,
    period_name = EXCLUDED.period_name,
    period_title = EXCLUDED.period_title,
    description_general = EXCLUDED.description_general,
    traits_positifs = EXCLUDED.traits_positifs,
    traits_vigilance = EXCLUDED.traits_vigilance,
    professions_favorables = EXCLUDED.professions_favorables,
    sante_vigilance = EXCLUDED.sante_vigilance,
    updated_at = NOW();

-- ================================================
-- 2. SEED DES PÉRIODES QUOTIDIENNES (A-G)
-- 7 entrées avec mapping jour de semaine
-- ================================================

INSERT INTO cycle_vie_daily_periods (period_letter, weekday_number, period_name, keyword, description, activities_favorables, activities_eviter, color_code, energy_level)
VALUES
    ('A', 1, 'Période A', 'Influence', 
     'Période propice à l''influence et à la planification. Excellent moment pour solliciter, persuader et mettre en place des stratégies.',
     'Planification, sollicitation, influence des autres, démarrage de projets, présentations',
     'Attendre passivement, procrastiner sur des décisions importantes',
     '#10b981', 'high'),
    
    ('B', 2, 'Période B', 'Social', 
     'Période favorable aux contacts sociaux et au raffinement. Idéale pour les réunions, négociations et échanges.',
     'Réunions, négociations, contacts sociaux, branding personnel, raffinement',
     'Travail solitaire intense, confrontations',
     '#3b82f6', 'medium'),
    
    ('C', 3, 'Période C', 'Connaissance', 
     'Période excellente pour la recherche, l''apprentissage et la communication écrite. Favorise l''éducation et la publication.',
     'Recherche, lecture, éducation, publication, rédaction, apprentissage',
     'Activités purement physiques, décisions financières majeures',
     '#6366f1', 'medium'),
    
    ('D', 4, 'Période D', 'Matériel', 
     'Période neutre orientée vers les affaires matérielles. Convient aux tâches administratives et aux questions d''argent.',
     'Gestion financière, affaires matérielles, tâches administratives, organisation',
     'Nouveaux départs créatifs, décisions émotionnelles',
     '#f59e0b', 'neutral'),
    
    ('E', 5, 'Période E', 'Action', 
     'Période d''action et de décision. Moment pour pousser les projets en avant, arbitrer et trancher.',
     'Décisions importantes, avancement de projets, arbitrage, résolution de conflits',
     'Reports, hésitations, nouvelles initiatives non préparées',
     '#ef4444', 'high'),
    
    ('F', 6, 'Période F', 'Succès', 
     'Période très favorable au succès. Excellent moment pour conclure des affaires, obtenir des promotions et finaliser.',
     'Conclusions d''affaires, promotions, signatures, demandes de faveurs, fenêtre favorable',
     'Démarrer de longs projets, éviter les engagements',
     '#22c55e', 'high'),
    
    ('G', 7, 'Période G', 'Réflexion', 
     'Période de repos et de réflexion. Nécessaire pour recharger l''énergie et méditer sur les prochaines étapes.',
     'Méditation, planification future, repos, réflexion, travail intérieur',
     'Nouvelles initiatives, décisions majeures, efforts intenses',
     '#8b5cf6', 'low')
ON CONFLICT (period_letter) DO UPDATE SET
    weekday_number = EXCLUDED.weekday_number,
    period_name = EXCLUDED.period_name,
    keyword = EXCLUDED.keyword,
    description = EXCLUDED.description,
    activities_favorables = EXCLUDED.activities_favorables,
    activities_eviter = EXCLUDED.activities_eviter,
    color_code = EXCLUDED.color_code,
    energy_level = EXCLUDED.energy_level,
    updated_at = NOW();

-- ================================================
-- 3. SEED DES TYPES DE DÉCISIONS
-- 17 types couvrant les principales décisions de vie
-- ================================================

INSERT INTO cycle_vie_decision_types (code, label, category, icon_name, description, display_order)
VALUES
    -- Immobilier
    ('location_immobilier', 'Location / Immobilier', 'immobilier', 'home', 
     'Signature de bail, recherche de logement, visite d''appartement', 1),
    ('achat_immobilier', 'Achat Immobilier', 'immobilier', 'house', 
     'Achat de maison, appartement, terrain, investissement immobilier', 2),
    ('demenagement', 'Déménagement', 'immobilier', 'truck', 
     'Changement de domicile, emménagement, installation', 3),
    
    -- Finance
    ('achat_vehicule', 'Achat Véhicule', 'finance', 'car', 
     'Achat de voiture, moto, véhicule de transport', 4),
    ('achat_important', 'Achat Important', 'finance', 'shopping_cart', 
     'Achat majeur: électroménager, équipement, mobilier', 5),
    ('demande_financement', 'Demande de Financement', 'finance', 'money', 
     'Demande de prêt, crédit, emprunt bancaire', 6),
    ('recherche_argent', 'Recherche d''Argent', 'finance', 'search_money', 
     'Recherche de fonds, investisseurs, sources de revenus', 7),
    ('investissement', 'Investissement', 'finance', 'trending_up', 
     'Placement financier, bourse, crypto, business', 8),
    
    -- Juridique
    ('signature_contrat', 'Signature de Contrat', 'juridique', 'contract', 
     'Signature de tout type de contrat ou engagement légal', 9),
    
    -- Business
    ('lancement_business', 'Lancement Business', 'business', 'rocket', 
     'Création d''entreprise, lancement de produit, nouveau projet', 10),
    ('partenariat', 'Partenariat / Association', 'business', 'handshake', 
     'Conclusion de partenariat, association, collaboration', 11),
    
    -- Carrière
    ('entretien_embauche', 'Entretien d''Embauche', 'carriere', 'briefcase', 
     'Entretien de recrutement, candidature, présentation', 12),
    ('demande_promotion', 'Demande de Promotion', 'carriere', 'arrow_up', 
     'Demande d''augmentation, promotion, évolution de poste', 13),
    ('demission_changement', 'Démission / Changement', 'carriere', 'exit', 
     'Démission, changement d''emploi, reconversion', 14),
    
    -- Personnel
    ('voyage', 'Voyage', 'personnel', 'plane', 
     'Voyage d''affaires ou de loisirs, déplacement important', 15),
    ('mariage_engagement', 'Mariage / Engagement', 'personnel', 'heart', 
     'Mariage, fiançailles, engagement sentimental', 16),
    ('debut_relation', 'Début de Relation', 'personnel', 'people', 
     'Nouvelle relation amoureuse ou amicale importante', 17),
    
    -- Santé
    ('operation_medicale', 'Opération Médicale', 'sante', 'medical', 
     'Opération chirurgicale, intervention médicale planifiée', 18),
    ('debut_traitement', 'Début de Traitement', 'sante', 'pill', 
     'Début d''un nouveau traitement médical ou thérapie', 19),
    
    -- Autre
    ('autre_decision', 'Autre Décision Importante', 'autre', 'help', 
     'Toute autre décision importante de vie', 99)
ON CONFLICT (code) DO UPDATE SET
    label = EXCLUDED.label,
    category = EXCLUDED.category,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    updated_at = NOW();

-- ================================================
-- Vérification
-- ================================================
SELECT 'Données seed insérées:' AS status;
SELECT 'Soul Periods:' AS table_name, COUNT(*) AS count FROM cycle_vie_soul_periods
UNION ALL
SELECT 'Daily Periods:', COUNT(*) FROM cycle_vie_daily_periods
UNION ALL
SELECT 'Decision Types:', COUNT(*) FROM cycle_vie_decision_types;
