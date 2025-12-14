import 'dart:math';
import 'package:flutter/material.dart';

/// A star particle with its properties for animation.
class _Star {
  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.twinkleSpeed,
  });

  double x;
  double y;
  final double size;
  double opacity;
  final double speed;
  final double twinkleSpeed;
  double twinklePhase = 0;
}

/// Animated background with floating stars/particles.
/// Creates a dreamy cosmic effect perfect for astrology/numerology apps.
class AnimatedStarField extends StatefulWidget {
  const AnimatedStarField({
    super.key,
    this.starCount = 40,
    this.starColor = const Color(0xFFF2E6C4),
    this.maxStarSize = 3.0,
    this.minStarSize = 1.0,
    this.speedFactor = 1.0,
  });

  /// Number of stars to display.
  final int starCount;

  /// Base color for the stars.
  final Color starColor;

  /// Maximum size of a star.
  final double maxStarSize;

  /// Minimum size of a star.
  final double minStarSize;

  /// Speed multiplier for star movement.
  final double speedFactor;

  @override
  State<AnimatedStarField> createState() => _AnimatedStarFieldState();
}

class _AnimatedStarFieldState extends State<AnimatedStarField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final Random _random = Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initStars(Size size) {
    if (_size == size && _stars.isNotEmpty) return;
    _size = size;
    _stars.clear();

    for (int i = 0; i < widget.starCount; i++) {
      _stars.add(_createStar(size, randomY: true));
    }
  }

  _Star _createStar(Size size, {bool randomY = false}) {
    return _Star(
      x: _random.nextDouble() * size.width,
      y: randomY
          ? _random.nextDouble() * size.height
          : -widget.maxStarSize,
      size: widget.minStarSize +
          _random.nextDouble() * (widget.maxStarSize - widget.minStarSize),
      opacity: 0.3 + _random.nextDouble() * 0.7,
      speed: (0.2 + _random.nextDouble() * 0.5) * widget.speedFactor,
      twinkleSpeed: 0.5 + _random.nextDouble() * 2,
    );
  }

  void _updateStars(double dt) {
    for (final star in _stars) {
      // Gentle downward drift
      star.y += star.speed * dt * 30;
      
      // Slight horizontal sway
      star.x += sin(star.twinklePhase) * 0.3;
      
      // Twinkle effect
      star.twinklePhase += star.twinkleSpeed * dt;
      star.opacity = 0.3 + (sin(star.twinklePhase) + 1) * 0.35;

      // Reset star if it goes off screen
      if (star.y > _size.height + widget.maxStarSize) {
        star.y = -widget.maxStarSize;
        star.x = _random.nextDouble() * _size.width;
      }
      
      // Wrap horizontal position
      if (star.x < -widget.maxStarSize) {
        star.x = _size.width + widget.maxStarSize;
      } else if (star.x > _size.width + widget.maxStarSize) {
        star.x = -widget.maxStarSize;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initStars(size);

        return ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            _updateStars(1 / 60); // Approximate 60fps
            return CustomPaint(
              size: size,
              painter: _StarFieldPainter(
                stars: _stars,
                starColor: widget.starColor,
              ),
            );
          },
        );
      },
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter({
    required this.stars,
    required this.starColor,
  });

  final List<_Star> stars;
  final Color starColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final paint = Paint()
        ..color = starColor.withValues(alpha: star.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);

      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        paint,
      );

      // Inner brighter core
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: star.opacity * 0.8);
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size * 0.4,
        corePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) => true;
}
