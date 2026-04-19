import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../event_tokens.dart';

enum DayBoxState { claimed, today, future }

/// One day of the 7-day login streak.
class DayBox extends StatelessWidget {
  const DayBox({
    super.key,
    required this.dayNumber,
    required this.state,
    required this.reward,
    this.onTap,
  });

  final int dayNumber; // 1..7
  final DayBoxState state;
  final String reward; // e.g. "50💎", "1📘"
  final VoidCallback? onTap;

  bool get _isToday => state == DayBoxState.today;
  bool get _isClaimed => state == DayBoxState.claimed;

  @override
  Widget build(BuildContext context) {
    final enabled = _isToday && onTap != null;

    final Color bg;
    final Color fg;
    final String icon;
    if (_isClaimed) {
      bg = EventTokens.ink;
      fg = EventTokens.paper;
      icon = '✓';
    } else if (_isToday) {
      bg = EventTokens.red;
      fg = Colors.white;
      icon = '🎁';
    } else {
      bg = Colors.white;
      fg = EventTokens.ink;
      icon = dayNumber == 7 ? '★' : '·';
    }

    final inner = Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: EventTokens.ink, width: 2),
        boxShadow: _isToday
            ? const [
                BoxShadow(
                  color: EventTokens.ink,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: 12, color: fg, height: 1.0)),
          const SizedBox(height: 2),
          Text(
            reward,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: EventTokens.bebas(size: 9, color: fg, letterSpacing: 0.3),
          ),
          const SizedBox(height: 1),
          Text(
            'D$dayNumber',
            style: EventTokens.bebas(
              size: 8,
              color: fg.withValues(alpha: _isClaimed ? 0.7 : 1.0),
              letterSpacing: 0.6,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    // Nudge the "today" box up-left so its shadow shows
    final positioned = _isToday
        ? Transform.translate(offset: const Offset(-1, -1), child: inner)
        : inner;

    final semanticsLabel = _isClaimed
        ? 'Day $dayNumber, already claimed, $reward'
        : _isToday
            ? 'Day $dayNumber, tap to claim, reward $reward'
            : 'Day $dayNumber, locked, future reward $reward';

    return Semantics(
      button: enabled,
      enabled: enabled,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: enabled
            ? () {
                HapticFeedback.heavyImpact();
                onTap!();
              }
            : null,
        child: positioned,
      ),
    );
  }
}
