/// Payment Method Card Widget
library;

import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../models/purchase_model.dart';

/// Card widget for payment method selection
class PaymentMethodCard extends StatelessWidget {
  final PaymentProvider provider;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDisabled;
  
  const PaymentMethodCard({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.block.withValues(alpha: 0.3)
              : isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.block.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? AppColors.textMuted.withValues(alpha: 0.3)
                : isSelected
                    ? AppColors.primary
                    : AppColors.block,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Logo placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDisabled
                    ? AppColors.textMuted.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getProviderIcon(),
                  color: isDisabled
                      ? AppColors.textMuted
                      : isSelected
                          ? AppColors.primary
                          : AppColors.textLight,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              provider.displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? AppColors.textMuted.withValues(alpha: 0.5)
                    : AppColors.textLight,
              ),
            ),
            
            if (isDisabled) ...[
              const SizedBox(height: 4),
              const Text(
                'Bientôt',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
            
            const SizedBox(height: 8),
            
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isDisabled
                  ? AppColors.textMuted.withValues(alpha: 0.3)
                  : isSelected
                      ? AppColors.primary
                      : AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getProviderIcon() {
    switch (provider) {
      case PaymentProvider.kkiapay:
        return Icons.account_balance_wallet;
      case PaymentProvider.fedapay:
        return Icons.credit_card;
    }
  }
}
