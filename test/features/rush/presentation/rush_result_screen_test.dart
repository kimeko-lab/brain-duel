import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_duel/features/rush/presentation/rush_result_screen.dart';

// Helper that wraps the screen in a GoRouter so context.go() works.
Widget buildResultScreen({
  int score = 1500,
  int crystals = 30,
  int correctCount = 5,
  int totalCount = 8,
}) {
  final router = GoRouter(
    initialLocation: '/result',
    routes: [
      GoRoute(
        path: '/result',
        builder: (context, state) => RushResultScreen(
          extra: {
            'score': score,
            'crystals': crystals,
            'correctCount': correctCount,
            'totalCount': totalCount,
          },
        ),
      ),
      GoRoute(
        path: '/rush/game',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('RushGame')),
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

  testWidgets('shows N questions in 60s! text', (tester) async {
    await tester.pumpWidget(buildResultScreen(totalCount: 12));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('12 questions in 60s!'), findsOneWidget);
  });

  testWidgets('shows correctCount / totalCount correct text', (tester) async {
    await tester.pumpWidget(buildResultScreen(correctCount: 5, totalCount: 8));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('5 / 8 correct'), findsOneWidget);
  });

  testWidgets('Play Again navigates to /rush/game', (tester) async {
    await tester.pumpWidget(buildResultScreen());
    await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.text('Play Again'));
    await tester.pump();
    await tester.tap(find.text('Play Again'));
    await tester.pumpAndSettle();
    expect(find.text('RushGame'), findsOneWidget);
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
