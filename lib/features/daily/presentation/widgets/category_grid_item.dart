import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A glassmorphic grid tile representing a single quiz category.
class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.animationIndex = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Position index used to stagger the entrance animation.
  final int animationIndex;

  @override
  Widget build(BuildContext context) {
    final tile = _GlassTile(
      icon: icon,
      label: label,
      onTap: onTap,
    );

    return tile
        .animate(delay: Duration(milliseconds: 100 + animationIndex * 80))
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }
}

class _GlassTile extends StatefulWidget {
  const _GlassTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_GlassTile> createState() => _GlassTileState();
}

class _GlassTileState extends State<_GlassTile> {
  bool _pressed = false;

  static const double _radius = AppSpacing.cardRadius;

  @override
  Widget build(BuildContext context) {
    final borderColor = _pressed
        ? AppColors.primary.withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.12);

    final glowColor = _pressed
        ? AppColors.primary.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.25);

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
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
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, size: 28, color: AppColors.mountainNear),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.label,
                style: AppTypography.headlineSmall
                    .copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    final withShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: _pressed ? 28 : 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: content,
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: withShadow,
    );
  }
}
