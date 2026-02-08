import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service principal pour les fonctionnalités Cycles de Vie.
/// Gère les calculs de cycles, requêtes DB et génération de rapports.
class CyclesVieService {
  static final CyclesVieService _instance = CyclesVieService._internal();
  factory CyclesVieService() => _instance;
  CyclesVieService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // ═══════════════════════════════════════════════════════════════
  // MODÈLES DE DONNÉES
  // ═══════════════════════════════════════════════════════════════

  // Cache pour les données statiques
  List<SoulPeriod>? _cachedSoulPeriods;
  List<DailyPeriod>? _cachedDailyPeriods;
  List<DecisionType>? _cachedDecisionTypes;

  // ═══════════════════════════════════════════════════════════════
  // SOUL CYCLE - Période basée sur date de naissance
  // ═══════════════════════════════════════════════════════════════

  /// Récupère toutes les périodes Soul depuis la base
  Future<List<SoulPeriod>> getSoulPeriods() async {
    if (_cachedSoulPeriods != null) {
      debugPrint('🌟 getSoulPeriods: Returning ${_cachedSoulPeriods!.length} cached periods');
      return _cachedSoulPeriods!;
    }

    debugPrint('🌟 getSoulPeriods: Fetching from database...');
    final response = await _client
        .from('cycle_vie_soul_periods')
        .select()
        .eq('is_active', true)
        .order('period_number')
        .order('polarity');

    debugPrint('🌟 getSoulPeriods: Raw response has ${(response as List).length} items');
    if (response.isNotEmpty) {
      debugPrint('🌟 getSoulPeriods: First item: ${response.first}');
    }
    
    _cachedSoulPeriods =
        response.map((e) => SoulPeriod.fromJson(e)).toList();
    debugPrint('🌟 getSoulPeriods: Parsed ${_cachedSoulPeriods!.length} SoulPeriod objects');
    return _cachedSoulPeriods!;
  }

  /// Détermine la période Soul pour une date de naissance
  Future<SoulPeriod?> getSoulPeriodForBirthdate(DateTime birthdate) async {
    final periods = await getSoulPeriods();

    // Convertir la date de naissance en (mois, jour) pour comparaison
    final birthMonth = birthdate.month;
    final birthDay = birthdate.day;

    for (final period in periods) {
      if (_isDateInRangeFrench(birthMonth, birthDay, period.dateStart, period.dateEnd)) {
        // Déterminer la polarité (A ou B) selon l'année
        // Années paires = A, années impaires = B (simplification)
        final polarity = (birthdate.year % 2 == 0) ? 'A' : 'B';
        if (period.polarity == polarity) {
          return period;
        }
      }
    }

    // Fallback: retourner la première correspondance sans tenir compte de la polarité
    for (final period in periods) {
      if (_isDateInRangeFrench(birthMonth, birthDay, period.dateStart, period.dateEnd)) {
        return period;
      }
    }

    return null;
  }

  /// Parse une date au format français "22 mars" en (jour, mois)
  (int day, int month)? _parseFrenchDate(String frenchDate) {
    final monthNames = {
      'janvier': 1, 'février': 2, 'mars': 3, 'avril': 4,
      'mai': 5, 'juin': 6, 'juillet': 7, 'août': 8,
      'septembre': 9, 'octobre': 10, 'novembre': 11, 'décembre': 12,
      // Variantes sans accents
      'fevrier': 2, 'aout': 8, 'decembre': 12,
    };

    final parts = frenchDate.trim().toLowerCase().split(' ');
    if (parts.length != 2) return null;

    final day = int.tryParse(parts[0]);
    final month = monthNames[parts[1]];

    if (day == null || month == null) return null;
    return (day, month);
  }

