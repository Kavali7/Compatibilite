/// Personal Cycle Service
/// Service pour le Cycle Personnel (Service 02)
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

/// Modèle pour une période du cycle personnel
class PersonalPeriod {
  final String id;
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final int dayStart;
  final int dayEnd;
  final String energiePeriode;
  final String descriptionTheme;
  final Map<String, dynamic> domainesFavorables;
  final Map<String, dynamic> domainesEviter;
  final List<String> conseils;
  final String affirmation;
  final String influenceDecisions;
  final String enseignement;
  final bool isActive;

  PersonalPeriod({
    required this.id,
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.dayStart,
    required this.dayEnd,
    required this.energiePeriode,
    required this.descriptionTheme,
    required this.domainesFavorables,
    required this.domainesEviter,
    required this.conseils,
    required this.affirmation,
    required this.influenceDecisions,
    required this.enseignement,
    this.isActive = true,
  });

  factory PersonalPeriod.fromJson(Map<String, dynamic> json) {
    // Parser les domaines (JSONB)
    Map<String, dynamic> parseFavorables = {};
    if (json['domaines_favorables'] != null) {
      if (json['domaines_favorables'] is String) {
        parseFavorables = jsonDecode(json['domaines_favorables']);
      } else {
        parseFavorables = Map<String, dynamic>.from(json['domaines_favorables']);
      }
    }

    Map<String, dynamic> parseEviter = {};
    if (json['domaines_eviter'] != null) {
      if (json['domaines_eviter'] is String) {
        parseEviter = jsonDecode(json['domaines_eviter']);
      } else {
        parseEviter = Map<String, dynamic>.from(json['domaines_eviter']);
      }
    }

    // Parser les conseils (array)
    List<String> parseConseils = [];
    if (json['conseils'] != null) {
      if (json['conseils'] is String) {
        // Si c'est une string JSON
        final decoded = jsonDecode(json['conseils']);
        parseConseils = List<String>.from(decoded);
      } else if (json['conseils'] is List) {
        parseConseils = List<String>.from(json['conseils']);
      }
    }

    return PersonalPeriod(
      id: json['id']?.toString() ?? '',
      periodNumber: json['period_number'] ?? 1,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      dayStart: json['day_start'] ?? 1,
      dayEnd: json['day_end'] ?? 52,
      energiePeriode: json['energie_periode'] ?? '',
      descriptionTheme: json['description_theme'] ?? '',
      domainesFavorables: parseFavorables,
      domainesEviter: parseEviter,
      conseils: parseConseils,
      affirmation: json['affirmation'] ?? '',
      influenceDecisions: json['influence_decisions'] ?? '',
      enseignement: json['enseignement'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  /// Liste des domaines très favorables
  List<String> get tresFavorables {
    final list = domainesFavorables['tres_favorables'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines favorables
  List<String> get favorables {
    final list = domainesFavorables['favorables'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines à reporter
  List<String> get reporter {
    final list = domainesEviter['reporter'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines nécessitant attention
  List<String> get attention {
    final list = domainesEviter['attention'];
    if (list == null) return [];
    return List<String>.from(list);
  }
}

/// Modèle pour les informations de la période actuelle
class CurrentPeriodInfo {
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final int dayInPeriod;
  final int daysRemaining;
  final DateTime periodStartDate;
  final DateTime periodEndDate;
  final String energiePeriode;
  final String descriptionTheme;
  final Map<String, dynamic> domainesFavorables;
  final Map<String, dynamic> domainesEviter;
  final List<String> conseils;
  final String affirmation;
  final String influenceDecisions;
  final String enseignement;

  CurrentPeriodInfo({
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.dayInPeriod,
    required this.daysRemaining,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.energiePeriode,
    required this.descriptionTheme,
    required this.domainesFavorables,
    required this.domainesEviter,
    required this.conseils,
    required this.affirmation,
    required this.influenceDecisions,
    required this.enseignement,
  });

  factory CurrentPeriodInfo.fromRpc(Map<String, dynamic> json) {
    // Parser les domaines
    Map<String, dynamic> parseFavorables = {};
    if (json['domaines_favorables'] != null) {
      if (json['domaines_favorables'] is String) {
        parseFavorables = jsonDecode(json['domaines_favorables']);
      } else {
        parseFavorables = Map<String, dynamic>.from(json['domaines_favorables']);
      }
    }

    Map<String, dynamic> parseEviter = {};
    if (json['domaines_eviter'] != null) {
      if (json['domaines_eviter'] is String) {
        parseEviter = jsonDecode(json['domaines_eviter']);
      } else {
        parseEviter = Map<String, dynamic>.from(json['domaines_eviter']);
      }
    }

    // Parser les conseils
    List<String> parseConseils = [];
    if (json['conseils'] != null) {
      if (json['conseils'] is String) {
        parseConseils = List<String>.from(jsonDecode(json['conseils']));
      } else if (json['conseils'] is List) {
        parseConseils = List<String>.from(json['conseils']);
      }
    }

    return CurrentPeriodInfo(
      periodNumber: json['period_number'] ?? 1,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      dayInPeriod: json['day_in_period'] ?? 1,
      daysRemaining: json['days_remaining'] ?? 0,
      periodStartDate: DateTime.parse(json['period_start_date'].toString()),
      periodEndDate: DateTime.parse(json['period_end_date'].toString()),
      energiePeriode: json['energie_periode'] ?? '',
      descriptionTheme: json['description_theme'] ?? '',
      domainesFavorables: parseFavorables,
      domainesEviter: parseEviter,
      conseils: parseConseils,
      affirmation: json['affirmation'] ?? '',
      influenceDecisions: json['influence_decisions'] ?? '',
      enseignement: json['enseignement'] ?? '',
    );
  }

  /// Liste des domaines très favorables
  List<String> get tresFavorables {
    final list = domainesFavorables['tres_favorables'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines favorables
  List<String> get favorables {
    final list = domainesFavorables['favorables'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines à reporter
  List<String> get reporter {
    final list = domainesEviter['reporter'];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// Liste des domaines nécessitant attention
  List<String> get attention {
    final list = domainesEviter['attention'];
    if (list == null) return [];
    return List<String>.from(list);
  }
}

/// Modèle pour une entrée du calendrier annuel
class PersonalCalendarEntry {
  final int periodNumber;
  final String periodName;
  final String themeCentral;
  final DateTime startDate;
  final DateTime endDate;
  final String affirmation;
  final bool isCurrent;

  PersonalCalendarEntry({
    required this.periodNumber,
    required this.periodName,
    required this.themeCentral,
    required this.startDate,
    required this.endDate,
    required this.affirmation,
    this.isCurrent = false,
  });

  factory PersonalCalendarEntry.fromJson(Map<String, dynamic> json, {bool isCurrent = false}) {
    return PersonalCalendarEntry(
      periodNumber: json['period_number'] ?? 1,
      periodName: json['period_name'] ?? '',
      themeCentral: json['theme_central'] ?? '',
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      affirmation: json['affirmation'] ?? '',
      isCurrent: isCurrent,
    );
  }
}

/// Modèle pour le calendrier annuel personnalisé
class PersonalYearCalendar {
  final DateTime birthday;
  final int year;
  final List<PersonalCalendarEntry> periods;

  PersonalYearCalendar({
    required this.birthday,
    required this.year,
    required this.periods,
  });

  factory PersonalYearCalendar.fromRpc(Map<String, dynamic> json) {
    final birthday = DateTime.parse(json['birthday'].toString());
    final year = json['year'] ?? DateTime.now().year;
    
    final periodsJson = json['periods'] as List? ?? [];
    final now = DateTime.now();
    
    final periods = periodsJson.map((p) {
      final entry = PersonalCalendarEntry.fromJson(p as Map<String, dynamic>);
      // Vérifier si c'est la période actuelle
      final isCurrent = now.isAfter(entry.startDate.subtract(const Duration(days: 1))) &&
                        now.isBefore(entry.endDate.add(const Duration(days: 1)));
      return PersonalCalendarEntry(
        periodNumber: entry.periodNumber,
        periodName: entry.periodName,
        themeCentral: entry.themeCentral,
        startDate: entry.startDate,
        endDate: entry.endDate,
        affirmation: entry.affirmation,
        isCurrent: isCurrent,
      );
    }).toList();

    return PersonalYearCalendar(
      birthday: birthday,
      year: year,
      periods: periods,
    );
  }

  /// Période actuelle
  PersonalCalendarEntry? get currentPeriod {
    try {
      return periods.firstWhere((p) => p.isCurrent);
    } catch (_) {
      return null;
    }
  }
}

/// Modèle pour un abonnement au cycle personnel
class PersonalSubscription {
  final String id;
  final String userId;
  final DateTime userBirthdate;
  final String? userFirstname;
  final DateTime startDate;
  final DateTime endDate;
  final String? paymentId;
  final String status;
  final bool autoRenew;

  PersonalSubscription({
    required this.id,
    required this.userId,
    required this.userBirthdate,
    this.userFirstname,
    required this.startDate,
    required this.endDate,
    this.paymentId,
    required this.status,
    this.autoRenew = false,
  });

  factory PersonalSubscription.fromJson(Map<String, dynamic> json) {
    return PersonalSubscription(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userBirthdate: DateTime.parse(json['user_birthdate'].toString()),
      userFirstname: json['user_firstname'],
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      paymentId: json['payment_id'],
      status: json['status'] ?? 'active',
      autoRenew: json['auto_renew'] ?? false,
    );
  }

  /// Vérifie si l'abonnement est actif
  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now());

  /// Jours restants dans l'abonnement
  int get daysRemaining {
    if (!isActive) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
}

/// Service pour gérer le Cycle Personnel
class PersonalCycleService {
  static final PersonalCycleService _instance = PersonalCycleService._internal();
  static PersonalCycleService get instance => _instance;

  PersonalCycleService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  // Cache local
  List<PersonalPeriod>? _cachedPeriods;

  /// Récupère toutes les périodes (7)
  Future<List<PersonalPeriod>> getPeriods({bool forceRefresh = false}) async {
    if (_cachedPeriods != null && !forceRefresh) {
      return _cachedPeriods!;
    }

    try {
      final response = await _supabase
          .from('personal_cycle_periods')
          .select()
          .eq('is_active', true)
          .order('period_number');

      final periods = (response as List)
          .map((json) => PersonalPeriod.fromJson(json))
          .toList();

      _cachedPeriods = periods;
      return periods;
    } catch (e) {
      debugPrint('Erreur récupération périodes: $e');
      rethrow;
    }
  }

  /// Récupère une période par son numéro
  Future<PersonalPeriod?> getPeriodByNumber(int number) async {
    final periods = await getPeriods();
    try {
      return periods.firstWhere((p) => p.periodNumber == number);
    } catch (_) {
      return null;
    }
  }

  /// Calcule et récupère la période actuelle pour une date de naissance
  Future<CurrentPeriodInfo> getCurrentPeriod(DateTime birthdate, {DateTime? targetDate}) async {
    try {
      final response = await _supabase.rpc(
        'fn_get_current_personal_period',
        params: {
          'p_birthdate': birthdate.toIso8601String().split('T').first,
          'p_target_date': (targetDate ?? DateTime.now()).toIso8601String().split('T').first,
        },
      );

      // La fonction retourne une liste avec un seul élément
      if (response is List && response.isNotEmpty) {
        return CurrentPeriodInfo.fromRpc(response[0] as Map<String, dynamic>);
      }

      throw Exception('Aucune donnée retournée par la fonction RPC');
    } catch (e) {
      debugPrint('Erreur calcul période actuelle: $e');
      rethrow;
    }
  }

  /// Récupère le calendrier annuel personnalisé
  Future<PersonalYearCalendar> getYearCalendar(DateTime birthdate, {int? year}) async {
    try {
      final response = await _supabase.rpc(
        'fn_get_personal_year_calendar',
        params: {
          'p_birthdate': birthdate.toIso8601String().split('T').first,
          'p_year': year ?? DateTime.now().year,
        },
      );

      if (response != null && response['success'] == true) {
        return PersonalYearCalendar.fromRpc(response as Map<String, dynamic>);
      }

      throw Exception('Erreur lors de la récupération du calendrier');
    } catch (e) {
      debugPrint('Erreur récupération calendrier: $e');
      rethrow;
    }
  }

  /// Vérifie si l'utilisateur a un abonnement actif
  Future<PersonalSubscription?> getActiveSubscription({String? userId}) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) return null;

      final response = await _supabase
          .from('personal_cycle_subscriptions')
          .select()
          .eq('user_id', uid)
          .eq('status', 'active')
          .gte('end_date', DateTime.now().toIso8601String().split('T').first)
          .order('end_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return PersonalSubscription.fromJson(response);
    } catch (e) {
      debugPrint('Erreur vérification abonnement: $e');
      return null;
    }
  }

  /// Crée un abonnement après paiement réussi
  Future<PersonalSubscription> createSubscription({
    required String paymentId,
    required DateTime birthdate,
    required String firstname,
    String? userId,
  }) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await _supabase.rpc(
        'fn_create_personal_cycle_subscription',
        params: {
          'p_user_id': uid,
          'p_payment_id': paymentId,
          'p_birthdate': birthdate.toIso8601String().split('T').first,
          'p_firstname': firstname,
        },
      );

      if (response != null && response['success'] == true) {
        // Récupérer l'abonnement créé
        final subId = response['subscription_id'];
        final subResponse = await _supabase
            .from('personal_cycle_subscriptions')
            .select()
            .eq('id', subId)
            .single();

        return PersonalSubscription.fromJson(subResponse);
      }

      throw Exception('Erreur lors de la création de l\'abonnement');
    } catch (e) {
      debugPrint('Erreur création abonnement: $e');
      rethrow;
    }
  }

  /// Vérifie rapidement si l'utilisateur a accès
  Future<bool> hasAccess({String? userId}) async {
    try {
      final uid = userId ?? AuthService.instance.currentUser?.id;
      if (uid == null) return false;

      final response = await _supabase.rpc(
        'fn_check_personal_cycle_access',
        params: {'p_user_id': uid},
      );

      return response == true;
    } catch (e) {
      debugPrint('Erreur vérification accès: $e');
      return false;
    }
  }

  /// Efface le cache
  void clearCache() {
    _cachedPeriods = null;
  }
}
