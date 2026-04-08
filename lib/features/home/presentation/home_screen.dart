import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/rounded_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
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
            Text('Welcome back', style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('Brain Duel', style: AppTypography.displayMedium),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatChip('Rank', 'Bronze', AppColors.rarityCommon)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _buildStatChip('Crystals', '0', AppColors.primary)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _buildStatChip('Streak', '0d', AppColors.rarityLegendary)),
      ],
    ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildStatChip(String label, String value, Color accent) {
    return RoundedCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      borderColor: accent.withValues(alpha: 0.3),
      borderWidth: 1,
      child: Column(
        children: [
          Text(value,
              style: AppTypography.headlineMedium.copyWith(color: accent)),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }

  Widget _buildModesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Modes', style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Daily Classic',
          subtitle: '15 questions · 5 categories',
          icon: Icons.calendar_today_rounded,
          accent: AppColors.primary,
          isPrimary: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Survival',
          subtitle: 'How long can you last?',
          icon: Icons.local_fire_department_rounded,
          accent: AppColors.wrong,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildModeCard(
          context,
          title: 'Rush Mode',
          subtitle: '60 seconds — beat the clock',
          icon: Icons.bolt_rounded,
          accent: AppColors.rarityLegendary,
        ),
      ],
    ).animate(delay: 200.ms).fadeIn(duration: 500.ms);
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    bool isPrimary = false,
  }) {
    return RoundedCard(
      gradient: isPrimary ? AppColors.cardGradient : null,
      borderColor: accent.withValues(alpha: 0.4),
      borderWidth: isPrimary ? 2 : 1,
      glowColor: isPrimary ? accent : null,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title — coming next phase'),
            backgroundColor: AppColors.bgSurface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
            ),
            child: Icon(icon, color: accent, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondary, size: 28),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return RoundedCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: AppColors.rarityLegendary.withValues(alpha: 0.3),
      borderWidth: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: AppColors.rarityLegendary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('Phase 0 — Foundation',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.rarityLegendary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You\'re looking at the Brain Duel skeleton. '
            'Theme, navigation, and core widgets are in place. '
            'Next phase: question engine, scoring, and Daily Classic mode.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms);
  }
}
