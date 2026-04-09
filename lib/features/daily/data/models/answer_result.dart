import 'package:flutter/foundation.dart';

@immutable
class AnswerResult {
  final String questionId;
  final bool isCorrect;
  final int responseMs;    // how long user took to answer (milliseconds)
  final int scoreEarned;

  const AnswerResult({
    required this.questionId,
    required this.isCorrect,
    required this.responseMs,
    required this.scoreEarned,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerResult &&
          questionId == other.questionId &&
          isCorrect == other.isCorrect &&
          responseMs == other.responseMs &&
          scoreEarned == other.scoreEarned;

  @override
  int get hashCode => Object.hash(questionId, isCorrect, responseMs, scoreEarned);
}
