/// Daily Guide Service
/// Service pour le Guide Horaire (Service 05)
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

/// Modèle pour un créneau horaire quotidien
class DailyPeriod {
  final String id;
  final String periodLetter;
  final int? weekdayNumber;
  final String periodName;
  final String keyword;
  final String description;
  final String? activitiesFavorables;
  final String? activitiesEviter;
  final String? colorCode;
  final String? iconName;
  final String? energyLevel;
  final bool isActive;

  DailyPeriod({
    required this.id,
    required this.periodLetter,
    this.weekdayNumber,
    required this.periodName,
    required this.keyword,
    required this.description,
    this.activitiesFavorables,
    this.activitiesEviter,
    this.colorCode,
    this.iconName,
    this.energyLevel,
    this.isActive = true,
  });

  factory DailyPeriod.fromJson(Map<String, dynamic> json) {
    return DailyPeriod(
      id: json['id']?.toString() ?? '',
      periodLetter: json['period_letter']?.toString() ?? '',
      weekdayNumber: json['weekday_number'] as int?,
      periodName: json['period_name']?.toString() ?? '',
      keyword: json['keyword']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      activitiesFavorables: json['activities_favorables']?.toString(),
      activitiesEviter: json['activities_eviter']?.toString(),
      colorCode: json['color_code']?.toString(),
      iconName: json['icon_name']?.toString(),
      energyLevel: json['energy_level']?.toString(),
      isActive: json['is_active'] ?? true,
    );
  }

  /// Liste des activités favorables
  List<String> get favorablesList {
    if (activitiesFavorables == null || activitiesFavorables!.isEmpty) return [];
    return activitiesFavorables!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  /// Liste des activités à éviter
  List<String> get eviterList {
    if (activitiesEviter == null || activitiesEviter!.isEmpty) return [];
    return activitiesEviter!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  /// Créneau horaire approximatif basé sur period_letter
  String get timeSlot {
    switch (periodLetter.toUpperCase()) {
      case 'A': return '5h-8h';
      case 'B': return '8h-11h';
      case 'C': return '11h-14h';
      case 'D': return '14h-16h';
      case 'E': return '16h-18h';
      case 'F': return '18h-21h';
      case 'G': return '21h-5h';
      default: return '';
    }
  }

  /// Heure de début (pour déterminer la période actuelle)
  int get startHour {
    switch (periodLetter.toUpperCase()) {
      case 'A': return 5;
      case 'B': return 8;
      case 'C': return 11;
      case 'D': return 14;
      case 'E': return 16;
      case 'F': return 18;
      case 'G': return 21;
      default: return 0;
    }
  }

  /// Heure de fin
  int get endHour {
    switch (periodLetter.toUpperCase()) {
      case 'A': return 8;
      case 'B': return 11;
      case 'C': return 14;
      case 'D': return 16;
      case 'E': return 18;
      case 'F': return 21;
      case 'G': return 5; // Après minuit
      default: return 0;
    }
  }
}

/// Modèle pour un achat de guide quotidien
class DailyGuidePurchase {
  final String id;
  final String userId;
  final DateTime purchaseDate;
  final DateTime targetDate;
  final String? paymentId;
  final String status;
  final DateTime createdAt;

  DailyGuidePurchase({
    required this.id,
    required this.userId,
    required this.purchaseDate,
    required this.targetDate,
    this.paymentId,
    required this.status,
    required this.createdAt,
  });

  factory DailyGuidePurchase.fromJson(Map<String, dynamic> json) {
    return DailyGuidePurchase(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      purchaseDate: DateTime.parse(json['purchase_date'].toString()),
      targetDate: DateTime.parse(json['target_date'].toString()),
      paymentId: json['payment_id']?.toString(),
      status: json['status']?.toString() ?? 'active',
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  bool get isActive => status == 'active';
}

/// Service pour gérer le Guide Horaire
class DailyGuideService {
  static final DailyGuideService _instance = DailyGuideService._internal();
  static DailyGuideService get instance => _instance;

  DailyGuideService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  // Cache local
  List<DailyPeriod>? _cachedPeriods;

  /// Récupère toutes les périodes quotidiennes (7)
  Future<List<DailyPeriod>> getPeriods({bool forceRefresh = false}) async {
    if (_cachedPeriods != null && !forceRefresh) {
      return _cachedPeriods!;
    }

    try {
      final response = await _supabase
          .from('cycle_vie_daily_periods')
          .select()
          .eq('is_active', true)
          .order('period_letter');

      final periods = (response as List)
          .map((json) => DailyPeriod.fromJson(json))
          .toList();

      _cachedPeriods = periods;
      return periods;
    } catch (e) {
      debugPrint('Erreur récupération périodes quotidiennes: $e');
      rethrow;
    }
  }

  /// Récupère la période actuelle selon l'heure
  Future<DailyPeriod?> getCurrentPeriod() async {
    final periods = await getPeriods();
    final now = DateTime.now();
    final currentHour = now.hour;

    for (final period in periods) {
      // Cas spécial pour la nuit (période G: 21h-5h)
      if (period.periodLetter.toUpperCase() == 'G') {
        if (currentHour >= 21 || currentHour < 5) {
          return period;
        }
      } else {
        if (currentHour >= period.startHour && currentHour < period.endHour) {
          return period;
        }
      }
    }

    return periods.isNotEmpty ? periods.first : null;
  }

  /// Récupère une période par sa lettre
  Future<DailyPeriod?> getPeriodByLetter(String letter) async {
    final periods = await getPeriods();
    try {
      return periods.firstWhere(
        (p) => p.periodLetter.toUpperCase() == letter.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Vérifie si l'utilisateur a un accès pour une date donnée
  Future<bool> hasAccessForDate(DateTime date, {String? userId}) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) return false;

      final dateStr = date.toIso8601String().split('T').first;
      
      final response = await _supabase
          .from('daily_guide_purchases')
          .select('id')
          .eq('user_id', uid)
          .eq('target_date', dateStr)
          .eq('status', 'active')
          .limit(1)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Erreur vérification accès guide: $e');
      return false;
    }
  }

  /// Crée un achat de guide quotidien
  Future<DailyGuidePurchase> createPurchase({
    required String paymentId,
    required DateTime targetDate,
    String? userId,
  }) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) {
        throw Exception('Utilisateur non connecté');
      }

      final dateStr = targetDate.toIso8601String().split('T').first;

      final response = await _supabase
          .from('daily_guide_purchases')
          .insert({
            'user_id': uid,
            'payment_id': paymentId,
            'purchase_date': DateTime.now().toIso8601String(),
            'target_date': dateStr,
            'status': 'active',
          })
          .select()
          .single();

      return DailyGuidePurchase.fromJson(response);
    } catch (e) {
      debugPrint('Erreur création achat guide: $e');
      rethrow;
    }
  }

  /// Récupère les achats de l'utilisateur
  Future<List<DailyGuidePurchase>> getUserPurchases({String? userId}) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) return [];

      final response = await _supabase
          .from('daily_guide_purchases')
          .select()
          .eq('user_id', uid)
          .eq('status', 'active')
          .order('target_date', ascending: false);

      return (response as List)
          .map((json) => DailyGuidePurchase.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Erreur récupération achats: $e');
      return [];
    }
  }

  /// Efface le cache
  void clearCache() {
    _cachedPeriods = null;
  }
}
