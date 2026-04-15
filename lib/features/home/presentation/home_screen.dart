import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildModesSection(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left currency
        _CurrencyBadge(
          icon: Icons.menu_book_rounded,
          amount: 240,
          label: 'Silver',
          accent: AppColors.primary,
        ),
        const Spacer(),
        // Center: avatar + title stacked
        Column(
          children: [
            _AvatarWidget(),
            const SizedBox(height: AppSpacing.sm),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFe8d8ff), AppColors.primary],
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: const Text(
                'Brain Duel',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Where scholars become champions.',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ).copyWith(color: AppColors.primary.withValues(alpha: 0.7)),
            ),
          ],
        ),
        const Spacer(),
        // Right currency
        _CurrencyBadge(
          icon: Icons.menu_book_rounded,
          amount: 80,
          label: 'Gold',
          accent: AppColors.rarityLegendary,
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.15, curve: Curves.easeOutCubic);
  }

  Widget _buildModesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Game Modes',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFc8b8f0),
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 24, height: 2, color: AppColors.primary),
            ],
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: AppSpacing.md),
        // Classic — opens bottom sheet
        _ModeCard(
          title: 'Classic',
          subtitle: 'Daily · Survival · Rush',
          icon: Icons.auto_stories_rounded,
          accent: AppColors.primary,
          isPrimary: true,
          delay: 400,
          onTap: () => _showClassicSheet(context),
        ),
        const SizedBox(height: AppSpacing.md),
        // Versus — coming soon
        Opacity(
          opacity: 0.35,
          child: _ModeCard(
            title: 'Versus',
            subtitle: 'Coming Soon',
            icon: Icons.sports_kabaddi_rounded,
            accent: AppColors.rarityUnique,
            isPrimary: false,
            delay: 500,
            comingSoon: true,
          ),
        ),
      ],
    );
  }

  void _showClassicSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ClassicModeSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyBadge extends StatelessWidget {
  const _CurrencyBadge({
    required this.icon,
    required this.amount,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final int amount;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderColor: accent.withValues(alpha: 0.4),
      glowColor: accent.withValues(alpha: 0.15),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 3),
          Text(
            '$amount',
            style: AppTypography.labelLarge.copyWith(color: accent),
          ),
          Text(
            label,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.mountainNear.withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 14,
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.person_rounded, color: AppColors.textPrimary, size: 30),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode card — identical pattern to the old home_screen game mode cards
// ─────────────────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.delay,
    this.isPrimary = false,
    this.comingSoon = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int delay;
  final bool isPrimary;
  final bool comingSoon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: accent.withValues(alpha: isPrimary ? 1.0 : 0.4),
      glowColor: isPrimary ? accent.withValues(alpha: 0.3) : null,
      borderWidth: isPrimary ? 1.5 : 1.0,
      onTap: comingSoon
          ? null
          : onTap ??
              () {
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
              gradient: comingSoon ? null : AppColors.primaryGradient,
              color: comingSoon ? accent.withValues(alpha: 0.08) : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: comingSoon
                  ? Border.all(color: accent.withValues(alpha: 0.2), width: 1.5)
                  : null,
              boxShadow: [
                if (!comingSoon)
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
              ],
            ),
            child: Icon(
              icon,
              color: comingSoon
                  ? accent.withValues(alpha: 0.4)
                  : accent,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: comingSoon ? AppColors.textTertiary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: comingSoon
                        ? AppColors.textDisabled
                        : AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (comingSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryDark,
                  width: 1,
                ),
              ),
              child: const Text(
                'SOON',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            )
          else
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Classic mode bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ClassicModeSheet extends StatelessWidget {
  const _ClassicModeSheet();

  static const _modes = [
    _SheetMode(
      icon: Icons.calendar_today_rounded,
      accent: AppColors.primary,
      title: 'Daily Classic',
      description: '5 soal · 10s per soal · pilih kategori',
      route: '/daily/select',
    ),
    _SheetMode(
      icon: Icons.local_fire_department_rounded,
      accent: AppColors.wrong,
      title: 'Survival',
      description: 'Jawab salah = game over',
      route: '/survival/game',
    ),
    _SheetMode(
      icon: Icons.bolt_rounded,
      accent: AppColors.rarityLegendary,
      title: 'Rush',
      description: '60 detik · jawab sebanyak mungkin',
      route: '/rush/game',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mountainMid.withValues(alpha: 0.90),
                AppColors.mountainNear.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(
              top: BorderSide(color: AppColors.borderStrong, width: 1),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 14, AppSpacing.lg, AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Row(
                children: [
                  Text('Pilih Mode', style: AppTypography.headlineMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.mountainNear.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Mode rows
              ...List.generate(_modes.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: i < _modes.length - 1 ? 10 : 0),
                  child: _SheetModeRow(mode: _modes[i])
                      .animate(delay: Duration(milliseconds: 50 * i))
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetMode {
  const _SheetMode({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
    required this.route,
  });
  final IconData icon;
  final Color accent;
  final String title;
  final String description;
  final String route;
}

class _SheetModeRow extends StatelessWidget {
  const _SheetModeRow({required this.mode});
  final _SheetMode mode;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: mode.accent.withValues(alpha: 0.4),
      glowColor: mode.accent.withValues(alpha: 0.18),
      onTap: () {
        Navigator.of(context).pop();
        context.go(mode.route);
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: mode.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: mode.accent.withValues(alpha: 0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: mode.accent.withValues(alpha: 0.3),
                  blurRadius: 14,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Icon(mode.icon, color: mode.accent, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode.title, style: AppTypography.headlineSmall),
                const SizedBox(height: 2),
                Text(
                  mode.description,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glass card widget — identical to the pattern used in game screens
// ─────────────────────────────────────────────────────────────────────────────

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
              width: borderWidth,
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
            BoxShadow(color: glowColor!, blurRadius: 32, spreadRadius: -4),
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
