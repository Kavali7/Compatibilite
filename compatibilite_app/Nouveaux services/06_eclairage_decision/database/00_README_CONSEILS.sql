-- =============================================
-- Service 06 - Éclairage Décision
-- SCRIPT SQL CONSOLIDÉ - TOUS LES CONSEILS ENRICHIS
-- À exécuter dans Supabase SQL Editor
-- =============================================

-- ORDRE D'EXÉCUTION:
-- 1. 01_schema_enrichi.sql        - Crée les tables et seed les 20 types
-- 2. 02_conseils_immobilier.sql   - Location (7), Achat (2)
-- 3. 02b_conseils_immobilier_suite.sql - Achat (5), Déménagement (7)
-- 4. 03_conseils_finance_part1.sql - Véhicule (7), Achat Important (7)
-- 5. 03b_conseils_finance_part2.sql - Financement (7), Recherche Argent (7), Investissement (7)
-- 6. 04_conseils_juridique_business_carriere.sql - Signature (7), Business (14), Carrière (21)
-- 7. 05_conseils_personnel_sante_divers.sql - Mariage (7), Voyage (7), Chirurgie (7), Régime (7), Habitude (7), Procès (7)

-- =============================================
-- RÉSUMÉ DES CONSEILS:
-- =============================================
-- 20 types de décision × 7 périodes = 140 conseils
--
-- IMMOBILIER (3 types):
--   - Location Immobilier: 7 périodes
--   - Achat Immobilier: 7 périodes  
--   - Déménagement: 7 périodes
--   TOTAL: 21 conseils
--
-- FINANCE (5 types):
--   - Achat Véhicule: 7 périodes
--   - Achat Important: 7 périodes
--   - Demande Financement: 7 périodes
--   - Recherche Argent: 7 périodes
--   - Investissement: 7 périodes
--   TOTAL: 35 conseils
--
-- JURIDIQUE (1 type):
--   - Signature Contrat: 7 périodes
--   TOTAL: 7 conseils
--
-- BUSINESS (2 types):
--   - Lancement Business: 7 périodes
--   - Partenariat: 7 périodes
--   TOTAL: 14 conseils
--
-- CARRIÈRE (3 types):
--   - Entretien Embauche: 7 périodes
--   - Demande Promotion: 7 périodes
--   - Démission: 7 périodes
--   TOTAL: 21 conseils
--
-- PERSONNEL (2 types):
--   - Mariage: 7 périodes
--   - Voyage: 7 périodes
--   TOTAL: 14 conseils
--
-- SANTÉ (2 types):
--   - Chirurgie: 7 périodes
--   - Régime/Habitude Alimentaire: 7 périodes
--   TOTAL: 14 conseils
--
-- DIVERS (2 types):
--   - Nouvelle Habitude: 7 périodes
--   - Procès/Action Justice: 7 périodes
--   TOTAL: 14 conseils
--
-- GRAND TOTAL: 140 conseils enrichis
-- =============================================

-- STRUCTURE DE CHAQUE CONSEIL (8 champs):
-- 1. cosmic_context: Contexte mystique de la période (~50 mots)
-- 2. advice_text: Conseil principal détaillé (~200 mots)
-- 3. recommended_actions: Actions concrètes à entreprendre (liste)
-- 4. warnings: Avertissements importants
-- 5. pitfalls_to_avoid: Pièges à éviter (liste)
-- 6. optimal_timing: Timing optimal dans la période
-- 7. alternatives_suggestion: Alternatives si période défavorable
-- 8. closing_message: Message d'inspiration final

-- LONGUEUR TOTALE PAR CONSEIL: ~400-550 mots
-- TOTAL ESTIMÉ: 140 × 450 = 63 000 mots de contenu

-- =============================================
-- INSTRUCTIONS D'EXÉCUTION:
-- =============================================
-- 1. Allez dans Supabase Dashboard > SQL Editor
-- 2. Exécutez d'abord 01_schema_enrichi.sql (crée les tables)
-- 3. Puis exécutez les fichiers 02 à 05 dans l'ordre
-- 4. Vérifiez avec la requête de contrôle ci-dessous

-- REQUÊTE DE VÉRIFICATION:
/*
SELECT 
  dt.category,
  dt.label,
  COUNT(a.id) as nb_conseils,
  AVG(LENGTH(COALESCE(a.cosmic_context, '') || 
             COALESCE(a.advice_text, '') || 
             COALESCE(a.recommended_actions, '') || 
             COALESCE(a.warnings, '') || 
             COALESCE(a.pitfalls_to_avoid, '') || 
             COALESCE(a.optimal_timing, '') || 
             COALESCE(a.alternatives_suggestion, '') || 
             COALESCE(a.closing_message, ''))) as avg_chars
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
GROUP BY dt.category, dt.label
ORDER BY dt.category, dt.label;
*/

-- REQUÊTE COMPTAGE GLOBAL:
/*
SELECT 
  COUNT(*) as total_conseils,
  COUNT(DISTINCT decision_type_id) as nb_types,
  COUNT(DISTINCT period_number) as nb_periodes
FROM cycle_vie_decision_advice;
-- Attendu: 140 conseils, 20 types, 7 périodes
*/
