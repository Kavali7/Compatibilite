import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/cycles_vie_service.dart';
import '../widgets/common/custom_app_bar.dart';

/// Écran d'affichage du rapport Cycles de Vie.
/// Affiche les résultats de l'analyse selon le type de service.
class CyclesVieReportScreen extends StatefulWidget {
  final String serviceType;
  final String? purchaseId;
  final DateTime? birthdate;
  final DateTime? consultationDate;

  const CyclesVieReportScreen({
    super.key,
    required this.serviceType,
    this.purchaseId,
    this.birthdate,
    this.consultationDate,
  });

  @override
  State<CyclesVieReportScreen> createState() => _CyclesVieReportScreenState();
}

class _CyclesVieReportScreenState extends State<CyclesVieReportScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();

  bool _isLoading = true;
  ExpressReport? _report;
  SoulPeriod? _soulPeriod;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);

    try {
      final birthdate = widget.birthdate ?? DateTime(1990, 1, 1);
      final targetDate = widget.consultationDate ?? DateTime.now();

      // Générer le rapport
      _report = await _cyclesService.generateExpressReport(
        birthdate: birthdate,
        targetDate: targetDate,
      );

      _soulPeriod = _report?.soulPeriod;
    } catch (e) {
      _errorMessage = 'Erreur de chargement: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
            tooltip: 'Partager',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildError()
              : _buildReport(),
    );
  }

  String _getTitle() {
    switch (widget.serviceType) {
      case 'express':
        return '⚡ Lecture Express';
      case 'strategique':
        return '🎯 Lecture Stratégique';
      case 'consultation':
        return '📅 Consultation Date';
      case 'abonnement':
        return '👑 Premium';
      default:
        return '🌀 Cycles de Vie';
    }
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadReport,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReport() {
    return RefreshIndicator(
      onRefresh: _loadReport,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_soulPeriod != null) _buildSoulPeriodCard(),
            const SizedBox(height: 20),
            _buildDayScheduleCard(),
            const SizedBox(height: 20),
            _buildCurrentPeriodCard(),
            const SizedBox(height: 20),
            _buildCTASection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSoulPeriodCard() {
    if (_soulPeriod == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.indigo.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Période ${_soulPeriod!.periodNumber}${_soulPeriod!.polarity}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _soulPeriod!.periodName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '« ${_soulPeriod!.periodTitle} »',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _soulPeriod!.descriptionGeneral,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.95),
              height: 1.5,
            ),
          ),
          if (_soulPeriod!.traitsPositifs != null) ...[
            const SizedBox(height: 16),
            _buildTraitSection(
              '✨ Points forts',
              _soulPeriod!.traitsPositifs!,
              Colors.green.shade100,
            ),
          ],
          if (_soulPeriod!.traitsVigilance != null) ...[
            const SizedBox(height: 12),
            _buildTraitSection(
              '⚠️ Points de vigilance',
              _soulPeriod!.traitsVigilance!,
              Colors.orange.shade100,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTraitSection(String title, String content, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayScheduleCard() {
    if (_report == null || _report!.daySchedule.isEmpty) {
      return const SizedBox.shrink();
    }

    final dateLabel = DateFormat('EEEE d MMMM', 'fr_FR')
        .format(_report!.targetDate)
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 20),
              const SizedBox(width: 8),
              Text(
                'Périodes du $dateLabel',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_report!.daySchedule.map((item) => _buildPeriodRow(item))),
        ],
      ),
    );
  }

  Widget _buildPeriodRow(DailyPeriodWithTime item) {
    final isCurrentPeriod = item.isCurrentPeriod;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentPeriod
            ? item.period.color.withOpacity(0.15)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: isCurrentPeriod
            ? Border.all(color: item.period.color, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.period.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.period.periodLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.period.periodName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCurrentPeriod
                            ? item.period.color
                            : Colors.black87,
                      ),
                    ),
                    if (isCurrentPeriod) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.period.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'EN COURS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${item.startTime} - ${item.endTime} • ${item.period.keyword}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            _getEnergyIcon(item.period.energyLevel),
            color: _getEnergyColor(item.period.energyLevel),
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _getEnergyIcon(String? level) {
    switch (level) {
      case 'high':
        return Icons.whatshot;
      case 'medium':
        return Icons.flash_on;
      case 'low':
        return Icons.spa;
      default:
        return Icons.remove;
    }
  }

  Color _getEnergyColor(String? level) {
    switch (level) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCurrentPeriodCard() {
    if (_report?.currentPeriod == null) return const SizedBox.shrink();

    final current = _report!.currentPeriod!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [current.color.withOpacity(0.8), current.color],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Période actuelle',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  current.periodLetter,
                  style: TextStyle(
                    color: current.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            current.periodName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '🏷️ ${current.keyword}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            current.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
          if (current.activitesFavorables != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.lightGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      current.activitesFavorables!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (current.activitesEviter != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      current.activitesEviter!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Voulez-vous aller plus loin ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrez notre analyse de compatibilité de couple et notre prévision temporelle.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Découvrir nos autres services'),
          ),
        ],
      ),
    );
  }

  void _shareReport() {
    // TODO: Implémenter le partage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partage bientôt disponible')),
    );
  }
}
