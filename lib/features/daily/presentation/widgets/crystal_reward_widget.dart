import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Animated crystal reward card shown on the result screen.
///
/// Displays the crystal count animating from 0 → [crystals] over 1 second,
/// with a legendary gold border glass card.
class CrystalRewardWidget extends StatefulWidget {
  const CrystalRewardWidget({super.key, required this.crystals});

  final int crystals;

  @override
  State<CrystalRewardWidget> createState() => _CrystalRewardWidgetState();
}

class _CrystalRewardWidgetState extends State<CrystalRewardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.rarityLegendary.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xl,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.mountainMid.withValues(alpha: 0.55),
                  AppColors.mountainNear.withValues(alpha: 0.65),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: AppColors.rarityLegendary.withValues(alpha: 0.7),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.diamond_rounded,
                      color: AppColors.rarityLegendary,
                      size: 36,
                      shadows: [
                        Shadow(
                          color: AppColors.rarityLegendary.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: widget.crystals),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Text(
                          '+$value',
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.rarityLegendary,
                            shadows: [
                              Shadow(
                                color: AppColors.rarityLegendary
                                    .withValues(alpha: 0.6),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '+${widget.crystals} CRYSTALS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.rarityLegendary.withValues(alpha: 0.85),
                    letterSpacing: 2.0,
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
