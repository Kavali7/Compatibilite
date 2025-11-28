# Rapport original — sauvegarde du wording actuel

Ce fichier conserve le libellé et le vocabulaire actuels (version numérologie) pour pouvoir revenir en arrière si la réécriture “non numérologie” ne convient pas.

## Écran d’accueil / Wizard
- Titre : « Découvrez si vous êtes faits l’un pour l’autre »
- Sous-titre : « Parcours en 6 étapes rapides, conçu pour rester fluide. »
- Étape : « Étape 1 / 6 »
- Section « Bienvenue »
  - Texte : « Analyse la vibration de votre couple via un quiz d’une minute. Nous calculons le nombre du couple, les chemins de vie et un conseil quotidien. »
  - Card info : « Flow en étapes courtes : design nocturne et call-to-action clair. »
- Boutons : « Commencer », « Continuer », « Passer »

## Sections du wizard
- « Dates de naissance » (texte d’aide : « Les dates servent au chemin de vie et aux cycles personnels. »)
- « Contexte (optionnel) » (texte d’aide : « Personnalisez les textes sans rallonger le flux principal. Cette étape peut être ignorée. »)
- « Guide & contact » / CTA contact/support (libellés existants dans le wizard).

## Rapport / Résultats
- Cartes et intitulés :
  - « Rapport du couple »
  - « Nombre du couple : {x} »
  - Interprétation : issue de `NumerologyService` (ex. `describeCoupleInterpretation`, `describeCoupleDeep`, `describeCoupleDailyAction`)
  - « Conseil du jour (couple) : {x} »
  - « Contexte noté » (affiche Statut, Durée, Rencontre, Défis)
- Partners :
  - `_numberRow` labels : « Chemin de vie », « Nombre du nom », « Nombre intime », « Nombre de personnalité », « Nombre héréditaire », « Nombre kabbalistique », « Année personnelle »
  - Texte « Mois personnel : ? Jour personnel : () »
  - Bloc « Guides Chemin/Expression »
- CTA fin : « Recommencer », « Retour aux étapes »

## Menu burger (libellés actuels)
- Politique de confidentialité (ouvre `LegalPage.confidentialite`)
- Conditions d’utilisation (ouvre `LegalPage.conditions`)
- Facturation / Paiements (ouvre `LegalPage.facturation`)
- Remboursements & rétractation (ouvre `LegalPage.remboursement`)
- Cookies & suivi (ouvre `LegalPage.cookies`)
- Contacter Growpeak (mailto)
- Appeler Growpeak (tel)

## Pages légales (titres/sections)
- Confidentialité : Responsable & contacts, Données collectées, Finalités, Durées, Partage, Droits, Sécurité.
- Conditions d’utilisation : Objet, Accès/comportement, Propriété intellectuelle, Disponibilité, Responsabilités, Résiliation, Droit applicable.
- Facturation/Paiements : Aucun paiement actif, transparence future, absence de prélèvement, abonnements futurs.
- Remboursements & rétractation : contenu numérique immédiat, services différés/abonnements, politique de remboursement.
- Cookies & suivi : Essentiels, Optionnels (analytics), Pas de publicitaire par défaut.

## Textes d’aide (snackbars / hints)
- « Choisissez les deux dates de naissance. »
- Astuce dates : « Astuce : sur mobile, utilisez des champs larges en colonne unique pour limiter les erreurs. »

## Divers
- Couleurs et thème : AppColors (primary, secondary, background, block, textLight, textMuted, accentText) conservés.
- Progression : StepProgressIndicator (totalSteps: 6, currentStep + 1).

> Conserver ce fichier tel quel ; il sert de référence de wording et de structure pour revenir à la version actuelle axée numérologie.***
