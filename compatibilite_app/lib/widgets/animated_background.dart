import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_star_field.dart';
import 'pulsating_orb.dart';

/// Composite animated background widget that combines:
/// - Background image (optional)
/// - Gradient overlay
/// - Animated star field
/// - Pulsating orbs
class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({
    super.key,
    this.backgroundImage,
    this.showStars = true,
    this.showOrbs = true,
    this.starCount = 35,
    this.overlayOpacity = 0.5,
    this.gradientColors,
    required this.child,
  });

  /// Optional background image asset path.
  final String? backgroundImage;

  /// Whether to show animated star particles.
  final bool showStars;

  /// Whether to show pulsating orbs.
  final bool showOrbs;

  /// Number of stars to display.
  final int starCount;

  /// Opacity of the gradient overlay.
  final double overlayOpacity;

  /// Custom gradient colors (defaults to app theme gradient).
  final List<Color>? gradientColors;

  /// The child widget to display on top.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Background image or gradient
        if (backgroundImage != null)
          Positioned.fill(
            child: Image.asset(
              backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors ??
                          [AppColors.background, const Color(0xFF0E1E2A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
          )
        else
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors ??
                      [AppColors.background, const Color(0xFF0E1E2A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

        // Layer 2: Gradient overlay for readability
        if (backgroundImage != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(overlayOpacity * 0.6),
                    Colors.black.withOpacity(overlayOpacity * 0.8),
                    Colors.black.withOpacity(overlayOpacity),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

        // Layer 3: Animated star field
        if (showStars)
          Positioned.fill(
            child: AnimatedStarField(
              starCount: starCount,
              starColor: AppColors.textLight,
              maxStarSize: 2.5,
              minStarSize: 0.8,
              speedFactor: 0.6,
            ),
          ),

        // Layer 4: Pulsating orbs
        if (showOrbs) ...[
          Positioned(
            top: -60,
            right: -30,
            child: FloatingOrb(
              color: AppColors.primary,
              size: 180,
              floatRange: 15,
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: FloatingOrb(
              color: AppColors.secondary,
              size: 200,
              floatRange: 12,
              floatDuration: const Duration(seconds: 7),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -80,
            child: PulsatingOrb(
              color: const Color(0xFF8B5CF6), // Purple accent
              size: 120,
              blurRadius: 40,
              duration: const Duration(seconds: 5),
            ),
          ),
        ],

        // Layer 5: Child content
        child,
      ],
    );
  }
}

/// A simpler animated background with just gradient and subtle animations.
/// Ideal for form-focused screens where we want less distraction.
class SubtleAnimatedBackground extends StatelessWidget {
  const SubtleAnimatedBackground({
    super.key,
    this.showStars = true,
    required this.child,
  });

  final bool showStars;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.background, Color(0xFF0E1E2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Subtle orbs (smaller and less prominent)
        Positioned(
          top: -80,
          right: -50,
          child: PulsatingOrb(
            color: AppColors.primary,
            size: 160,
            duration: const Duration(seconds: 6),
            blurRadius: 50,
          ),
        ),
        Positioned(
          bottom: -60,
          left: -50,
          child: PulsatingOrb(
            color: AppColors.secondary,
            size: 180,
            duration: const Duration(seconds: 7),
            blurRadius: 50,
          ),
        ),

        // Very subtle stars
        if (showStars)
          Positioned.fill(
            child: AnimatedStarField(
              starCount: 20,
              starColor: AppColors.textLight.withOpacity(0.5),
              maxStarSize: 1.5,
              minStarSize: 0.5,
              speedFactor: 0.3,
            ),
          ),

        // Child content
        child,
      ],
    );
  }
}
