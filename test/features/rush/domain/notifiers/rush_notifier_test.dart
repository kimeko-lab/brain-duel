import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/rush/domain/notifiers/rush_notifier.dart';
import 'package:brain_duel/features/rush/domain/state/rush_state.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';

/// A deterministic fake repository for testing.
class FakeQuestionRepository implements QuestionRepository {
  final List<QuestionModel> _questions;

  FakeQuestionRepository(this._questions);

  @override
  Future<List<QuestionModel>> getAllQuestions() async => _questions;

  @override
  Future<List<QuestionModel>> getQuestionsForCategory(String category) async =>
      _questions.where((q) => q.category == category).toList();
}

List<QuestionModel> _makeQuestions(int count) {
  return List.generate(
    count,
    (i) => QuestionModel(
      id: 'q_$i',
      category: 'science',
      rarity: QuestionRarity.common,
      text: 'Question $i?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 0, // correct answer is always index 0
    ),
  );
}

void main() {
  group('RushNotifier', () {
    late FakeQuestionRepository fakeRepo;
    late RushNotifier notifier;

    setUp(() {
      fakeRepo = FakeQuestionRepository(_makeQuestions(25));
      notifier = RushNotifier(fakeRepo);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state: phase is loading, timeRemainingMs is 60000', () {
      expect(notifier.state.phase, RushPhase.loading);
      expect(notifier.state.timeRemainingMs, 60000);
      expect(notifier.state.score, 0);
      expect(notifier.state.questions, isEmpty);
      expect(notifier.state.currentIndex, 0);
    });

    test('after loadQuestions: phase is answering, 25 questions loaded', () async {
      await notifier.loadQuestions();
      expect(notifier.state.phase, RushPhase.answering);
      expect(notifier.state.questions.length, 25);
      expect(notifier.state.currentIndex, 0);
      expect(notifier.state.currentQuestion, isNotNull);
    });

    test('submitAnswer with correct answer: score > 0, phase is showingFeedback', () async {
      await notifier.loadQuestions();
      notifier.submitAnswer(0, 2000); // index 0 is correct
      expect(notifier.state.phase, RushPhase.showingFeedback);
      expect(notifier.state.score, greaterThan(0));
      expect(notifier.state.selectedIndex, 0);
      expect(notifier.state.answers.length, 1);
      expect(notifier.state.answers.first.isCorrect, isTrue);
    });

    test('submitAnswer with wrong answer: score = 0, phase is showingFeedback', () async {
      await notifier.loadQuestions();
      notifier.submitAnswer(1, 2000); // index 1 is wrong
      expect(notifier.state.phase, RushPhase.showingFeedback);
      expect(notifier.state.score, 0);
      expect(notifier.state.selectedIndex, 1);
      expect(notifier.state.answers.length, 1);
      expect(notifier.state.answers.first.isCorrect, isFalse);
    });

    test('submitAnswer is ignored when phase is not answering', () async {
      await notifier.loadQuestions();
      notifier.submitAnswer(0, 2000); // sets showingFeedback
      final scoreAfterFirst = notifier.state.score;
      // Try to submit again while in showingFeedback
      notifier.submitAnswer(0, 1000);
      expect(notifier.state.score, scoreAfterFirst); // unchanged
      expect(notifier.state.answers.length, 1); // still only one answer
    });

    test('wrong answer does NOT end the game (Rush continues)', () async {
      await notifier.loadQuestions();
      notifier.submitAnswer(2, 2000); // wrong answer
      expect(notifier.state.phase, RushPhase.showingFeedback);
      // After 500ms, should advance to next question, not finish
      await Future.delayed(const Duration(milliseconds: 600));
      expect(notifier.state.phase, RushPhase.answering);
      expect(notifier.state.currentIndex, 1);
    });

    test('after 500ms delay, advances to next question (phase back to answering)', () async {
      await notifier.loadQuestions();
      notifier.submitAnswer(0, 2000);
      expect(notifier.state.phase, RushPhase.showingFeedback);

      // Wait for the 500ms delay to fire _nextQuestion
      await Future.delayed(const Duration(milliseconds: 600));

      expect(notifier.state.phase, RushPhase.answering);
      expect(notifier.state.currentIndex, 1);
      expect(notifier.state.selectedIndex, isNull);
    });

    test('question index wraps around after all questions are answered', () async {
      final smallRepo = FakeQuestionRepository(_makeQuestions(2));
      final smallNotifier = RushNotifier(smallRepo);
      addTearDown(smallNotifier.dispose);

      await smallNotifier.loadQuestions();
      expect(smallNotifier.state.currentIndex, 0);

      // Answer question at index 0
      smallNotifier.submitAnswer(0, 2000);
      await Future.delayed(const Duration(milliseconds: 600));
      expect(smallNotifier.state.currentIndex, 1);

      // Answer question at index 1 — should wrap to 0
      smallNotifier.submitAnswer(0, 2000);
      await Future.delayed(const Duration(milliseconds: 600));
      expect(smallNotifier.state.currentIndex, 0);
    });

    test('timeRemainingMs decrements over time after loadQuestions', () async {
      await notifier.loadQuestions();
      expect(notifier.state.timeRemainingMs, 60000);

      // Wait 300ms — at least 2 ticks of 100ms should have fired
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.timeRemainingMs, lessThan(60000));
    });

    test('game ends when global countdown reaches zero', () async {
      // Use a notifier with a seeded short time by calling loadQuestions
      // then waiting — but to make it fast, use a custom fake that returns quickly
      // and test with the real timer but short initial time via a subclass.
      final shortNotifier = _ShortTimerNotifier(_makeQuestions(5));
      addTearDown(shortNotifier.dispose);

      await shortNotifier.loadQuestions();
      // Timer starts at 300ms (3 ticks of 100ms)
      await Future.delayed(const Duration(milliseconds: 500));

      expect(shortNotifier.state.phase, RushPhase.finished);
      expect(shortNotifier.state.timeRemainingMs, 0);
    });

    test('crystals are calculated on finish', () async {
      final shortNotifier = _ShortTimerNotifier(_makeQuestions(5));
      addTearDown(shortNotifier.dispose);

      await shortNotifier.loadQuestions();
      // Answer one correct question before time runs out
      shortNotifier.submitAnswer(0, 2000);

      // Countdown expires first (~300ms → _finish sets phase=finished),
      // then at ~500ms _nextQuestion fires but is suppressed by the phase==finished guard.
      await Future.delayed(const Duration(milliseconds: 600));

      expect(shortNotifier.state.phase, RushPhase.finished);
      expect(shortNotifier.state.timeRemainingMs, 0);
      // correctCount = 1 → crystals = 1*10 + 0*2 = 10
      expect(shortNotifier.state.crystals, 10);
    });

    test('_finish is idempotent: calling again does not change finished state', () async {
      final shortNotifier = _ShortTimerNotifier(_makeQuestions(5));
      addTearDown(shortNotifier.dispose);

      await shortNotifier.loadQuestions();
      await Future.delayed(const Duration(milliseconds: 500));

      expect(shortNotifier.state.phase, RushPhase.finished);
      final crystalsAfterFirstFinish = shortNotifier.state.crystals;

      // Wait more — timer is already cancelled, state should not change
      await Future.delayed(const Duration(milliseconds: 300));

      expect(shortNotifier.state.phase, RushPhase.finished);
      expect(shortNotifier.state.crystals, crystalsAfterFirstFinish);
    });
  });
}

/// A RushNotifier subclass that overrides [loadQuestions] to set a very short
/// initial timeRemainingMs (300 ms = 3 timer ticks) so timer tests run fast.
class _ShortTimerNotifier extends RushNotifier {
  final List<QuestionModel> _questions;

  _ShortTimerNotifier(this._questions)
      : super(FakeQuestionRepository(_questions));

  @override
  Future<void> loadQuestions() async {
    state = const RushState(phase: RushPhase.loading);
    // Simulate async load
    await Future.delayed(Duration.zero);
    state = RushState(
      questions: _questions,
      phase: RushPhase.answering,
      timeRemainingMs: 300, // 3 ticks × 100 ms = expires in ~300 ms
    );
    startTestCountdown();
  }
}
