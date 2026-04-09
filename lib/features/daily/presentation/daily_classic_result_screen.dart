import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/background/sky_background.dart';
import 'widgets/crystal_reward_widget.dart';

class DailyClassicResultScreen extends StatelessWidget {
  const DailyClassicResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  // --- Rank tier helpers ---
  static const _tiers = [
    _RankTier(name: 'Bronze', color: AppColors.rarityCommon, min: 0, max: 999),
    _RankTier(name: 'Silver', color: AppColors.textSecondary, min: 1000, max: 1999),
    _RankTier(name: 'Gold', color: AppColors.rarityLegendary, min: 2000, max: 2999),
    _RankTier(name: 'Platinum', color: AppColors.primary, min: 3000, max: 4000),
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
    final within = (score - tier.min).clamp(0, range);
    return within / range;
  }

  @override
  Widget build(BuildContext context) {
    final score = extra['score'] as int? ?? 0;
    final crystals = extra['crystals'] as int? ?? 0;
    final correctCount = extra['correctCount'] as int? ?? 0;
    final totalCount = extra['totalCount'] as int? ?? 5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // ── Header ────────────────────────────────────────────────
                Column(
                  children: [
                    Text(
                      'GAME OVER',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Daily Classic',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: -0.2, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.xl),

                // ── Score Card ────────────────────────────────────────────
                _GlassCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xl,
                    horizontal: AppSpacing.lg,
                  ),
                  borderColor: AppColors.primary.withValues(alpha: 0.7),
                  glowColor: AppColors.primary.withValues(alpha: 0.3),
                  child: Column(
                    children: [
                      Text(
                        'SCORE',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$score',
                        textAlign: TextAlign.center,
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.primary,
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.7),
                              blurRadius: 20,
                            ),
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 40,
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

                // ── Correct/total chip ────────────────────────────────────
                Center(
                  child: Text(
                    '$correctCount / $totalCount correct',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
                    .animate(delay: 350.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.xl),

                // ── Crystal Reward ────────────────────────────────────────
                CrystalRewardWidget(crystals: crystals)
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.xl),

                // ── Rank Progress ─────────────────────────────────────────
                _buildRankProgress(score)
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.15, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.xxl),

                // ── Buttons ───────────────────────────────────────────────
                _buildButton(
                  context,
                  label: 'Play Again',
                  onTap: () => context.go('/daily/select'),
                  primary: true,
                )
                    .animate(delay: 850.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.sm),

                _buildButton(
                  context,
                  label: 'Home',
                  onTap: () => context.go('/'),
                  primary: false,
                )
                    .animate(delay: 950.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankProgress(int score) {
    final tier = _tierForScore(score);
    final progress = _progressForScore(score, tier);

    return _GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: tier.color.withValues(alpha: 0.5),
      glowColor: tier.color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RANK PROGRESS',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              Text(
                tier.name,
                style: AppTypography.labelLarge.copyWith(
                  color: tier.color,
                  shadows: [
                    Shadow(
                      color: tier.color.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Stack(
            children: [
              // Track
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.mountainNear.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                ),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        tier.color.withValues(alpha: 0.8),
                        tier.color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                    boxShadow: [
                      BoxShadow(
                        color: tier.color.withValues(alpha: 0.5),
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
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    required bool primary,
  }) {
    if (primary) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            splashColor: Colors.white.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.mountainNear,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _GlassCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      borderColor: AppColors.borderStrong,
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Internal glass card (mirrors HomeScreen pattern, kept local to avoid
// coupling — HomeScreen's _GlassCard is private)
// ============================================================================

class _GlassCard extends StatelessWidget {
  const _GlassCard({
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
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mountainMid.withValues(alpha: 0.55),
                AppColors.mountainNear.withValues(alpha: 0.65),
              ],
            ),
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );

    final withShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          if (glowColor != null)
            BoxShadow(
              color: glowColor!,
              blurRadius: 32,
              spreadRadius: -4,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: content,
    );

    if (onTap == null) return withShadow;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: withShadow,
      ),
    );
  }
}

/// Immutable data class for rank tiers.
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
