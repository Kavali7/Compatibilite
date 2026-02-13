import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/social_proof_service.dart';

/// A compact popularity badge displayed on service catalog cards.
/// Shows text like "🔥 Populaire" or a counter like "423 consultations".
/// When serviceId is provided, shows the badge specific to that service.
class PopularityBadge extends StatelessWidget {
  final String? serviceId;
  
  const PopularityBadge({super.key, this.serviceId});

  @override
  Widget build(BuildContext context) {
    SocialProofEntry? badge;
    
    if (serviceId != null) {
      // Get badge for this specific service
      badge = SocialProofService.instance.badgeForService(serviceId!);
    } else {
      // Get global badge (first without service_key)
      badge = SocialProofService.instance.globalBadge;
      if (badge == null) {
        final badges = SocialProofService.instance.badgeConfigs;
        if (badges.isNotEmpty) badge = badges.first;
      }
    }
    
    if (badge == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade700.withValues(alpha: 0.9),
            Colors.orange.shade600.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge.badgeText != null) ...[
            Text(
              badge.badgeText!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
          if (badge.badgeCounter != null && badge.badgeCounterLabel != null) ...[
            if (badge.badgeText != null) const SizedBox(width: 6),
            Text(
              '${_formatCounter(badge.badgeCounter!)} ${badge.badgeCounterLabel!}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCounter(int count) {
    if (count >= 1000) {
      final str = count.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return count.toString();
  }
}

/// A large counter banner for the top of the catalog screen.
/// Shows total analyses across all services.
class PopularityCounterBanner extends StatelessWidget {
  const PopularityCounterBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Try total from per-service badges first
    int totalCounter = SocialProofService.instance.totalBadgeCounter;
    String label = 'consultations réalisées';
    
    // If no per-service badges, fall back to global badge
    if (totalCounter == 0) {
      final global = SocialProofService.instance.globalBadge;
      if (global == null || global.badgeCounter == null) return const SizedBox.shrink();
      totalCounter = global.badgeCounter!;
      label = global.badgeCounterLabel ?? label;
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.10),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_formatBig(totalCounter)} ',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      color: AppColors.textLight.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.auto_awesome,
            color: AppColors.primary,
            size: 18,
          ),
        ],
      ),
    );
  }

  String _formatBig(int count) {
    if (count >= 1000) {
      final str = count.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return count.toString();
  }
}
