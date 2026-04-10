import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/state/daily_classic_state.dart';

/// A tappable answer option tile that shows feedback after the user answers.
class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.index,
    required this.correctIndex,
    required this.selectedIndex,
    required this.phase,
    required this.onTap,
  });

  final String label;
  final String text;
  final int index;
  final int correctIndex;
  final int? selectedIndex;
  final GamePhase phase;
  final VoidCallback? onTap;

  bool get _isFeedbackPhase => phase == GamePhase.showingFeedback;
  bool get _isCorrect => index == correctIndex;
  bool get _isWrong =>
      selectedIndex != null &&
      index == selectedIndex &&
      index != correctIndex;

  Color get _tileColor {
    if (!_isFeedbackPhase) return AppColors.mountainMid.withValues(alpha: 0.55);
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.35);
    if (_isWrong) return AppColors.wrong.withValues(alpha: 0.35);
    return AppColors.mountainMid.withValues(alpha: 0.3);
  }

  Color get _borderColor {
    if (!_isFeedbackPhase) {
      return Colors.white.withValues(alpha: 0.15);
    }
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.8);
    if (_isWrong) return AppColors.wrong.withValues(alpha: 0.8);
    return Colors.white.withValues(alpha: 0.08);
  }

  Color get _labelBgColor {
    if (!_isFeedbackPhase) return AppColors.primary.withValues(alpha: 0.25);
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.45);
    if (_isWrong) return AppColors.wrong.withValues(alpha: 0.45);
    return AppColors.mountainNear.withValues(alpha: 0.5);
  }

  Color get _labelTextColor {
    if (!_isFeedbackPhase) return AppColors.primary;
    if (_isCorrect) return AppColors.correct;
    if (_isWrong) return AppColors.wrong;
    return AppColors.textDisabled;
  }

  Color get _textColor {
    if (_isFeedbackPhase && !_isCorrect && !_isWrong) {
      return AppColors.textDisabled;
    }
    return AppColors.textPrimary;
  }

  VoidCallback? get _effectiveOnTap {
    if (phase == GamePhase.answering) return onTap;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _tileColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _borderColor,
              width: _isFeedbackPhase && (_isCorrect || _isWrong) ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _labelBgColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      color: _labelTextColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.bodyMedium.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isFeedbackPhase && _isCorrect)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.correct,
                  size: 20,
                )
              else if (_isFeedbackPhase && _isWrong)
                const Icon(
                  Icons.cancel_rounded,
                  color: AppColors.wrong,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );

    final withShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          if (_isFeedbackPhase && _isCorrect)
            BoxShadow(
              color: AppColors.correct.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: -4,
            )
          else if (_isFeedbackPhase && _isWrong)
            BoxShadow(
              color: AppColors.wrong.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: -4,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: content,
    );

    if (_effectiveOnTap == null) return withShadow;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _effectiveOnTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.06),
        child: withShadow,
      ),
    );
  }
}
