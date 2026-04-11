import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_duel/main.dart';

void main() {
  testWidgets('App smoke test — home screen renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BrainDuelApp()));
    await tester.pump(const Duration(seconds: 1));

    // New HomeScreen shows 'BRAIN DUEL' hero title and 'CLASSIC' mode button
    expect(find.text('BRAIN DUEL'), findsOneWidget);
    expect(find.text('CLASSIC'), findsOneWidget);
  });
}
