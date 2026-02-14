import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/social_proof_service.dart';

/// A social proof notification banner that shows activity from backend config.
/// Loads names, messages, and timing from Supabase via SocialProofService.
/// Falls back to generating messages internally if no backend data is available.
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
  
  String _currentMessage = '';
  bool _isVisible = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
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
      _initAndStart();
    }
  }

  Future<void> _initAndStart() async {
    // Load social proof config from backend
    await SocialProofService.instance.fetchEntries();
    if (mounted) {
      setState(() => _dataLoaded = true);
      _startCycle();
    }
  }

  @override
  void didUpdateWidget(SocialProofBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      if (_dataLoaded) {
        _startCycle();
      } else {
        _initAndStart();
      }
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
    final config = SocialProofService.instance.toastConfig;
    final pauseMin = config?.pauseMinMs ?? 6000;
    final pauseMax = config?.pauseMaxMs ?? 12000;
    final delay = 3000 + (pauseMin ~/ 2); // Initial delay
    
    Timer(Duration(milliseconds: delay), () {
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
    
    final message = SocialProofService.instance.generateToastMessage();
    if (message == null) return;
    
    setState(() {
      _currentMessage = message;
      _isVisible = true;
    });
    
    _slideController.forward();
    
    final config = SocialProofService.instance.toastConfig;
    final showDuration = config?.showDurationMs ?? 4000;
    final pauseMin = config?.pauseMinMs ?? 6000;
    final pauseMax = config?.pauseMaxMs ?? 12000;
    
    // Hide after configured duration
    Timer(Duration(milliseconds: showDuration), () {
      if (mounted && _isVisible) {
        _slideController.reverse().then((_) {
          if (mounted) {
            setState(() => _isVisible = false);
          }
        });
        
        // Schedule next notification with configured random pause
        final pause = pauseMin + (DateTime.now().millisecondsSinceEpoch % (pauseMax - pauseMin));
        _cycleTimer = Timer(Duration(milliseconds: pause), () {
          if (mounted && widget.enabled) {
            _showNotification();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();
    
    return Positioned(
      top: 80,
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
                    _currentMessage,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
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
