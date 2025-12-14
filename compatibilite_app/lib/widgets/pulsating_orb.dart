import 'package:flutter/material.dart';

/// An animated glowing orb that pulses gently.
/// Creates a mystical ambient effect for the background.
class PulsatingOrb extends StatefulWidget {
  const PulsatingOrb({
    super.key,
    required this.color,
    this.size = 180,
    this.minScale = 0.85,
    this.maxScale = 1.15,
    this.duration = const Duration(seconds: 4),
    this.blurRadius = 60,
  });

  /// Primary color of the orb.
  final Color color;

  /// Base size of the orb.
  final double size;

  /// Minimum scale during pulsation.
  final double minScale;

  /// Maximum scale during pulsation.
  final double maxScale;

  /// Duration of one full pulse cycle.
  final Duration duration;

  /// Blur radius for the glow effect.
  final double blurRadius;

  @override
  State<PulsatingOrb> createState() => _PulsatingOrbState();
}

class _PulsatingOrbState extends State<PulsatingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.15,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withValues(alpha: _opacityAnimation.value),
                  widget.color.withValues(alpha: _opacityAnimation.value * 0.5),
                  widget.color.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _opacityAnimation.value * 0.6),
                  blurRadius: widget.blurRadius,
                  spreadRadius: widget.blurRadius * 0.3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A floating orb that moves slightly while pulsating.
/// More dynamic version of PulsatingOrb.
class FloatingOrb extends StatefulWidget {
  const FloatingOrb({
    super.key,
    required this.color,
    this.size = 200,
    this.floatRange = 20,
    this.floatDuration = const Duration(seconds: 6),
    this.pulseDuration = const Duration(seconds: 4),
  });

  final Color color;
  final double size;
  final double floatRange;
  final Duration floatDuration;
  final Duration pulseDuration;

  @override
  State<FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<FloatingOrb>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      vsync: this,
      duration: widget.floatDuration,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    )..repeat(reverse: true);

    _floatAnimation = Tween<Offset>(
      begin: Offset(-widget.floatRange, -widget.floatRange * 0.5),
      end: Offset(widget.floatRange, widget.floatRange * 0.5),
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_floatController, _pulseController]),
      builder: (context, child) {
        return Transform.translate(
          offset: _floatAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.2),
                    widget.color.withValues(alpha: 0.1),
                    widget.color.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.15),
                    blurRadius: 80,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
