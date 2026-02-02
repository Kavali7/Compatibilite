-- =============================================
-- Service 06 - Éclairage Décision
-- SCHÉMA DE TABLE ENRICHI
-- Version 2.0 - Structure améliorée
-- =============================================

-- Suppression de l'ancienne table si elle existe
DROP TABLE IF EXISTS cycle_vie_decision_advice CASCADE;
DROP TABLE IF EXISTS cycle_vie_decision_types CASCADE;

-- =============================================
-- TABLE: Types de Décision (20 types)
-- =============================================
CREATE TABLE cycle_vie_decision_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  category TEXT NOT NULL,
  icon_name TEXT,
  description TEXT,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- =============================================
-- TABLE: Conseils de Décision (ENRICHIE)
-- 8 champs de contenu pour ~550 mots par conseil
-- =============================================
CREATE TABLE cycle_vie_decision_advice (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_type_id UUID NOT NULL REFERENCES cycle_vie_decision_types(id) ON DELETE CASCADE,
  cycle_type TEXT NOT NULL DEFAULT 'personal',
  period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
  
  -- Score de favorabilité (1-5)
  favorability_score INT CHECK (favorability_score BETWEEN 1 AND 5),
  
  -- ========================================
  -- CONTENU ENRICHI (8 sections)
  -- ========================================
  
  -- Section 1: Contexte cosmique (~80 mots)
  -- Position énergétique de la période, vocabulaire mystique
  cosmic_context TEXT,
  
  -- Section 2: Conseil principal (~200 mots)
  -- Explication approfondie de l'influence de la période
  advice_text TEXT NOT NULL,
  
  -- Section 3: Actions recommandées (~100 mots)
  -- Liste d'actions concrètes à entreprendre
  recommended_actions TEXT,
  
  -- Section 4: Points de vigilance (~80 mots)
  -- Avertissements détaillés
  warnings TEXT,
  
  -- Section 5: Pièges à éviter (~60 mots)
  -- Erreurs spécifiques à ne pas commettre
  pitfalls_to_avoid TEXT,
  
  -- Section 6: Timing optimal (~40 mots)
  -- Meilleurs jours/moments dans la période
  optimal_timing TEXT,
  
  -- Section 7: Alternatives suggérées (~50 mots)
  -- Périodes meilleures si report nécessaire
  alternatives_suggestion TEXT,
  
  -- Section 8: Message d'inspiration (~40 mots)
  -- Citation ou message mystique de clôture
  closing_message TEXT,
  
  -- ========================================
  -- MÉTADONNÉES
  -- ========================================
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  
  -- Contrainte d'unicité
  UNIQUE(decision_type_id, cycle_type, period_number)
);

-- =============================================
-- INDEX pour performance
-- =============================================
CREATE INDEX idx_decision_advice_lookup 
ON cycle_vie_decision_advice(decision_type_id, cycle_type, period_number);

CREATE INDEX idx_decision_types_code 
ON cycle_vie_decision_types(code);

CREATE INDEX idx_decision_types_category 
ON cycle_vie_decision_types(category);

-- =============================================
-- INSERTION: 20 Types de Décision
-- =============================================
INSERT INTO cycle_vie_decision_types (code, label, category, description, display_order) VALUES

-- IMMOBILIER (3 types)
('location_immobilier', 'Location / Immobilier', 'immobilier', 
 'Recherche et signature de bail locatif', 1),
('achat_immobilier', 'Achat Immobilier', 'immobilier', 
 'Acquisition d''un bien immobilier résidentiel ou d''investissement', 2),
('demenagement', 'Déménagement', 'immobilier', 
 'Changement de domicile et installation dans un nouveau lieu', 3),

-- FINANCE (5 types)
('achat_vehicule', 'Achat Véhicule', 'finance', 
 'Acquisition d''un véhicule neuf ou d''occasion', 4),
('achat_important', 'Achat Important', 'finance', 
 'Acquisition majeure (électroménager, mobilier, équipement)', 5),
('demande_financement', 'Demande de Financement', 'finance', 
 'Sollicitation de prêt bancaire ou crédit', 6),
('recherche_argent', 'Recherche d''Argent', 'finance', 
 'Négociation salariale, demande de fonds, levée de capitaux', 7),
('investissement', 'Investissement', 'finance', 
 'Placement financier, investissement boursier ou immobilier', 8),

-- JURIDIQUE (1 type)
('signature_contrat', 'Signature de Contrat', 'juridique', 
 'Engagement contractuel important (travail, commercial, juridique)', 9),

-- BUSINESS (2 types)
('lancement_business', 'Lancement Business', 'business', 
 'Création d''entreprise, lancement de produit ou service', 10),
('partenariat', 'Partenariat / Association', 'business', 
 'Création d''alliance commerciale ou professionnelle', 11),

-- CARRIÈRE (3 types)
('entretien_embauche', 'Entretien d''Embauche', 'carriere', 
 'Passage d''entretien de recrutement', 12),
('demande_promotion', 'Demande de Promotion', 'carriere', 
 'Sollicitation d''avancement professionnel', 13),
('demission', 'Démission / Changement', 'carriere', 
 'Rupture professionnelle et changement de carrière', 14),

-- PERSONNEL (3 types)
('voyage', 'Voyage', 'personnel', 
 'Déplacement touristique, professionnel ou familial', 15),
('mariage', 'Mariage / Engagement', 'personnel', 
 'Union matrimoniale ou engagement sentimental formel', 16),
('debut_relation', 'Début de Relation', 'personnel', 
 'Commencement d''une nouvelle relation amoureuse', 17),

-- SANTÉ (2 types)
('operation_medicale', 'Opération Médicale', 'sante', 
 'Intervention chirurgicale planifiée', 18),
('debut_traitement', 'Début de Traitement', 'sante', 
 'Commencement d''un protocole médical ou thérapeutique', 19),

-- AUTRE (1 type)
('autre', 'Autre Décision Importante', 'autre', 
 'Décision majeure ne correspondant pas aux autres catégories', 20);

-- =============================================
-- VÉRIFICATION
-- =============================================
SELECT 'Types de décision créés:' AS status, COUNT(*) AS total 
FROM cycle_vie_decision_types;
