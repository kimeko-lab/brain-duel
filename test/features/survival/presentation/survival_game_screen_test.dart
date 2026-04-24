import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/core/widgets/game/answer_option_tile.dart';
import 'package:brain_duel/core/widgets/game/question_card.dart';
import 'package:brain_duel/features/survival/presentation/survival_game_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps the screen inside a minimal GoRouter so navigation calls don't throw.
Widget _buildWithRouter() {
  final router = GoRouter(
    initialLocation: '/survival/game',
    routes: [
      GoRoute(
        path: '/survival/game',
        builder: (context, state) => const SurvivalGameScreen(),
      ),
      GoRoute(
        path: '/survival/result',
        builder: (context, state) => const Scaffold(body: Text('result')),
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
  testWidgets('shows loading indicator initially', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(); // let initState fire
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Drain all pending timers: mock load (200ms) + questions × (10s countdown + 1.5s feedback)
    await tester.pump(const Duration(milliseconds: 300));
    // Drive through all questions via timer expiry + auto-advance (survival ends on wrong/expired)
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 10)); // countdown
      await tester.pump(const Duration(milliseconds: 1600)); // feedback delay
    }
  });

  testWidgets('shows question after loading', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500)); // past mock 200ms delay
    expect(find.byType(QuestionCard), findsOneWidget);
    expect(find.byType(AnswerOptionTile), findsNWidgets(4));

    // Drain remaining timer
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('tapping an answer shows feedback', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(
      find.byType(AnswerOptionTile).first,
      warnIfMissed: false,
    );
    await tester.pump(const Duration(milliseconds: 100));
    // Phase should now be showingFeedback — tiles are non-interactive.
    expect(find.byType(AnswerOptionTile), findsNWidgets(4));

    // Drain remaining timers
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('navigates to result when game finishes', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500)); // questions loaded

    // Let the timer expire to end the game immediately
    await tester.pump(const Duration(seconds: 11));
    // Give navigation time to fire
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Should have navigated to the result stub
    expect(find.text('result'), findsOneWidget);
  });
}
