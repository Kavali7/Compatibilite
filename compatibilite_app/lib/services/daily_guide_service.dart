/// Daily Guide Service
/// Service pour le Guide Horaire (Service 05)
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

/// Les 7 créneaux horaires fixes (3h25 chacun, de minuit à minuit)
/// Basé sur le livre de H. Spencer Lewis, Chapitre 11
class DailyTimeSlot {
  final int periodNumber; // 1 à 7
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const DailyTimeSlot(this.periodNumber, this.startHour, this.startMinute, this.endHour, this.endMinute);

  String get timeSlot {
    final sh = startHour.toString().padLeft(2, '0');
    final sm = startMinute.toString().padLeft(2, '0');
    final eh = endHour.toString().padLeft(2, '0');
    final em = endMinute.toString().padLeft(2, '0');
    return '${sh}h$sm - ${eh}h$em';
  }

  /// Vérifie si une heure/minute donnée tombe dans ce créneau
  bool containsTime(int hour, int minute) {
    final timeInMinutes = hour * 60 + minute;
    final startInMinutes = startHour * 60 + startMinute;
    final endInMinutes = endHour * 60 + endMinute;
    
    if (endInMinutes == 0) {
      // Dernier créneau : 20:34 → 00:00 (minuit)
      return timeInMinutes >= startInMinutes;
    }
    return timeInMinutes >= startInMinutes && timeInMinutes < endInMinutes;
  }
}

/// Les 7 créneaux fixes
const List<DailyTimeSlot> kDailyTimeSlots = [
  DailyTimeSlot(1, 0, 0, 3, 25),     // 00h00 - 03h25
  DailyTimeSlot(2, 3, 25, 6, 51),    // 03h25 - 06h51
  DailyTimeSlot(3, 6, 51, 10, 17),   // 06h51 - 10h17
  DailyTimeSlot(4, 10, 17, 13, 42),  // 10h17 - 13h42
  DailyTimeSlot(5, 13, 42, 17, 8),   // 13h42 - 17h08
  DailyTimeSlot(6, 17, 8, 20, 34),   // 17h08 - 20h34
  DailyTimeSlot(7, 20, 34, 0, 0),    // 20h34 - 00h00
];

/// Tableau de rotation jour/lettre (Chart E du livre)
/// Index 0 = Dimanche (DateTime.sunday = 7, mais on utilise % 7)
/// Chaque sous-liste = lettres pour pér.1..7 ce jour-là
const List<List<String>> kDailyRotation = [
  // Dimanche
  ['G', 'A', 'B', 'C', 'D', 'E', 'F'],
  // Lundi
  ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
  // Mardi
  ['F', 'G', 'A', 'B', 'C', 'D', 'E'],
  // Mercredi
  ['B', 'C', 'D', 'E', 'F', 'G', 'A'],
  // Jeudi
  ['E', 'F', 'G', 'A', 'B', 'C', 'D'],
  // Vendredi
  ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
  // Samedi
  ['D', 'E', 'F', 'G', 'A', 'B', 'C'],
];

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

  /// Créneau horaire — maintenant calculé à partir du numéro de période
  /// et non plus hardcodé par lettre
  String timeSlotForPeriodNumber(int periodNumber) {
    if (periodNumber < 1 || periodNumber > 7) return '';
    return kDailyTimeSlots[periodNumber - 1].timeSlot;
  }
}

/// Wrapper qui associe un DailyPeriod (contenu de la DB) avec son créneau
/// horaire effectif et son numéro de période pour une date donnée.
/// Nécessaire car la même lettre peut occuper différents créneaux selon le jour.
class DailyPeriodWithSlot {
  final DailyPeriod period;
  final int periodNumber; // 1 à 7 (position dans la journée)
  final DailyTimeSlot timeSlot;

  DailyPeriodWithSlot({
    required this.period,
    required this.periodNumber,
    required this.timeSlot,
  });

  /// Raccourcis vers les champs du DailyPeriod
  String get id => period.id;
  String get periodLetter => period.periodLetter;
  String get periodName => period.periodName;
  String get keyword => period.keyword;
  String get description => period.description;
  String? get activitiesFavorables => period.activitiesFavorables;
  String? get activitiesEviter => period.activitiesEviter;
  String? get colorCode => period.colorCode;
  String? get energyLevel => period.energyLevel;
  List<String> get favorablesList => period.favorablesList;
  List<String> get eviterList => period.eviterList;
  String get timeSlotLabel => timeSlot.timeSlot;
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

  /// Convertit DateTime.weekday (1=lundi..7=dimanche) en index rotation (0=dimanche..6=samedi)
  static int _weekdayToRotationIndex(int weekday) {
    // DateTime: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
    // Rotation: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
    return weekday % 7; // 7%7=0=Sun, 1%7=1=Mon, etc.
  }

  /// Récupère les 7 périodes ordonnées pour une date donnée
  /// L'ordre des lettres dépend du jour de la semaine (rotation)
  Future<List<DailyPeriodWithSlot>> getPeriodsForDate(DateTime date) async {
    final allPeriods = await getPeriods();
    final rotIndex = _weekdayToRotationIndex(date.weekday);
    final rotation = kDailyRotation[rotIndex];

    final result = <DailyPeriodWithSlot>[];
    for (int i = 0; i < 7; i++) {
      final letter = rotation[i];
      final period = allPeriods.firstWhere(
        (p) => p.periodLetter.toUpperCase() == letter,
        orElse: () => allPeriods.first,
      );
      result.add(DailyPeriodWithSlot(
        period: period,
        periodNumber: i + 1,
        timeSlot: kDailyTimeSlots[i],
      ));
    }
    return result;
  }

  /// Récupère la période actuelle (maintenant) pour aujourd'hui
  Future<DailyPeriodWithSlot?> getCurrentPeriod() async {
    return getCurrentPeriodForDate(DateTime.now());
  }

  /// Récupère la période active pour une date/heure donnée
  Future<DailyPeriodWithSlot?> getCurrentPeriodForDate(DateTime dateTime) async {
    final periods = await getPeriodsForDate(dateTime);
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    for (final pws in periods) {
      if (pws.timeSlot.containsTime(hour, minute)) {
        return pws;
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
