import 'package:flutter/material.dart';

/// Static, zero-animation scholarly library background.
/// Deep purple tones + teal glow orbs + bookshelf silhouettes.
///
/// Uses [RepaintBoundary] around the [CustomPaint] so screen content
/// repaints never trigger a background repaint.
class ArcaneLibraryBackground extends StatelessWidget {
  const ArcaneLibraryBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            painter: _ArcaneLibraryPainter(),
            child: const SizedBox.expand(),
          ),
        ),
        child,
      ],
    );
  }
}

class _ArcaneLibraryPainter extends CustomPainter {
  const _ArcaneLibraryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGlowOrbs(canvas, size);
    _drawDustParticles(canvas, size);
    _drawBookshelves(canvas, size);
    _drawVignette(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0d0a1e), Color(0xFF160e2e), Color(0xFF0a0618)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawGlowOrbs(Canvas canvas, Size size) {
    final paint = Paint();

    // Left purple orb
    final leftCenter = Offset(size.width * 0.18, size.height * 0.18);
    final leftR = size.width * 0.38;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF8a50dc).withValues(alpha: 0.22), Colors.transparent],
    ).createShader(Rect.fromCircle(center: leftCenter, radius: leftR));
    canvas.drawCircle(leftCenter, leftR, paint);

    // Right teal orb
    final rightCenter = Offset(size.width * 0.84, size.height * 0.22);
    final rightR = size.width * 0.32;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF2dd2be).withValues(alpha: 0.18), Colors.transparent],
    ).createShader(Rect.fromCircle(center: rightCenter, radius: rightR));
    canvas.drawCircle(rightCenter, rightR, paint);

    // Subtle center orb
    final midCenter = Offset(size.width * 0.50, size.height * 0.38);
    final midR = size.width * 0.42;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF8a50dc).withValues(alpha: 0.10), Colors.transparent],
    ).createShader(Rect.fromCircle(center: midCenter, radius: midR));
    canvas.drawCircle(midCenter, midR, paint);
  }

  void _drawDustParticles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // (xFraction, yFraction, radius, isPurple)
    const dots = [
      (0.15, 0.07, 1.5, true),  (0.34, 0.11, 1.0, false),
      (0.60, 0.05, 2.0, true),  (0.78, 0.13, 1.5, false),
      (0.90, 0.08, 1.0, true),  (0.25, 0.19, 2.5, false),
      (0.50, 0.17, 1.0, true),  (0.70, 0.22, 1.5, false),
      (0.08, 0.29, 2.0, true),  (0.44, 0.27, 1.0, false),
      (0.85, 0.31, 2.5, true),  (0.22, 0.34, 1.5, false),
    ];
    for (final d in dots) {
      paint.color = (d.$4
          ? const Color(0xFF8a50dc)
          : const Color(0xFF2dd2be))
          .withValues(alpha: 0.45);
      canvas.drawCircle(Offset(size.width * d.$1, size.height * d.$2), d.$3, paint);
    }
  }

  void _drawBookshelves(Canvas canvas, Size size) {
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF1e0830), Color(0xFF240e38), Color(0xFF1a0628)],
      baseY: size.height * 0.72, maxH: size.height * 0.09);
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF2a1040), Color(0xFF321658), Color(0xFF241040)],
      baseY: size.height * 0.80, maxH: size.height * 0.11);
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF3c1660), Color(0xFF4a1a78), Color(0xFF34145a)],
      baseY: size.height * 0.89, maxH: size.height * 0.13);
  }

  void _drawShelfRow(Canvas canvas, Size size, {
    required List<Color> colors,
    required double baseY,
    required double maxH,
  }) {
    const ws = [14.0, 10.0, 16.0, 12.0, 18.0, 11.0, 15.0, 13.0, 17.0, 12.0];
    const hs = [0.85, 0.65, 0.95, 0.55, 0.80, 0.70, 0.90, 0.60, 0.75, 0.72];

    final paint = Paint()..style = PaintingStyle.fill;
    var x = 0.0;
    var i = 0;
    while (x < size.width) {
      final idx = i % ws.length;
      paint.color = colors[i % colors.length];
      final h = maxH * hs[idx];
      canvas.drawRect(Rect.fromLTWH(x + 0.5, baseY - h, ws[idx] - 1, h), paint);
      x += ws[idx] + 1;
      i++;
    }
    // Shelf baseline
    paint.color = colors[0];
    canvas.drawRect(Rect.fromLTWH(0, baseY, size.width, 2), paint);
  }

  void _drawVignette(Canvas canvas, Size size) {
    final vignetteRect = Rect.fromLTWH(0, size.height * 0.78, size.width, size.height * 0.22);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0xFF08040f)],
      ).createShader(vignetteRect);
    canvas.drawRect(vignetteRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
