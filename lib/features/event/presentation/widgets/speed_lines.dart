import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../event_tokens.dart';

/// Diagonal speed-lines overlay for the featured event panel.
/// -18° angle, 8px gap, 1px stroke, ink 6% opacity.
class SpeedLines extends StatelessWidget {
  const SpeedLines({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _SpeedLinesPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _SpeedLinesPainter extends CustomPainter {
  static const double _angleDeg = -18;
  static const double _gap = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EventTokens.ink.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;

    final angle = _angleDeg * math.pi / 180;
    final dx = math.cos(angle);
    final dy = math.sin(angle);

    // Line span long enough to cover the box regardless of angle.
    final length = size.width + size.height;

    // Iterate perpendicular offsets from -length to +length.
    for (double t = -length; t < length; t += _gap) {
      // Perpendicular vector: (-sin, cos)
      final px = -dy * t;
      final py = dx * t;
      // Line from (px - dx*length/2, py - dy*length/2) to (px + dx*length/2, py + dy*length/2)
      canvas.drawLine(
        Offset(px - dx * length, py - dy * length),
        Offset(px + dx * length, py + dy * length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedLinesPainter oldDelegate) => false;
}
