import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/question_model.dart';

/// Glass card that displays the current question and its category/rarity label.
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
            color: _rarityColor.withValues(alpha: 0.25),
            blurRadius: 24,
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
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                color: _rarityColor.withValues(alpha: 0.45),
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
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      ' · ',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
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
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.12, curve: Curves.easeOutCubic);
  }
}
