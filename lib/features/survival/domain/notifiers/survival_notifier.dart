import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';
import 'package:brain_duel/features/survival/domain/state/survival_state.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';
import 'package:brain_duel/features/daily/domain/utils/scoring.dart';

class SurvivalNotifier extends StateNotifier<SurvivalState> {
  final QuestionRepository _repository;

  SurvivalNotifier(this._repository) : super(const SurvivalState());

  Future<void> loadQuestions() async {
    state = const SurvivalState(phase: SurvivalPhase.loading);
    final questions = await _repository.getAllQuestions();
    state = SurvivalState(
      questions: questions,
      phase: SurvivalPhase.answering,
    );
  }

  /// Submits the player's answer.
  /// Correct → feedback then advance to next question.
  /// Wrong → feedback then end the game.
  /// The UI must cancel the per-question countdown timer before calling this.
  void submitAnswer(int selectedIndex, int responseMs) {
    final question = state.currentQuestion;
    if (question == null || state.phase != SurvivalPhase.answering) return;

    final isCorrect = selectedIndex == question.correctIndex;
    final scoreEarned = calculateScore(
      isCorrect: isCorrect,
      responseMs: responseMs,
      rarity: question.rarity,
    );

    final result = AnswerResult(
      questionId: question.id,
      isCorrect: isCorrect,
      responseMs: responseMs,
      scoreEarned: scoreEarned,
    );

    state = state.copyWith(
      score: state.score + scoreEarned,
      answers: [...state.answers, result],
      phase: SurvivalPhase.showingFeedback,
      selectedIndex: selectedIndex,
    );

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 1500), _nextQuestion);
    } else {
      Future.delayed(const Duration(milliseconds: 1500), _finish);
    }
  }

  /// Called when the per-question timer expires.
  /// Ends the game immediately (no feedback delay).
  void timerExpired() {
    final question = state.currentQuestion;
    if (question == null || state.phase != SurvivalPhase.answering) return;

    final result = AnswerResult(
      questionId: question.id,
      isCorrect: false,
      responseMs: 10000, // max responseMs → 0 time bonus
      scoreEarned: 0,
    );

    state = state.copyWith(
      answers: [...state.answers, result],
      phase: SurvivalPhase.showingFeedback,
      clearSelectedIndex: true,
    );

    _finish();
  }

  void _nextQuestion() {
    if (!mounted) return;
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      phase: SurvivalPhase.answering,
      clearSelectedIndex: true,
    );
  }

  void _finish() {
    if (state.phase == SurvivalPhase.finished) return;
    if (!mounted) return;
    final totalTimeRemainingSeconds = state.answers.fold<double>(
      0,
      (sum, a) => sum + (10000 - a.responseMs.clamp(0, 10000)) / 1000,
    );
    final crystals = calculateCrystals(
      correctCount: state.correctCount,
      totalTimeRemainingSeconds: totalTimeRemainingSeconds,
    );
    state = state.copyWith(crystals: crystals, phase: SurvivalPhase.finished);
  }
}
