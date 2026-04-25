import 'package:flutter/material.dart';

import '../event_tokens.dart';

/// Paper-white background with subtle halftone dot pattern.
/// Locked params per spec: 1.0px diameter dots on 6px grid, 9% ink opacity.
class MangaPaperBackground extends StatelessWidget {
  const MangaPaperBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EventTokens.paper,
      child: CustomPaint(
        painter: _HalftonePainter(),
        child: child,
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  static const double _grid = 6;
  static const double _radius = 0.5; // 1.0 px diameter

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = EventTokens.ink.withValues(alpha: 0.09);
    for (double y = 0; y < size.height; y += _grid) {
      for (double x = 0; x < size.width; x += _grid) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HalftonePainter oldDelegate) => false;
}
