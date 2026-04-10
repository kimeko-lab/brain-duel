import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/data/services/mock/mock_question_service.dart';

void main() {
  late MockQuestionService service;

  setUp(() {
    service = MockQuestionService();
  });

  group('MockQuestionService', () {
    test('getQuestionsForCategory returns exactly 5 questions for science', () async {
      final questions = await service.getQuestionsForCategory('science');
      expect(questions.length, equals(5));
    });

    test('all returned science questions have category == "science"', () async {
      final questions = await service.getQuestionsForCategory('science');
      for (final q in questions) {
        expect(q.category, equals('science'));
      }
    });

    test('all returned science questions have rarity == QuestionRarity.common', () async {
      final questions = await service.getQuestionsForCategory('science');
      for (final q in questions) {
        expect(q.rarity, equals(QuestionRarity.common));
      }
    });

    test('all returned science questions have exactly 4 options', () async {
      final questions = await service.getQuestionsForCategory('science');
      for (final q in questions) {
        expect(q.options.length, equals(4));
      }
    });

    test('correctIndex is within 0–3 for all science questions', () async {
      final questions = await service.getQuestionsForCategory('science');
      for (final q in questions) {
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    });

    test('unknown category returns an empty list', () async {
      final questions = await service.getQuestionsForCategory('unknown_category');
      expect(questions, isEmpty);
    });

    group('all 5 categories return 5 questions each', () {
      const categories = ['science', 'geography', 'history', 'sport', 'entertainment'];

      for (final category in categories) {
        test('$category returns 5 questions', () async {
          final service = MockQuestionService();
          final questions = await service.getQuestionsForCategory(category);
          expect(questions.length, equals(5));
        });
      }
    });

    group('all categories have correct rarity and option count', () {
      const categories = ['science', 'geography', 'history', 'sport', 'entertainment'];

      for (final category in categories) {
        test('$category questions all have rarity common and 4 options', () async {
          final service = MockQuestionService();
          final questions = await service.getQuestionsForCategory(category);
          for (final q in questions) {
            expect(q.rarity, equals(QuestionRarity.common));
            expect(q.options.length, equals(4));
            expect(q.correctIndex, inInclusiveRange(0, 3));
            expect(q.category, equals(category));
          }
        });
      }
    });

    group('getAllQuestions', () {
      test('returns a non-empty list', () async {
        final questions = await service.getAllQuestions();
        expect(questions, isNotEmpty);
      });

      test('returns all 25 questions (5 categories × 5 questions each)', () async {
        final questions = await service.getAllQuestions();
        expect(questions.length, equals(25));
      });

      test('all 5 categories are represented in the result', () async {
        final questions = await service.getAllQuestions();
        const expectedCategories = {'science', 'geography', 'history', 'sport', 'entertainment'};
        final actualCategories = questions.map((q) => q.category).toSet();
        expect(actualCategories, equals(expectedCategories));
      });

      test('respects provided Random instance for shuffling', () async {
        final result1 = await service.getAllQuestions(random: Random(42));
        final result2 = await service.getAllQuestions(random: Random(42));
        expect(
          result1.map((q) => q.id).toList(),
          equals(result2.map((q) => q.id).toList()),
          reason: 'same seed should produce same order',
        );
      });
    });
  });
}
