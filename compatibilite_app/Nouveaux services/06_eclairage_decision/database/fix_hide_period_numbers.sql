-- ===========================================================
-- REFORMULATION DES ALTERNATIVES_SUGGESTION
-- Supprime les références aux numéros de période
-- pour masquer le mécanisme de calcul
-- ===========================================================

-- Remplacements systématiques des patterns courants
-- "période 1" → "une phase d'initiative et de renouveau"
-- "période 2" → "une phase de stabilisation"
-- "période 3" → "une phase de communication favorable"
-- "période 4" → "une phase d'harmonie"
-- "période 5" → "une phase de réflexion"
-- "période 6" → "une phase de transformation"
-- "période 7" → "une phase de bilan"

-- ─── Remplacement par REPLACE imbriqués ───

UPDATE cycle_vie_decision_advice
SET alternatives_suggestion = REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              alternatives_suggestion,
              'période 1', 'une phase d''initiative'
            ),
            'période 2', 'une phase de stabilisation'
          ),
          'période 3', 'une phase de communication'
        ),
        'période 4', 'une phase d''harmonie'
      ),
      'période 5', 'une phase de réflexion'
    ),
    'période 6', 'une phase de transformation'
  ),
  'période 7', 'une phase de bilan'
)
WHERE alternatives_suggestion IS NOT NULL
  AND alternatives_suggestion LIKE '%période %';

-- Nettoyer aussi "Période" avec majuscule
UPDATE cycle_vie_decision_advice
SET alternatives_suggestion = REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              alternatives_suggestion,
              'Période 1', 'une phase d''initiative'
            ),
            'Période 2', 'une phase de stabilisation'
          ),
          'Période 3', 'une phase de communication'
        ),
        'Période 4', 'une phase d''harmonie'
      ),
      'Période 5', 'une phase de réflexion'
    ),
    'Période 6', 'une phase de transformation'
  ),
  'Période 7', 'une phase de bilan'
)
WHERE alternatives_suggestion IS NOT NULL
  AND alternatives_suggestion LIKE '%Période %';

-- Aussi nettoyer le champ advice_text s'il contient des références
UPDATE cycle_vie_decision_advice
SET advice_text = REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              advice_text,
              'période 1', 'une phase d''initiative'
            ),
            'période 2', 'une phase de stabilisation'
          ),
          'période 3', 'une phase de communication'
        ),
        'période 4', 'une phase d''harmonie'
      ),
      'période 5', 'une phase de réflexion'
    ),
    'période 6', 'une phase de transformation'
  ),
  'période 7', 'une phase de bilan'
)
WHERE advice_text IS NOT NULL
  AND advice_text LIKE '%période %';

-- Nettoyer warnings aussi
UPDATE cycle_vie_decision_advice
SET warnings = REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              warnings,
              'période 1', 'une phase d''initiative'
            ),
            'période 2', 'une phase de stabilisation'
          ),
          'période 3', 'une phase de communication'
        ),
        'période 4', 'une phase d''harmonie'
      ),
      'période 5', 'une phase de réflexion'
    ),
    'période 6', 'une phase de transformation'
  ),
  'période 7', 'une phase de bilan'
)
WHERE warnings IS NOT NULL
  AND warnings LIKE '%période %';

-- ─── VÉRIFICATION ───
-- Compter les lignes qui contiennent encore "période [chiffre]"
SELECT 'alternatives_suggestion' AS champ,
  COUNT(*) AS restant
FROM cycle_vie_decision_advice
WHERE alternatives_suggestion ~ 'p[eé]riode [0-9]'

UNION ALL

SELECT 'advice_text' AS champ,
  COUNT(*) AS restant
FROM cycle_vie_decision_advice
WHERE advice_text ~ 'p[eé]riode [0-9]'

UNION ALL

SELECT 'warnings' AS champ,
  COUNT(*) AS restant
FROM cycle_vie_decision_advice
WHERE warnings ~ 'p[eé]riode [0-9]';

-- Si tout est à 0, c'est bon ✅
