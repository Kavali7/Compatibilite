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

  /// Store a report after successful purchase
  Future<String?> storeReport({
    required String userId,
    String? paymentId,
    required String serviceType,
    required String serviceLabel,
    required Map<String, dynamic> reportData,
    Map<String, dynamic>? metadata,
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
      });

      final reportId = response as String?;
      debugPrint('StoredReportService: Report stored with ID: $reportId');
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

  /// Check if a stored report already exists for a user and service type
  /// Used to prevent duplicate entries in "Mes Achats"
  Future<bool> hasStoredReport({
    required String userId,
    required String serviceType,
  }) async {
    if (!SupabaseManager.isReady) {
      return false;
    }

    try {
      final client = Supabase.instance.client;
      
      final response = await client
          .from('stored_reports')
          .select('id')
          .eq('user_id', userId)
          .eq('service_type', serviceType)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      debugPrint('StoredReportService: Error checking report existence: $e');
      return false; // Assume not exists on error, allow store attempt
    }
  }

  /// Store Portrait de l'Âme report
  Future<String?> storePortraitAmeReport({
    required String userId,
    String? paymentId,
    required String userName,
    required DateTime birthDate,
    required Map<String, dynamic> reportData,
  }) async {
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typePortraitAme,
      serviceLabel: StoredReport.getLabelForType(StoredReport.typePortraitAme),
      reportData: reportData,
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
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeCyclePersonnel,
      serviceLabel: StoredReport.getLabelForType(StoredReport.typeCyclePersonnel),
      reportData: reportData,
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
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeCompatibility,
      serviceLabel: '$user1Name & $user2Name',
      reportData: reportData,
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

    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: StoredReport.typeTemporal,
      serviceLabel: label,
      reportData: reportData,
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
    return storeReport(
      userId: userId,
      paymentId: paymentId,
      serviceType: serviceType,
      serviceLabel: StoredReport.getLabelForType(serviceType),
      reportData: reportData,
      metadata: {
        'user_name': userName,
        'birth_date': birthDate.toIso8601String(),
        if (targetDate != null) 'target_date': targetDate.toIso8601String(),
      },
    );
  }
}
