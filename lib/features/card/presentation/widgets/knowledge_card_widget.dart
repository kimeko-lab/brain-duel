import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/knowledge_card_model.dart';

// ─── Category icon ────────────────────────────────────────────────────────────

IconData _iconForCategory(String cat) {
  switch (cat) {
    case 'science':       return Icons.science_rounded;
    case 'geography':     return Icons.public_rounded;
    case 'history':       return Icons.history_edu_rounded;
    case 'sport':         return Icons.sports_rounded;
    case 'entertainment': return Icons.movie_rounded;
    case 'events':        return Icons.auto_stories_rounded;
    default:              return Icons.quiz_rounded;
  }
}

// ─── Public widget ────────────────────────────────────────────────────────────

/// Tappable knowledge card that flips between front (Q+A) and back (design).
class KnowledgeCardWidget extends StatefulWidget {
  const KnowledgeCardWidget({super.key, required this.card});

  final KnowledgeCardModel card;

  @override
  State<KnowledgeCardWidget> createState() => _KnowledgeCardWidgetState();
}

class _KnowledgeCardWidgetState extends State<KnowledgeCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_ctrl.isCompleted) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final angle   = _anim.value * math.pi;
          final isFront = _anim.value <= 0.5;
          final face    = isFront
              ? _FrontFace(card: widget.card)
              : const _BackFace();
          final faceAngle = isFront ? angle : angle - math.pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(faceAngle),
            child: face,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Front face
// ─────────────────────────────────────────────────────────────────────────────

class _FrontFace extends StatelessWidget {
  const _FrontFace({required this.card});

  final KnowledgeCardModel card;

  @override
  Widget build(BuildContext context) {
    final icon        = _iconForCategory(card.category);
    final rarityColor = card.rarity.color;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D2226),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rarityColor.withValues(alpha: 0.40),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: rarityColor.withValues(alpha: 0.18),
            blurRadius: 14,
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header: category-themed pattern + rarity ─────────────────
            _CardHeader(card: card, icon: icon, rarityColor: rarityColor),

