import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Static, zero-animation **Neural Synapse** premium background.
///
/// Palette (Cyber Arena): Indigo `#6366F1` · Hot Pink `#EC4899` · Cyan
/// `#22D3EE` over a deep cosmic gradient (`#06081F → #181B3E → #03050F`).
///
/// Composition:
///   1. Base vertical gradient
///   2. Three chromatic orbs (indigo TL, pink TR, cyan bottom)
///   3. Synapse edges — curved bezier lines between nearest nodes
///   4. Static pulse dots along 7 random edges (frozen-in-time data travel)
///   5. Nodes — 34 glowing dots, ~25% "active" (brighter + larger halo)
///   6. Bottom vignette
///
/// Uses [RepaintBoundary] + `shouldRepaint => false` so the background
/// never repaints after first layout regardless of foreground animation.
class DeepNightBackground extends StatelessWidget {
  const DeepNightBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            painter: _NeuralSynapsePainter(),
            child: const SizedBox.expand(),
          ),
        ),
        child,
      ],
    );
  }
}

// ─── Palette ─────────────────────────────────────────────────────────────────
const Color _bgTop  = Color(0xFF06081F);
const Color _bgMid  = Color(0xFF181B3E);
const Color _bgBot  = Color(0xFF03050F);

const Color _indigo = Color(0xFF6366F1); // primary nodes
const Color _pink   = Color(0xFFEC4899); // accent nodes
const Color _cyan   = Color(0xFF22D3EE); // pulse dots

// ─── Scene tuning (HIGH density) ─────────────────────────────────────────────
const int    _nodeCount   = 34;
const double _connPerNode = 2.8;
const double _activeRatio = 0.25;
const double _accentRatio = 0.32; // % of nodes tinted pink
const int    _pulseCount  = 7;
const int    _seed        = 42;

// ─── Painter ─────────────────────────────────────────────────────────────────
class _NeuralSynapsePainter extends CustomPainter {
  _NeuralSynapsePainter();

  static final Paint _fillPaint   = Paint();
  static final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.9;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(_seed);
    final scene = _buildScene(rng, size);

