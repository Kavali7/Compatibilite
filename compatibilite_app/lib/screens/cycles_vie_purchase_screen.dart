import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/cycles_vie_service.dart';
import '../services/pricing_service.dart';
import '../services/payment_service.dart';
import '../widgets/common/custom_app_bar.dart';
import 'cycles_vie_report_screen.dart';

/// Écran d'achat pour un service Cycles de Vie.
/// Collecte les informations nécessaires et gère le paiement.
class CyclesViePurchaseScreen extends StatefulWidget {
  final String planType;
  final PricingPlan plan;

  const CyclesViePurchaseScreen({
    super.key,
    required this.planType,
    required this.plan,
  });

  @override
  State<CyclesViePurchaseScreen> createState() => _CyclesViePurchaseScreenState();
}

class _CyclesViePurchaseScreenState extends State<CyclesViePurchaseScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  final _formKey = GlobalKey<FormState>();

  // Champs du formulaire
  final _firstnameController = TextEditingController();
  DateTime? _birthdate;
  DateTime? _consultationDate;
  String? _selectedDecisionTypeId;

  bool _isLoading = false;
  bool _isLoadingDecisionTypes = true;
  List<DecisionType> _decisionTypes = [];

  @override
  void initState() {
    super.initState();
    _loadDecisionTypes();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    super.dispose();
  }

  Future<void> _loadDecisionTypes() async {
    try {
      _decisionTypes = await _cyclesService.getDecisionTypes();
    } catch (e) {
      debugPrint('Erreur chargement types décisions: $e');
    } finally {
      setState(() => _isLoadingDecisionTypes = false);
    }
  }

  String get _serviceType {
    // Extrait le type de service du planType (ex: cycle_vie_express -> express)
    return widget.planType.replaceFirst('cycle_vie_', '');
  }

  bool get _needsConsultationDate {
    return _serviceType == 'consultation';
  }

  bool get _needsDecisionType {
    return _serviceType == 'consultation' || _serviceType == 'strategique';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.plan.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPlanSummary(),
              const SizedBox(height: 24),
              _buildFormFields(),
              const SizedBox(height: 32),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.plan.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.plan.priceFcfa} FCFA',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.plan.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vos informations',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Prénom (optionnel)
        TextFormField(
          controller: _firstnameController,
          decoration: const InputDecoration(
            labelText: 'Prénom (optionnel)',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Date de naissance (obligatoire)
        _buildDateField(
          label: 'Date de naissance *',
          icon: Icons.cake_outlined,
          value: _birthdate,
          onTap: () => _selectDate(
            context,
            initial: _birthdate,
            first: DateTime(1900),
            last: DateTime.now().subtract(const Duration(days: 365 * 10)),
            onSelect: (date) => setState(() => _birthdate = date),
          ),
          validator: (_) => _birthdate == null ? 'Requis' : null,
        ),
        const SizedBox(height: 16),

        // Date de consultation (pour service consultation)
        if (_needsConsultationDate) ...[
          _buildDateField(
            label: 'Date à consulter *',
            icon: Icons.event,
            value: _consultationDate,
            onTap: () => _selectDate(
              context,
              initial: _consultationDate,
              first: DateTime.now().subtract(const Duration(days: 365)),
              last: DateTime.now().add(const Duration(days: 365 * 2)),
              onSelect: (date) => setState(() => _consultationDate = date),
            ),
            validator: (_) =>
                _needsConsultationDate && _consultationDate == null
                    ? 'Requis'
                    : null,
          ),
          const SizedBox(height: 16),
        ],

        // Type de décision (pour consultation et stratégique)
        if (_needsDecisionType) ...[
          _isLoadingDecisionTypes
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Type de décision',
                    prefixIcon: Icon(Icons.help_outline),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDecisionTypeId,
                  items: _decisionTypes.map((type) {
                    return DropdownMenuItem(
                      value: type.id,
                      child: Row(
                        children: [
                          Icon(type.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(type.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedDecisionTypeId = value),
                  hint: const Text('Sélectionnez...'),
                ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? value,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      controller: TextEditingController(
        text: value != null
            ? DateFormat('d MMMM yyyy', 'fr_FR').format(value)
            : '',
      ),
      validator: validator,
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    DateTime? initial,
    required DateTime first,
    required DateTime last,
    required Function(DateTime) onSelect,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: first,
      lastDate: last,
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      onSelect(picked);
    }
  }

  Widget _buildPayButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePurchase,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              'Payer ${widget.plan.priceFcfa} FCFA',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre date de naissance')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Lancer le paiement via le service de paiement
      final paymentResult = await PaymentService().initiatePayment(
        planType: widget.planType,
        amount: widget.plan.priceFcfa,
        description: widget.plan.name,
        context: context,
      );

      if (paymentResult.success) {
        // Créer l'achat en base
        final purchaseId = await _cyclesService.createPurchase(
          serviceType: _serviceType,
          birthdate: DateFormat('yyyy-MM-dd').format(_birthdate!),
          firstname: _firstnameController.text.isNotEmpty
              ? _firstnameController.text
              : null,
          consultationDate: _consultationDate != null
              ? DateFormat('yyyy-MM-dd').format(_consultationDate!)
              : null,
          decisionTypeId: _selectedDecisionTypeId,
          paymentId: paymentResult.transactionId,
        );

        if (purchaseId != null && mounted) {
          // Naviguer vers le rapport
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CyclesVieReportScreen(
                serviceType: _serviceType,
                purchaseId: purchaseId,
                birthdate: _birthdate,
                consultationDate: _consultationDate,
              ),
            ),
          );
        }
      } else {
        _showError('Paiement annulé ou échoué');
      }
    } catch (e) {
      _showError('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
