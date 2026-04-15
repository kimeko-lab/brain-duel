import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arcane_theme.dart';

/// Bottom sheet shown when the user taps the Classic button on HomeScreen.
class ClassicModeSheet extends StatelessWidget {
  const ClassicModeSheet({super.key});

  static const _modes = [
    _ModeData(
      icon: Icons.calendar_today_rounded,
      gradient: ArcaneGradients.modeDailyIcon,
      glowColor: Color(0x662d7aff),
      title: 'Daily Classic',
      description: 'Pilih kategori · 5 soal · 10s per soal',
      route: '/daily/select',
    ),
    _ModeData(
      icon: Icons.local_fire_department_rounded,
      gradient: ArcaneGradients.modeSurvivalIcon,
      glowColor: Color(0x66cc2222),
      title: 'Survival',
      description: 'Jawab salah = game over',
      route: '/survival/game',
    ),
    _ModeData(
      icon: Icons.bolt_rounded,
      gradient: ArcaneGradients.modeRushIcon,
      glowColor: Color(0x66cc9a22),
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
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mountainNear.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(
              top: BorderSide(color: ArcaneColors.borderSheet, width: 1),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 16, AppSpacing.lg, AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Row(
                children: [
                  const Text(
                    'Pilih Mode',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.mountainMid.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.close_rounded, color: AppColors.textTertiary, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Mode cards
              ...List.generate(_modes.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: i < _modes.length - 1 ? 10 : 0),
                  child: _ModeCard(data: _modes[i])
                      .animate(delay: Duration(milliseconds: 60 * i))
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.15, curve: Curves.easeOutCubic),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeData {
  const _ModeData({
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.title,
    required this.description,
    required this.route,
  });

  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final String title;
  final String description;
  final String route;
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.data});

  final _ModeData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          context.go(data.route);
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        splashColor: Colors.white.withValues(alpha: 0.06),
        highlightColor: Colors.white.withValues(alpha: 0.03),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mountainMid.withValues(alpha: 0.5),
                AppColors.mountainNear.withValues(alpha: 0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          child: Row(
            children: [
              // Mode icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: data.gradient,
                  boxShadow: [BoxShadow(color: data.glowColor, blurRadius: 12, spreadRadius: -2)],
                ),
                child: Icon(data.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
