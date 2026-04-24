import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'widgets/crystal_reward_widget.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg       = Color(0xFF06081F);
const Color _cardBg   = Color(0xFF111428);
const Color _border   = Color(0xFF2A2F52);
const Color _textSub  = Color(0xFF9CA3AF);
const Color _primary  = Color(0xFF6366F1);

class DailyClassicResultScreen extends StatelessWidget {
  const DailyClassicResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  // ── Rank tier helpers ──────────────────────────────────────────────────────
  static const _tiers = [
    _RankTier(name: 'Bronze',   color: AppColors.rarityCommon,   min: 0,    max: 999),
    _RankTier(name: 'Silver',   color: AppColors.textSecondary,  min: 1000, max: 1999),
    _RankTier(name: 'Gold',     color: AppColors.rarityLegendary, min: 2000, max: 2999),
    _RankTier(name: 'Platinum', color: _primary,                 min: 3000, max: 4000),
  ];

  static _RankTier _tierForScore(int score) {
    for (final t in _tiers) {
      if (score <= t.max) return t;
    }
    return _tiers.last;
  }

  static double _progressForScore(int score, _RankTier tier) {
    final range = tier.max - tier.min;
    if (range <= 0) return 1.0;
    return (score - tier.min).clamp(0, range) / range;
  }

  @override
  Widget build(BuildContext context) {
    final score        = extra['score']        as int? ?? 0;
    final crystals     = extra['crystals']     as int? ?? 0;
    final correctCount = extra['correctCount'] as int? ?? 0;
    final totalCount   = extra['totalCount']   as int? ?? 5;

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

              // ── Header ──────────────────────────────────────────────────
              Column(
                children: [
                  Text(
                    'GAME OVER',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _textSub,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Daily Classic',
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

              // ── Correct / total chip ─────────────────────────────────────
              Center(
                child: Text(
                  '$correctCount / $totalCount correct',
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

              // ── Rank progress ─────────────────────────────────────────────
              _buildRankProgress(score)
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),

              const SizedBox(height: AppSpacing.xxl),

              // ── Buttons ──────────────────────────────────────────────────
              _PrimaryButton(
                label: 'Play Again',
                onTap: () => context.go('/daily/select'),
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

  Widget _buildRankProgress(int score) {
    final tier     = _tierForScore(score);
    final progress = _progressForScore(score, tier);

    return _DarkCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: tier.color.withValues(alpha: 0.45),
      glowColor: tier.color.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RANK PROGRESS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _textSub,
                  letterSpacing: 2,
                ),
              ),
              Text(
                tier.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: tier.color,
                  shadows: [
                    Shadow(
                      color: tier.color.withValues(alpha: 0.45),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3D3D),
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        tier.color.withValues(alpha: 0.75),
                        tier.color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                    boxShadow: [
                      BoxShadow(
                        color: tier.color.withValues(alpha: 0.40),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            tier.min == 3000
                ? 'Max rank achieved'
                : '${score - tier.min} / ${tier.max - tier.min} pts',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: _textSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable solid dark card — no BackdropFilter
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
// Buttons
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

// ─────────────────────────────────────────────────────────────────────────────
// Rank tier data
// ─────────────────────────────────────────────────────────────────────────────

class _RankTier {
  const _RankTier({
    required this.name,
    required this.color,
    required this.min,
    required this.max,
  });

  final String name;
  final Color color;
  final int min;
  final int max;
}
