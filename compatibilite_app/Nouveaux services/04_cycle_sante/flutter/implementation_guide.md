# Guide Flutter - Cycle Santé

## Modèle
```dart
class HealthCyclePeriod {
  final int periodNumber;
  final String periodName;
  final String theme;
  final List<String> pointsVigilance;
  final List<String> activitesRecommandees;
  final DateTime startDate;
  final DateTime endDate;
}
```

## Checklist
- [ ] Modèle HealthCyclePeriod
- [ ] HealthCycleService
- [ ] Écran période actuelle avec conseils santé
- [ ] Avertissement médical obligatoire
