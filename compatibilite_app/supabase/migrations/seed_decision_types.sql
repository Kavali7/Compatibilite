-- =====================================================
-- Script: Insertion des Types de Décision
-- Table: cycle_vie_decision_types
-- =====================================================

-- Vérifier d'abord si la table existe et son contenu actuel
-- SELECT * FROM cycle_vie_decision_types ORDER BY display_order;

-- =====================================================
-- INSERTION DES TYPES DE DECISION PAR DEFAUT
-- =====================================================

INSERT INTO cycle_vie_decision_types (id, code, label, description, icon_name, category, display_order, is_active)
VALUES
  -- AMOUR & RELATIONS
  (gen_random_uuid(), 'relation_amoureuse', 'Relation Amoureuse', 'Décisions concernant votre vie sentimentale, rencontres et engagements amoureux.', 'favorite', 'amour', 1, true),
  (gen_random_uuid(), 'mariage', 'Mariage / Union', 'Décisions relatives au mariage, au PACS ou à l''engagement à long terme.', 'favorite_border', 'amour', 2, true),
  (gen_random_uuid(), 'rupture_separation', 'Rupture / Séparation', 'Décisions concernant une séparation ou un divorce.', 'heart_broken', 'amour', 3, true),

  -- TRAVAIL & CARRIERE
  (gen_random_uuid(), 'recherche_emploi', 'Recherche d''Emploi', 'Décisions liées à la recherche d''un nouveau travail ou changement de carrière.', 'work', 'travail', 10, true),
  (gen_random_uuid(), 'demission', 'Démission', 'Décisions concernant le fait de quitter votre emploi actuel.', 'exit_to_app', 'travail', 11, true),
  (gen_random_uuid(), 'promotion', 'Promotion / Évolution', 'Décisions relatives à une promotion ou évolution de carrière.', 'trending_up', 'travail', 12, true),
  (gen_random_uuid(), 'creation_entreprise', 'Création d''Entreprise', 'Décisions pour lancer votre propre activité ou business.', 'business', 'travail', 13, true),
  (gen_random_uuid(), 'investissement', 'Investissement', 'Décisions concernant les investissements financiers ou projets majeurs.', 'attach_money', 'travail', 14, true),

  -- IMMOBILIER & LOGEMENT
  (gen_random_uuid(), 'achat_immobilier', 'Achat Immobilier', 'Décisions concernant l''achat d''une maison ou d''un appartement.', 'home', 'immobilier', 20, true),
  (gen_random_uuid(), 'location_immobilier', 'Location de Logement', 'Décisions relatives à la location d''un nouveau logement.', 'home_work', 'immobilier', 21, true),
  (gen_random_uuid(), 'demenagement', 'Déménagement', 'Décisions concernant un changement de lieu de vie.', 'local_shipping', 'immobilier', 22, true),
  (gen_random_uuid(), 'renovation', 'Rénovation / Travaux', 'Décisions pour des travaux de rénovation ou d''aménagement.', 'construction', 'immobilier', 23, true),

  -- SANTE & BIEN-ETRE
  (gen_random_uuid(), 'sante_traitement', 'Traitement / Intervention', 'Décisions concernant un traitement médical ou une intervention.', 'medical_services', 'sante', 30, true),
  (gen_random_uuid(), 'changement_hygiene', 'Changement de Mode de Vie', 'Décisions pour améliorer votre hygiène de vie ou habitudes.', 'fitness_center', 'sante', 31, true),

  -- FAMILLE
  (gen_random_uuid(), 'avoir_enfant', 'Avoir un Enfant', 'Décisions concernant la conception ou l''adoption d''un enfant.', 'child_friendly', 'famille', 40, true),
  (gen_random_uuid(), 'education_enfants', 'Éducation des Enfants', 'Décisions relatives à l''éducation et au parcours des enfants.', 'school', 'famille', 41, true),

  -- VOYAGES & LOISIRS
  (gen_random_uuid(), 'voyage', 'Voyage', 'Décisions concernant un voyage ou des vacances importantes.', 'flight', 'loisirs', 50, true),
  (gen_random_uuid(), 'achat_vehicule', 'Achat de Véhicule', 'Décisions pour l''achat d''une voiture, moto ou autre véhicule.', 'directions_car', 'loisirs', 51, true),

  -- DIVERS
  (gen_random_uuid(), 'decision_generale', 'Décision Générale', 'Pour toute autre décision importante de votre vie.', 'psychology', 'autre', 99, true)

ON CONFLICT (code) DO UPDATE SET
  label = EXCLUDED.label,
  description = EXCLUDED.description,
  icon_name = EXCLUDED.icon_name,
  category = EXCLUDED.category,
  display_order = EXCLUDED.display_order,
  is_active = EXCLUDED.is_active;

-- =====================================================
-- VERIFICATION
-- =====================================================
-- Après exécution, vérifiez avec:
-- SELECT id, code, label, category, display_order FROM cycle_vie_decision_types WHERE is_active = true ORDER BY display_order;
