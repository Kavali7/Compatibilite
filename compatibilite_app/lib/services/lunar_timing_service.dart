/// Service Timing Lunaire - Service 08
/// Gestion des 8 phases lunaires et abonnements
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

/// Modèle représentant une phase lunaire
class LunarPhase {
  final String id;
  final int phaseNumber;
  final String phaseName;
  final String phaseKey;
  final String theme;
  final String energyType;
  final String fullContent;
  final List<String> activitiesFavorables;
  final List<String> activitiesEviter;
  final String? conseil;
  final int durationDays;
  final bool isActive;

  LunarPhase({
    required this.id,
    required this.phaseNumber,
    required this.phaseName,
    required this.phaseKey,
    required this.theme,
    required this.energyType,
    required this.fullContent,
    required this.activitiesFavorables,
    required this.activitiesEviter,
    this.conseil,
    this.durationDays = 3,
    this.isActive = true,
  });

  factory LunarPhase.fromJson(Map<String, dynamic> json) {
    return LunarPhase(
      id: json['id'] as String,
      phaseNumber: json['phase_number'] as int,
      phaseName: json['phase_name'] as String,
      phaseKey: json['phase_key'] as String,
      theme: json['theme'] as String,
      energyType: json['energy_type'] as String,
      fullContent: json['full_content'] as String? ?? '',
      activitiesFavorables: (json['activities_favorables'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      activitiesEviter: (json['activities_eviter'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      conseil: json['conseil'] as String?,
      durationDays: json['duration_days'] as int? ?? 3,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Retourne l'emoji correspondant à la phase
  String get emoji {
    switch (phaseNumber) {
      case 1: return '🌑'; // Nouvelle Lune
      case 2: return '🌒'; // Premier Croissant
      case 3: return '🌓'; // Premier Quartier
      case 4: return '🌔'; // Gibbeuse Croissante
      case 5: return '🌕'; // Pleine Lune
      case 6: return '🌖'; // Gibbeuse Décroissante
      case 7: return '🌗'; // Dernier Quartier
      case 8: return '🌘'; // Dernier Croissant
      default: return '🌙';
    }
  }
}

/// Informations sur la phase lunaire actuelle
class CurrentLunarPhaseInfo {
  final LunarPhase phase;
  final DateTime phaseStartDate;
  final DateTime phaseEndDate;
  final int daysIntoPhase;
  final int daysRemaining;
  final double progressPercentage;
  final LunarPhase? nextPhase;

  CurrentLunarPhaseInfo({
    required this.phase,
    required this.phaseStartDate,
    required this.phaseEndDate,
    required this.daysIntoPhase,
    required this.daysRemaining,
    required this.progressPercentage,
    this.nextPhase,
  });
}

/// Modèle pour un abonnement lunaire
class LunarSubscription {
  final String id;
  final String? userId;
  final DateTime startDate;
  final DateTime endDate;
  final String? paymentId;
  final String status;

  LunarSubscription({
    required this.id,
    this.userId,
    required this.startDate,
    required this.endDate,
    this.paymentId,
    this.status = 'active',
  });

  factory LunarSubscription.fromJson(Map<String, dynamic> json) {
    return LunarSubscription(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      paymentId: json['payment_id'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }

  bool get isActive {
    final now = DateTime.now();
    return status == 'active' && now.isBefore(endDate) && now.isAfter(startDate);
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }
}

/// Service pour gérer le timing lunaire
class LunarTimingService {
  static final LunarTimingService instance = LunarTimingService._();
  LunarTimingService._();

  SupabaseClient get _client => Supabase.instance.client;

  /// Date de référence d'une Nouvelle Lune connue
  static final DateTime _knownNewMoon = DateTime(2024, 1, 11);
  
  /// Durée moyenne d'un cycle lunaire en jours
  static const double _lunarCycleDays = 29.53;

  /// Calcule le numéro de phase lunaire pour une date donnée (1-8)
  int calculatePhaseNumber(DateTime date) {
    final daysSinceNewMoon = date.difference(_knownNewMoon).inDays;
    final dayInCycle = daysSinceNewMoon % _lunarCycleDays;
    final phaseDuration = _lunarCycleDays / 8;
    int phase = (dayInCycle / phaseDuration).floor() + 1;
    return min(phase, 8);
  }

  /// Calcule les détails complets de la phase actuelle
  CurrentLunarPhaseInfo? calculateCurrentPhase({
    required List<LunarPhase> phases,
    DateTime? referenceDate,
  }) {
    final date = referenceDate ?? DateTime.now();
    final phaseNumber = calculatePhaseNumber(date);
    
    try {
      final currentPhase = phases.firstWhere((p) => p.phaseNumber == phaseNumber);
      
      // Calculer les dates de début et fin de la phase actuelle
      final daysSinceNewMoon = date.difference(_knownNewMoon).inDays;
      final dayInCycle = daysSinceNewMoon % _lunarCycleDays;
      final phaseDuration = _lunarCycleDays / 8;
      
      final daysIntoPhase = (dayInCycle % phaseDuration).floor();
      final daysRemaining = (phaseDuration - daysIntoPhase).ceil();
      
      final phaseStartDate = date.subtract(Duration(days: daysIntoPhase));
      final phaseEndDate = phaseStartDate.add(Duration(days: phaseDuration.ceil()));
      
      // Trouver la phase suivante
      final nextPhaseNumber = phaseNumber == 8 ? 1 : phaseNumber + 1;
      LunarPhase? nextPhase;
      try {
        nextPhase = phases.firstWhere((p) => p.phaseNumber == nextPhaseNumber);
      } catch (_) {}
      
      return CurrentLunarPhaseInfo(
        phase: currentPhase,
        phaseStartDate: phaseStartDate,
        phaseEndDate: phaseEndDate,
        daysIntoPhase: daysIntoPhase,
        daysRemaining: daysRemaining,
        progressPercentage: (daysIntoPhase / phaseDuration) * 100,
        nextPhase: nextPhase,
      );
    } catch (e) {
      debugPrint('LunarTimingService: Phase $phaseNumber not found');
      return null;
    }
  }

  /// Récupère toutes les phases lunaires
  Future<List<LunarPhase>> getAllPhases() async {
    try {
      final result = await _client
          .from('lunar_phases')
          .select()
          .eq('is_active', true)
          .order('phase_number');

      return (result as List).map((json) => LunarPhase.fromJson(json)).toList();
    } catch (e) {
      debugPrint('LunarTimingService.getAllPhases error: $e');
      return [];
    }
  }

  /// Récupère une phase spécifique par numéro
  Future<LunarPhase?> getPhaseByNumber(int phaseNumber) async {
    try {
      final result = await _client
          .from('lunar_phases')
          .select()
          .eq('phase_number', phaseNumber)
          .eq('is_active', true)
          .maybeSingle();

      if (result == null) return null;
      return LunarPhase.fromJson(result);
    } catch (e) {
      debugPrint('LunarTimingService.getPhaseByNumber error: $e');
      return null;
    }
  }

  /// Récupère l'abonnement actif d'un utilisateur
  Future<LunarSubscription?> getActiveSubscription(String userId) async {
    try {
      final now = DateTime.now().toIso8601String().split('T')[0];
      final result = await _client
          .from('lunar_subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .gte('end_date', now)
          .order('end_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (result == null) return null;
      return LunarSubscription.fromJson(result);
    } catch (e) {
      debugPrint('LunarTimingService.getActiveSubscription error: $e');
      return null;
    }
  }

  /// Crée un nouvel abonnement
  Future<LunarSubscription?> createSubscription({
    required String userId,
    required int durationDays,
    String? paymentId,
  }) async {
    try {
      final startDate = DateTime.now();
      final endDate = startDate.add(Duration(days: durationDays));

      final result = await _client.from('lunar_subscriptions').insert({
        'user_id': userId,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'payment_id': paymentId,
        'status': 'active',
      }).select().single();

      return LunarSubscription.fromJson(result);
    } catch (e) {
      debugPrint('LunarTimingService.createSubscription error: $e');
      return null;
    }
  }

  /// Génère le calendrier lunaire pour une période donnée
  List<Map<String, dynamic>> generateLunarCalendar({
    required List<LunarPhase> phases,
    required int daysCount,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now();
    final calendar = <Map<String, dynamic>>[];

    for (int i = 0; i < daysCount; i++) {
      final date = start.add(Duration(days: i));
      final phaseNumber = calculatePhaseNumber(date);
      
      try {
        final phase = phases.firstWhere((p) => p.phaseNumber == phaseNumber);
        calendar.add({
          'date': date,
          'phase': phase,
          'phaseNumber': phaseNumber,
        });
      } catch (_) {
        calendar.add({
          'date': date,
          'phase': null,
          'phaseNumber': phaseNumber,
        });
      }
    }

    return calendar;
  }

  /// Calcule la prochaine occurrence d'une phase spécifique
  DateTime getNextPhaseDate(int targetPhaseNumber, {DateTime? fromDate}) {
    final start = fromDate ?? DateTime.now();
    final currentPhase = calculatePhaseNumber(start);
    
    if (targetPhaseNumber == currentPhase) {
      // Phase actuelle - retourner la prochaine occurrence
      final phaseDuration = _lunarCycleDays / 8;
      final daysUntilNextCycle = (_lunarCycleDays - 
          (start.difference(_knownNewMoon).inDays % _lunarCycleDays)).ceil();
      final daysToTarget = ((targetPhaseNumber - 1) * phaseDuration).ceil();
      return start.add(Duration(days: daysUntilNextCycle + daysToTarget));
    }
    
    // Calculer le nombre de jours jusqu'à la phase cible
    int phasesAhead = targetPhaseNumber - currentPhase;
    if (phasesAhead <= 0) phasesAhead += 8;
    
    final phaseDuration = _lunarCycleDays / 8;
    final daysToTarget = (phasesAhead * phaseDuration).ceil();
    
    return start.add(Duration(days: daysToTarget));
  }

  /// Retourne la prochaine Nouvelle Lune
  DateTime getNextNewMoon({DateTime? fromDate}) {
    return getNextPhaseDate(1, fromDate: fromDate);
  }

  /// Retourne la prochaine Pleine Lune
  DateTime getNextFullMoon({DateTime? fromDate}) {
    return getNextPhaseDate(5, fromDate: fromDate);
  }
}
