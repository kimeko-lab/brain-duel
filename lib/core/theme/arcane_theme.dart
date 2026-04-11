import 'package:flutter/material.dart';

/// Royal Arcane color tokens used by AppShell, HomeScreen, and ClassicModeSheet.
/// Existing app_colors.dart / app_typography.dart / app_spacing.dart are
/// kept unchanged for game screens. This file is purely additive.
abstract final class ArcaneColors {
  // Background gradient
  static const Color bgDeep = Color(0xFF130820);
  static const Color bgMid = Color(0xFF1e0b35);

  // Surface (card / sheet backgrounds)
  static const Color surface = Color(0x0Fffffff); // ~6% white
  static const Color surfaceSheet = Color(0xFF1a0830);
  static const Color borderSubtle = Color(0x33C832FF); // 20% violet
  static const Color borderSheet = Color(0x4DC832FF); // 30% violet

  // Primary CTA gradient stops
  static const Color primaryStart = Color(0xFF8a1aaa);
  static const Color primaryEnd = Color(0xFFcc32ff);
  static const Color primaryGlow = Color(0x66C832FF); // 40% violet

  // Accent (currency, active highlights)
  static const Color accent = Color(0xFFff9a32);
  static const Color accentGlow = Color(0x59FF9A32); // 35% orange

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0x80ffffff); // 50% white

  // Bottom nav
  static const Color navBg = Color(0xFF0e061a);
  static const Color navActive = Color(0xFFcc32ff);
  static const Color navInactive = Color(0x59ffffff); // 35% white

  // Mode icon gradient stops — Classic (main CTA)
  static const Color modeClassicStart = Color(0xFF5e1a8a);
  static const Color modeClassicEnd = Color(0xFFa020f0);
  // Daily Classic (in sheet)
  static const Color modeDailyStart = Color(0xFF1a4a8a);
  static const Color modeDailyEnd = Color(0xFF2d7aff);
  // Survival (in sheet)
  static const Color modeSurvivalStart = Color(0xFF8a1a1a);
  static const Color modeSurvivalEnd = Color(0xFFcc2222);
  // Rush (in sheet)
  static const Color modeRushStart = Color(0xFF8a5a1a);
  static const Color modeRushEnd = Color(0xFFcc9a22);
}

abstract final class ArcaneGradients {
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ArcaneColors.primaryStart, ArcaneColors.primaryEnd],
  );

  static const RadialGradient background = RadialGradient(
    center: Alignment(0.0, -0.3),
    radius: 1.2,
    colors: [ArcaneColors.bgDeep, ArcaneColors.bgMid],
  );

  static const LinearGradient modeClassicIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ArcaneColors.modeClassicStart, ArcaneColors.modeClassicEnd],
  );

  static const LinearGradient modeDailyIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ArcaneColors.modeDailyStart, ArcaneColors.modeDailyEnd],
  );

  static const LinearGradient modeSurvivalIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ArcaneColors.modeSurvivalStart, ArcaneColors.modeSurvivalEnd],
  );

  static const LinearGradient modeRushIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ArcaneColors.modeRushStart, ArcaneColors.modeRushEnd],
  );
}
