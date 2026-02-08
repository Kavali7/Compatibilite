/// Stored Report Service
/// Manages storing and retrieving frozen report data
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/stored_report_model.dart';
import 'supabase_manager.dart';

/// Service for managing stored (frozen) reports
class StoredReportService {
  StoredReportService._();
  static final StoredReportService instance = StoredReportService._();

  /// Store a report after successful purchase (UPSERT: updates if same upsert_key exists)
  Future<String?> storeReport({
    required String userId,
    String? paymentId,
    required String serviceType,
    required String serviceLabel,
    required Map<String, dynamic> reportData,
    Map<String, dynamic>? metadata,
    required String upsertKey,
  }) async {
    if (!SupabaseManager.isReady) {
      debugPrint('StoredReportService: Supabase not ready');
      return null;
    }

    try {
      final client = Supabase.instance.client;
      
      final response = await client.rpc('fn_store_report', params: {
        'p_user_id': userId,
        'p_payment_id': paymentId,
        'p_service_type': serviceType,
        'p_service_label': serviceLabel,
        'p_report_data': reportData,
        'p_metadata': metadata ?? {},
        'p_upsert_key': upsertKey,
      });

      final reportId = response as String?;
      debugPrint('StoredReportService: Report upserted with ID: $reportId (key: $upsertKey)');
      return reportId;
    } catch (e) {
      debugPrint('StoredReportService: Error storing report: $e');
      return null;
    }
  }

  /// Get all stored reports for a user
  Future<List<StoredReport>> getUserReports(String userId) async {
    if (!SupabaseManager.isReady) {
      debugPrint('StoredReportService: Supabase not ready');
      return [];
    }

    try {
      final client = Supabase.instance.client;
      
      final response = await client.rpc('fn_get_user_stored_reports', params: {
        'p_user_id': userId,
      });

      if (response == null) return [];

      final reports = (response as List)
          .map((json) => StoredReport.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('StoredReportService: Fetched ${reports.length} reports');
      return reports;
    } catch (e) {
      debugPrint('StoredReportService: Error fetching reports: $e');
      return [];
    }
  }

  /// Get a single stored report by ID
  Future<StoredReport?> getReport(String reportId) async {
    if (!SupabaseManager.isReady) {
      debugPrint('StoredReportService: Supabase not ready');
      return null;
    }

    try {
      final client = Supabase.instance.client;
      
      final response = await client.rpc('fn_get_stored_report', params: {
        'p_report_id': reportId,
      });

      if (response == null || (response as List).isEmpty) {
        return null;
      }

      return StoredReport.fromJson((response as List).first as Map<String, dynamic>);
    } catch (e) {
      debugPrint('StoredReportService: Error fetching report: $e');
      return null;
    }
  }

  /// Helper to format a date as yyyy-MM-dd for upsert keys
  String _dateKey(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Store Portrait de l'Âme report
  Future<String?> storePortraitAmeReport({
    required String userId,
    String? paymentId,
    required String userName,
    required DateTime birthDate,
    required Map<String, dynamic> reportData,
  }) async {
    final key = 'portrait_ame|${userName.trim().toLowerCase()}|${_dateKey(birthDate)}';
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typePortraitAme,
      serviceLabel: StoredReport.getLabelForType(StoredReport.typePortraitAme),
      reportData: reportData,
      upsertKey: key,
      metadata: {
        'user_name': userName,
        'birth_date': birthDate.toIso8601String(),
      },
    );
  }

  /// Store Cycle Personnel report
  Future<String?> storeCyclePersonnelReport({
    required String userId,
    String? paymentId,
    required String userName,
    required DateTime birthDate,
    required Map<String, dynamic> reportData,
  }) async {
    final key = 'cycle_personnel|${userName.trim().toLowerCase()}|${_dateKey(birthDate)}';
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeCyclePersonnel,
      serviceLabel: StoredReport.getLabelForType(StoredReport.typeCyclePersonnel),
      reportData: reportData,
      upsertKey: key,
      metadata: {
        'user_name': userName,
        'birth_date': birthDate.toIso8601String(),
      },
    );
  }

  /// Store Compatibility report
  Future<String?> storeCompatibilityReport({
    required String userId,
    String? paymentId,
    required String user1Name,
    required String user2Name,
    required DateTime user1BirthDate,
    required DateTime user2BirthDate,
    required Map<String, dynamic> reportData,
  }) async {
    final key = 'compatibility|${user1Name.trim().toLowerCase()}|${_dateKey(user1BirthDate)}|${user2Name.trim().toLowerCase()}|${_dateKey(user2BirthDate)}';
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeCompatibility,
      serviceLabel: '$user1Name & $user2Name',
      reportData: reportData,
      upsertKey: key,
      metadata: {
        'user1_name': user1Name,
        'user2_name': user2Name,
        'user1_birth_date': user1BirthDate.toIso8601String(),
        'user2_birth_date': user2BirthDate.toIso8601String(),
      },
    );
  }

  /// Store Temporal Prediction report
  Future<String?> storeTemporalReport({
    required String userId,
    String? paymentId,
    required String periodType, // 'jour', 'mois', 'annee'
    required DateTime targetDate,
    required Map<String, dynamic> reportData,
  }) async {
    String label;
    switch (periodType) {
      case 'jour':
        label = 'Prévision Journalière';
        break;
      case 'mois':
        label = 'Prévision Mensuelle';
        break;
      case 'annee':
        label = 'Prévision Annuelle';
        break;
      default:
        label = 'Prévision Temporelle';
    }

    final key = 'temporal|$periodType|${_dateKey(targetDate)}';
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeTemporal,
      serviceLabel: label,
      reportData: reportData,
      upsertKey: key,
      metadata: {
        'period_type': periodType,
        'target_date': targetDate.toIso8601String(),
      },
    );
  }

  /// Generic store for any Cycles de Vie service
  Future<String?> storeCyclesVieReport({
    required String userId,
    String? paymentId,
    required String serviceType,
    required String userName,
    required DateTime birthDate,
    required DateTime? targetDate,
    required Map<String, dynamic> reportData,
  }) async {
    // Build the upsert key: serviceType|name|birthdate (+ |targetDate if applicable)
    final namePart = userName.trim().toLowerCase();
    final birthPart = _dateKey(birthDate);
    final key = targetDate != null
        ? '$serviceType|$namePart|$birthPart|${_dateKey(targetDate)}'
        : '$serviceType|$namePart|$birthPart';
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: serviceType,
      serviceLabel: StoredReport.getLabelForType(serviceType),
      reportData: reportData,
      upsertKey: key,
      metadata: {
        'user_name': userName,
        'birth_date': birthDate.toIso8601String(),
        if (targetDate != null) 'target_date': targetDate.toIso8601String(),
      },
    );
  }
}