    _drawBackground(canvas, size);
    _drawOrbs(canvas, size);
    _drawEdges(canvas, scene);
    _drawPulses(canvas, scene);
    _drawNodes(canvas, scene);
    _drawVignette(canvas, size);
  }

  // ── Scene generation ─────────────────────────────────────────────────────
  _Scene _buildScene(math.Random rng, Size size) {
    // Nodes
    final nodes = <_Node>[];
    for (var i = 0; i < _nodeCount; i++) {
      nodes.add(_Node(
        pos: Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height,
        ),
        r: 1.8 + rng.nextDouble() * 3.2,
        accent: rng.nextDouble() < _accentRatio,
        active: rng.nextDouble() < _activeRatio,
      ));
    }

    // Edges — connect each node to its N nearest neighbors
    final edges = <_Edge>[];
    final seen = <int>{};
    for (var i = 0; i < nodes.length; i++) {
      final a = nodes[i];
      // Sort other nodes by distance
      final indexed = List.generate(nodes.length, (j) => j)
        ..removeAt(i);
      indexed.sort((x, y) {
        final dx = (nodes[x].pos - a.pos).distanceSquared;
        final dy = (nodes[y].pos - a.pos).distanceSquared;
        return dx.compareTo(dy);
      });
      final count = (_connPerNode + (rng.nextDouble() * 1.5 - 0.5)).round();
      for (var k = 0; k < count && k < indexed.length; k++) {
        final j = indexed[k];
        final key = i < j ? i * 1000 + j : j * 1000 + i;
        if (seen.contains(key)) continue;
        seen.add(key);

        final b = nodes[j];
        // Quadratic control point: midpoint offset along perpendicular
        final mid = (a.pos + b.pos) / 2;
        final d = b.pos - a.pos;
        final len = d.distance;
        if (len < 0.5) continue;
        final nx = -d.dy / len;
        final ny = d.dx / len;
        final curve = (rng.nextDouble() - 0.5) * 60.0;
        final control = Offset(
          mid.dx + nx * curve,
          mid.dy + ny * curve,
        );
        edges.add(_Edge(
          a: i,
          b: j,
          control: control,
          accent: a.accent || b.accent,
        ));
      }
    }

    // Mark pulseCount random edges + pick a static t along each
    final shuffledIdx = List.generate(edges.length, (i) => i)..shuffle(rng);
    final pulses = <_Pulse>[];
    for (var i = 0; i < math.min(_pulseCount, shuffledIdx.length); i++) {
      final e = edges[shuffledIdx[i]];
      final t = 0.2 + rng.nextDouble() * 0.6; // frozen somewhere in-flight
      final a = nodes[e.a].pos;
      final b = nodes[e.b].pos;
      final p = _quadPoint(a, e.control, b, t);
      pulses.add(_Pulse(pos: p));
    }

    return _Scene(nodes: nodes, edges: edges, pulses: pulses);
  }

  Offset _quadPoint(Offset a, Offset c, Offset b, double t) {
    final u = 1 - t;
    return Offset(
      u * u * a.dx + 2 * u * t * c.dx + t * t * b.dx,
      u * u * a.dy + 2 * u * t * c.dy + t * t * b.dy,
    );
  }

  // ── Drawing ──────────────────────────────────────────────────────────────
  void _drawBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    _fillPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_bgTop, _bgMid, _bgBot],
      stops: [0.0, 0.5, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, _fillPaint);
  }

  void _drawOrbs(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final orbs = [
      (Offset(size.width * 0.18, size.height * 0.12), size.width * 0.95,
        _indigo, 0.28),
      (Offset(size.width * 0.88, size.height * 0.22), size.width * 0.70,
        _pink, 0.22),
      (Offset(size.width * 0.55, size.height * 0.85), size.width * 0.90,
        _cyan, 0.18),
    ];
    for (final (center, radius, color, alpha) in orbs) {
      _fillPaint.shader = RadialGradient(
        colors: [color.withValues(alpha: alpha), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawRect(rect, _fillPaint);
    }
  }

  void _drawEdges(Canvas canvas, _Scene scene) {
    _strokePaint
      ..shader = null
      ..strokeWidth = 0.9;
    for (final e in scene.edges) {
      final a = scene.nodes[e.a].pos;
      final b = scene.nodes[e.b].pos;
      final color = e.accent ? _pink : _indigo;
      _strokePaint.color = color.withValues(alpha: 0.22);
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(e.control.dx, e.control.dy, b.dx, b.dy);
      canvas.drawPath(path, _strokePaint);
    }
  }

  void _drawPulses(Canvas canvas, _Scene scene) {
    for (final p in scene.pulses) {
      // Cyan glow halo
      _fillPaint.shader = RadialGradient(
        colors: [_cyan.withValues(alpha: 0.95), Colors.transparent],
      ).createShader(Rect.fromCircle(center: p.pos, radius: 10));
      canvas.drawCircle(p.pos, 10, _fillPaint);
      // White core
      _fillPaint
        ..shader = null
        ..color = Colors.white.withValues(alpha: 0.95);
      canvas.drawCircle(p.pos, 1.8, _fillPaint);
    }
  }

  void _drawNodes(Canvas canvas, _Scene scene) {
    for (final n in scene.nodes) {
      final color = n.accent ? _pink : _indigo;
      final haloR = n.r * (n.active ? 7 : 4);
      // Halo
      _fillPaint.shader = RadialGradient(
        colors: [
          color.withValues(alpha: n.active ? 0.50 : 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: n.pos, radius: haloR));
      canvas.drawCircle(n.pos, haloR, _fillPaint);
      // Core (colored)
      _fillPaint
        ..shader = null
        ..color = color;
      canvas.drawCircle(n.pos, n.r, _fillPaint);
      // Bright white center
      _fillPaint.color = Colors.white.withValues(alpha: 0.85);
      canvas.drawCircle(n.pos, n.r * 0.45, _fillPaint);
    }
  }

  void _drawVignette(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      0,
      size.height * 0.75,
      size.width,
      size.height * 0.25,
    );
    _fillPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Color(0xFF02040A)],
    ).createShader(rect);
    canvas.drawRect(rect, _fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Data ────────────────────────────────────────────────────────────────────
class _Scene {
  _Scene({required this.nodes, required this.edges, required this.pulses});
  final List<_Node> nodes;
  final List<_Edge> edges;
  final List<_Pulse> pulses;
}

class _Node {
  _Node({
    required this.pos,
    required this.r,
    required this.accent,
    required this.active,
  });
  final Offset pos;
  final double r;
  final bool accent;
  final bool active;
}

class _Edge {
  _Edge({
    required this.a,
    required this.b,
    required this.control,
    required this.accent,
  });
  final int a;
  final int b;
  final Offset control;
  final bool accent;
}

class _Pulse {
  _Pulse({required this.pos});
  final Offset pos;
}
