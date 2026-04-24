import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../daily/presentation/widgets/crystal_reward_widget.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg      = Color(0xFF06081F);
const Color _cardBg  = Color(0xFF111428);
const Color _border  = Color(0xFF2A2F52);
const Color _textSub = Color(0xFF9CA3AF);
const Color _primary = Color(0xFF6366F1);

class SurvivalResultScreen extends StatelessWidget {
  const SurvivalResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  @override
  Widget build(BuildContext context) {
    final score        = extra['score']        as int? ?? 0;
    final crystals     = extra['crystals']     as int? ?? 0;
    final correctCount = extra['correctCount'] as int? ?? 0;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // ── Header ───────────────────────────────────────────────────
              Column(
                children: [
                  const Text(
                    'GAME OVER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _textSub,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Survival',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.2, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.xl),

              // ── Score card ───────────────────────────────────────────────
              _DarkCard(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xl,
                  horizontal: AppSpacing.lg,
                ),
                borderColor: _primary.withValues(alpha: 0.55),
                glowColor: _primary.withValues(alpha: 0.20),
                child: Column(
                  children: [
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _textSub,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$score',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: _primary,
                        height: 1.0,
                        letterSpacing: -1.5,
                        shadows: [
                          Shadow(
                            color: Color(0x556366F1),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.md),

              // ── Streak message ───────────────────────────────────────────
              Center(
                child: Text(
                  correctCount > 0
                      ? '$correctCount correct in a row!'
                      : 'Better luck next time!',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: _textSub,
                  ),
                ),
              )
                  .animate(delay: 350.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              // ── Crystal reward ───────────────────────────────────────────
              CrystalRewardWidget(crystals: crystals)
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.xl),

              // ── Best streak chip (only when > 0) ─────────────────────────
              if (correctCount > 0)
                _buildStreakChip(correctCount)
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.15, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.xxl),

              // ── Buttons ──────────────────────────────────────────────────
              _PrimaryButton(
                label: 'Play Again',
                onTap: () => context.go('/survival/game'),
              )
                  .animate(delay: 850.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.sm),

              _SecondaryButton(
                label: 'Home',
                onTap: () => context.go('/'),
              )
                  .animate(delay: 950.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakChip(int correctCount) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: _primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
          border: Border.all(
            color: _primary.withValues(alpha: 0.40),
            width: 1,
          ),
        ),
        child: Text(
          'STREAK: $correctCount',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _primary,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Solid dark card — no BackdropFilter (copied verbatim from Daily Classic)
// ─────────────────────────────────────────────────────────────────────────────

class _DarkCard extends StatelessWidget {
  const _DarkCard({
    required this.child,
    required this.padding,
    this.borderColor,
    this.glowColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? glowColor;
  final VoidCallback? onTap;

  static const double _radius = AppSpacing.cardRadius;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: borderColor ?? _border,
          width: 1.2,
        ),
        boxShadow: [
          if (glowColor != null)
            BoxShadow(
              color: glowColor!,
              blurRadius: 28,
              spreadRadius: -4,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        splashColor: Colors.white.withValues(alpha: 0.06),
        highlightColor: Colors.white.withValues(alpha: 0.03),
        child: content,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Buttons (copied verbatim from Daily Classic)
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF008A5B)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.35),
            blurRadius: 18,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          splashColor: Colors.white.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF06081F),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DarkCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      borderColor: _primary.withValues(alpha: 0.40),
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textSub,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