  /// Vérifie si une date (mois, jour) est dans la plage [start, end] (format français)
  bool _isDateInRangeFrench(int month, int day, String startFr, String endFr) {
    final start = _parseFrenchDate(startFr);
    final end = _parseFrenchDate(endFr);

    if (start == null || end == null) {
      debugPrint('⚠️ Erreur parsing dates: start=$startFr, end=$endFr');
      return false;
    }

    // Convertir en valeur comparable (mois * 100 + jour)
    final dateVal = month * 100 + day;
    final startVal = start.$2 * 100 + start.$1;
    final endVal = end.$2 * 100 + end.$1;

    // Gère le cas spécial où la période traverse le nouvel an
    if (startVal > endVal) {
      // Période qui traverse le 1er janvier (ex: 14 déc → 12 janv)
      return dateVal >= startVal || dateVal <= endVal;
    }
    return dateVal >= startVal && dateVal <= endVal;
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY CYCLE - Période de la journée
  // ═══════════════════════════════════════════════════════════════

  /// Récupère toutes les périodes quotidiennes
  Future<List<DailyPeriod>> getDailyPeriods() async {
    if (_cachedDailyPeriods != null) {
      debugPrint('⏰ getDailyPeriods: Returning ${_cachedDailyPeriods!.length} cached periods');
      return _cachedDailyPeriods!;
    }

    debugPrint('⏰ getDailyPeriods: Fetching from database...');
    final response = await _client
        .from('cycle_vie_daily_periods')
        .select()
        .eq('is_active', true)
        .order('period_letter');

    debugPrint('⏰ getDailyPeriods: Raw response has ${(response as List).length} items');
    if (response.isNotEmpty) {
      debugPrint('⏰ getDailyPeriods: First item: ${response.first}');
    }
    
    _cachedDailyPeriods =
        response.map((e) => DailyPeriod.fromJson(e)).toList();
    debugPrint('⏰ getDailyPeriods: Parsed ${_cachedDailyPeriods!.length} DailyPeriod objects');
    return _cachedDailyPeriods!;
  }

  /// Calcule la période quotidienne actuelle
  Future<DailyPeriod?> getCurrentDailyPeriod() async {
    final periods = await getDailyPeriods();
    if (periods.isEmpty) return null;

    final now = DateTime.now();
    final dayOfWeek = now.weekday; // 1 = lundi, 7 = dimanche

    // Chaque jour commence par une lettre différente
    // Lundi = A, Mardi = B, etc.
    final startLetterIndex = (dayOfWeek - 1) % 7;

    // Calculer quelle période de ~3h25 nous sommes
    // 24h / 7 périodes = ~3.43 heures par période
    final minutesSinceMidnight = now.hour * 60 + now.minute;
    final periodDurationMinutes = (24 * 60) ~/ 7; // ~205 minutes
    final currentPeriodIndex =
        (minutesSinceMidnight ~/ periodDurationMinutes) % 7;

    // La lettre actuelle
    final currentLetterIndex = (startLetterIndex + currentPeriodIndex) % 7;
    final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final currentLetter = letters[currentLetterIndex];

    return periods.firstWhere(
      (p) => p.periodLetter == currentLetter,
      orElse: () => periods.first,
    );
  }

  /// Retourne toutes les périodes du jour avec leurs horaires
  Future<List<DailyPeriodWithTime>> getDaySchedule([DateTime? date]) async {
    final periods = await getDailyPeriods();
    final targetDate = date ?? DateTime.now();
    final dayOfWeek = targetDate.weekday;

    final startLetterIndex = (dayOfWeek - 1) % 7;
    final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final periodDurationMinutes = (24 * 60) ~/ 7;

    final List<DailyPeriodWithTime> schedule = [];

    for (var i = 0; i < 7; i++) {
      final letterIndex = (startLetterIndex + i) % 7;
      final letter = letters[letterIndex];
      final period = periods.firstWhere(
        (p) => p.periodLetter == letter,
        orElse: () => periods.first,
      );

      final startMinutes = i * periodDurationMinutes;
      final endMinutes = (i + 1) * periodDurationMinutes;

      schedule.add(DailyPeriodWithTime(
        period: period,
        startTime: _minutesToTime(startMinutes),
        endTime: _minutesToTime(endMinutes),
        isCurrentPeriod: false, // À mettre à jour ensuite
      ));
    }

    // Marquer la période actuelle
    final now = DateTime.now();
    if (targetDate.day == now.day &&
        targetDate.month == now.month &&
        targetDate.year == now.year) {
      final minutesSinceMidnight = now.hour * 60 + now.minute;
      final currentIndex = (minutesSinceMidnight ~/ periodDurationMinutes) % 7;
      if (currentIndex < schedule.length) {
        schedule[currentIndex] = DailyPeriodWithTime(
          period: schedule[currentIndex].period,
          startTime: schedule[currentIndex].startTime,
          endTime: schedule[currentIndex].endTime,
          isCurrentPeriod: true,
        );
      }
    }

    return schedule;
  }

  String _minutesToTime(int minutes) {
    final h = (minutes ~/ 60) % 24;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  // ═══════════════════════════════════════════════════════════════
  // DECISION TYPES
  // ═══════════════════════════════════════════════════════════════

  /// Récupère tous les types de décision actifs
  Future<List<DecisionType>> getDecisionTypes() async {
    if (_cachedDecisionTypes != null) return _cachedDecisionTypes!;

    final response = await _client
        .from('cycle_vie_decision_types')
        .select()
        .eq('is_active', true)
        .order('display_order');

    _cachedDecisionTypes =
        (response as List).map((e) => DecisionType.fromJson(e)).toList();
    return _cachedDecisionTypes!;
  }

  // ═══════════════════════════════════════════════════════════════
  // DECISION ADVICE
  // ═══════════════════════════════════════════════════════════════

  /// Récupère le conseil pour un type de décision et une période spécifique
  Future<DecisionAdvice?> getAdvice({
    required String decisionTypeId,
    required String cycleType,
    required int periodNumber,
  }) async {
    try {
      debugPrint('>>> getAdvice: typeId=$decisionTypeId, cycle=$cycleType, period=$periodNumber');
      
      final response = await _client
          .from('cycle_vie_decision_advice')
          .select()
          .eq('decision_type_id', decisionTypeId)
          .eq('cycle_type', cycleType)
          .eq('period_number', periodNumber)
          .maybeSingle();

      debugPrint('>>> getAdvice response: ${response != null ? "FOUND" : "NULL"}');
      
      if (response == null) return null;
      return DecisionAdvice.fromJson(response);
    } catch (e) {
      debugPrint('>>> getAdvice error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PURCHASES
  // ═══════════════════════════════════════════════════════════════

  /// Vérifie si l'utilisateur a un achat valide pour un service
  /// userId parameter supports custom auth systems
  Future<CyclePurchase?> getValidPurchase(String serviceType, {String? userId}) async {
    final effectiveUserId = userId ?? _client.auth.currentUser?.id;
    if (effectiveUserId == null) return null;

    final response = await _client.rpc('fn_get_cycle_vie_purchase', params: {
      'p_user_id': effectiveUserId,
      'p_service_type': serviceType,
    });

    if (response == null || (response is List && response.isEmpty)) {
      return null;
    }

    final data = response is List ? response.first : response;
    return CyclePurchase.fromJson(data);
  }

  /// Crée un nouvel achat après paiement réussi
  /// userId parameter supports custom auth systems
  Future<String?> createPurchase({
    required String serviceType,
    required String birthdate,
    String? firstname,
    String? consultationDate,
    String? decisionTypeId,
    String? decisionDetail,
    String? paymentId,
    String? userId, // Optional: pass for custom auth systems
  }) async {
    final effectiveUserId = userId ?? _client.auth.currentUser?.id;
    if (effectiveUserId == null) throw Exception('Utilisateur non connecté');

    final response = await _client.rpc('fn_create_cycle_vie_purchase', params: {
      'p_user_id': effectiveUserId,
      'p_service_type': serviceType,
      'p_user_birthdate': birthdate,
      'p_user_firstname': firstname,
      'p_consultation_date': consultationDate,
      'p_decision_type_id': decisionTypeId,
      'p_decision_detail': decisionDetail,
      'p_payment_id': paymentId,
    });

    return response as String?;
  }

  // ═══════════════════════════════════════════════════════════════
  // GÉNÉRATION DE RAPPORT EXPRESS
  // ═══════════════════════════════════════════════════════════════

  /// Génère un rapport Express pour la date donnée
  Future<ExpressReport> generateExpressReport({
    required DateTime birthdate,
    required DateTime targetDate,
  }) async {
    debugPrint('📊 generateExpressReport: Starting...');
    debugPrint('📊 generateExpressReport: birthdate=$birthdate, targetDate=$targetDate');

    // 1. Soul Period
    final soulPeriod = await getSoulPeriodForBirthdate(birthdate);
    debugPrint('📊 generateExpressReport: soulPeriod=${soulPeriod?.identiteCosmique ?? "NULL"}');
    if (soulPeriod != null) {
      debugPrint('📊 soulPeriod.identiteCosmique: ${soulPeriod.identiteCosmique}');
      debugPrint('📊 soulPeriod.introduction: ${soulPeriod.introduction.substring(0, soulPeriod.introduction.length.clamp(0, 100))}...');
    }

    // 2. Schedule du jour
    final daySchedule = await getDaySchedule(targetDate);
    debugPrint('📊 generateExpressReport: daySchedule has ${daySchedule.length} items');
    if (daySchedule.isNotEmpty) {
      debugPrint('📊 First schedule item: ${daySchedule.first.period.periodName} (${daySchedule.first.startTime}-${daySchedule.first.endTime})');
    }

    // 3. Période actuelle si c'est aujourd'hui
    final currentPeriod = await getCurrentDailyPeriod();
    debugPrint('📊 generateExpressReport: currentPeriod=${currentPeriod?.periodName ?? "NULL"}');

    return ExpressReport(
      soulPeriod: soulPeriod,
      daySchedule: daySchedule,
      currentPeriod: currentPeriod,
      targetDate: targetDate,
      birthdate: birthdate,
    );
  }

  /// Vide le cache (utile après un changement de données)
  void clearCache() {
    _cachedSoulPeriods = null;
    _cachedDailyPeriods = null;
    _cachedDecisionTypes = null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MODÈLES DE DONNÉES
// ═══════════════════════════════════════════════════════════════════════════

class SoulPeriod {
  final String id;
  final int periodNumber;
  final String polarity;
  final String dateStart;
  final String dateEnd;
  
  // ═══════════════════════════════════════════════════════════
  // NOUVELLE STRUCTURE - 11 sections de contenu intégral
  // ═══════════════════════════════════════════════════════════
  final String identiteCosmique;         // Titre de l'identité (ex: "L'Âme Souveraine")
  final String introduction;              // Texte d'introduction personnalisé
  final String heritageCosmique;          // Section "Votre Héritage Cosmique"
  final String coeurEtre;                 // Section "Le Cœur de Votre Être"
  final String forcesNaturelles;          // Section "Vos Forces Naturelles"
  final String defisTranscender;          // Section "Vos Défis à Transcender"
  final String vocationsIdeales;          // Section "Vos Vocations Idéales"
  final String affinitesGeographiques;    // Section "Vos Affinités Géographiques"
  final String vigilanceSante;            // Section "Points de Vigilance Santé"
  final String conseilsEpanouissement;    // Section "Conseils pour Votre Épanouissement"
  final String messageCosmique;           // Section "Votre Message Cosmique"

  SoulPeriod({
    required this.id,
    required this.periodNumber,
    required this.polarity,
    required this.dateStart,
    required this.dateEnd,
    required this.identiteCosmique,
    required this.introduction,
    required this.heritageCosmique,
    required this.coeurEtre,
    required this.forcesNaturelles,
    required this.defisTranscender,
    required this.vocationsIdeales,
    required this.affinitesGeographiques,
    required this.vigilanceSante,
    required this.conseilsEpanouissement,
    required this.messageCosmique,
  });

  factory SoulPeriod.fromJson(Map<String, dynamic> json) {
    return SoulPeriod(
      id: json['id'] ?? '',
      periodNumber: json['period_number'] ?? 0,
      polarity: json['polarity'] ?? 'A',
      dateStart: json['date_start'] ?? '',
      dateEnd: json['date_end'] ?? '',
      identiteCosmique: json['identite_cosmique'] ?? '',
      introduction: json['introduction'] ?? '',
      heritageCosmique: json['heritage_cosmique'] ?? '',
      coeurEtre: json['coeur_etre'] ?? '',
      forcesNaturelles: json['forces_naturelles'] ?? '',
      defisTranscender: json['defis_transcender'] ?? '',
      vocationsIdeales: json['vocations_ideales'] ?? '',
      affinitesGeographiques: json['affinites_geographiques'] ?? '',
      vigilanceSante: json['vigilance_sante'] ?? '',
      conseilsEpanouissement: json['conseils_epanouissement'] ?? '',
      messageCosmique: json['message_cosmique'] ?? '',
    );
  }
}

class DailyPeriod {
  final String id;
  final String periodLetter;
  final int? weekdayNumber;
  final String periodName;
  final String keyword;
  final String description;
  final String? activitesFavorables;
  final String? activitesEviter;
  final String? colorCode;
  final String? energyLevel;

  DailyPeriod({
    required this.id,
    required this.periodLetter,
    this.weekdayNumber,
    required this.periodName,
    required this.keyword,
    required this.description,
    this.activitesFavorables,
    this.activitesEviter,
    this.colorCode,
    this.energyLevel,
  });

  factory DailyPeriod.fromJson(Map<String, dynamic> json) {
    return DailyPeriod(
      id: json['id'] ?? '',
      periodLetter: json['period_letter'] ?? 'A',
      weekdayNumber: json['weekday_number'],
      periodName: json['period_name'] ?? '',
      keyword: json['keyword'] ?? '',
      description: json['description'] ?? '',
      activitesFavorables: json['activities_favorables'],
      activitesEviter: json['activities_eviter'],
      colorCode: json['color_code'],
      energyLevel: json['energy_level'],
    );
  }

  Color get color {
    if (colorCode != null && colorCode!.startsWith('#')) {
      try {
        return Color(int.parse('FF${colorCode!.substring(1)}', radix: 16));
      } catch (_) {}
    }
    return Colors.indigo;
  }
}

class DailyPeriodWithTime {
  final DailyPeriod period;
  final String startTime;
  final String endTime;
  final bool isCurrentPeriod;

  DailyPeriodWithTime({
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.isCurrentPeriod,
  });
}

class DecisionType {
  final String id;
  final String code;
  final String label;
  final String? category;
  final String? iconName;
  final String? description;
  final String? detailedDescription;
  final int displayOrder;

  DecisionType({
    required this.id,
    required this.code,
    required this.label,
    this.category,
    this.iconName,
    this.description,
    this.detailedDescription,
    required this.displayOrder,
  });

  factory DecisionType.fromJson(Map<String, dynamic> json) {
    return DecisionType(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      label: json['label'] ?? '',
      category: json['category'],
      iconName: json['icon'],
      description: json['description'],
      detailedDescription: json['detailed_description'],
      displayOrder: json['display_order'] ?? 0,
    );
  }

  IconData get icon {
    switch (category) {
      case 'immobilier':
        return Icons.home;
      case 'finance':
        return Icons.attach_money;
      case 'juridique':
        return Icons.gavel;
      case 'business':
        return Icons.business;
      case 'carriere':
        return Icons.work;
      case 'personnel':
        return Icons.favorite;
      case 'sante':
        return Icons.local_hospital;
      default:
        return Icons.help_outline;
    }
  }
}

class DecisionAdvice {
  final String id;
  final String decisionTypeId;
  final String cycleType;
  final int periodNumber;
  final int? favorabilityScore;
  
  // 8 champs de contenu enrichi
  final String? cosmicContext;
  final String adviceText;
  final String? recommendedActions;
  final String? warnings;
  final String? pitfallsToAvoid;
  final String? optimalTiming;
  final String? alternativesSuggestion;
  final String? closingMessage;

  DecisionAdvice({
    required this.id,
    required this.decisionTypeId,
    required this.cycleType,
    required this.periodNumber,
    this.favorabilityScore,
    this.cosmicContext,
    required this.adviceText,
    this.recommendedActions,
    this.warnings,
    this.pitfallsToAvoid,
    this.optimalTiming,
    this.alternativesSuggestion,
    this.closingMessage,
  });

  factory DecisionAdvice.fromJson(Map<String, dynamic> json) {
    return DecisionAdvice(
      id: json['id'] ?? '',
      decisionTypeId: json['decision_type_id'] ?? '',
      cycleType: json['cycle_type'] ?? '',
      periodNumber: json['period_number'] ?? 0,
      favorabilityScore: json['favorability_score'],
      cosmicContext: json['cosmic_context'],
      adviceText: json['advice_text'] ?? '',
      recommendedActions: json['recommended_actions'],
      warnings: json['warnings'],
      pitfallsToAvoid: json['pitfalls_to_avoid'],
      optimalTiming: json['optimal_timing'],
      alternativesSuggestion: json['alternatives_suggestion'],
      closingMessage: json['closing_message'],
    );
  }

  Color get favorabilityColor {
    if (favorabilityScore == null) return Colors.grey;
    final s = favorabilityScore!;
    if (s >= 80) return Colors.green;
    if (s >= 65) return Colors.lightGreen;
    if (s >= 50) return Colors.orange;
    if (s >= 35) return Colors.deepOrange;
    if (s > 0) return Colors.red;
    return Colors.grey;
  }

  String get favorabilityLabel {
    if (favorabilityScore == null) return 'Non évalué';
    final s = favorabilityScore!;
    if (s >= 80) return 'Très favorable';
    if (s >= 65) return 'Favorable';
    if (s >= 50) return 'Neutre';
    if (s >= 35) return 'Défavorable';
    if (s > 0) return 'Déconseillé';
    return 'Non évalué';
  }
  
  /// Vérifie si le conseil a du contenu enrichi
  bool get hasEnrichedContent => 
    cosmicContext != null || 
    recommendedActions != null || 
    pitfallsToAvoid != null ||
    optimalTiming != null ||
    closingMessage != null;
}

class CyclePurchase {
  final String id;
  final String userId;
  final String serviceType;
  final String userBirthdate;
  final String? userFirstname;
  final String? consultationDate;
  final String? decisionTypeId;
  final String status;
  final DateTime createdAt;
  final DateTime? expiresAt;

  CyclePurchase({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.userBirthdate,
    this.userFirstname,
    this.consultationDate,
    this.decisionTypeId,
    required this.status,
    required this.createdAt,
    this.expiresAt,
  });

  factory CyclePurchase.fromJson(Map<String, dynamic> json) {
    return CyclePurchase(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      serviceType: json['service_type'] ?? '',
      userBirthdate: json['user_birthdate'] ?? '',
      userFirstname: json['user_firstname'],
      consultationDate: json['consultation_date'],
      decisionTypeId: json['decision_type_id'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      expiresAt:
          json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    );
  }

  bool get isValid {
    if (status != 'completed') return false;
    if (expiresAt != null && expiresAt!.isBefore(DateTime.now())) return false;
    return true;
  }
}

class ExpressReport {
  final SoulPeriod? soulPeriod;
  final List<DailyPeriodWithTime> daySchedule;
  final DailyPeriod? currentPeriod;
  final DateTime targetDate;
  final DateTime birthdate;

  ExpressReport({
    this.soulPeriod,
    required this.daySchedule,
    this.currentPeriod,
    required this.targetDate,
    required this.birthdate,
  });
}
