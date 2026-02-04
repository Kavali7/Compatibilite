/// Portrait de l'Âme - Report Screen
/// Écran d'affichage du rapport Portrait de l'Âme
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/navigation_helper.dart';
import '../services/cycles_vie_service.dart';
import '../widgets/animated_background.dart';

/// Écran d'affichage du rapport Portrait de l'Âme
class PortraitAmeReportScreen extends StatefulWidget {
  final String firstName;
  final DateTime birthdate;

  const PortraitAmeReportScreen({
    super.key,
    required this.firstName,
    required this.birthdate,
  });

  @override
  State<PortraitAmeReportScreen> createState() => _PortraitAmeReportScreenState();
}

class _PortraitAmeReportScreenState extends State<PortraitAmeReportScreen> {
  final CyclesVieService _cyclesService = CyclesVieService();
  
  bool _isLoading = true;
  String? _error;
  SoulPeriod? _soulPeriod;

  @override
  void initState() {
    super.initState();
    _loadPortrait();
  }

  Future<void> _loadPortrait() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Charger la période Soul basée sur la date de naissance
      final soulPeriod = await _cyclesService.getSoulPeriodForBirthdate(widget.birthdate);
      
      if (mounted) {
        setState(() {
          _soulPeriod = soulPeriod;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement portrait: $e');
      if (mounted) {
        setState(() {
          _error = 'Impossible de charger votre portrait. Veuillez réessayer.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => NavigationHelper.goToMenu(context),
        ),
        title: Text(
          'Portrait de l\'Âme',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textLight),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 40,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 20),
            Text(
              'Révélation de votre Portrait...',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: AppColors.textLight, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadPortrait,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_soulPeriod == null) {
      return const Center(
        child: Text(
          'Aucune donnée disponible',
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      );
    }

    return _buildReport();
  }

  Widget _buildReport() {
    final sp = _soulPeriod!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête utilisateur
          _buildUserHeader(),
          const SizedBox(height: 24),

          // Carte principale du portrait - Identité Cosmique
          _buildMainPortraitCard(sp),
          const SizedBox(height: 20),

          // ═══════════════════════════════════════════════════════════
          // 11 SECTIONS DE CONTENU INTÉGRAL
          // ═══════════════════════════════════════════════════════════

          // 1. Introduction personnalisée
          if (sp.introduction.isNotEmpty)
            _buildReportCard(
              icon: Icons.auto_awesome,
              iconColor: Colors.purple,
              title: 'Votre Portrait',
              children: [
                _buildFormattedContent(_replacePlaceholders(sp.introduction), Colors.purple),
              ],
            ),
          if (sp.introduction.isNotEmpty)
            const SizedBox(height: 20),

          // 2. Héritage Cosmique
          if (sp.heritageCosmique.isNotEmpty)
            _buildReportCard(
              icon: Icons.history_edu,
              iconColor: Colors.indigo,
              title: 'Votre Héritage Cosmique',
              children: [
                _buildFormattedContent(sp.heritageCosmique, Colors.indigo),
              ],
            ),
          if (sp.heritageCosmique.isNotEmpty)
            const SizedBox(height: 20),

          // 3. Cœur de l'Être
          if (sp.coeurEtre.isNotEmpty)
            _buildReportCard(
              icon: Icons.favorite,
              iconColor: Colors.pink,
              title: 'Le Cœur de Votre Être',
              children: [
                _buildFormattedContent(sp.coeurEtre, Colors.pink),
              ],
            ),
          if (sp.coeurEtre.isNotEmpty)
            const SizedBox(height: 20),

          // 4. Forces Naturelles
          if (sp.forcesNaturelles.isNotEmpty)
            _buildReportCard(
              icon: Icons.star,
              iconColor: Colors.amber,
              title: 'Vos Forces Naturelles',
              children: [
                _buildFormattedContent(sp.forcesNaturelles, Colors.amber),
              ],
            ),
          if (sp.forcesNaturelles.isNotEmpty)
            const SizedBox(height: 20),

          // 5. Défis à Transcender
          if (sp.defisTranscender.isNotEmpty)
            _buildReportCard(
              icon: Icons.psychology,
              iconColor: Colors.orange,
              title: 'Vos Défis à Transcender',
              children: [
                _buildFormattedContent(sp.defisTranscender, Colors.orange),
              ],
            ),
          if (sp.defisTranscender.isNotEmpty)
            const SizedBox(height: 20),

          // 6. Vocations Idéales
          if (sp.vocationsIdeales.isNotEmpty)
            _buildReportCard(
              icon: Icons.work,
              iconColor: Colors.teal,
              title: 'Vos Vocations Idéales',
              children: [
                _buildFormattedContent(sp.vocationsIdeales, Colors.teal),
              ],
            ),
          if (sp.vocationsIdeales.isNotEmpty)
            const SizedBox(height: 20),

          // 7. Affinités Géographiques
          if (sp.affinitesGeographiques.isNotEmpty)
            _buildReportCard(
              icon: Icons.public,
              iconColor: Colors.blue,
              title: 'Vos Affinités Géographiques',
              children: [
                _buildFormattedContent(sp.affinitesGeographiques, Colors.blue),
              ],
            ),
          if (sp.affinitesGeographiques.isNotEmpty)
            const SizedBox(height: 20),

          // 8. Points de Vigilance Santé
          if (sp.vigilanceSante.isNotEmpty)
            _buildReportCard(
              icon: Icons.health_and_safety,
              iconColor: Colors.red,
              title: 'Points de Vigilance Santé',
              children: [
                _buildFormattedContent(sp.vigilanceSante, Colors.red),
              ],
            ),
          if (sp.vigilanceSante.isNotEmpty)
            const SizedBox(height: 20),

          // 9. Conseils pour l'Épanouissement
          if (sp.conseilsEpanouissement.isNotEmpty)
            _buildReportCard(
              icon: Icons.lightbulb,
              iconColor: Colors.green,
              title: 'Conseils pour Votre Épanouissement',
              children: [
                _buildFormattedContent(sp.conseilsEpanouissement, Colors.green),
              ],
            ),
          if (sp.conseilsEpanouissement.isNotEmpty)
            const SizedBox(height: 20),

          // 10. Message Cosmique - Style spécial
          if (sp.messageCosmique.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.purple, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Votre Message Cosmique',
                    style: GoogleFonts.philosopher(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    sp.messageCosmique,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textLight,
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (sp.messageCosmique.isNotEmpty)
            const SizedBox(height: 20),

          // Carte de cross-promotion
          _buildCrossPromotionCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    final dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
    final sp = _soulPeriod!;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          // Avatar mystique
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.purple, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          
          // Nom
          Text(
            widget.firstName,
            style: GoogleFonts.philosopher(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          
          // Date de naissance
          Text(
            'Né(e) le ${dateFormat.format(widget.birthdate)}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPortraitCard(SoulPeriod sp) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identité Cosmique - Titre principal (seul élément visible)
          Text(
            sp.identiteCosmique,
            style: GoogleFonts.philosopher(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Sous-titre personnalisé avec le prénom
          Text(
            'Portrait Cosmique de ${widget.firstName}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Formate la date de naissance en français pour l'affichage
  String _formatBirthdateFrench(DateTime date) {
    final months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  /// Remplace les placeholders dans le contenu par les vraies valeurs
  String _replacePlaceholders(String content) {
    return content.replaceAll(
      '[date de naissance]', 
      _formatBirthdateFrench(widget.birthdate)
    );
  }

  /// Affiche le contenu formaté avec les titres en gras
  Widget _buildFormattedContent(String content, Color accentColor) {
    // Parse le contenu pour extraire les sections
    final lines = content.split('\n');
    final widgets = <Widget>[];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      // Détecte les titres (commence par • ou - ou **)
      if (line.startsWith('**') && line.endsWith('**')) {
        // Titre entre ** **
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: i > 0 ? 16 : 0, bottom: 8),
            child: Text(
              line.replaceAll('**', ''),
              style: GoogleFonts.philosopher(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        );
      } else if (line.startsWith('• ') || line.startsWith('- ')) {
        // Point de liste
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.contains(':') && line.indexOf(':') < 30) {
        // Ligne avec label (ex: "Qualité principale: ...")
        final parts = line.split(':');
        if (parts.length >= 2) {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(top: i > 0 ? 12 : 0, bottom: 4),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${parts[0]}: ',
                      style: GoogleFonts.philosopher(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    TextSpan(
                      text: parts.sublist(1).join(':'),
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        // Texte normal
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              line,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        );
      }
    }
    
    // Si le contenu ne contient pas de formatage spécial, afficher tel quel
    if (widgets.isEmpty) {
      return Text(
        content,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 15,
          height: 1.7,
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITRE EN GRAS
                    Text(
                      title,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.textMuted, height: 32),
          // CONTENU INTÉGRAL
          ...children,
        ],
      ),
    );
  }

  Widget _buildCrossPromotionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.explore, color: AppColors.secondary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Explorez Aussi',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Consultez notre Guide Horaire pour optimiser chaque journée selon votre cycle personnel !',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => NavigationHelper.goToMenu(context),
              icon: const Icon(Icons.home, size: 18),
              label: const Text('Voir autres services'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de partage bientôt disponible'),
        backgroundColor: AppColors.block,
      ),
    );
  }
}
