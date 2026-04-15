import 'package:flutter/material.dart';
import '../../../core/theme/arcane_theme.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration_rounded, color: ArcaneColors.navActive, size: 56),
              const SizedBox(height: 16),
              const Text('EVENT', style: TextStyle(fontFamily: 'Fraunces', color: ArcaneColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Coming Soon', style: TextStyle(fontFamily: 'Inter', color: ArcaneColors.textMuted, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
