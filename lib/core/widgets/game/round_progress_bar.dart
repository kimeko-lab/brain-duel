import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Displays "ROUND X / Y" label above a linear progress bar.
/// Colors match the dark teal theme.
class RoundProgressBar extends StatelessWidget {
  const RoundProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  final int current; // 1-based
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'ROUND',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$current / $total',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D084)),
          ),
        ),
      ],
    );
  }
}
