import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

// Silver book reward colors
const Color _silverBook = Color(0xFFCBD5E1);

/// Animated silver-book reward card shown on the result screen.
///
/// Displays the book count animating from 0 → [crystals] over 1 second.
/// No BackdropFilter — solid dark card with silver border.
class CrystalRewardWidget extends StatefulWidget {
  const CrystalRewardWidget({super.key, required this.crystals});

  /// Number of silver books earned (parameter name kept for API compatibility).
  final int crystals;

  @override
  State<CrystalRewardWidget> createState() => _CrystalRewardWidgetState();
}

class _CrystalRewardWidgetState extends State<CrystalRewardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2226),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: _silverBook.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _silverBook.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: _silverBook,
                size: 36,
                shadows: [
                  Shadow(
                    color: _silverBook.withValues(alpha: 0.50),
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
                      color: _silverBook,
                      shadows: [
                        Shadow(
                          color: _silverBook.withValues(alpha: 0.50),
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
            '+${widget.crystals} SILVER BOOKS',
            style: AppTypography.labelSmall.copyWith(
              color: _silverBook.withValues(alpha: 0.75),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
