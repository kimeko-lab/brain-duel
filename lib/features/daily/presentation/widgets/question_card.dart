import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/question_model.dart';

/// Solid dark card that displays the current question and rarity label.
/// No BackdropFilter — compatible with any background.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
  });

  final QuestionModel question;

  Color get _rarityColor {
    switch (question.rarity) {
      case QuestionRarity.common:
        return AppColors.rarityCommon;
      case QuestionRarity.rare:
        return AppColors.rarityRare;
      case QuestionRarity.unique:
        return AppColors.rarityUnique;
      case QuestionRarity.legendary:
        return AppColors.rarityLegendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: _rarityColor.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: const Color(0xFF0D2226),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: _rarityColor.withValues(alpha: 0.40),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  question.category.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: const Color(0xFF9CA3AF),
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  ' · ',
                  style: AppTypography.labelSmall.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  question.rarity.name.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: _rarityColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              question.text,
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.10, curve: Curves.easeOutCubic);
  }
}
