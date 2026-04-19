import 'package:flutter/material.dart';

import '../event_tokens.dart';

/// Thick ink border + offset drop shadow container — the core "panel" element.
/// Shadow is solid (no blur) to mimic comic ink drop-shadow.
class MangaPanel extends StatelessWidget {
  const MangaPanel({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderWidth = EventTokens.borderWidth,
    this.shadowOffset = EventTokens.shadowOffset,
    this.shadowColor = EventTokens.ink,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double borderWidth;
  final double shadowOffset;
  final Color shadowColor;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(color: EventTokens.ink, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: clipBehavior,
      padding: padding,
      child: child,
    );
  }
}
