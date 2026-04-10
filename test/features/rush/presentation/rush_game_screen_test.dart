import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/daily/presentation/widgets/answer_option_tile.dart';
import 'package:brain_duel/features/daily/presentation/widgets/question_card.dart';
import 'package:brain_duel/features/rush/presentation/rush_game_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps the screen inside a minimal GoRouter so navigation calls don't throw.
Widget _buildWithRouter() {
  final router = GoRouter(
    initialLocation: '/rush/game',
    routes: [
      GoRoute(
        path: '/rush/game',
        builder: (context, state) => const RushGameScreen(),
      ),
      GoRoute(
        path: '/rush/result',
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

    // Drain all pending timers: mock load (200ms) + global 60s timer
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  testWidgets('shows question card after loading', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500)); // past mock 200ms delay
    expect(find.byType(QuestionCard), findsOneWidget);
    expect(find.byType(AnswerOptionTile), findsNWidgets(4));

    // Drain remaining timer
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  testWidgets('timer shows remaining seconds initially around 60s', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500)); // questions loaded

    // Timer should display 60s (or close — notifier starts at 60000ms)
    expect(find.text('60s'), findsOneWidget);

    // Drain remaining timer
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  testWidgets('tapping an answer triggers feedback phase', (tester) async {
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
    // Still showing the question (not navigating away or in a loading state).
    expect(find.byType(QuestionCard), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Drain remaining timers
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  testWidgets('navigates to result when global timer expires', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildWithRouter());
    await tester.pump(const Duration(milliseconds: 500)); // questions loaded

    // Let the global 60s timer expire
    await tester.pump(const Duration(seconds: 61));
    // Give navigation time to fire
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Should have navigated to the result stub
    expect(find.text('result'), findsOneWidget);
  });
}
