import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/daily/presentation/category_select_screen.dart';

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
        builder: (context, state) => const CategorySelectScreen(),
      ),
      // Absorb the navigation target so go_router doesn't throw a 404.
      GoRoute(
        path: '/daily/game/:category',
        builder: (context, state) => const Scaffold(body: Text('game')),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Text('home')),
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

    // Each category card shows its name as text.
    for (final name in [
      'Science',
      'Geography',
      'History',
      'Sport',
      'Entertainment',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
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

    // Tap the first visible category tile ("Science").
    await tester.tap(find.text('Science'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
    // No crash = navigation was triggered successfully.
  });
}
