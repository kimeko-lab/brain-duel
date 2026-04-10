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

    test('returns 0 when responseMs > 5000 (e.g. 6000ms)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 6000,
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

    test('returns small score when responseMs is 4999ms and common (near timeout → small timeBonus)', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 4999,
        rarity: QuestionRarity.common,
      );
      expect(result, 0);
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

    test('correct formula: responseMs=1000ms, common → expect 800', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 1000,
        rarity: QuestionRarity.common,
      );
      // Formula: (1000 * (5000 - 1000) / 5000 * 1.0).round() = (1000 * 0.8 * 1.0).round() = 800
      expect(result, 800);
    });

    test('correct formula: responseMs=2500ms, rare → expect 650', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 2500,
        rarity: QuestionRarity.rare,
      );
      // Formula: (1000 * (5000 - 2500) / 5000 * 1.3).round() = (1000 * 0.5 * 1.3).round() = 650
      expect(result, 650);
    });

    test('timer at exactly 5000ms (boundary) — timeBonus = 0, score = 0 even if correct', () {
      final result = calculateScore(
        isCorrect: true,
        responseMs: 5000,
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
