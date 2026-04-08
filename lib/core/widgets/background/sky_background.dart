import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Layered atmospheric sky background inspired by Flappy Dragon.
///
/// Renders from back to front:
///   1. Sky gradient (top=dusty blue → bottom=peach horizon)
///   2. Twinkling star field (upper sky)
///   3. Soft cloud blobs (mid-sky)
///   4. Far mountain silhouette
///   5. Mid mountain silhouette
///   6. Near mountain silhouette
///   7. Foreground ground shadow
///
/// Use as Scaffold body wrapper to get full-screen atmosphere.
class SkyBackground extends StatefulWidget {
  const SkyBackground({super.key, required this.child});

  final Widget child;

  @override
  State<SkyBackground> createState() => _SkyBackgroundState();
}

class _SkyBackgroundState extends State<SkyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _twinkle;
  late final AnimationController _drift;

  @override
  void initState() {
    super.initState();
    _twinkle = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _drift = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _twinkle.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Sky gradient base
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.skyGradient),
        ),

        // Layer 2: Star field
        AnimatedBuilder(
          animation: _twinkle,
          builder: (_, child) => CustomPaint(
            painter: _StarFieldPainter(twinkle: _twinkle.value),
          ),
        ),

        // Layer 3: Drifting clouds
        AnimatedBuilder(
          animation: _drift,
          builder: (_, child) => CustomPaint(
            painter: _CloudPainter(drift: _drift.value),
          ),
        ),

        // Layer 4-6: Mountain silhouettes (static)
        const Positioned.fill(
          child: CustomPaint(painter: _MountainPainter()),
        ),

        // Layer 7: Bottom vignette for content legibility
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0x332A1E3A),
                    Color(0x662A1E3A),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

/// Paints subtle twinkling stars in the upper portion of the sky.
class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter({required this.twinkle});
  final double twinkle;

  static final _rng = math.Random(42); // seeded for stable positions
  static final List<Offset> _positions = List.generate(
    60,
    (i) => Offset(_rng.nextDouble(), _rng.nextDouble() * 0.45),
  );
  static final List<double> _sizes = List.generate(
    60,
    (i) => 0.5 + _rng.nextDouble() * 1.8,
  );
  static final List<double> _phases = List.generate(
    60,
    (i) => _rng.nextDouble(),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var i = 0; i < _positions.length; i++) {
      final pos = _positions[i];
      final phase = (_phases[i] + twinkle) % 1.0;
      final alpha = 0.35 + 0.55 * (0.5 + 0.5 * math.sin(phase * math.pi * 2));
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(
        Offset(pos.dx * size.width, pos.dy * size.height),
        _sizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter old) =>
      old.twinkle != twinkle;
}

/// Paints soft pinkish cloud blobs drifting slowly across the mid-sky.
class _CloudPainter extends CustomPainter {
  _CloudPainter({required this.drift});
  final double drift;

  static final _clouds = [
    _Cloud(baseX: 0.15, y: 0.30, width: 0.42, height: 0.09, alpha: 0.65),
    _Cloud(baseX: 0.55, y: 0.37, width: 0.50, height: 0.10, alpha: 0.72),
    _Cloud(baseX: 0.05, y: 0.45, width: 0.55, height: 0.11, alpha: 0.80),
    _Cloud(baseX: 0.60, y: 0.48, width: 0.48, height: 0.09, alpha: 0.70),
    _Cloud(baseX: 0.25, y: 0.54, width: 0.60, height: 0.12, alpha: 0.85),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final cloud in _clouds) {
      // Drift horizontally slowly, wrap around
      final offset = (cloud.baseX + drift * 0.15) % 1.2 - 0.1;
      final cx = offset * size.width;
      final cy = cloud.y * size.height;
      final w = cloud.width * size.width;
      final h = cloud.height * size.height;

      // Soft cloud: draw multiple overlapping ellipses
      final paint = Paint()
        ..color = AppColors.cloudSoft.withValues(alpha: cloud.alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      // Main body
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
        paint,
      );
      // Puffs
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.25, cy + h * 0.1),
          width: w * 0.6,
          height: h * 0.85,
        ),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + w * 0.25, cy + h * 0.1),
          width: w * 0.6,
          height: h * 0.85,
        ),
        paint,
      );

      // Shadow underside
      final shadowPaint = Paint()
        ..color = AppColors.cloudShadow.withValues(alpha: cloud.alpha * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy + h * 0.35),
          width: w * 0.85,
          height: h * 0.35,
        ),
        shadowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CloudPainter old) => old.drift != drift;
}

class _Cloud {
  const _Cloud({
    required this.baseX,
    required this.y,
    required this.width,
    required this.height,
    required this.alpha,
  });
  final double baseX;
  final double y;
  final double width;
  final double height;
  final double alpha;
}

/// Paints three layers of mountain silhouettes.
class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Far mountains (lighter violet, ~55% down)
    final farPaint = Paint()..color = AppColors.mountainFar;
    final farPath = Path()
      ..moveTo(0, h * 0.68)
      ..lineTo(w * 0.00, h * 0.62)
      ..lineTo(w * 0.10, h * 0.58)
      ..lineTo(w * 0.18, h * 0.61)
      ..lineTo(w * 0.27, h * 0.55)
      ..lineTo(w * 0.35, h * 0.60)
      ..lineTo(w * 0.45, h * 0.56)
      ..lineTo(w * 0.55, h * 0.62)
      ..lineTo(w * 0.65, h * 0.57)
      ..lineTo(w * 0.75, h * 0.63)
      ..lineTo(w * 0.85, h * 0.58)
      ..lineTo(w * 0.95, h * 0.62)
      ..lineTo(w, h * 0.60)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farPath, farPaint);

    // Mid mountains (dusk purple, ~68% down)
    final midPaint = Paint()..color = AppColors.mountainMid;
    final midPath = Path()
      ..moveTo(0, h * 0.78)
      ..lineTo(w * 0.05, h * 0.72)
      ..lineTo(w * 0.12, h * 0.76)
      ..lineTo(w * 0.20, h * 0.70)
      ..lineTo(w * 0.28, h * 0.74)
      ..lineTo(w * 0.38, h * 0.68)
      ..lineTo(w * 0.48, h * 0.73)
      ..lineTo(w * 0.58, h * 0.69)
      ..lineTo(w * 0.68, h * 0.75)
      ..lineTo(w * 0.78, h * 0.71)
      ..lineTo(w * 0.88, h * 0.76)
      ..lineTo(w, h * 0.73)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midPath, midPaint);

    // Near mountains (deep twilight, ~80% down)
    final nearPaint = Paint()..color = AppColors.mountainNear;
    final nearPath = Path()
      ..moveTo(0, h * 0.88)
      ..lineTo(w * 0.08, h * 0.83)
      ..lineTo(w * 0.18, h * 0.86)
      ..lineTo(w * 0.28, h * 0.81)
      ..lineTo(w * 0.40, h * 0.84)
      ..lineTo(w * 0.52, h * 0.79)
      ..lineTo(w * 0.63, h * 0.83)
      ..lineTo(w * 0.74, h * 0.80)
      ..lineTo(w * 0.85, h * 0.85)
      ..lineTo(w * 0.95, h * 0.82)
      ..lineTo(w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(nearPath, nearPaint);

    // Ground
    final groundPaint = Paint()..color = AppColors.mountainGround;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.95, w, h * 0.05), groundPaint);
  }

  @override
  bool shouldRepaint(covariant _MountainPainter oldDelegate) => false;
}
