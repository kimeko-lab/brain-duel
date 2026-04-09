import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/daily/domain/providers/question_providers.dart';
import 'package:brain_duel/features/daily/domain/state/daily_classic_state.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  // helper: load questions for 'science'
  Future<void> loadScience() async {
    await container.read(dailyClassicProvider.notifier).loadQuestions('science');
  }

  test('initial state is loading phase', () {
    expect(container.read(dailyClassicProvider).phase, GamePhase.loading);
  });

  test('after loadQuestions, phase is answering with 5 questions', () async {
    await loadScience();
    final state = container.read(dailyClassicProvider);
    expect(state.phase, GamePhase.answering);
    expect(state.questions.length, 5);
    expect(state.currentIndex, 0);
  });

  test('submitAnswer with correct answer adds score and shows feedback', () async {
    await loadScience();
    final question = container.read(dailyClassicProvider).currentQuestion!;
    container.read(dailyClassicProvider.notifier)
        .submitAnswer(question.correctIndex, 1000);
    final state = container.read(dailyClassicProvider);
    expect(state.phase, GamePhase.showingFeedback);
    expect(state.score, greaterThan(0));
    expect(state.answers.length, 1);
    expect(state.answers.first.isCorrect, true);
    expect(state.selectedIndex, question.correctIndex);
  });

  test('submitAnswer with wrong answer gives 0 score', () async {
    await loadScience();
    final question = container.read(dailyClassicProvider).currentQuestion!;
    final wrongIndex = question.correctIndex == 0 ? 1 : 0;
    container.read(dailyClassicProvider.notifier)
        .submitAnswer(wrongIndex, 2000);
    final state = container.read(dailyClassicProvider);
    expect(state.score, 0);
    expect(state.answers.first.isCorrect, false);
  });

  test('timerExpired records incorrect answer with responseMs 5000', () async {
    await loadScience();
    container.read(dailyClassicProvider.notifier).timerExpired();
    final state = container.read(dailyClassicProvider);
    expect(state.phase, GamePhase.showingFeedback);
    expect(state.answers.first.isCorrect, false);
    expect(state.answers.first.responseMs, 5000);
    expect(state.selectedIndex, isNull);
  });

  test('after auto-advance delay, moves to next question', () async {
    await loadScience();
    container.read(dailyClassicProvider.notifier).submitAnswer(0, 1000);
    await Future.delayed(const Duration(milliseconds: 1600));
    final state = container.read(dailyClassicProvider);
    expect(state.currentIndex, 1);
    expect(state.phase, GamePhase.answering);
  });

  test('finishing last question sets phase to finished with crystals', () async {
    await loadScience();
    final notifier = container.read(dailyClassicProvider.notifier);
    // Answer all 5 questions
    for (var i = 0; i < 5; i++) {
      final q = container.read(dailyClassicProvider).currentQuestion!;
      notifier.submitAnswer(q.correctIndex, 1000);
      await Future.delayed(const Duration(milliseconds: 1600));
    }
    final state = container.read(dailyClassicProvider);
    expect(state.phase, GamePhase.finished);
    expect(state.crystals, greaterThan(0));
    expect(state.answers.length, 5);
  });
}
