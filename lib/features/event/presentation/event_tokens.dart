import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Manga page design tokens — scoped to the Events tab only.
/// Do NOT import these from elsewhere. Events tab is the only screen in
/// the app that uses a light background.
class EventTokens {
  EventTokens._();

  // Colors
  static const Color paper = Color(0xFFF5F2E8);
  static const Color ink = Color(0xFF0B0B0B);
  static const Color red = Color(0xFFE63946);
  static const Color gold = Color(0xFFFFD93D);
  static const Color silver = Color(0xFFC8CDD3);
  static const Color bronze = Color(0xFFD98E4A);

  // Accent bg (claimed milestone, "You" row, etc.)
  static const Color paperShade = Color(0xFFEEEAD7);
  static const Color paperHi = Color(0xFFFFFDF0);
  static const Color meYellow = Color(0xFFFFF0D4);
  static const Color doneGreen = Color(0xFF2A7D2A);

  // Shadow offset (px)
  static const double shadowOffset = 3;
  static const double borderWidth = 3;

  // Text styles via google_fonts (no asset bundling required — OFL handled by pkg)
  static TextStyle bangers({
    double size = 14,
    Color color = ink,
    double letterSpacing = 0.5,
    double height = 1.0,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.bangers(
      fontSize: size,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
    );
  }

  static TextStyle bebas({
    double size = 12,
    Color color = ink,
    double letterSpacing = 0.5,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: size,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: weight,
    );
  }

  static TextStyle inter({
    double size = 12,
    Color color = ink,
    FontWeight weight = FontWeight.w700,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );
  }
}
