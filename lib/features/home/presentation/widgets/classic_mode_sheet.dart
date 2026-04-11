import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/arcane_theme.dart';

/// Bottom sheet shown when the user taps the Classic button on HomeScreen.
/// Presents Daily Classic, Survival, and Rush mode cards.
class ClassicModeSheet extends StatelessWidget {
  const ClassicModeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ArcaneColors.surfaceSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: ArcaneColors.borderSheet, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: ArcaneColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header row
          Row(
            children: [
              Text(
                'Pilih Mode',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ArcaneColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ArcaneColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: ArcaneColors.borderSubtle),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: ArcaneColors.textMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mode cards
          _ModeCard(
            icon: Icons.calendar_today_rounded,
            iconGradient: ArcaneGradients.modeDailyIcon,
            title: 'Daily Classic',
            description: 'Pilih kategori · 5 soal · 10s per soal',
            route: '/daily/select',
          ),
          const SizedBox(height: 10),
          _ModeCard(
            icon: Icons.local_fire_department_rounded,
            iconGradient: ArcaneGradients.modeSurvivalIcon,
            title: 'Survival',
            description: 'Jawab salah = game over',
            route: '/survival/game',
          ),
          const SizedBox(height: 10),
          _ModeCard(
            icon: Icons.bolt_rounded,
            iconGradient: ArcaneGradients.modeRushIcon,
            title: 'Rush',
            description: '60 detik · jawab sebanyak mungkin',
            route: '/rush/game',
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.description,
    required this.route,
  });

  final IconData icon;
  final LinearGradient iconGradient;
  final String title;
  final String description;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ArcaneColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ArcaneColors.borderSubtle, width: 1),
        ),
        child: Row(
          children: [
            // Mode icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: iconGradient,
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.colors.last.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            // Title + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.orbitron(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ArcaneColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ArcaneColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ArcaneColors.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
