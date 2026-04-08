import 'package:flutter/material.dart';

/// Brain Duel — Twilight Sky palette.
///
/// Inspired by Flappy Dragon's Western theme: layered sky gradient from
/// dusty blue through lavender and rose mist to peach horizon, with deep
/// twilight mountains in the foreground. Soft, adventurous, premium.
class AppColors {
  AppColors._();

  // === Sky layers (vertical gradient stops) ===
  static const Color skyTop = Color(0xFF6B7EB8); // dusty blue (zenith)
  static const Color skyUpper = Color(0xFF8A8BC4); // blue-violet
  static const Color skyMid = Color(0xFF9B8BC4); // soft lavender
  static const Color skyLow = Color(0xFFD4A5B8); // rose mist
  static const Color skyHorizon = Color(0xFFF5C7B8); // peach glow

  // === Foreground mountain layers (far → near) ===
  static const Color mountainFar = Color(0xFF8A7BAA); // distant violet
  static const Color mountainMid = Color(0xFF5D4E7A); // dusk purple
  static const Color mountainNear = Color(0xFF3A2D4D); // deep twilight
  static const Color mountainGround = Color(0xFF2A1E3A); // night earth

  // === Clouds ===
  static const Color cloudSoft = Color(0xFFF3D9E0); // pink cream
  static const Color cloudMid = Color(0xFFC9A5C7); // dusty rose
  static const Color cloudShadow = Color(0xFFA58AB0); // underside

  // === Background aliases (for compatibility) ===
  static const Color bgBase = Color(0xFF2A1E3A); // night earth fallback
  static const Color bgSurface = Color(0xFF3A2D4D); // deep twilight
  static const Color bgCard = Color(0x993A2D4D); // semi-transparent twilight (60%)
  static const Color bgCardElevated = Color(0xCC5D4E7A); // dusk purple 80%

  // === Brand & Action ===
  static const Color primary = Color(0xFF4FD1C5); // dragon cyan (from WESTERN text)
  static const Color primaryDark = Color(0xFF2FA89D);
  static const Color primaryLight = Color(0xFF7FE5DB);

  // === Accents ===
  static const Color accentParchment = Color(0xFFF5C7B8); // peach warm
  static const Color accentParchmentDim = Color(0xFFD4A598);

  // === Rarity Colors (soft pastel tuned to twilight palette) ===
  static const Color rarityCommon = Color(0xFFB8A58E); // stone beige
  static const Color rarityRare = Color(0xFF8FD9C9); // mint scale
  static const Color rarityUnique = Color(0xFFC9A5C7); // dusty rose
  static const Color rarityLegendary = Color(0xFFF5D76E); // soft gold

  // === Feedback ===
  static const Color correct = Color(0xFF7ED9A5); // mint green
  static const Color wrong = Color(0xFFE08585); // rose red
  static const Color warning = Color(0xFFF5D76E);
  static const Color info = Color(0xFF7FE5DB);

  // === Text ===
  static const Color textPrimary = Color(0xFFF8F0F5); // silk white
  static const Color textSecondary = Color(0xFFC9B8D9); // lavender gray
  static const Color textTertiary = Color(0xFF9A8BA8); // muted lavender
  static const Color textDisabled = Color(0xFF6B5F78);
  static const Color textOnLight = Color(0xFF3A2D4D); // for light cards

  // === Borders & Dividers ===
  static const Color borderSubtle = Color(0x338A7BAA); // 20% dusty violet
  static const Color borderStrong = Color(0x66C9A5C7); // 40% dusty rose

  // === Sky gradient (top → bottom, full twilight) ===
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.25, 0.5, 0.78, 1.0],
    colors: [skyTop, skyUpper, skyMid, skyLow, skyHorizon],
  );

  // === Card glass gradient (semi-transparent) ===
  static const LinearGradient cardGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xB35D4E7A), Color(0x993A2D4D)],
  );

  // === Primary CTA gradient ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4FD1C5), Color(0xFF2FA89D)],
  );

  // === Legendary glow ===
  static const LinearGradient legendaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5D76E), Color(0xFFD4A540)],
  );

  // === Backward-compat fallbacks (kept for old code refs) ===
  static const LinearGradient bgGradient = skyGradient;
  static const LinearGradient cardGradient = cardGlassGradient;
}
