-- =============================================
-- Service 06 - Éclairage Décision : Seed Types de Décision
-- À exécuter AVANT les conseils
-- =============================================

-- Table des types de décision (20 types)
CREATE TABLE IF NOT EXISTS cycle_vie_decision_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  category TEXT,
  icon_name TEXT,
  description TEXT,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Insertion des 20 types de décision
INSERT INTO cycle_vie_decision_types (code, label, category, display_order, is_active) VALUES
-- Immobilier (3)
('location_immobilier', 'Location immobilière', 'immobilier', 1, true),
('achat_immobilier', 'Achat immobilier', 'immobilier', 2, true),
('demenagement', 'Déménagement', 'immobilier', 3, true),

-- Finance (5)
('achat_vehicule', 'Achat véhicule', 'finance', 4, true),
('achat_important', 'Achat important', 'finance', 5, true),
('demande_financement', 'Demande de financement', 'finance', 6, true),
('recherche_argent', 'Recherche d''argent', 'finance', 7, true),
('investissement', 'Investissement', 'finance', 8, true),

-- Juridique (1)
('signature_contrat', 'Signature de contrat', 'juridique', 9, true),

-- Business (2)
('lancement_business', 'Lancement business', 'business', 10, true),
('partenariat', 'Partenariat / Association', 'business', 11, true),

-- Carrière (3)
('entretien_embauche', 'Entretien d''embauche', 'carriere', 12, true),
('demande_promotion', 'Demande de promotion', 'carriere', 13, true),
('demission', 'Démission / Changement', 'carriere', 14, true),

-- Personnel (3)
('voyage', 'Voyage', 'personnel', 15, true),
('mariage', 'Mariage / Engagement', 'personnel', 16, true),
('debut_relation', 'Début de relation', 'personnel', 17, true),

-- Santé (2)
('operation_medicale', 'Opération médicale', 'sante', 18, true),
('debut_traitement', 'Début de traitement', 'sante', 19, true),

-- Autre (1)
('autre', 'Autre décision importante', 'autre', 20, true)

ON CONFLICT (code) DO NOTHING;

-- Vérification
SELECT code, label, category FROM cycle_vie_decision_types ORDER BY display_order;

-- Compter les types
SELECT COUNT(*) as total_types FROM cycle_vie_decision_types WHERE is_active = true;
