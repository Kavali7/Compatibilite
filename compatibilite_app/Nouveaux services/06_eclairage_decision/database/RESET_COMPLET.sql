-- =============================================
-- Service 06 - Éclairage Décision
-- SCRIPT DE RESET COMPLET
-- Exécuter ce script UNIQUE pour tout recréer proprement
-- =============================================

-- ÉTAPE 1: Supprimer les tables existantes
DROP TABLE IF EXISTS cycle_vie_decision_advice CASCADE;
DROP TABLE IF EXISTS cycle_vie_decision_types CASCADE;

-- ÉTAPE 2: Créer la table des types de décision
CREATE TABLE cycle_vie_decision_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(50) UNIQUE NOT NULL,
  label VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  description TEXT,
  icon VARCHAR(50),
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ÉTAPE 3: Créer la table des conseils enrichis (8 champs de contenu)
CREATE TABLE cycle_vie_decision_advice (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_type_id UUID NOT NULL REFERENCES cycle_vie_decision_types(id) ON DELETE CASCADE,
  cycle_type VARCHAR(20) NOT NULL DEFAULT 'personal',
  period_number INTEGER NOT NULL CHECK (period_number BETWEEN 1 AND 7),
  favorability_score INTEGER NOT NULL CHECK (favorability_score BETWEEN 1 AND 5),
  
  -- 8 champs de contenu enrichi
  cosmic_context TEXT,
  advice_text TEXT NOT NULL,
  recommended_actions TEXT,
  warnings TEXT,
  pitfalls_to_avoid TEXT,
  optimal_timing TEXT,
  alternatives_suggestion TEXT,
  closing_message TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(decision_type_id, cycle_type, period_number)
);

-- Index pour les performances
CREATE INDEX idx_advice_type ON cycle_vie_decision_advice(decision_type_id);
CREATE INDEX idx_advice_period ON cycle_vie_decision_advice(period_number);

-- ÉTAPE 4: Insérer les 20 types de décision
INSERT INTO cycle_vie_decision_types (code, label, category, description, icon, display_order) VALUES
-- IMMOBILIER (3)
('location_immobilier', 'Location Immobilier', 'immobilier', 'Louer un appartement ou une maison', NULL, 1),
('achat_immobilier', 'Achat Immobilier', 'immobilier', 'Acheter un bien immobilier', NULL, 2),
('demenagement', 'Déménagement', 'immobilier', 'Changer de lieu de vie', NULL, 3),

-- FINANCE (5)
('achat_vehicule', 'Achat Véhicule', 'finance', 'Acheter une voiture ou moto', NULL, 4),
('achat_important', 'Achat Important', 'finance', 'Gros achat (électroménager, mobilier...)', NULL, 5),
('demande_financement', 'Demande Financement', 'finance', 'Crédit, prêt bancaire', NULL, 6),
('recherche_argent', 'Recherche Argent', 'finance', 'Augmentation, bonus, levée de fonds', NULL, 7),
('investissement', 'Investissement', 'finance', 'Placements financiers', NULL, 8),

-- JURIDIQUE (1)
('signature_contrat', 'Signature Contrat', 'juridique', 'Signature de documents juridiques', NULL, 9),

-- BUSINESS (2)
('lancement_business', 'Lancement Business', 'business', 'Créer ou lancer une activité', NULL, 10),
('partenariat', 'Partenariat', 'business', 'Association ou collaboration', NULL, 11),

-- CARRIÈRE (3)
('entretien_embauche', 'Entretien Embauche', 'carriere', 'Passer un entretien d''emploi', NULL, 12),
('demande_promotion', 'Demande Promotion', 'carriere', 'Demander une évolution', NULL, 13),
('demission', 'Démission', 'carriere', 'Quitter un emploi', NULL, 14),

-- PERSONNEL (2)
('mariage', 'Mariage', 'personnel', 'S''engager dans le mariage', NULL, 15),
('voyage', 'Voyage', 'personnel', 'Partir en voyage', NULL, 16),

-- SANTÉ (2)
('chirurgie', 'Chirurgie', 'sante', 'Opération chirurgicale programmée', NULL, 17),
('regime', 'Régime Alimentaire', 'sante', 'Changement d''habitudes alimentaires', NULL, 18),

-- DIVERS (2)
('nouvelle_habitude', 'Nouvelle Habitude', 'divers', 'Adopter une nouvelle routine', NULL, 19),
('proces', 'Procès / Justice', 'divers', 'Action en justice', NULL, 20);

-- Vérification
SELECT 'Types créés:' AS status, COUNT(*) AS total FROM cycle_vie_decision_types;
