# Guide Flutter - Cycle Annuel Personnel

## Service 02 : Cycle Personnel

### Modèle de Données

```dart
class PersonalCyclePeriod {
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final String fullContent;
  final List<String> conseils;
  final String affirmation;
  final DateTime startDate;
  final DateTime endDate;

  PersonalCyclePeriod({
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.fullContent,
    required this.conseils,
    required this.affirmation,
    required this.startDate,
    required this.endDate,
  });

  factory PersonalCyclePeriod.fromJson(Map<String, dynamic> json) {
    return PersonalCyclePeriod(
      periodNumber: json['period_number'],
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme'] ?? json['theme_central'] ?? '',
      fullContent: json['full_content'] ?? '',
      conseils: List<String>.from(json['conseils'] ?? []),
      affirmation: json['affirmation'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  double get progress => 1 - (daysRemaining / 52);
}
```

### Service Supabase

```dart
class PersonalCycleService {
  final SupabaseClient _client;

  PersonalCycleService(this._client);

  Future<PersonalCyclePeriod?> getCurrentPeriod(DateTime birthdate) async {
    final response = await _client.rpc(
      'fn_get_current_personal_period',
      params: {'p_birthdate': birthdate.toIso8601String().split('T')[0]},
    );
    if (response != null && response is List && response.isNotEmpty) {
      return PersonalCyclePeriod.fromJson(response.first);
    }
    return null;
  }

  Future<List<PersonalCyclePeriod>> getYearCalendar(DateTime birthdate) async {
    final response = await _client.rpc(
      'fn_get_personal_year_calendar',
      params: {'p_birthdate': birthdate.toIso8601String().split('T')[0]},
    );
    if (response != null && response['periods'] != null) {
      return (response['periods'] as List)
          .map((p) => PersonalCyclePeriod.fromJson(p))
          .toList();
    }
    return [];
  }

  Future<bool> hasActiveSubscription(String userId) async {
    return await _client.rpc('fn_check_personal_cycle_access', 
      params: {'p_user_id': userId});
  }
}
```

### Écran Principal

```dart
class PersonalCycleScreen extends StatefulWidget {
  @override
  _PersonalCycleScreenState createState() => _PersonalCycleScreenState();
}

class _PersonalCycleScreenState extends State<PersonalCycleScreen> {
  PersonalCyclePeriod? currentPeriod;
  List<PersonalCyclePeriod> yearCalendar = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Charger période actuelle et calendrier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon Cycle Personnel')),
      body: Column(
        children: [
          _buildCurrentPeriodCard(),
          _buildProgressIndicator(),
          _buildCalendarView(),
        ],
      ),
    );
  }

  Widget _buildCurrentPeriodCard() {
    if (currentPeriod == null) return SizedBox();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Période ${currentPeriod!.periodNumber}',
                style: Theme.of(context).textTheme.headlineSmall),
            Text(currentPeriod!.periodName,
                style: Theme.of(context).textTheme.titleLarge),
            Text(currentPeriod!.themeCentral),
            SizedBox(height: 16),
            LinearProgressIndicator(value: currentPeriod!.progress),
            Text('${currentPeriod!.daysRemaining} jours restants'),
          ],
        ),
      ),
    );
  }
}
```

### Checklist

- [ ] Créer `PersonalCyclePeriod` model
- [ ] Créer `PersonalCycleService`
- [ ] Écran de période actuelle
- [ ] Vue calendrier annuel
- [ ] Intégration paiement/abonnement
- [ ] Notifications de changement de période
