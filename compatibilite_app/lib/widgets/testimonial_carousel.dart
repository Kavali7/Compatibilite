import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/social_proof_service.dart';

/// A premium testimonial carousel for the welcome screen.
/// Displays rotating user testimonials loaded from the backend.
/// Features glassmorphism cards, star ratings, and auto-scroll.
class TestimonialCarousel extends StatefulWidget {
  const TestimonialCarousel({super.key});

  @override
  State<TestimonialCarousel> createState() => _TestimonialCarouselState();
}

class _TestimonialCarouselState extends State<TestimonialCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _startAutoScroll();
    _loadData();
  }

  Future<void> _loadData() async {
    await SocialProofService.instance.fetchEntries();
    if (mounted && !_loaded) {
      setState(() => _loaded = true);
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final testimonials = SocialProofService.instance.testimonialConfigs;
      if (testimonials.isEmpty) return;
      
      final nextPage = (_currentPage + 1) % testimonials.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = SocialProofService.instance.testimonialConfigs;
    if (testimonials.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(Icons.format_quote_rounded, 
                color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Ce qu\'ils en disent',
                style: TextStyle(
                  color: AppColors.textLight.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: testimonials.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildTestimonialCard(testimonials[index]);
            },
          ),
        ),
        
        // Dot indicators
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            testimonials.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.textLight.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(SocialProofEntry entry) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Glassmorphism effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < (entry.testimonialRating ?? 5)
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 10),
          
          // Quote
          Expanded(
            child: Text(
              '"${entry.testimonialText ?? ""}"',
              style: TextStyle(
                color: AppColors.textLight.withValues(alpha: 0.85),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Author
          Row(
            children: [
              // Avatar circle with initial
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  (entry.testimonialName ?? 'A')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                entry.testimonialName ?? 'Anonyme',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.verified_rounded,
                color: AppColors.primary.withValues(alpha: 0.6),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Vérifié',
                style: TextStyle(
                  color: AppColors.textLight.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
