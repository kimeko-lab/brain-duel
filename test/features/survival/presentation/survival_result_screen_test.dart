import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/survival/presentation/survival_result_screen.dart';

// Helper that wraps the screen in a GoRouter so context.go() works.
Widget buildResultScreen({
  int score = 1500,
  int crystals = 30,
  int correctCount = 5,
  int totalCount = 6,
}) {
  final router = GoRouter(
    initialLocation: '/result',
    routes: [
      GoRoute(
        path: '/result',
        builder: (context, state) => SurvivalResultScreen(
          extra: {
            'score': score,
            'crystals': crystals,
            'correctCount': correctCount,
            'totalCount': totalCount,
          },
        ),
      ),
      GoRoute(
        path: '/survival/game',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('SurvivalGame')),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('HomeScreen')),
        ),
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
  testWidgets('shows score correctly', (tester) async {
    await tester.pumpWidget(buildResultScreen(score: 1500));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1500'), findsOneWidget);
  });

  testWidgets('shows crystal count', (tester) async {
    await tester.pumpWidget(buildResultScreen(crystals: 42));
    // Wait for TweenAnimationBuilder to complete (1 second duration)
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('+42'), findsOneWidget);
  });

  testWidgets('streak chip visible when correctCount > 0', (tester) async {
    await tester.pumpWidget(buildResultScreen(correctCount: 7));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('STREAK: 7'), findsOneWidget);
  });

  testWidgets('no streak chip when correctCount == 0', (tester) async {
    await tester.pumpWidget(buildResultScreen(correctCount: 0));
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('STREAK:'), findsNothing);
  });

  testWidgets('shows correct in a row message when correctCount > 0',
      (tester) async {
    await tester.pumpWidget(buildResultScreen(correctCount: 5));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('5 correct in a row!'), findsOneWidget);
  });

  testWidgets('shows better luck message when correctCount == 0',
      (tester) async {
    await tester.pumpWidget(buildResultScreen(correctCount: 0));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Better luck next time!'), findsOneWidget);
  });

  testWidgets('Play Again navigates to /survival/game', (tester) async {
    await tester.pumpWidget(buildResultScreen());
    await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.text('Play Again'));
    await tester.pump();
    await tester.tap(find.text('Play Again'));
    await tester.pumpAndSettle();
    expect(find.text('SurvivalGame'), findsOneWidget);
  });

  testWidgets('Home navigates to /', (tester) async {
    await tester.pumpWidget(buildResultScreen());
    await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.text('Home'));
    await tester.pump();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('HomeScreen'), findsOneWidget);
  });
}
