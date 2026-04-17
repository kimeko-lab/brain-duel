import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/knowledge_card_model.dart';

// ─── Category helpers (mirrors home screen) ───────────────────────────────────

List<Color> _gradientForCategory(String cat) {
  const map = <String, List<Color>>{
    'science':       [Color(0xFFF97316), Color(0xFFC2410C)],
    'geography':     [Color(0xFF0EA5E9), Color(0xFF0369A1)],
    'history':       [Color(0xFFA855F7), Color(0xFF6B21A8)],
    'sport':         [Color(0xFF00D084), Color(0xFF008A5B)],
    'entertainment': [Color(0xFFEC4899), Color(0xFFBE185D)],
    'events':        [Color(0xFF7C3AED), Color(0xFF3730A3)],
  };
  return map[cat] ?? [const Color(0xFF00D084), const Color(0xFF008A5B)];
}

IconData _iconForCategory(String cat) {
  switch (cat) {
    case 'science':       return Icons.science_rounded;
    case 'geography':     return Icons.public_rounded;
    case 'history':       return Icons.history_edu_rounded;
    case 'sport':         return Icons.sports_rounded;
    case 'entertainment': return Icons.movie_rounded;
    case 'events':        return Icons.celebration_rounded;
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

          // The face we want to show
          final face = isFront
              ? _FrontFace(card: widget.card)
              : _BackFace();

          // Counter-rotate the back face so it isn't mirrored
          final faceAngle = isFront ? angle : angle - math.pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // perspective
              ..rotateY(faceAngle),
            child: face,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Front face — category header + question + answer + icon footer
// ─────────────────────────────────────────────────────────────────────────────

class _FrontFace extends StatelessWidget {
  const _FrontFace({required this.card});

  final KnowledgeCardModel card;

  @override
  Widget build(BuildContext context) {
    final gradient    = _gradientForCategory(card.category);
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
            // ── Header: category gradient + rarity ──────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.category.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing: 1.3,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      // Filled stars only
                      for (int i = 0; i < card.rarity.stars; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: rarityColor,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        card.rarity.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: rarityColor,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Body: question + answer ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
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

                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFF2D4A4A),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),

                    // Answer
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
              height: 42,
              color: const Color(0xFF081518),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: Colors.white.withValues(alpha: 0.22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Back face — Brain Duel design
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
            // Dot grid pattern
            Positioned.fill(
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
            // Corner ornaments
            Positioned(
              top: 8,
              left: 8,
              child: _CornerOrnament(),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Transform.rotate(
                angle: math.pi / 2,
                child: _CornerOrnament(),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Transform.rotate(
                angle: -math.pi / 2,
                child: _CornerOrnament(),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Transform.rotate(
                angle: math.pi,
                child: _CornerOrnament(),
              ),
            ),
            // Center content
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
    const radius = 1.2;

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

    // L-shape corner
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
