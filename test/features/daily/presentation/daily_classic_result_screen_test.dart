import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brain_duel/features/daily/presentation/daily_classic_result_screen.dart';

// Helper
Widget buildResultScreen({
  int score = 3200,
  int crystals = 70,
  int correct = 4,
  int total = 5,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: DailyClassicResultScreen(
        extra: {
          'score': score,
          'crystals': crystals,
          'correctCount': correct,
          'totalCount': total,
        },
      ),
    ),
  );
}

void main() {
  testWidgets('shows score', (tester) async {
    await tester.pumpWidget(buildResultScreen(score: 3200));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('3200'), findsOneWidget);
  });

  testWidgets('shows correct count', (tester) async {
    await tester.pumpWidget(buildResultScreen(correct: 4, total: 5));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('4 / 5 correct'), findsOneWidget);
  });

  testWidgets('shows Play Again and Home buttons', (tester) async {
    await tester.pumpWidget(buildResultScreen());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Play Again'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('tapping Play Again navigates without crash', (tester) async {
    await tester.pumpWidget(buildResultScreen());
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Play Again'));
    await tester.pump(const Duration(milliseconds: 100));
    // No crash = pass
  });
}
