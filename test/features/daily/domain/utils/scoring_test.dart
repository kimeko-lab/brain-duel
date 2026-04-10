import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/domain/utils/scoring.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateScore', () {
    test('returns 0 when isCorrect is false (any responseMs)', () {
      final result = calculateScore(
        isCorrect: false,
        responseMs: 1000,
        rarity: QuestionRarity.common,
      );
      expect(result, 0);
    });

    test('returns 0 when responseMs < 100 (e.g. 50ms — anti-cheat)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 50,
        rarity: QuestionRarity.common,
      );
      expect(result, 0);
    });

    test('returns 0 when responseMs > 10000 (e.g. 11000ms)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 11000,
        rarity: QuestionRarity.common,
      );
      expect(result, 0);
    });

    test('returns max score (~1000) when responseMs is just above minimum (e.g. 101ms, common)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 101,
        rarity: QuestionRarity.common,
      );
      expect(result, greaterThan(900));
      expect(result, lessThanOrEqualTo(1000));
    });

    test('returns small score when responseMs is 9900ms and common (near timeout → small timeBonus)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 9900,
        rarity: QuestionRarity.common,
      );
      // Formula: (1000 * (10000 - 9900) / 10000 * 1.0).round() = (1000 * 0.01).round() = 10
      expect(result, 10);
    });

    test('returns higher score for rare vs common at same responseMs', () {
      const responseMs = 2500;
      final commonScore = calculateScore(
        isCorrect: true,
        responseMs: responseMs,
        rarity: QuestionRarity.common,
      );
      final rareScore = calculateScore(
        isCorrect: true,
        responseMs: responseMs,
        rarity: QuestionRarity.rare,
      );
      expect(rareScore, greaterThan(commonScore));
    });

    test('returns higher score for legendary vs rare at same responseMs', () {
      const responseMs = 2500;
      final rareScore = calculateScore(
        isCorrect: true,
        responseMs: responseMs,
        rarity: QuestionRarity.rare,
      );
      final legendaryScore = calculateScore(
        isCorrect: true,
        responseMs: responseMs,
        rarity: QuestionRarity.legendary,
      );
      expect(legendaryScore, greaterThan(rareScore));
    });

    test('correct formula: responseMs=1000ms, common → expect 900', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 1000,
        rarity: QuestionRarity.common,
      );
      // Formula: (1000 * (10000 - 1000) / 10000 * 1.0).round() = (1000 * 0.9 * 1.0).round() = 900
      expect(result, 900);
    });

    test('correct formula: responseMs=2500ms, rare → expect 975', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 2500,
        rarity: QuestionRarity.rare,
      );
      // Formula: (1000 * (10000 - 2500) / 10000 * 1.3).round() = (1000 * 0.75 * 1.3).round() = 975
      expect(result, 975);
    });

    test('timer at exactly 10000ms (boundary) — timeBonus = 0, score = 0 even if correct', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 10000,
        rarity: QuestionRarity.common,
      );
      expect(result, 0);
    });
  });

  group('calculateCrystals', () {
    test('5 correct, 10s remaining → 50 + 20 = 70 crystals', () {
      final result = calculateCrystals(
        correctCount: 5,
        totalTimeRemainingSeconds: 10,
      );
      expect(result, 70);
    });

    test('0 correct, 0s remaining → 0 crystals', () {
      final result = calculateCrystals(
        correctCount: 0,
        totalTimeRemainingSeconds: 0,
      );
      expect(result, 0);
    });

    test('negative correctCount → 0', () {
      final result = calculateCrystals(
        correctCount: -5,
        totalTimeRemainingSeconds: 10,
      );
      expect(result, 0);
    });

    test('negative timeRemaining → 0', () {
      final result = calculateCrystals(
        correctCount: 5,
        totalTimeRemainingSeconds: -10,
      );
      expect(result, 0);
    });

    test('5 correct, 0s remaining → 50 crystals', () {
      final result = calculateCrystals(
        correctCount: 5,
        totalTimeRemainingSeconds: 0,
      );
      expect(result, 50);
    });
  });
}
