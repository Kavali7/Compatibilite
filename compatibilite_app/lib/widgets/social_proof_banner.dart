import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A social proof notification banner that shows simulated purchase activity.
/// Displays messages like "Fatou K. vient de découvrir sa compatibilité, il y a 3 min"
/// with slide-in/out animations on a periodic timer.
class SocialProofBanner extends StatefulWidget {
  /// Whether the banner is enabled (visible) or not
  final bool enabled;
  
  const SocialProofBanner({
    super.key,
    this.enabled = true,
  });

  @override
  State<SocialProofBanner> createState() => _SocialProofBannerState();
}

class _SocialProofBannerState extends State<SocialProofBanner>
    with SingleTickerProviderStateMixin {
  Timer? _cycleTimer;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  int _currentIndex = 0;
  bool _isVisible = false;
  final _random = Random();
  
  // Pool of realistic African first names
  static const _firstNames = [
    'Fatou', 'Adama', 'Aïssa', 'Ibrahim', 'Mariam',
    'Moussa', 'Aminata', 'Ousmane', 'Nafissatou', 'Abdoulaye',
    'Ramatou', 'Issouf', 'Djamila', 'Koffi', 'Binta',
    'Youssouf', 'Salimata', 'Dramane', 'Fanta', 'Habib',
    'Rokia', 'Souleymane', 'Kadiatou', 'Seydou', 'Aicha',
    'Mamadou', 'Fatoumata', 'Boukary', 'Nana', 'Issa',
  ];
  
  // Last name initials
  static const _lastInitials = [
    'K', 'D', 'M', 'T', 'B', 'S', 'O', 'C', 'A', 'N',
    'H', 'G', 'L', 'Y', 'F', 'Z', 'R', 'W', 'P', 'E',
  ];
  
  // Message templates — {name} will be replaced
  static const _messageTemplates = [
    '🎉 {name} vient de découvrir sa compatibilité',
    '✨ {name} vient d\'acheter son rapport',
    '❤️ {name} et son partenaire connaissent maintenant leur avenir',
    '💫 {name} a reçu son analyse de couple',
    '🔮 {name} vient de consulter ses prévisions',
    '💕 {name} a débloqué son rapport de compatibilité',
  ];
  
  // Time ago labels
  static const _timeAgo = [
    'il y a 2 min',
    'il y a 3 min',
    'il y a 5 min',
    'il y a 7 min',
    'il y a 12 min',
    'il y a 15 min',
    'il y a 20 min',
    'il y a 25 min',
  ];

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    if (widget.enabled) {
      _startCycle();
    }
  }

  @override
  void didUpdateWidget(SocialProofBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _startCycle();
    } else if (!widget.enabled && oldWidget.enabled) {
      _stopCycle();
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  void _startCycle() {
    // Show first notification after a short delay
    Timer(Duration(seconds: 3 + _random.nextInt(3)), () {
      if (mounted && widget.enabled) {
        _showNotification();
      }
    });
  }

  void _stopCycle() {
    _cycleTimer?.cancel();
    if (_isVisible) {
      _slideController.reverse();
      _isVisible = false;
    }
  }

  void _showNotification() {
    if (!mounted || !widget.enabled) return;
    
    setState(() {
      _currentIndex = _random.nextInt(_messageTemplates.length);
      _isVisible = true;
    });
    
    _slideController.forward();
    
    // Hide after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted && _isVisible) {
        _slideController.reverse().then((_) {
          if (mounted) {
            setState(() => _isVisible = false);
          }
        });
        
        // Schedule next notification
        _cycleTimer = Timer(Duration(seconds: 6 + _random.nextInt(6)), () {
          if (mounted && widget.enabled) {
            _showNotification();
          }
        });
      }
    });
  }

  String _generateMessage() {
    final name = '${_firstNames[_random.nextInt(_firstNames.length)]} '
        '${_lastInitials[_random.nextInt(_lastInitials.length)]}.';
    final template = _messageTemplates[_currentIndex];
    final time = _timeAgo[_random.nextInt(_timeAgo.length)];
    return '${template.replaceAll('{name}', name)}, $time';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.block.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _generateMessage(),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
