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
    required this.rewardAmount,
    required this.rewardKind,
    this.onTap,
  });

  final int dayNumber; // 1..7
  final DayBoxState state;
  final int rewardAmount;
  final String rewardKind; // "GEM" / "CARD" / "JOKER"
  final VoidCallback? onTap;

  bool get _isToday => state == DayBoxState.today;
  bool get _isClaimed => state == DayBoxState.claimed;
  bool get _isFinalDay => dayNumber == 7;

  /// State-aware icon system. No more placeholder dots or ad-hoc stars.
  String get _icon {
    if (_isClaimed) return '✓';
    if (_isToday) return _isFinalDay ? '🏆' : '🎁';
    return _isFinalDay ? '👑' : '💎';
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _isToday && onTap != null;

    final Color bg;
    final Color fg;
    if (_isClaimed) {
      bg = EventTokens.ink;
      fg = EventTokens.paper;
    } else if (_isToday) {
      bg = EventTokens.red;
      fg = Colors.white;
    } else {
      bg = Colors.white;
      fg = EventTokens.ink;
    }

    final inner = Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Decoration icon — small, state-aware
          Text(
            _icon,
            style: TextStyle(fontSize: 14, color: fg, height: 1.0),
          ),
          const SizedBox(height: 5),
          // HERO: reward amount
          Text(
            '$rewardAmount',
            style: EventTokens.bebas(
              size: 14,
              color: fg,
              weight: FontWeight.w900,
            ),
          ),
          // SUPPORT: reward kind caption
          Text(
            rewardKind,
            style: EventTokens.bebas(
              size: 8,
              color: fg,
              weight: FontWeight.w700,
              letterSpacing: 1.2,
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
        ? 'Day $dayNumber, already claimed, $rewardAmount $rewardKind'
        : _isToday
            ? 'Day $dayNumber, tap to claim, reward $rewardAmount $rewardKind'
            : 'Day $dayNumber, locked, future reward $rewardAmount $rewardKind';

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
