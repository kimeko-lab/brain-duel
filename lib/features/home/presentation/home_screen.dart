import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/background/sky_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl),
                _buildStatsRow(),
                const SizedBox(height: AppSpacing.xl),
                _buildModesSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildPlaceholderCard(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME BACK',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Brain Duel',
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
        ),
        _GlassCircle(
          size: 52,
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.textPrimary,
            size: 28,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, curve: Curves.easeOutCubic);
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            label: 'RANK',
            value: 'Bronze',
            accent: AppColors.rarityCommon,
            delay: 0,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatChip(
            label: 'CRYSTALS',
            value: '0',
            accent: AppColors.primary,
            delay: 80,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatChip(
            label: 'STREAK',
            value: '0d',
            accent: AppColors.rarityLegendary,
            delay: 160,
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required Color accent,
    required int delay,
  }) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      borderColor: accent.withValues(alpha: 0.5),
      glowColor: accent.withValues(alpha: 0.25),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: accent,
              shadows: [
                Shadow(
                  color: accent.withValues(alpha: 0.5),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 150 + delay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.25, curve: Curves.easeOutCubic);
  }

  Widget _buildModesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Text(
            'Game Modes',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Daily Classic',
          subtitle: '15 questions · 5 categories',
          icon: Icons.calendar_today_rounded,
          accent: AppColors.primary,
          isPrimary: true,
          delay: 500,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Survival',
          subtitle: 'How long can you last?',
          icon: Icons.local_fire_department_rounded,
          accent: AppColors.wrong,
          delay: 600,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Rush Mode',
          subtitle: '60 seconds · beat the clock',
          icon: Icons.bolt_rounded,
          accent: AppColors.rarityLegendary,
          delay: 700,
        ),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required int delay,
    bool isPrimary = false,
  }) {
    return _GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: accent.withValues(alpha: isPrimary ? 0.7 : 0.4),
      glowColor: isPrimary ? accent.withValues(alpha: 0.35) : null,
      borderWidth: isPrimary ? 2 : 1,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title — coming next phase'),
            backgroundColor: AppColors.mountainNear,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: accent.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Icon(icon, color: accent, size: 30),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            size: 28,
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 550.ms)
        .slideY(begin: 0.15, curve: Curves.easeOutCubic);
  }

  Widget _buildPlaceholderCard() {
    return _GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: AppColors.rarityLegendary.withValues(alpha: 0.4),
      glowColor: AppColors.rarityLegendary.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.rarityLegendary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'PHASE 0 · FOUNDATION',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.rarityLegendary,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You\'re looking at the Brain Duel skeleton. '
            'Sky, theme, navigation, and core widgets are in place. '
            'Next up: question engine, scoring, and Daily Classic mode.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.85),
              height: 1.55,
            ),
          ),
        ],
      ),
    ).animate(delay: 900.ms).fadeIn(duration: 700.ms);
  }
}

// ============================================================================
// Glassmorphic widgets (backdrop blur for semi-transparent card effect)
// ============================================================================

/// A reusable glass card that blurs the content behind it.
class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    required this.padding,
    this.borderColor,
    this.glowColor,
    this.borderWidth = 1,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? glowColor;
  final double borderWidth;
  final VoidCallback? onTap;
  static const double radius = AppSpacing.cardRadius;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
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
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.12),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );

    final withShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
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
        borderRadius: BorderRadius.circular(radius),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: withShadow,
      ),
    );
  }
}

/// Circular glass button (for avatar / profile).
class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.mountainNear.withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
