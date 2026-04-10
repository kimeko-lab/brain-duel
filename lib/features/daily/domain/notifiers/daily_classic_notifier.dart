import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';
import 'package:brain_duel/features/daily/domain/state/daily_classic_state.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';
import 'package:brain_duel/features/daily/domain/utils/scoring.dart';

class DailyClassicNotifier extends StateNotifier<DailyClassicState> {
  final QuestionRepository _repository;

  DailyClassicNotifier(this._repository) : super(const DailyClassicState());

  Future<void> loadQuestions(String category) async {
    state = const DailyClassicState(phase: GamePhase.loading);
    final questions = await _repository.getQuestionsForCategory(category);
    state = DailyClassicState(
      questions: questions,
      phase: GamePhase.answering,
    );
  }

  void submitAnswer(int selectedIndex, int responseMs) {
    final question = state.currentQuestion;
    if (question == null || state.phase != GamePhase.answering) return;

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
      phase: GamePhase.showingFeedback,
      selectedIndex: selectedIndex,
    );

    // Auto-advance after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), _advanceOrFinish);
  }

  void timerExpired() {
    final question = state.currentQuestion;
    if (question == null || state.phase != GamePhase.answering) return;

    final result = AnswerResult(
      questionId: question.id,
      isCorrect: false,
      responseMs: 5000,
      scoreEarned: 0,
    );

    state = state.copyWith(
      answers: [...state.answers, result],
      phase: GamePhase.showingFeedback,
      clearSelectedIndex: true,
    );

    Future.delayed(const Duration(milliseconds: 1500), _advanceOrFinish);
  }

  void _advanceOrFinish() {
    if (!mounted) return;
    if (state.isLastQuestion) {
      final totalTimeRemainingSeconds = state.answers.fold<double>(
        0,
        (sum, a) => sum + (5000 - a.responseMs.clamp(0, 5000)) / 1000,
      );
      final crystals = calculateCrystals(
        correctCount: state.answers.where((a) => a.isCorrect).length,
        totalTimeRemainingSeconds: totalTimeRemainingSeconds,
      );
      state = state.copyWith(crystals: crystals, phase: GamePhase.finished);
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        phase: GamePhase.answering,
        clearSelectedIndex: true,
      );
    }
  }
}
