import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/kkiapay_service.dart';
import '../services/pricing_service.dart';
import '../services/temporal_report_service.dart';
import '../widgets/animated_background.dart';

/// Screen for purchasing temporal predictions (year, month, day)
class TemporalPurchaseScreen extends StatefulWidget {
  const TemporalPurchaseScreen({super.key});

  @override
  State<TemporalPurchaseScreen> createState() => _TemporalPurchaseScreenState();
}

class _TemporalPurchaseScreenState extends State<TemporalPurchaseScreen> {
  String _selectedPeriod = 'jour'; // 'jour', 'mois', 'annee'
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate; // For ranges
  bool _isRange = false;
  bool _isProcessingPayment = false;
  bool _isLoadingPrices = true;

  // Pricing (in FCFA) - loaded from database, null if not configured
  int? _priceDayFcfa;
  int? _priceMonthFcfa;
  int? _priceYearFcfa;

  @override
  void initState() {
    super.initState();
    _loadPricesFromDatabase();
  }

  Future<void> _loadPricesFromDatabase() async {
    try {
      final pricingService = PricingService.instance;
      await pricingService.fetchPlans();
      
      // Look for temporal pricing plans
      for (final plan in pricingService.plans) {
        final planType = plan.planType.toLowerCase();
        if (planType.contains('jour') && planType.contains('temporel')) {
          _priceDayFcfa = plan.priceFcfa;
        } else if (planType.contains('mois') && planType.contains('temporel')) {
          _priceMonthFcfa = plan.priceFcfa;
        } else if ((planType.contains('annee') || planType.contains('année')) && planType.contains('temporel')) {
          _priceYearFcfa = plan.priceFcfa;
        }
      }
      
      debugPrint('TemporalPurchaseScreen: Loaded prices - Day: $_priceDayFcfa, Month: $_priceMonthFcfa, Year: $_priceYearFcfa');
    } catch (e) {
      debugPrint('TemporalPurchaseScreen: Error loading prices: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPrices = false);
      }
    }
  }

  int? get _basePrice {
    switch (_selectedPeriod) {
      case 'annee':
        return _priceYearFcfa;
      case 'mois':
        return _priceMonthFcfa;
      case 'jour':
      default:
        return _priceDayFcfa;
    }
  }

  bool get _isPriceConfigured => _basePrice != null;

  int get _totalPrice {
    final base = _basePrice;
    if (base == null) return 0;
    if (!_isRange || _endDate == null) return base;
    
    // Calculate range price
    final days = _endDate!.difference(_selectedDate).inDays + 1;
    switch (_selectedPeriod) {
      case 'mois':
        // Count months in range
        final months = ((_endDate!.year - _selectedDate.year) * 12 + 
            _endDate!.month - _selectedDate.month) + 1;
        return (_priceMonthFcfa ?? 0) * months;
      case 'jour':
        return (_priceDayFcfa ?? 0) * days;
      default:
        return base;
    }
  }

  List<String> get _includedBonuses {
    final bonuses = <String>[];
    switch (_selectedPeriod) {
      case 'annee':
        bonuses.add('Prévision du mois en cours');
        bonuses.add('Prévision d\'aujourd\'hui');
        break;
      case 'mois':
        bonuses.add('Prévision d\'aujourd\'hui');
        break;
      case 'jour':
        if (_isRange && _endDate != null) {
          final days = _endDate!.difference(_selectedDate).inDays + 1;
          final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
          if (days > daysInMonth / 2) {
            bonuses.add('Prévision du mois concerné (bonus > 50% des jours)');
          }
        }
        break;
    }
    return bonuses;
  }

