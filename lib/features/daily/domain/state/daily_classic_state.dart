import 'package:flutter/foundation.dart';
import 'package:brain_duel/core/widgets/game/game_phase.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';

export 'package:brain_duel/core/widgets/game/game_phase.dart';

@immutable
class DailyClassicState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int crystals;
  final List<AnswerResult> answers;
  final GamePhase phase;
  final int? selectedIndex; // which option the user tapped (null if timer expired)

  const DailyClassicState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.crystals = 0,
    this.answers = const [],
    this.phase = GamePhase.loading,
    this.selectedIndex,
  });

  DailyClassicState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? crystals,
    List<AnswerResult>? answers,
    GamePhase? phase,
    int? selectedIndex,
    bool clearSelectedIndex = false,
  }) {
    return DailyClassicState(
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

  bool get isLastQuestion => currentIndex >= questions.length - 1;
}
