/// Stored Report Model
/// Model for frozen report data stored at purchase time
library;

import 'package:flutter/foundation.dart';

/// Represents a stored (frozen) report
class StoredReport {
  final String id;
  final String userId;
  final String? paymentId;
  final String serviceType;
  final String serviceLabel;
  final Map<String, dynamic> reportData;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const StoredReport({
    required this.id,
    required this.userId,
    this.paymentId,
    required this.serviceType,
    required this.serviceLabel,
    required this.reportData,
    this.metadata = const {},
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from database response
  factory StoredReport.fromJson(Map<String, dynamic> json) {
    return StoredReport(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      paymentId: json['payment_id'] as String?,
      serviceType: json['service_type'] as String? ?? '',
      serviceLabel: json['service_label'] as String? ?? '',
      reportData: (json['report_data'] as Map<String, dynamic>?) ?? {},
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'payment_id': paymentId,
      'service_type': serviceType,
      'service_label': serviceLabel,
      'report_data': reportData,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Service type constants
  static const String typePortraitAme = 'portrait_ame';
  static const String typeCyclePersonnel = 'cycle_personnel';
  static const String typeCycleBusiness = 'cycle_business';
  static const String typeCycleSante = 'cycle_sante';
  static const String typeGuideHoraire = 'guide_horaire';
  static const String typeEclairageDecision = 'eclairage_decision';
  static const String typePhasesVie = 'phases_vie';
  static const String typeTimingLunaire = 'timing_lunaire';
  static const String typeCompatibility = 'compatibility';
  static const String typeTemporal = 'temporal';

  /// Service labels (user-facing)
  static const Map<String, String> serviceLabels = {
    typePortraitAme: 'Portrait de l\'Âme',
    typeCyclePersonnel: 'Cycle Personnel',
    typeCycleBusiness: 'Cycle Business',
    typeCycleSante: 'Cycle Santé',
    typeGuideHoraire: 'Guide Horaire',
    typeEclairageDecision: 'Éclairage Décision',
    typePhasesVie: 'Phases de Vie',
    typeTimingLunaire: 'Timing Lunaire',
    typeCompatibility: 'Compatibilité Couple',
    typeTemporal: 'Prévision Temporelle',
  };

  /// Get label for a service type
  static String getLabelForType(String type) {
    return serviceLabels[type] ?? type;
  }

  /// Get icon for a service type
  static String getIconForType(String type) {
    switch (type) {
      case typePortraitAme:
        return '🌟';
      case typeCyclePersonnel:
        return '🔄';
      case typeCycleBusiness:
        return '💼';
      case typeCycleSante:
        return '🏥';
      case typeGuideHoraire:
        return '⏰';
      case typeEclairageDecision:
        return '💡';
      case typePhasesVie:
        return '🌀';
      case typeTimingLunaire:
        return '🌙';
      case typeCompatibility:
        return '❤️';
      case typeTemporal:
        return '📅';
      default:
        return '📄';
    }
  }

  @override
  String toString() {
    return 'StoredReport(id: $id, serviceType: $serviceType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
