import 'package:flutter/foundation.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';

enum SurvivalPhase { loading, answering, showingFeedback, finished }

@immutable
class SurvivalState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int crystals;
  final List<AnswerResult> answers;
  final SurvivalPhase phase;
  final int? selectedIndex;

  const SurvivalState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.crystals = 0,
    this.answers = const [],
    this.phase = SurvivalPhase.loading,
    this.selectedIndex,
  });

  SurvivalState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? crystals,
    List<AnswerResult>? answers,
    SurvivalPhase? phase,
    int? selectedIndex,
    bool clearSelectedIndex = false,
  }) {
    return SurvivalState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      crystals: crystals ?? this.crystals,
      answers: answers ?? this.answers,
      phase: phase ?? this.phase,
      selectedIndex: clearSelectedIndex ? null : (selectedIndex ?? this.selectedIndex),
    );
  }

  QuestionModel? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  int get correctCount => answers.where((a) => a.isCorrect).length;
}
