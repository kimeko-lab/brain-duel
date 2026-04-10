import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/background/sky_background.dart';
import 'widgets/category_grid_item.dart';

// ---------------------------------------------------------------------------
// Data model — private to this file
// ---------------------------------------------------------------------------

class _Category {
  const _Category(this.name, this.key, this.icon);

  final String name;
  final String key;
  final IconData icon;
}

const _categories = [
  _Category('Science', 'science', Icons.science_rounded),
  _Category('Geography', 'geography', Icons.public_rounded),
  _Category('History', 'history', Icons.history_edu_rounded),
  _Category('Sport', 'sport', Icons.sports_soccer_rounded),
  _Category('Entertainment', 'entertainment', Icons.movie_rounded),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CategorySelectScreen extends ConsumerWidget {
  const CategorySelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Daily Classic'),
      ),
      body: SkyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a category',
                  style: AppTypography.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return CategoryGridItem(
                        icon: cat.icon,
                        label: cat.name,
                        animationIndex: index,
                        onTap: () =>
                            context.go('/daily/game/${cat.key}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
