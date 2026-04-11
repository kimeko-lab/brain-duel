import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/arcane_theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront_rounded, color: ArcaneColors.navActive, size: 56),
              const SizedBox(height: 16),
              Text('SHOP', style: GoogleFonts.orbitron(color: ArcaneColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Coming Soon', style: TextStyle(color: ArcaneColors.textMuted, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
