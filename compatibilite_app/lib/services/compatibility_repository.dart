import 'package:compatibilite_app/models/compatibility_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SaveResult {
  SaveResult({required this.sessionId, required this.clientToken});

  final String sessionId;
  final String clientToken;
}

/// Handles persistence of compatibility sessions and partner reports into Supabase.
class CompatibilityRepository {
  CompatibilityRepository(this._client);

  final SupabaseClient _client;
  final Uuid _uuid = const Uuid();
  static const String _tableSessions = 'sessions_compatibilite';
  static const String _tableReports = 'rapports_partenaires';

  Future<SaveResult> saveSession({
    required PartnerInput partnerA,
    required PartnerInput partnerB,
    required CompatibilitySummary summary,
    String? relationStatus,
    DateTime? meetingDate,
    String? durationText,
    List<String> challenges = const [],
    bool wantsNotifications = false,
    String? contactEmail,
    String? contactPhone,
    String paymentStatus = 'pending',
    String currency = 'EUR',
    int? amountCents,
  }) async {
    final clientToken = _uuid.v4();
    final sessionPayload = {
      'partenaire_a_nom': partnerA.name,
      'partenaire_a_naissance': partnerA.birthDate.toIso8601String(),
      'partenaire_b_nom': partnerB.name,
      'partenaire_b_naissance': partnerB.birthDate.toIso8601String(),
      'statut_relation': relationStatus,
      'date_rencontre': meetingDate?.toIso8601String(),
      'duree_relation': durationText,
      'defis': challenges,
      'notifications': wantsNotifications,
      'nombre_couple': summary.coupleNumber,
      'nombre_couple_jour': summary.coupleDailyNumber,
      'genere_le': summary.generatedAt.toIso8601String(),
      'email_contact': contactEmail,
      'telephone_contact': contactPhone,
      'statut_paiement': paymentStatus,
      'devise': currency,
      'montant_centimes': amountCents,
      'client_token': clientToken,
    };

    final inserted = await _client.from(_tableSessions).insert(sessionPayload).select('id').single();
    final sessionId = inserted['id'] as String;

    final partnerRows = [
      _mapReport(
        sessionId: sessionId,
        report: summary.partnerA,
        role: partnerA.role ?? 'Partenaire 1',
      ),
      _mapReport(
        sessionId: sessionId,
        report: summary.partnerB,
        role: partnerB.role ?? 'Partenaire 2',
      ),
    ];

    await _client.from(_tableReports).insert(partnerRows);

    return SaveResult(sessionId: sessionId, clientToken: clientToken);
  }

  Map<String, dynamic> _mapReport({
    required String sessionId,
    required PartnerReport report,
    required String role,
  }) {
    return {
      'session_id': sessionId,
      'role_partenaire': role,
      'nom_partenaire': report.input.name,
      'chemin_vie': report.lifePath,
      'nombre_nom': report.nameNumber,
      'nombre_kabbale': report.kabbalahNumber,
      'nombre_intime': report.intimateNumber,
      'nombre_personnalite': report.personalityNumber,
      'nombre_heredite': report.heredityNumber,
      'annee_personnelle': report.personalYear,
      'mois_personnel': report.personalMonth,
      'jour_personnel': report.personalDay,
    };
  }
}
