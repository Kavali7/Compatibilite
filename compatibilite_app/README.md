# Compatibilité & Guidance amoureuse

Parcours Flutter pour calculer la vibration du couple, afficher les chemins de vie et proposer un conseil quotidien. Le design reprend un thème sombre bleu/vert (couleurs issues du CSS cible) et un flow en 6 étapes conforme aux documents fournis.

## Parcours utilisateur
- Accueil avec CTA « Commencer » et rappel confidentialité/rapidité.
- Prénoms (obligatoire) + statut facultatif.
- Dates de naissance (obligatoire) pour les deux partenaires.
- Contexte facultatif (date de rencontre, durée, défis).
- Coordonnées (e‑mail requis, opt‑in notifications).
- Résultats : nombre du couple, chemins de vie, nombres kabbalistiques, cycles personnels, conseil du jour.

## Logique numérologique
- Table pythagoricienne pour les prénoms (AJS=1 … IR=9), réduction avec gestion des maîtres nombres.
- Chemin de vie (réduction jour/mois/année), année/mois/jour personnels (Affinity Numerology).
- Nombre kabbalistique (somme des positions A=1…Z=26 mod 9).
- Interprétations 1‑9, maîtres nombres, compatibilité de couple, années personnelles et conseils quotidiens issus des PDF.

## Lancer le projet
```bash
cd compatibilite_app
flutter pub get
flutter run    # ou flutter test pour lancer le test de fumée
```

## Fichiers clés
- `lib/main.dart` : point d’entrée.
- `lib/theme/app_theme.dart` : palette et fonts (Philosopher/Open Sans).
- `lib/services/numerology_service.dart` + `interpretations.dart` : calculs et textes.
- `lib/screens/compatibility_wizard.dart` : flow multi‑étapes + UI.

## Notes
- Tests : `flutter test` passe (un test de fumée vérifie le header).  
- `flutter analyze` signale seulement des dépréciations `withOpacity`/`activeColor` (API Flutter récente) sans impact fonctionnel.
