import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';
import 'package:brain_duel/features/rush/domain/state/rush_state.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';
import 'package:brain_duel/features/daily/domain/utils/scoring.dart';

class RushNotifier extends StateNotifier<RushState> {
  final QuestionRepository _repository;
  Timer? _countdownTimer;
  Timer? _feedbackTimer;

  RushNotifier(this._repository) : super(const RushState());

  Future<void> loadQuestions() async {
    state = const RushState(phase: RushPhase.loading);
    final questions = await _repository.getAllQuestions();
    state = RushState(
      questions: questions,
      phase: RushPhase.answering,
    );
    _startCountdown();
  }

  /// Exposed for testing subclasses that need to start the countdown manually
  /// after seeding state with a custom [timeRemainingMs].
  @visibleForTesting
  void startTestCountdown() => _startCountdown();

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      final newTime = state.timeRemainingMs - 100;
      if (newTime <= 0) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
        _finish();
      } else {
        state = state.copyWith(timeRemainingMs: newTime);
      }
    });
  }

  void submitAnswer(int selectedIndex, int responseMs) {
    final question = state.currentQuestion;
    if (question == null || state.phase != RushPhase.answering) return;

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
      phase: RushPhase.showingFeedback,
      selectedIndex: selectedIndex,
    );

    _feedbackTimer = Timer(const Duration(milliseconds: 500), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;
    if (state.phase == RushPhase.finished) return;
    final nextIndex = state.questions.isNotEmpty
        ? (state.currentIndex + 1) % state.questions.length
        : 0;
    state = state.copyWith(
      currentIndex: nextIndex,
      phase: RushPhase.answering,
      clearSelectedIndex: true,
    );
  }

  void _finish() {
    if (!mounted) return;
    if (state.phase == RushPhase.finished) return;
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    final totalTimeRemainingSeconds = state.timeRemainingMs / 1000;
    final crystals = calculateCrystals(
      correctCount: state.correctCount,
      totalTimeRemainingSeconds: totalTimeRemainingSeconds,
    );
    state = state.copyWith(
      crystals: crystals,
      phase: RushPhase.finished,
      timeRemainingMs: 0,
    );
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
