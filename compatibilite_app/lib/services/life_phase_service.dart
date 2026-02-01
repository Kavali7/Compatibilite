import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_manager.dart';

/// Période Phase de Vie (un des 10 cycles de 7 ans)
class LifePhase {
  final String id;
  final int phaseNumber;
  final String phaseName;
  final int ageStart;
  final int ageEnd;
  final String theme;
  final String fullContent;
  final List<String> impacts;
  final List<String> questionsReflection;
  final List<String> travailGuerison;

  LifePhase({
    required this.id,
    required this.phaseNumber,
    required this.phaseName,
    required this.ageStart,
    required this.ageEnd,
    required this.theme,
    required this.fullContent,
    required this.impacts,
    required this.questionsReflection,
    required this.travailGuerison,
  });

  factory LifePhase.fromJson(Map<String, dynamic> json) {
    return LifePhase(
      id: json['id'] as String,
      phaseNumber: json['phase_number'] as int,
      phaseName: json['phase_name'] as String,
      ageStart: json['age_start'] as int,
      ageEnd: json['age_end'] as int,
      theme: json['theme'] as String,
      fullContent: json['full_content'] as String? ?? '',
      impacts: _parseStringList(json['impacts']),
      questionsReflection: _parseStringList(json['questions_reflection']),
      travailGuerison: _parseStringList(json['travail_guerison']),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  String get ageRange => ageEnd >= 100 ? '$ageStart+ ans' : '$ageStart-$ageEnd ans';
}

/// Infos de phase actuelle avec contexte
class CurrentLifePhaseInfo {
  final LifePhase phase;
  final int currentAge;
  final int yearInPhase;
  final int yearsRemaining;

  CurrentLifePhaseInfo({
    required this.phase,
    required this.currentAge,
    required this.yearInPhase,
    required this.yearsRemaining,
  });
}

/// Achat du service Phases de Vie
class LifePhasePurchase {
  final String id;
  final String userId;
  final DateTime userBirthdate;
  final DateTime purchaseDate;
  final String? paymentId;

  LifePhasePurchase({
    required this.id,
    required this.userId,
    required this.userBirthdate,
    required this.purchaseDate,
    this.paymentId,
  });

  factory LifePhasePurchase.fromJson(Map<String, dynamic> json) {
    return LifePhasePurchase(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userBirthdate: DateTime.parse(json['user_birthdate'] as String),
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      paymentId: json['payment_id'] as String?,
    );
  }
}

/// Service pour les Phases de Vie (Service 07)
class LifePhaseService {
  static final LifePhaseService instance = LifePhaseService._();
  LifePhaseService._();

  SupabaseClient get _client => Supabase.instance.client;

  /// Récupérer toutes les phases de vie
  Future<List<LifePhase>> getAllPhases() async {
    try {
      final response = await _client
          .from('life_phase_periods')
          .select()
          .eq('is_active', true)
          .order('phase_number');
      
      return (response as List)
          .map((json) => LifePhase.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('LifePhaseService.getAllPhases error: $e');
      return [];
    }
  }

  /// Récupérer une phase spécifique
  Future<LifePhase?> getPhaseByNumber(int phaseNumber) async {
    try {
      final response = await _client
          .from('life_phase_periods')
          .select()
          .eq('phase_number', phaseNumber)
          .eq('is_active', true)
          .single();
      
      return LifePhase.fromJson(response);
    } catch (e) {
      debugPrint('LifePhaseService.getPhaseByNumber error: $e');
      return null;
    }
  }

  /// Calculer la phase actuelle pour une date de naissance
  CurrentLifePhaseInfo? calculateCurrentPhase({
    required DateTime birthDate,
    required List<LifePhase> phases,
    DateTime? referenceDate,
  }) {
    if (phases.isEmpty) return null;

    final now = referenceDate ?? DateTime.now();
    final currentAge = _calculateAge(birthDate, now);
    
    // Trouver la phase correspondante
    LifePhase? currentPhase;
    for (final phase in phases) {
      if (currentAge >= phase.ageStart && currentAge < phase.ageEnd) {
        currentPhase = phase;
        break;
      }
    }
    
    // Si âge > 63, prendre la dernière phase
    currentPhase ??= phases.last;

    // Calculer la position dans la phase
    final yearInPhase = currentAge - currentPhase.ageStart + 1;
    final yearsRemaining = currentPhase.ageEnd - currentAge;

    return CurrentLifePhaseInfo(
      phase: currentPhase,
      currentAge: currentAge,
      yearInPhase: yearInPhase,
      yearsRemaining: yearsRemaining > 0 ? yearsRemaining : 0,
    );
  }

  int _calculateAge(DateTime birthDate, DateTime referenceDate) {
    int age = referenceDate.year - birthDate.year;
    if (referenceDate.month < birthDate.month ||
        (referenceDate.month == birthDate.month && referenceDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Générer l'historique des phases passées
  List<LifePhase> getPastPhases({
    required DateTime birthDate,
    required List<LifePhase> phases,
  }) {
    final currentAge = _calculateAge(birthDate, DateTime.now());
    return phases.where((phase) => phase.ageEnd <= currentAge).toList();
  }

  /// Récupérer l'achat actif de l'utilisateur
  Future<LifePhasePurchase?> getActivePurchase(String userId) async {
    try {
      final response = await _client
          .from('life_phase_purchases')
          .select()
          .eq('user_id', userId)
          .order('purchase_date', ascending: false)
          .limit(1)
          .maybeSingle();
      
      if (response == null) return null;
      return LifePhasePurchase.fromJson(response);
    } catch (e) {
      debugPrint('LifePhaseService.getActivePurchase error: $e');
      return null;
    }
  }

  /// Créer un nouvel achat
  Future<LifePhasePurchase?> createPurchase({
    required String userId,
    required DateTime birthDate,
    String? paymentId,
  }) async {
    try {
      final response = await _client
          .from('life_phase_purchases')
          .insert({
            'user_id': userId,
            'user_birthdate': birthDate.toIso8601String().split('T').first,
            'payment_id': paymentId,
          })
          .select()
          .single();
      
      return LifePhasePurchase.fromJson(response);
    } catch (e) {
      debugPrint('LifePhaseService.createPurchase error: $e');
      return null;
    }
  }

  /// Vérifier si l'utilisateur a accès au service
  Future<bool> hasAccess(String userId) async {
    final purchase = await getActivePurchase(userId);
    return purchase != null;
  }
}
