-- =============================================
-- Service 06 - Éclairage Décision : Création table Conseils
-- À exécuter APRÈS les types de décision
-- =============================================

-- Table des conseils par période
CREATE TABLE IF NOT EXISTS cycle_vie_decision_advice (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_type_id UUID NOT NULL REFERENCES cycle_vie_decision_types(id),
  cycle_type TEXT NOT NULL DEFAULT 'daily',
  period_number INT NOT NULL CHECK (period_number BETWEEN 1 AND 7),
  favorability_score INT CHECK (favorability_score BETWEEN 1 AND 5),
  advice_text TEXT NOT NULL,
  warnings TEXT,
  alternatives_suggestion TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(decision_type_id, cycle_type, period_number)
);

-- Index pour les requêtes
CREATE INDEX IF NOT EXISTS idx_decision_advice_lookup 
ON cycle_vie_decision_advice(decision_type_id, cycle_type, period_number);

-- =============================================
-- Conseils pour LOCATION IMMOBILIER (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 4,
'Période favorable pour rechercher un nouveau logement. L''énergie d''initiative vous aide à trouver rapidement des opportunités.',
'Attention à ne pas vous précipiter sous l''enthousiasme du moment.',
'Si vous devez reporter, la période 3 sera également favorable.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 5,
'Excellente période pour signer un bail. L''énergie de construction favorise les engagements à long terme.',
'Vérifiez bien l''état des lieux et les conditions du contrat.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 4,
'Période propice aux échanges et négociations avec les propriétaires. Communication fluide.',
'Ne vous dispersez pas en visitant trop de biens différents.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période d''équilibre idéale pour les questions de logement. Moment parfait pour s''installer durablement.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 3,
'Période de réflexion. Prenez le temps d''analyser vos besoins réels avant de vous engager.',
'Évitez de signer dans la précipitation.',
'Attendez la période 6 ou 1 pour finaliser une signature.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 3,
'Période de transformation. Favorable si vous cherchez un changement de logement radical.',
'Les engagements standards sont moins favorables.',
'La période 7 sera meilleure pour les décisions définitives.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Bonne période pour conclure une recherche de logement. L''énergie de bilan vous aide à faire le bon choix.',
'Ne démarrez pas une nouvelle recherche, finalisez plutôt ce qui est en cours.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'location_immobilier'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour ACHAT IMMOBILIER (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 3,
'L''énergie d''initiative est présente mais l''achat immobilier demande réflexion. Période favorable pour commencer les recherches, pas pour signer.',
'Ne signez pas sous l''impulsion du moment.',
'Utilisez cette période pour les visites. Signez en période 2 ou 4.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 5,
'Excellente période pour un achat immobilier. L''énergie de construction est parfaitement alignée.',
'Vérifiez minutieusement tous les aspects techniques et juridiques.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 4,
'Période favorable aux négociations. Bon moment pour visiter et comparer.',
'Attention à la dispersion. Concentrez-vous sur vos critères principaux.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période d''équilibre parfaite pour l''achat d''une résidence principale. Énergies favorables au foyer stable.',
'Assurez-vous que l''achat correspond à vos besoins sur le long terme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période de réflexion peu favorable aux engagements majeurs. Les doutes peuvent surgir après signature.',
'Reportez la signature si possible.',
'Attendez la période 6 ou 7 pour une meilleure clarté.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 3,
'Période de transformation. Favorable si l''achat représente un changement de vie majeur.',
'Les achats routiniers sont défavorisés.',
'La période 2 du prochain cycle sera idéale.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Bonne période pour conclure un achat en cours. L''énergie de bilan aide à finaliser.',
'Ne commencez pas de nouvelles recherches. Finalisez ce qui est déjà en cours.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'achat_immobilier'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour DEMENAGEMENT (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 5,
'Excellente période pour un déménagement. L''énergie de nouveau départ est parfaitement alignée.',
'Prenez le temps de bien organiser malgré l''enthousiasme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 4,
'Bonne période pour un déménagement bien organisé. L''énergie de construction aide.',
'Planifiez méthodiquement. C''est le moment d''être rigoureux.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 3,
'Période d''expansion sociale. Déménager peut disperser votre énergie.',
'Risque de complications logistiques.',
'Si possible, attendez la période 4 pour plus de sérénité.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période idéale pour s''installer dans un nouveau foyer. L''équilibre favorise l''harmonie.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période de réflexion défavorable aux déménagements. Risque de regrets et de nostalgie.',
'Reportez si possible.',
'La période 1 du prochain cycle sera beaucoup plus favorable.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 4,
'Période de transformation favorable si le déménagement marque une rupture avec le passé.',
'Favorable uniquement pour les déménagements liés à une transformation de vie.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 3,
'Période de bilan. Déménager maintenant clôt un cycle. Acceptable pour préparer un nouveau départ.',
'Préférez finaliser les préparatifs et déménager en période 1.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'demenagement'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour INVESTISSEMENT (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 3,
'Période d''initiative. Favorable pour s''informer sur un investissement, pas pour signer.',
'L''enthousiasme peut vous faire négliger les risques.',
'Étudiez maintenant, investissez en période 2.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 5,
'Excellente période pour investir. L''énergie de construction favorise les placements à long terme.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 3,
'Période d''expansion. Risque de surinvestissement ou de diversification excessive.',
'Attention aux promesses trop belles.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période d''équilibre idéale. Investissements immobiliers et placements sécurisés favorisés.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période de réflexion défavorable aux investissements. Risque de mauvais timing.',
'Reportez toute décision d''investissement.',
'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 4,
'Période de transformation. Favorable pour les restructurations de portefeuille.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Bonne période pour récolter les fruits d''investissements passés ou repositionner.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'investissement'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour SIGNATURE CONTRAT (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 4,
'Période d''initiative. Favorable pour les contrats de démarrage.',
'Lisez bien toutes les clauses malgré l''enthousiasme.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 5,
'Excellente période pour signer. L''énergie de construction garantit des engagements solides.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 4,
'Période de communication favorable aux négociations finales.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période d''équilibre parfaite. Les contrats signés maintenant sont équilibrés et durables.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période de réflexion déconseillée pour les signatures. Risque de regrets.',
'Reportez si possible.',
'Attendez la période 6 ou 7.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 3,
'Période de transformation. Favorable pour les contrats de rupture ou restructuration.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Bonne période pour finaliser des contrats en négociation. Clôturez avant le nouveau cycle.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'signature_contrat'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour VOYAGE (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 5,
'Excellente période pour planifier et partir en voyage. L''énergie d''initiative favorise l''aventure.',
'Ne négligez pas les préparatifs pratiques.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 3,
'Période moins favorable aux voyages. Mieux vaut se concentrer sur la construction de projets.',
'Les déplacements peuvent être sources de fatigue.',
'Reportez si possible à la période 3.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 5,
'Excellente période pour voyager. Votre communication et sociabilité sont à leur maximum.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 4,
'Bonne période pour les voyages en famille ou entre amis proches.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 4,
'Période favorable pour les retraites spirituelles et voyages introspectifs.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 4,
'Bonne période pour les voyages de transformation ou de changement de vie.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 3,
'Période de bilan. Les voyages sont possibles mais mieux vaut préparer le prochain cycle.',
'Évitez les longs voyages fatigants.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'voyage'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour MARIAGE (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 3,
'Période d''initiative. Les fiançailles sont possibles mais pas le mariage lui-même.',
'L''impulsion peut ne pas durer. Prenez le temps.',
'Attendez la période 4 pour célébrer.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 5,
'Excellente période pour un engagement sérieux. L''énergie de construction favorise l''union.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 4,
'Bonne période pour les célébrations et fêtes. Communication harmonieuse.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 5,
'Période idéale pour le mariage et l''engagement. Équilibre et harmonie au maximum.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période de réflexion. Les doutes peuvent surgir. Reportez si possible.',
'Risque de regrets post-mariage.',
'Attendez la période 6 ou le prochain cycle.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 3,
'Période de transformation. Mariage possible si c''est un tournant de vie majeur.',
'Les mariages ordinaires sont moins favorisés.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Bonne période pour finaliser un engagement en cours. Clôture de cycle favorable.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'mariage'
ON CONFLICT DO NOTHING;

-- =============================================
-- Conseils pour ENTRETIEN EMBAUCHE (7 périodes)
-- =============================================
INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 1, 5,
'Excellente période pour les entretiens. Votre énergie d''initiative est convaincante.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 2, 4,
'Bonne période. Montrez votre côté méthodique et fiable.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 3, 5,
'Excellente période. Votre communication est fluide et convaincante.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 4, 4,
'Bonne période pour les postes impliquant travail d''équipe et stabilité.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 5, 2,
'Période défavorable. Vous pouvez paraître hésitant ou peu confiant.',
'Reportez l''entretien si possible.',
'Attendez la période 1 ou 3 du prochain cycle.'
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 6, 3,
'Période de transformation. Favorable si vous changez de domaine ou de carrière.',
NULL, NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text, warnings, alternatives_suggestion)
SELECT dt.id, 'personal', 7, 4,
'Acceptable pour finaliser un processus de recrutement déjà avancé.',
'Évitez de commencer de nouvelles recherches.',
NULL
FROM cycle_vie_decision_types dt WHERE dt.code = 'entretien_embauche'
ON CONFLICT DO NOTHING;

-- Vérification finale
SELECT 
  dt.label as type_decision,
  COUNT(a.id) as nb_conseils
FROM cycle_vie_decision_types dt
LEFT JOIN cycle_vie_decision_advice a ON a.decision_type_id = dt.id
GROUP BY dt.id, dt.label
ORDER BY dt.display_order;
