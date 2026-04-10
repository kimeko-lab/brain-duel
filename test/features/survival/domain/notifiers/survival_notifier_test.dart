import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/survival/domain/providers/survival_providers.dart';
import 'package:brain_duel/features/survival/domain/state/survival_state.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> loadQuestions() async {
    await container.read(survivalProvider.notifier).loadQuestions();
  }

  test('initial state is loading phase', () {
    expect(container.read(survivalProvider).phase, SurvivalPhase.loading);
  });

  test('after loadQuestions, phase is answering with 25 questions', () async {
    await loadQuestions();
    final state = container.read(survivalProvider);
    expect(state.phase, SurvivalPhase.answering);
    expect(state.questions.length, 25);
    expect(state.currentIndex, 0);
  });

  test('correct answer shows feedback with positive score', () async {
    await loadQuestions();
    final question = container.read(survivalProvider).currentQuestion!;
    container.read(survivalProvider.notifier).submitAnswer(question.correctIndex, 1000);
    final state = container.read(survivalProvider);
    expect(state.phase, SurvivalPhase.showingFeedback);
    expect(state.score, greaterThan(0));
    expect(state.answers.length, 1);
    expect(state.answers.first.isCorrect, true);
    expect(state.selectedIndex, question.correctIndex);
  });

  test('correct answer advances to next question after delay', () async {
    await loadQuestions();
    final question = container.read(survivalProvider).currentQuestion!;
    container.read(survivalProvider.notifier).submitAnswer(question.correctIndex, 1000);
    await Future.delayed(const Duration(milliseconds: 1600));
    final state = container.read(survivalProvider);
    expect(state.currentIndex, 1);
    expect(state.phase, SurvivalPhase.answering);
    expect(state.selectedIndex, isNull);
  });

  test('wrong answer shows feedback then finishes game', () async {
    await loadQuestions();
    final question = container.read(survivalProvider).currentQuestion!;
    final wrongIndex = question.correctIndex == 0 ? 1 : 0;
    container.read(survivalProvider.notifier).submitAnswer(wrongIndex, 2000);
    // Immediately after submitAnswer: showingFeedback
    expect(container.read(survivalProvider).phase, SurvivalPhase.showingFeedback);
    expect(container.read(survivalProvider).answers.first.isCorrect, false);
    // After delay: finished
    await Future.delayed(const Duration(milliseconds: 1600));
    expect(container.read(survivalProvider).phase, SurvivalPhase.finished);
  });

  test('timerExpired finishes immediately without delay', () async {
    await loadQuestions();
    container.read(survivalProvider.notifier).timerExpired();
    final state = container.read(survivalProvider);
    // timerExpired calls _finish() synchronously (no delay)
    expect(state.phase, SurvivalPhase.finished);
    expect(state.answers.first.isCorrect, false);
    expect(state.answers.first.responseMs, 10000);
    expect(state.selectedIndex, isNull);
  });

  test('timerExpired sets crystals and finishes', () async {
    await loadQuestions();
    container.read(survivalProvider.notifier).timerExpired();
    final state = container.read(survivalProvider);
    expect(state.phase, SurvivalPhase.finished);
    expect(state.crystals, isNonNegative);
  });

  test('correctCount reflects number of correct answers', () async {
    await loadQuestions();
    final notifier = container.read(survivalProvider.notifier);
    // Answer 3 questions correctly
    for (var i = 0; i < 3; i++) {
      final q = container.read(survivalProvider).currentQuestion!;
      notifier.submitAnswer(q.correctIndex, 1000);
      await Future.delayed(const Duration(milliseconds: 1600));
    }
    final state = container.read(survivalProvider);
    expect(state.correctCount, 3);
    expect(state.answers.length, 3);
  });

  test('game finishes with crystals after wrong answer', () async {
    await loadQuestions();
    final notifier = container.read(survivalProvider.notifier);
    // Answer 2 correctly first
    for (var i = 0; i < 2; i++) {
      final q = container.read(survivalProvider).currentQuestion!;
      notifier.submitAnswer(q.correctIndex, 1000);
      await Future.delayed(const Duration(milliseconds: 1600));
    }
    // Then answer wrong
    final q = container.read(survivalProvider).currentQuestion!;
    final wrongIndex = q.correctIndex == 0 ? 1 : 0;
    notifier.submitAnswer(wrongIndex, 2000);
    await Future.delayed(const Duration(milliseconds: 1600));
    final state = container.read(survivalProvider);
    expect(state.phase, SurvivalPhase.finished);
    expect(state.crystals, greaterThan(0));
    expect(state.correctCount, 2);
  });

  test('game finishes gracefully when all 25 questions answered correctly', () async {
    await container.read(survivalProvider.notifier).loadQuestions();
    final notifier = container.read(survivalProvider.notifier);

    for (var i = 0; i < 25; i++) {
      final q = container.read(survivalProvider).currentQuestion!;
      notifier.submitAnswer(q.correctIndex, 1000);
      await Future.delayed(const Duration(milliseconds: 1600));
    }

    final state = container.read(survivalProvider);
    expect(state.phase, SurvivalPhase.finished);
    expect(state.correctCount, 25);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
