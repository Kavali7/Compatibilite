import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_manager.dart';

/// Période Santé (un des 7 cycles de bien-être)
class HealthPeriod {
  final String id;
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final String etatEnergetique;
  final List<String> pointsVigilance;
  final List<String> activitesRecommandees;
  final List<String> activitesModerer;
  final List<String> alimentationPrivilegier;
  final List<String> alimentationEviter;
  final String reposSommeil;
  final List<String> conseilsPratiques;
  final String affirmationBienEtre;
  final String enseignement;
  final String avertissement;
  final bool isActive;

  HealthPeriod({
    required this.id,
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.etatEnergetique,
    required this.pointsVigilance,
    required this.activitesRecommandees,
    required this.activitesModerer,
    required this.alimentationPrivilegier,
    required this.alimentationEviter,
    required this.reposSommeil,
    required this.conseilsPratiques,
    required this.affirmationBienEtre,
    required this.enseignement,
    required this.avertissement,
    this.isActive = true,
  });

  factory HealthPeriod.fromJson(Map<String, dynamic> json) {
    return HealthPeriod(
      id: json['id'] ?? '',
      periodNumber: json['period_number'] ?? 0,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      etatEnergetique: json['etat_energetique'] ?? '',
      pointsVigilance: _parseStringList(json['points_vigilance']),
      activitesRecommandees: _parseStringList(json['activites_recommandees']),
      activitesModerer: _parseStringList(json['activites_moderer']),
      alimentationPrivilegier: _parseStringList(json['alimentation_privilegier']),
      alimentationEviter: _parseStringList(json['alimentation_eviter']),
      reposSommeil: json['repos_sommeil'] ?? '',
      conseilsPratiques: _parseStringList(json['conseils_pratiques']),
      affirmationBienEtre: json['affirmation_bien_etre'] ?? '',
      enseignement: json['enseignement'] ?? '',
      avertissement: json['avertissement'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }
}

/// Infos de période actuelle avec dates
class CurrentHealthPeriodInfo {
  final HealthPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final int dayInPeriod;
  final int daysRemaining;

  CurrentHealthPeriodInfo({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.dayInPeriod,
    required this.daysRemaining,
  });
}

/// Entrée du calendrier santé annuel
class HealthCalendarEntry {
  final int periodNumber;
  final String periodName;
  final String theme;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;

  HealthCalendarEntry({
    required this.periodNumber,
    required this.periodName,
    required this.theme,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });

  factory HealthCalendarEntry.fromJson(Map<String, dynamic> json) {
    return HealthCalendarEntry(
      periodNumber: json['period_number'] ?? 0,
      periodName: json['period_name'] ?? '',
      theme: json['theme'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isCurrent: json['is_current'] ?? false,
    );
  }
}

/// Calendrier annuel santé
class HealthYearCalendar {
  final int year;
  final DateTime referenceDate;
  final List<HealthCalendarEntry> periods;

  HealthYearCalendar({
    required this.year,
    required this.referenceDate,
    required this.periods,
  });
}

/// Abonnement Cycle Santé
class HealthSubscription {
  final String id;
  final String userId;
  final String userName;
  final DateTime birthDate;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? paymentId;
  final DateTime createdAt;

  HealthSubscription({
    required this.id,
    required this.userId,
    required this.userName,
    required this.birthDate,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.paymentId,
    required this.createdAt,
  });

  factory HealthSubscription.fromJson(Map<String, dynamic> json) {
    return HealthSubscription(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      birthDate: DateTime.parse(json['birth_date']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'] ?? 'active',
      paymentId: json['payment_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isActive => status == 'active' && DateTime.now().isBefore(endDate);
}

/// Service pour le Cycle Santé (Service 04)
class HealthCycleService {
  static HealthCycleService? _instance;
  static HealthCycleService get instance => _instance ??= HealthCycleService._();
  
  HealthCycleService._();

  SupabaseClient get _supabase => SupabaseManager.client;

  /// Durée d'une période en jours (52 ou 53 jours selon la période)
  static const int periodDays = 52;

  /// Récupérer toutes les périodes santé
  Future<List<HealthPeriod>> getAllPeriods() async {
    try {
      final response = await _supabase
          .from('health_cycle_periods')
          .select()
          .eq('is_active', true)
          .order('period_number');

      return (response as List)
          .map((json) => HealthPeriod.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('HealthCycleService: Error fetching periods: $e');
      return [];
    }
  }

  /// Récupérer une période spécifique
  Future<HealthPeriod?> getPeriodByNumber(int periodNumber) async {
    try {
      final response = await _supabase
          .from('health_cycle_periods')
          .select()
          .eq('period_number', periodNumber)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;
      return HealthPeriod.fromJson(response);
    } catch (e) {
      debugPrint('HealthCycleService: Error fetching period $periodNumber: $e');
      return null;
    }
  }

  /// Calculer la période actuelle pour une date de naissance
  CurrentHealthPeriodInfo? calculateCurrentPeriod({
    required DateTime birthDate,
    required List<HealthPeriod> periods,
    DateTime? referenceDate,
  }) {
    if (periods.isEmpty) return null;

    final now = referenceDate ?? DateTime.now();
    
    // Calculer le dernier anniversaire
    DateTime lastBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    if (lastBirthday.isAfter(now)) {
      lastBirthday = DateTime(now.year - 1, birthDate.month, birthDate.day);
    }

    // Jours depuis le dernier anniversaire
    final daysSinceBirthday = now.difference(lastBirthday).inDays;

    // Déterminer la période (chaque période = 52 jours, sauf la 7ème = 53 ou 54)
    int periodNumber;
    int dayInPeriod;
    int periodStartDay;
    int periodEndDay;

    if (daysSinceBirthday < 52) {
      periodNumber = 1;
      periodStartDay = 0;
      periodEndDay = 51;
    } else if (daysSinceBirthday < 104) {
      periodNumber = 2;
      periodStartDay = 52;
      periodEndDay = 103;
    } else if (daysSinceBirthday < 156) {
      periodNumber = 3;
      periodStartDay = 104;
      periodEndDay = 155;
    } else if (daysSinceBirthday < 208) {
      periodNumber = 4;
      periodStartDay = 156;
      periodEndDay = 207;
    } else if (daysSinceBirthday < 260) {
      periodNumber = 5;
      periodStartDay = 208;
      periodEndDay = 259;
    } else if (daysSinceBirthday < 312) {
      periodNumber = 6;
      periodStartDay = 260;
      periodEndDay = 311;
    } else {
      periodNumber = 7;
      periodStartDay = 312;
      periodEndDay = 365; // ou 366 pour année bissextile
    }

    dayInPeriod = daysSinceBirthday - periodStartDay + 1;
    final daysRemaining = periodEndDay - daysSinceBirthday;

    final period = periods.firstWhere(
      (p) => p.periodNumber == periodNumber,
      orElse: () => periods.first,
    );

    final startDate = lastBirthday.add(Duration(days: periodStartDay));
    final endDate = lastBirthday.add(Duration(days: periodEndDay));

    return CurrentHealthPeriodInfo(
      period: period,
      startDate: startDate,
      endDate: endDate,
      dayInPeriod: dayInPeriod,
      daysRemaining: daysRemaining > 0 ? daysRemaining : 0,
    );
  }

  /// Générer le calendrier annuel des périodes santé
  HealthYearCalendar generateYearCalendar({
    required DateTime birthDate,
    required List<HealthPeriod> periods,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    
    // Calculer le dernier anniversaire
    DateTime lastBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    if (lastBirthday.isAfter(now)) {
      lastBirthday = DateTime(now.year - 1, birthDate.month, birthDate.day);
    }

    final daysSinceBirthday = now.difference(lastBirthday).inDays;
    final currentPeriod = (daysSinceBirthday ~/ periodDays) + 1;

    final List<HealthCalendarEntry> entries = [];
    
    // Configuration des périodes (jours de début)
    final periodStarts = [0, 52, 104, 156, 208, 260, 312];
    final periodEnds = [51, 103, 155, 207, 259, 311, 365];

    for (int i = 0; i < 7; i++) {
      final period = periods.firstWhere(
        (p) => p.periodNumber == i + 1,
        orElse: () => periods.first,
      );

      final startDate = lastBirthday.add(Duration(days: periodStarts[i]));
      final endDate = lastBirthday.add(Duration(days: periodEnds[i]));

      entries.add(HealthCalendarEntry(
        periodNumber: i + 1,
        periodName: period.periodName,
        theme: period.themeCentral,
        startDate: startDate,
        endDate: endDate,
        isCurrent: (i + 1) == currentPeriod,
      ));
    }

    return HealthYearCalendar(
      year: lastBirthday.year,
      referenceDate: birthDate,
      periods: entries,
    );
  }

  /// Récupérer l'abonnement actif de l'utilisateur
  Future<HealthSubscription?> getActiveSubscription(String userId) async {
    try {
      final response = await _supabase
          .from('health_cycle_subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .gte('end_date', DateTime.now().toIso8601String().split('T')[0])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return HealthSubscription.fromJson(response);
    } catch (e) {
      debugPrint('HealthCycleService: Error fetching subscription: $e');
      return null;
    }
  }

  /// Créer un nouvel abonnement
  Future<HealthSubscription?> createSubscription({
    required String userId,
    required String userName,
    required DateTime birthDate,
    String? paymentId,
  }) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 365));

      final response = await _supabase
          .from('health_cycle_subscriptions')
          .insert({
            'user_id': userId,
            'user_name': userName,
            'birth_date': birthDate.toIso8601String().split('T')[0],
            'start_date': now.toIso8601String().split('T')[0],
            'end_date': endDate.toIso8601String().split('T')[0],
            'status': 'active',
            'payment_id': paymentId,
          })
          .select()
          .single();

      debugPrint('HealthCycleService: Subscription created successfully');
      return HealthSubscription.fromJson(response);
    } catch (e) {
      debugPrint('HealthCycleService: Error creating subscription: $e');
      return null;
    }
  }

  /// Vérifier si l'utilisateur a accès au service
  Future<bool> hasAccess(String userId) async {
    final subscription = await getActiveSubscription(userId);
    return subscription != null && subscription.isActive;
  }
}
