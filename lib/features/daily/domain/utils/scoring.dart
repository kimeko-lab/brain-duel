import 'package:brain_duel/features/daily/data/models/question_model.dart';

/// Calculates score for a single answered question.
/// Formula: BASE(1000) × timeBonus × rarityMult
/// Returns 0 if incorrect or responseMs is out of valid range (100–5000ms).
int calculateScore({
  required bool isCorrect,
  required int responseMs,
  required QuestionRarity rarity,
}) {
  if (!isCorrect) return 0;
  if (responseMs < 100 || responseMs > 5000) return 0;
  const base = 1000;
  final timeBonus = (5000 - responseMs) / 5000;
  final rarityMult = switch (rarity) {
    QuestionRarity.common => 1.0,
    QuestionRarity.rare => 1.3,
    QuestionRarity.unique => 1.6,
    QuestionRarity.legendary => 2.0,
  };
  return (base * timeBonus * rarityMult).round();
}

/// Calculates crystal reward for a completed game session.
/// Formula: correctCount × 10 + totalTimeRemainingSeconds × 2
/// Returns 0 if inputs are negative.
int calculateCrystals({
  required int correctCount,
  required double totalTimeRemainingSeconds,
}) {
  if (correctCount < 0 || totalTimeRemainingSeconds < 0) return 0;
  return (correctCount * 10 + totalTimeRemainingSeconds * 2).round();
}
