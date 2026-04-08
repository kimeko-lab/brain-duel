import 'package:flutter/material.dart';

/// Brain Duel — Royal Academy color palette (Variant A).
///
/// Theme: Dark academia × royal deck. Scholarly tapi premium.
/// Differentiates dari trivia apps lain (yang biasanya bright/flat).
class AppColors {
  AppColors._();

  // === Backgrounds ===
  static const Color bgBase = Color(0xFF1A0F1F); // deep aubergine
  static const Color bgSurface = Color(0xFF2B1B33); // rich plum
  static const Color bgCard = Color(0xFF3D2644); // warm purple
  static const Color bgCardElevated = Color(0xFF4A2F52);

  // === Brand & Action ===
  static const Color primary = Color(0xFF14B8A6); // teal — fresh, smart
  static const Color primaryDark = Color(0xFF0F8A7C);
  static const Color primaryLight = Color(0xFF2DD4BF);

  // === Accents ===
  static const Color accentParchment = Color(0xFFF5E6C8); // warm cream
  static const Color accentParchmentDim = Color(0xFFC9B89A);

  // === Rarity Colors ===
  static const Color rarityCommon = Color(0xFFA16F4B); // bronze
  static const Color rarityRare = Color(0xFFB8C0CC); // silver
  static const Color rarityUnique = Color(0xFFA855F7); // amethyst
  static const Color rarityLegendary = Color(0xFFFBBF24); // warm gold

  // === Feedback Colors ===
  static const Color correct = Color(0xFF84CC16); // lime
  static const Color wrong = Color(0xFFEF4444); // warm red
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF60A5FA);

  // === Text ===
  static const Color textPrimary = Color(0xFFFDF4E3); // warm white
  static const Color textSecondary = Color(0xFFC9B8D9);
  static const Color textTertiary = Color(0xFF8B7B98);
  static const Color textDisabled = Color(0xFF5A4D63);

  // === Borders & Dividers ===
  static const Color borderSubtle = Color(0xFF4A2F52);
  static const Color borderStrong = Color(0xFF6B4877);

  // === Gradients ===
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0F1F), Color(0xFF110A14)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D2644), Color(0xFF2B1B33)],
  );

  static const LinearGradient legendaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFE89800)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF14B8A6), Color(0xFF0F8A7C)],
  );
}
