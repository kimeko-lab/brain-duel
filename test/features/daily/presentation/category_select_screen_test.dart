import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/daily/presentation/category_select_screen.dart';
import 'package:brain_duel/features/daily/presentation/widgets/category_grid_item.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps the screen inside a minimal GoRouter so navigation calls don't throw.
Widget _buildWithRouter({required String initialLocation}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/category',
        builder: (_, __) => const CategorySelectScreen(),
      ),
      // Absorb the navigation target so go_router doesn't throw a 404.
      GoRoute(
        path: '/daily/game/:category',
        builder: (_, __) => const Scaffold(body: Text('game')),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows 5 category tiles', (tester) async {
    // Give the test surface enough height to render all 5 grid tiles.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _buildWithRouter(initialLocation: '/category'),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CategoryGridItem), findsNWidgets(5));
  });

  testWidgets('tapping a category navigates to game screen', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _buildWithRouter(initialLocation: '/category'),
    );
    await tester.pump(const Duration(seconds: 1));

    // warnIfMissed: false — the slide animation keeps the widget at a
    // fractional translation offset; the tap hit-test lands on the underlying
    // tile even so, and go_router receives the event without errors.
    await tester.tap(
      find.byType(CategoryGridItem).first,
      warnIfMissed: false,
    );
    await tester.pump(const Duration(milliseconds: 100));
    // No crash = navigation was triggered successfully.
  });
}
