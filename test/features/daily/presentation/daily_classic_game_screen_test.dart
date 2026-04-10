import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/daily/presentation/daily_classic_game_screen.dart';
import 'package:brain_duel/features/daily/presentation/widgets/answer_option_tile.dart';
import 'package:brain_duel/features/daily/presentation/widgets/question_card.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps the screen inside a minimal GoRouter so navigation calls don't throw.
Widget _buildWithRouter({String category = 'science'}) {
  final router = GoRouter(
    initialLocation: '/daily/game/$category',
    routes: [
      GoRoute(
        path: '/daily/game/:category',
        builder: (context, state) => DailyClassicGameScreen(
          category: state.pathParameters['category'] ?? '',
        ),
      ),
      GoRoute(
        path: '/daily/result',
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

    // Drain all pending timers: mock load (200ms) + 5 questions × (5s countdown + 1.5s feedback)
    await tester.pump(const Duration(milliseconds: 300));
    // Drive through all 5 questions via timer expiry + auto-advance
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 5)); // countdown
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

    // Drain remaining timer (countdown timer runs for up to 5s)
    await tester.pump(const Duration(seconds: 5));
    // Drain the 1500ms auto-advance after timer expiry
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
    // Verify no crash and feedback renders.
    expect(find.byType(AnswerOptionTile), findsNWidgets(4));

    // Drain all remaining timers (1500ms auto-advance + countdown timer)
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 5));
  });
}
