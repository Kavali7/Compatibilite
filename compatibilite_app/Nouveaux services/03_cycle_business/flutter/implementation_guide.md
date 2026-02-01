# Guide Flutter - Cycle Business

## Modèle

```dart
class BusinessCyclePeriod {
  final int periodNumber;
  final String periodName;
  final String theme;
  final List<String> actionsRecommandees;
  final List<String> decisionsFavorables;
  final String astuce;
  final DateTime startDate;
  final DateTime endDate;
  
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}
```

## Service

```dart
class BusinessCycleService {
  Future<BusinessCyclePeriod?> getCurrentPeriod(DateTime referenceDate) async {
    final response = await _client.rpc('fn_get_current_business_period',
      params: {'p_reference_date': referenceDate.toIso8601String().split('T')[0]});
    return BusinessCyclePeriod.fromJson(response);
  }
}
```

## Checklist

- [ ] Créer modèle BusinessCyclePeriod
- [ ] Créer BusinessCycleService  
- [ ] Écran période actuelle
- [ ] Vue calendrier annuel business
- [ ] Intégration paiement
