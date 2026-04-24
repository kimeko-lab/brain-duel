import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'game_phase.dart';

// Design tokens — match dark teal theme
const Color _tileBase    = Color(0xFF111428);
const Color _tileBorder  = Color(0xFF2A2F52);
const Color _accentGreen = Color(0xFF6366F1);

/// A tappable answer option tile that shows feedback after the user answers.
/// No BackdropFilter — compatible with any background.
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
    if (!_isFeedbackPhase) return _tileBase;
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.18);
    if (_isWrong)   return AppColors.wrong.withValues(alpha: 0.18);
    return const Color(0xFF081518);
  }

  Color get _borderColor {
    if (!_isFeedbackPhase) return _tileBorder;
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.80);
    if (_isWrong)   return AppColors.wrong.withValues(alpha: 0.80);
    return Colors.white.withValues(alpha: 0.06);
  }

  Color get _labelBgColor {
    if (!_isFeedbackPhase) return _accentGreen.withValues(alpha: 0.14);
    if (_isCorrect) return AppColors.correct.withValues(alpha: 0.30);
    if (_isWrong)   return AppColors.wrong.withValues(alpha: 0.30);
    return Colors.white.withValues(alpha: 0.04);
  }

  Color get _labelTextColor {
    if (!_isFeedbackPhase) return _accentGreen;
    if (_isCorrect) return AppColors.correct;
    if (_isWrong)   return AppColors.wrong;
    return AppColors.textDisabled;
  }

  Color get _textColor {
    if (_isFeedbackPhase && !_isCorrect && !_isWrong) {
      return AppColors.textDisabled;
    }
    return Colors.white;
  }

  VoidCallback? get _effectiveOnTap {
    if (phase == GamePhase.answering && onTap != null) {
      return () {
        HapticFeedback.selectionClick();
        onTap!();
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _tileColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: _borderColor,
          width: _isFeedbackPhase && (_isCorrect || _isWrong) ? 2 : 1.2,
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
    );

    final withShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          if (_isFeedbackPhase && _isCorrect)
            BoxShadow(
              color: AppColors.correct.withValues(alpha: 0.25),
              blurRadius: 18,
              spreadRadius: -4,
            )
          else if (_isFeedbackPhase && _isWrong)
            BoxShadow(
              color: AppColors.wrong.withValues(alpha: 0.25),
              blurRadius: 18,
              spreadRadius: -4,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 3),
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
        splashColor: _accentGreen.withValues(alpha: 0.10),
        highlightColor: _accentGreen.withValues(alpha: 0.05),
        child: withShadow,
      ),
    );
  }
}
