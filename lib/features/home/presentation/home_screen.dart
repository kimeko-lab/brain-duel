import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/arcane_theme.dart';
import 'widgets/classic_mode_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showClassicSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ClassicModeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            const Spacer(flex: 1),
            const _HeroTitle(),
            const Spacer(flex: 1),
            _ModeButtons(onClassicTap: () => _showClassicSheet(context)),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top bar: currency + avatar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _CurrencyBadge(amount: 240, isGold: false),
          _AvatarWidget(),
          _CurrencyBadge(amount: 80, isGold: true),
        ],
      ),
    );
  }
}

class _CurrencyBadge extends StatelessWidget {
  const _CurrencyBadge({required this.amount, required this.isGold});

  final int amount;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    final iconColor = isGold ? ArcaneColors.accent : Colors.white;
    final textColor = isGold ? ArcaneColors.accent : ArcaneColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ArcaneColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ArcaneColors.borderSubtle, width: 1),
        boxShadow: [
          if (isGold)
            BoxShadow(
              color: ArcaneColors.accentGlow,
              blurRadius: 10,
              spreadRadius: -3,
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Book icon — styled circle container
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isGold
                  ? ArcaneColors.accent.withValues(alpha: 0.25)
                  : ArcaneColors.primaryEnd.withValues(alpha: 0.2),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              size: 13,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$amount',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
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
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ArcaneGradients.primaryCta,
        boxShadow: [
          BoxShadow(
            color: ArcaneColors.primaryGlow,
            blurRadius: 14,
            spreadRadius: -2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF2a0a48),
        ),
        child: const Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero title
// ─────────────────────────────────────────────────────────────────────────────

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BRAIN DUEL',
          style: GoogleFonts.orbitron(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: ArcaneColors.textPrimary,
            letterSpacing: 4,
            shadows: [
              Shadow(
                color: ArcaneColors.primaryGlow,
                blurRadius: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Test your mind. Duel the world.',
          style: TextStyle(
            fontSize: 13,
            color: ArcaneColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode buttons
// ─────────────────────────────────────────────────────────────────────────────

class _ModeButtons extends StatelessWidget {
  const _ModeButtons({required this.onClassicTap});

  final VoidCallback onClassicTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Classic — enabled
          _ClassicButton(onTap: onClassicTap),
          const SizedBox(height: 12),
          // Versus — coming soon
          const _VersusButton(),
        ],
      ),
    );
  }
}

class _ClassicButton extends StatelessWidget {
  const _ClassicButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          gradient: ArcaneGradients.primaryCta,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ArcaneColors.primaryGlow,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _ModeIconWidget(gradient: ArcaneGradients.modeClassicIcon, icon: Icons.auto_stories_rounded),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLASSIC',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Daily · Survival · Rush',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}

class _VersusButton extends StatelessWidget {
  const _VersusButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: ArcaneColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ArcaneColors.borderSubtle, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _ModeIconWidget(
            gradient: const LinearGradient(
              colors: [Color(0x22ffffff), Color(0x11ffffff)],
            ),
            icon: Icons.sports_kabaddi_rounded,
            iconColor: Colors.white30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VERSUS',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ArcaneColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 12,
                    color: ArcaneColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // "SOON" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ArcaneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ArcaneColors.accent.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Text(
              'SOON',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: ArcaneColors.accent.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared: styled mode icon widget (gradient circle + icon)
// ─────────────────────────────────────────────────────────────────────────────

class _ModeIconWidget extends StatelessWidget {
  const _ModeIconWidget({
    required this.gradient,
    required this.icon,
    this.iconColor = Colors.white,
  });

  final LinearGradient gradient;
  final IconData icon;
  final Color iconColor;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: _size * 0.5),
    );
  }
}
