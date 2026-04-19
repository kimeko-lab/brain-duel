import 'package:flutter/material.dart';

import '../event_tokens.dart';

/// Floating sound-effect text (e.g. "WOW!!", "DON!!") — Bangers with ink stroke.
class SfxText extends StatelessWidget {
  const SfxText({
    super.key,
    required this.text,
    this.color = EventTokens.red,
    this.size = 22,
    this.rotationDeg = 8,
    this.strokeWidth = 2,
  });

  final String text;
  final Color color;
  final double size;
  final double rotationDeg;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationDeg * 3.1415926535 / 180,
      child: Stack(
        children: [
          // Ink stroke (rendered as foreground-painted text under fill)
          Text(
            text,
            style: EventTokens.bangers(
              size: size,
              color: EventTokens.ink,
              letterSpacing: 1,
            ).copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = EventTokens.ink,
            ),
          ),
          Text(
            text,
            style: EventTokens.bangers(
              size: size,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
