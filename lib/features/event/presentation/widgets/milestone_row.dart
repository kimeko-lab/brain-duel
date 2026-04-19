import 'package:flutter/material.dart';

import '../event_tokens.dart';
import 'manga_panel.dart';

enum MilestoneState { claimed, next, future }

class MilestoneData {
  const MilestoneData({
    required this.xp,
    required this.icon,
    required this.label,
    required this.state,
    this.isFinal = false,
  });

  final int xp;
  final String icon;
  final String label;
  final MilestoneState state;
  final bool isFinal;
}

class MilestoneRow extends StatelessWidget {
  const MilestoneRow({
    super.key,
    required this.data,
    required this.currentXp,
  });

  final MilestoneData data;
  final int currentXp;

  @override
  Widget build(BuildContext context) {
    final state = data.state;
    final claimed = state == MilestoneState.claimed;
    final isNext = state == MilestoneState.next;

    final bg = claimed
        ? EventTokens.paperShade
        : isNext
            ? EventTokens.paperHi
            : Colors.white;

    final borderWidth = isNext ? 4.0 : 3.0;

    final iconBoxColor = claimed ? EventTokens.ink : Colors.white;
    final iconFg = claimed ? EventTokens.paper : EventTokens.ink;

    final remaining = (data.xp - currentXp).clamp(0, data.xp);
    final progressPct = (currentXp / data.xp).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        MangaPanel(
          backgroundColor: bg,
          borderWidth: borderWidth,
          shadowOffset: 2,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBoxColor,
                  border: Border.all(color: EventTokens.ink, width: 2.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  claimed ? '✓' : data.icon,
                  style: TextStyle(fontSize: 20, color: iconFg, height: 1.0),
                ),
              ),
              const SizedBox(width: 10),
              // Label + optional progress hint
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.label,
                      style: EventTokens.bangers(
                        size: 15,
                        color: EventTokens.ink,
                        letterSpacing: 0.3,
                      ).copyWith(
                        decoration: claimed ? TextDecoration.lineThrough : null,
                        color: claimed
                            ? EventTokens.ink.withValues(alpha: 0.55)
                            : EventTokens.ink,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${(progressPct * 100).round()}% · $remaining XP to go',
                        style: EventTokens.bebas(
                          size: 10,
                          color: EventTokens.red,
                          letterSpacing: 0.4,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // XP chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: data.isFinal ? EventTokens.red : EventTokens.ink,
                ),
                child: Text(
                  '${data.xp} XP',
                  style: EventTokens.bebas(
                    size: 11,
                    color: EventTokens.paper,
                    letterSpacing: 0.5,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (data.isFinal)
          Positioned(
            right: -8,
            top: -10,
            child: Transform.rotate(
              angle: 18 * 3.1415926535 / 180,
              child: const Text('👑', style: TextStyle(fontSize: 22)),
            ),
          ),
      ],
    );
  }
}
