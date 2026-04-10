import 'package:flutter/foundation.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';

enum RushPhase { loading, answering, showingFeedback, finished }

@immutable
class RushState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int crystals;
  final List<AnswerResult> answers;
  final RushPhase phase;
  final int? selectedIndex;
  final int timeRemainingMs; // starts at 60000, counts down

  const RushState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.crystals = 0,
    this.answers = const [],
    this.phase = RushPhase.loading,
    this.selectedIndex,
    this.timeRemainingMs = 60000,
  });

  RushState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? crystals,
    List<AnswerResult>? answers,
    RushPhase? phase,
    int? selectedIndex,
    bool clearSelectedIndex = false,
    int? timeRemainingMs,
  }) {
    return RushState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      crystals: crystals ?? this.crystals,
      answers: answers ?? this.answers,
      phase: phase ?? this.phase,
      selectedIndex:
          clearSelectedIndex ? null : (selectedIndex ?? this.selectedIndex),
      timeRemainingMs: timeRemainingMs ?? this.timeRemainingMs,
    );
  }

  QuestionModel? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  int get correctCount => answers.where((a) => a.isCorrect).length;
}
