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
}
