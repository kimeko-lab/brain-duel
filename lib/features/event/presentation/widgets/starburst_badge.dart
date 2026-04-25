import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../event_tokens.dart';

/// 12-spike starburst shape (24 vertices: 12 outer + 12 inner) via polar loop.
/// Used for "14 DAYS LEFT" callout and podium medal blocks.
class StarburstBadge extends StatelessWidget {
  const StarburstBadge({
    super.key,
    required this.size,
    required this.color,
    required this.label,
    required this.sublabel,
    this.labelColor = Colors.white,
    this.spikes = 12,
    this.innerRatio = 0.62,
    this.borderColor = EventTokens.ink,
  });

  final double size;
  final Color color;
  final String label;
  final String sublabel;
  final Color labelColor;
  final int spikes;
  final double innerRatio;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StarburstPainter(
          color: color,
          borderColor: borderColor,
          spikes: spikes,
          innerRatio: innerRatio,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: EventTokens.bangers(
                  size: size * 0.34,
                  color: labelColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                sublabel,
                textAlign: TextAlign.center,
                style: EventTokens.bebas(
                  size: size * 0.10,
                  color: labelColor,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarburstPainter extends CustomPainter {
  _StarburstPainter({
    required this.color,
    required this.borderColor,
    required this.spikes,
    required this.innerRatio,
  });

  final Color color;
  final Color borderColor;
  final int spikes;
  final double innerRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = math.min(size.width, size.height) / 2 - 1.5;
    final innerR = outerR * innerRatio;
    final totalPoints = spikes * 2;
    final step = math.pi * 2 / totalPoints;

    final path = Path();
    for (var i = 0; i < totalPoints; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = -math.pi / 2 + step * i;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _StarburstPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.spikes != spikes ||
      oldDelegate.innerRatio != innerRatio;
}