            // ── Body: question + answer ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        card.question,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.45,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Container(
                      height: 1,
                      color: const Color(0xFF2D4A4A),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: rarityColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            card.answer,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: rarityColor,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer: category icon ────────────────────────────────────
            Container(
              height: 38,
              color: const Color(0xFF081518),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card Header ──────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.card,
    required this.icon,
    required this.rarityColor,
  });

  final KnowledgeCardModel card;
  final IconData icon;
  final Color rarityColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Category-themed pattern ──────────────────────────────────
          CustomPaint(
            painter: _HeaderPatternPainter(card.category),
          ),

          // ── Watermark icon (right, large, very dim) ──────────────────
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                icon,
                size: 42,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),

          // ── Rarity + category text (left) ────────────────────────────
          Positioned(
            left: 10,
            top: 9,
            bottom: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stars — standalone row
                _RarityStars(count: card.rarity.stars, color: rarityColor),

                // Rarity label — right below stars
                Text(
                  card.rarity.label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.0,
                    fontWeight: FontWeight.w800,
                    color: rarityColor,
                    letterSpacing: 1.4,
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: rarityColor.withValues(alpha: 0.60),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),

                // Category name — small, muted, at bottom
                Text(
                  card.category.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 6.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.30),
                    letterSpacing: 1.2,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rarity stars ─────────────────────────────────────────────────────────────

class _RarityStars extends StatelessWidget {
  const _RarityStars({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.only(right: i < count - 1 ? 2.5 : 0),
            child: Icon(
              Icons.star_rounded,
              size: 13.0,
              color: color,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.95),
                  blurRadius: 7,
                ),
                Shadow(
                  color: color.withValues(alpha: 0.40),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header pattern painters — one per category
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderPatternPainter extends CustomPainter {
  const _HeaderPatternPainter(this.category);

  final String category;

  // Shared brand-teal tint for all patterns
  static const Color _tint = Color(0xFF00D084);

  @override
  void paint(Canvas canvas, Size size) {
    // Dark header base — draw background fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF081C20),
    );

    final p = Paint()
      ..color = _tint.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..strokeCap = StrokeCap.round;

    switch (category) {
      case 'science':
        _paintScience(canvas, size, p);
      case 'geography':
        _paintGeography(canvas, size, p);
      case 'history':
        _paintHistory(canvas, size, p);
      case 'sport':
        _paintSport(canvas, size, p);
      case 'entertainment':
        _paintEntertainment(canvas, size, p);
      case 'events':
        _paintAnime(canvas, size, p);
      default:
        _paintHistory(canvas, size, p);
    }
  }

  // ── Science: hexagonal molecular grid ────────────────────────────────────

  void _paintScience(Canvas canvas, Size size, Paint p) {
    const r = 8.5;
    const w = r * 1.732; // sqrt(3)·r
    const h = r * 1.5;
    final cols = (size.width / w).ceil() + 2;
    final rows = (size.height / h).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final xOff = (row.isOdd) ? w / 2 : 0.0;
        _hexPath(canvas, col * w + xOff, row * h, r, p);
      }
    }

    // Small nucleus dots at hex centers (fill)
    final dotPaint = Paint()
      ..color = _tint.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;
    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final xOff = (row.isOdd) ? w / 2 : 0.0;
        canvas.drawCircle(Offset(col * w + xOff, row * h), 1.2, dotPaint);
      }
    }
  }

  void _hexPath(Canvas canvas, double cx, double cy, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  // ── Geography: globe meridian + parallel arcs ─────────────────────────────

  void _paintGeography(Canvas canvas, Size size, Paint p) {
    // Latitude parallels — gentle horizontal S-curves
    const lats = 6;
    for (int i = 0; i <= lats; i++) {
      final y = (i / lats) * size.height;
      final path = Path()..moveTo(0, y);
      path.cubicTo(
        size.width * 0.28, y - size.height * 0.09,
        size.width * 0.72, y + size.height * 0.09,
        size.width, y,
      );
      canvas.drawPath(path, p);
    }

    // Longitude meridians — vertical curved lines
    const lons = 5;
    for (int i = 1; i < lons; i++) {
      final x = (i / lons) * size.width;
      final bend = size.width * 0.06;
      final path = Path()..moveTo(x, 0);
      path.cubicTo(
        x - bend, size.height * 0.25,
        x + bend, size.height * 0.75,
        x, size.height,
      );
      canvas.drawPath(path, p);
    }

    // Equator highlight (slightly stronger)
    final eqPaint = Paint()
      ..color = _tint.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final eq = size.height / 2;
    final eqPath = Path()..moveTo(0, eq);
    eqPath.cubicTo(
      size.width * 0.28, eq - size.height * 0.09,
      size.width * 0.72, eq + size.height * 0.09,
      size.width, eq,
    );
    canvas.drawPath(eqPath, eqPaint);
  }

  // ── History: diagonal parchment hatching ──────────────────────────────────

  void _paintHistory(Canvas canvas, Size size, Paint p) {
    const spacing = 8.5;
    final diag = size.height;
    for (double x = -diag; x < size.width + diag; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + diag, size.height), p);
    }
    // Cross-hatch at 50% opacity for depth
    final p2 = Paint()
      ..color = _tint.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (double x = -diag; x < size.width + diag; x += spacing * 2) {
      canvas.drawLine(
          Offset(x + diag, 0), Offset(x, size.height), p2);
    }
  }

  // ── Sport: horizontal motion speed lines ──────────────────────────────────

  void _paintSport(Canvas canvas, Size size, Paint p) {
    const lines = 9;
    for (int i = 0; i < lines; i++) {
      final y = (i + 0.5) / lines * size.height;
      // Stagger start X for dynamic rhythm
      final startX = (i % 3) * size.width * 0.07;
      // Alternate lengths
      final endX = (i % 2 == 0) ? size.width : size.width * 0.87;
      p.color = _tint.withValues(alpha: i.isEven ? 0.09 : 0.05);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), p);
    }

    // Chevron accent marks suggesting directional energy
    p.color = _tint.withValues(alpha: 0.07);
    p.strokeWidth = 0.9;
    for (int i = 0; i < 3; i++) {
      final cx = size.width * (0.72 + i * 0.10);
      final half = size.height * 0.22;
      final mid = size.height / 2;
      canvas.drawLine(Offset(cx - 3, mid - half), Offset(cx + 3, mid), p);
      canvas.drawLine(Offset(cx + 3, mid), Offset(cx - 3, mid + half), p);
    }
  }

  // ── Entertainment: concentric film-reel / sound-wave rings ───────────────

  void _paintEntertainment(Canvas canvas, Size size, Paint p) {
    // Concentric circles from right-center (like a projector beam)
    final cx = size.width * 0.78;
    final cy = size.height / 2;
    double r = 7.0;
    while (r < size.width * 1.3) {
      p.color = _tint.withValues(alpha: r < 30 ? 0.12 : 0.06);
      canvas.drawCircle(Offset(cx, cy), r, p);
      r += 11.0;
    }

    // Film-strip tick marks along top and bottom edges
    final tickPaint = Paint()
      ..color = _tint.withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    const tickW = 5.0;
    const tickH = 4.0;
    const tickSpacing = 10.0;
    for (double x = 4; x < size.width; x += tickSpacing) {
      // Top ticks
      canvas.drawRect(
        Rect.fromLTWH(x, 2, tickW, tickH),
        tickPaint..style = PaintingStyle.stroke,
      );
      // Bottom ticks
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - 2 - tickH, tickW, tickH),
        tickPaint,
      );
    }
  }

  // ── Events / Anime: manga-style radial speed lines ────────────────────────

  void _paintAnime(Canvas canvas, Size size, Paint p) {
    // Action burst origin — top-right area
    final ox = size.width * 0.90;
    final oy = size.height * 0.10;

    const lineCount = 26;

    for (int i = 0; i < lineCount; i++) {
      final t = i / (lineCount - 1);
      // Spread across a wide arc facing the bottom-left quadrant (130° – 260°)
      final angle = math.pi * (0.72 + t * 0.74);
      final gap   = 5.0 + (i % 3) * 2.0;
      final len   = 42.0 + (i % 5) * 10.0;

      p.color = _tint.withValues(alpha: i.isEven ? 0.10 : 0.06);
      p.strokeWidth = i % 4 == 0 ? 1.1 : 0.7;

      canvas.drawLine(
        Offset(ox + gap * math.cos(angle), oy + gap * math.sin(angle)),
        Offset(ox + len * math.cos(angle), oy + len * math.sin(angle)),
        p,
      );
    }

    // Inner burst circle
    canvas.drawCircle(
      Offset(ox, oy),
      4.0,
      Paint()
        ..color = _tint.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );

    // Subtle cross-hatch in background for manga screen-tone feel
    final dotPaint = Paint()
      ..color = _tint.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    const ds = 6.0;
    for (double x = ds; x < size.width; x += ds) {
      for (double y = ds; y < size.height; y += ds) {
        canvas.drawCircle(Offset(x, y), 0.7, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_HeaderPatternPainter old) => old.category != category;
}

// ─────────────────────────────────────────────────────────────────────────────
// Back face — Brain Duel card design
// ─────────────────────────────────────────────────────────────────────────────

class _BackFace extends StatelessWidget {
  const _BackFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2226), Color(0xFF06161A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00D084).withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D084).withValues(alpha: 0.12),
            blurRadius: 14,
            spreadRadius: -3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
            Positioned(top: 8, left: 8,  child: _CornerOrnament()),
            Positioned(
              top: 8, right: 8,
              child: Transform.rotate(
                angle: math.pi / 2,
                child: _CornerOrnament(),
              ),
            ),
            Positioned(
              bottom: 8, left: 8,
              child: Transform.rotate(
                angle: -math.pi / 2,
                child: _CornerOrnament(),
              ),
            ),
            Positioned(
              bottom: 8, right: 8,
              child: Transform.rotate(
                angle: math.pi,
                child: _CornerOrnament(),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D084).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00D084).withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF00D084),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'BRAIN DUEL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF00D084),
                      letterSpacing: 2.8,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'KNOWLEDGE CARD',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 7.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 1.8,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Painters & helpers ───────────────────────────────────────────────────────

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D084).withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;

    const spacing = 14.0;
    const radius  = 1.2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter old) => false;
}

class _CornerOrnament extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: CustomPaint(painter: _CornerPainter()),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D084).withValues(alpha: 0.55)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