  String get _periodLabel {
    switch (_selectedPeriod) {
      case 'annee':
        return 'Année ${_selectedDate.year}';
      case 'mois':
        final months = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin',
            'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
        if (_isRange && _endDate != null) {
          return '${months[_selectedDate.month - 1]} - ${months[_endDate!.month - 1]} ${_selectedDate.year}';
        }
        return '${months[_selectedDate.month - 1]} ${_selectedDate.year}';
      case 'jour':
      default:
        if (_isRange && _endDate != null) {
          return '${_selectedDate.day}/${_selectedDate.month} - ${_endDate!.day}/${_endDate!.month}/${_selectedDate.year}';
        }
        return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    }
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Prévisions Temporelles',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Choisissez votre prévision',
                style: GoogleFonts.philosopher(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Anticipez les énergies de votre couple pour mieux naviguer ensemble.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              
              const SizedBox(height: 24),
              
              // Period selector
              _buildPeriodSelector(),
              
              const SizedBox(height: 20),
              
              // Date picker
              _buildDatePicker(),
              
              const SizedBox(height: 20),
              
              // Range toggle (for month/day)
              if (_selectedPeriod != 'annee') _buildRangeToggle(),
              
              const SizedBox(height: 24),
              
              // Summary card
              _buildSummaryCard(),
              
              const SizedBox(height: 24),
              
              // Purchase button
              _buildPurchaseButton(),
              
              const SizedBox(height: 16),
              
              // Payment info
              const Center(
                child: Text(
                  'Paiement sécurisé par Kkiapay',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _buildPeriodTab('Jour', 'jour', Icons.today),
          _buildPeriodTab('Mois', 'mois', Icons.date_range),
          _buildPeriodTab('Année', 'annee', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, String value, IconData icon) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedPeriod = value;
          _isRange = false;
          _endDate = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isRange ? 'Date de début' : 'Date',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDate(isStart: true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _periodLabel,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          if (_isRange) ...[
            const SizedBox(height: 12),
            Text(
              'Date de fin',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(isStart: false),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _endDate != null 
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : 'Sélectionner...',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeToggle() {
    return GestureDetector(
      onTap: () => setState(() {
        _isRange = !_isRange;
        if (!_isRange) _endDate = null;
      }),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _isRange 
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.block.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isRange ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _isRange ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isRange ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPeriod == 'mois' 
                        ? 'Sélectionner plusieurs mois' 
                        : 'Sélectionner plusieurs jours',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _isRange ? AppColors.primary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Activez pour choisir une plage',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final bonuses = _includedBonuses;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Récapitulatif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Selected period
          _buildSummaryRow(
            icon: Icons.event,
            label: 'Période sélectionnée',
            value: _periodLabel,
          ),
          
          const SizedBox(height: 12),
          
          // Bonuses
          if (bonuses.isNotEmpty) ...[
            const Divider(color: AppColors.textMuted),
            const SizedBox(height: 8),
            const Text(
              '🎁 Bonus inclus',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...bonuses.map((bonus) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bonus, style: const TextStyle(fontSize: 13))),
                ],
              ),
            )),
            const SizedBox(height: 8),
            const Divider(color: AppColors.textMuted),
          ],
          
          const SizedBox(height: 12),
          
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_totalPrice FCFA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    if (_isProcessingPayment) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              'Traitement en cours...',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: _initiatePurchase,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Acheter pour $_totalPrice FCFA',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    DateTime firstDate;
    DateTime initialDate;
    
    if (_selectedPeriod == 'annee') {
      firstDate = DateTime(now.year);
      initialDate = DateTime(_selectedDate.year);
    } else {
      firstDate = now;
      initialDate = isStart ? _selectedDate : (_endDate ?? _selectedDate);
    }
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.block,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _initiatePurchase() {
    setState(() => _isProcessingPayment = true);
    
    KkiapayService.instance.startPayment(
      context: context,
      amount: _totalPrice,
      reason: 'Prévision $_selectedPeriod - $_periodLabel',
      callback: (success, transactionId, error) async {
        if (!success || transactionId == null) {
          setState(() => _isProcessingPayment = false);
          _showSnack(error ?? 'Paiement échoué. Veuillez réessayer.');
          return;
        }

        // Generate the report
        try {
          final service = TemporalReportService.instance;
          final report = await service.generateReport(
            periode: _selectedPeriod,
            date: _selectedDate,
          );
          
          setState(() => _isProcessingPayment = false);
          
          if (report != null) {
            _showSnack('Paiement réussi ! Votre prévision est prête.');
            if (mounted) Navigator.pop(context, report);
          } else {
            _showSnack('Erreur lors de la génération du rapport.');
          }
        } catch (e) {
          setState(() => _isProcessingPayment = false);
          _showSnack('Erreur: ${e.toString()}');
        }
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
