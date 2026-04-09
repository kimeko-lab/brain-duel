import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';

void main() {
  group('QuestionModel', () {
    test('QuestionModel can be constructed and all fields are accessible', () {
      const question = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: 'common',
        text: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctIndex: 2,
      );

      expect(question.id, 'q1');
      expect(question.category, 'science');
      expect(question.rarity, 'common');
      expect(question.text, 'What is the capital of France?');
      expect(question.options, ['London', 'Berlin', 'Paris', 'Madrid']);
      expect(question.correctIndex, 2);
    });

    test('options has the expected length of 4', () {
      const question = QuestionModel(
        id: 'q1',
        category: 'geography',
        rarity: 'rare',
        text: 'What is the largest planet?',
        options: ['Mars', 'Earth', 'Jupiter', 'Saturn'],
        correctIndex: 2,
      );

      expect(question.options.length, 4);
    });

    test('correctIndex is within valid range (0-3)', () {
      const question0 = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: 'common',
        text: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      );
      expect(question0.correctIndex, greaterThanOrEqualTo(0));
      expect(question0.correctIndex, lessThanOrEqualTo(3));

      const question1 = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: 'common',
        text: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 1,
      );
      expect(question1.correctIndex, greaterThanOrEqualTo(0));
      expect(question1.correctIndex, lessThanOrEqualTo(3));

      const question2 = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: 'common',
        text: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 2,
      );
      expect(question2.correctIndex, greaterThanOrEqualTo(0));
      expect(question2.correctIndex, lessThanOrEqualTo(3));

      const question3 = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: 'common',
        text: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 3,
      );
      expect(question3.correctIndex, greaterThanOrEqualTo(0));
      expect(question3.correctIndex, lessThanOrEqualTo(3));
    });
  });
}
