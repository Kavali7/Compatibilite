/// Model representing a configurable report section from the database
/// Managed via Admin Panel -> Compatibilité -> Sections du Rapport
class ReportSection {
  final String code;
  final String labelFr;
  final bool isActive;
  final int displayOrder;
  final String periode;
  final String description;

  const ReportSection({
    required this.code,
    required this.labelFr,
    required this.isActive,
    required this.displayOrder,
    required this.periode,
    required this.description,
  });

  factory ReportSection.fromJson(Map<String, dynamic> json) {
    return ReportSection(
      code: json['code'] as String? ?? '',
      labelFr: json['label_fr'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      periode: json['periode'] as String? ?? 'toutes',
      description: json['description'] as String? ?? '',
    );
  }

  // Default sections if database is not available
  static const List<ReportSection> defaults = [
    ReportSection(code: 'couple_dynamic', labelFr: 'Dynamique du couple', isActive: true, displayOrder: 1, periode: 'toutes', description: ''),
    ReportSection(code: 'couple_report', labelFr: 'Rapport du couple', isActive: true, displayOrder: 2, periode: 'toutes', description: ''),
    ReportSection(code: 'partner_portraits', labelFr: 'Portraits des partenaires', isActive: true, displayOrder: 3, periode: 'toutes', description: ''),
    ReportSection(code: 'daily_advice', labelFr: 'Conseil du jour', isActive: true, displayOrder: 4, periode: 'jour', description: ''),
    ReportSection(code: 'temporal_reports', labelFr: 'Prévisions Temporelles', isActive: true, displayOrder: 5, periode: 'toutes', description: ''),
  ];
}
