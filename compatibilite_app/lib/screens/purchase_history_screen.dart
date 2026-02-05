import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../core/navigation_helper.dart';
import '../services/auth_service.dart';
import '../services/stored_report_service.dart';
import '../models/stored_report_model.dart';
import '../widgets/animated_background.dart';
import 'stored_report_viewer_screen.dart';

/// Screen to view purchase history - reads only from stored_reports
class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  bool _isLoading = true;
  List<StoredReport> _allReports = [];
  List<StoredReport> _filteredReports = [];
  String? _error;
  String _selectedFilter = 'all';

  // Filter categories
  static const Map<String, String> _filters = {
    'all': 'Tous',
    'couple': 'Couple',
    'cycles': 'Cycles',
    'previsions': 'Prévisions',
  };

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _error = 'Vous devez être connecté pour voir vos achats';
      });
      return;
    }

    try {
      final reports = await StoredReportService.instance.getUserReports(user.id);
      
      setState(() {
        _allReports = reports;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading reports: $e');
      setState(() {
        _isLoading = false;
        _error = 'Erreur lors du chargement: $e';
      });
    }
  }

  void _applyFilter() {
    switch (_selectedFilter) {
      case 'couple':
        _filteredReports = _allReports.where((r) => 
          r.serviceType == StoredReport.typeCompatibility
        ).toList();
        break;
      case 'cycles':
        _filteredReports = _allReports.where((r) => 
          r.serviceType == StoredReport.typeCyclePersonnel ||
          r.serviceType == StoredReport.typeCycleBusiness ||
          r.serviceType == StoredReport.typeCycleSante ||
          r.serviceType == StoredReport.typePortraitAme ||
          r.serviceType == StoredReport.typePhasesVie ||
          r.serviceType == StoredReport.typeGuideHoraire ||
          r.serviceType == StoredReport.typeTimingLunaire ||
          r.serviceType == StoredReport.typeEclairageDecision
        ).toList();
        break;
      case 'previsions':
        _filteredReports = _allReports.where((r) => 
          r.serviceType == StoredReport.typeTemporal
        ).toList();
        break;
      default:
        _filteredReports = List.from(_allReports);
    }
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  void _openReport(StoredReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoredReportViewerScreen(report: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => NavigationHelper.goToMenu(context),
          ),
          title: Text(
            'Mes Achats',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),
        body: Column(
          children: [
            // Filters
            _buildFilters(),
            // Content
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.entries.map((entry) {
            final isSelected = _selectedFilter == entry.key;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (_) => _setFilter(entry.key),
                backgroundColor: AppColors.block.withOpacity(0.6),
                selectedColor: AppColors.primary.withOpacity(0.3),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadReports();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredReports.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _selectedFilter == 'all' 
                    ? 'Aucun achat'
                    : 'Aucun achat dans cette catégorie',
                style: GoogleFonts.philosopher(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vos rapports apparaîtront ici après achat',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => NavigationHelper.goToMenu(context),
                icon: const Icon(Icons.explore),
                label: const Text('Découvrir les services'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredReports.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildReportCard(_filteredReports[index]),
      ),
    );
  }

  Widget _buildReportCard(StoredReport report) {
    final icon = StoredReport.getIconForType(report.serviceType);
    final color = _getColorForType(report.serviceType);
    final dateStr = '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}';

    return InkWell(
      onTap: () => _openReport(report),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.block.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.serviceLabel,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case StoredReport.typeCompatibility:
        return AppColors.primary;
      case StoredReport.typeTemporal:
        return AppColors.secondary;
      case StoredReport.typePortraitAme:
        return const Color(0xFF9C27B0);
      case StoredReport.typeCyclePersonnel:
      case StoredReport.typeCycleBusiness:
        return const Color(0xFF2196F3);
      case StoredReport.typeCycleSante:
        return const Color(0xFF4CAF50);
      case StoredReport.typeGuideHoraire:
        return const Color(0xFFFF9800);
      case StoredReport.typeEclairageDecision:
        return const Color(0xFFFFEB3B);
      case StoredReport.typePhasesVie:
        return const Color(0xFF673AB7);
      case StoredReport.typeTimingLunaire:
        return const Color(0xFF607D8B);
      default:
        return AppColors.primary;
    }
  }
}
