import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../event_tokens.dart';

/// Chunky manga button — ink/paper or custom bg, Bangers label, optional tilt.
class InkButton extends StatelessWidget {
  const InkButton({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor = EventTokens.ink,
    this.foregroundColor = EventTokens.paper,
    this.fontSize = 11,
    this.rotationDeg = 0,
    this.horizontalPadding = 10,
    this.verticalPadding = 3,
    this.shadow = true,
    this.hapticOnTap = true,
  });

  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final double fontSize;
  final double rotationDeg;
  final double horizontalPadding;
  final double verticalPadding;
  final bool shadow;
  final bool hapticOnTap;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: EventTokens.ink, width: 2),
        boxShadow: shadow
            ? const [
                BoxShadow(
                  color: EventTokens.ink,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: EventTokens.bangers(
          size: fontSize,
          color: foregroundColor,
          letterSpacing: 0.6,
        ),
      ),
    );

    final rotated = rotationDeg == 0
        ? button
        : Transform.rotate(
            angle: rotationDeg * 3.1415926535 / 180,
            child: button,
          );

    if (onTap == null) return rotated;

    return GestureDetector(
      onTap: () {
        if (hapticOnTap) HapticFeedback.selectionClick();
        onTap!();
      },
      child: rotated,
    );
  }
}
