import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/daily/data/models/question_model.dart';

void main() {
  group('QuestionModel', () {
    test('QuestionModel can be constructed and all fields are accessible', () {
      const question = QuestionModel(
        id: 'q1',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctIndex: 2,
      );

      expect(question.id, 'q1');
      expect(question.category, 'science');
      expect(question.rarity, QuestionRarity.common);
      expect(question.text, 'What is the capital of France?');
      expect(question.options, ['London', 'Berlin', 'Paris', 'Madrid']);
      expect(question.correctIndex, 2);
    });

    test('options has the expected length of 4', () {
      const question = QuestionModel(
        id: 'q1',
        category: 'geography',
        rarity: QuestionRarity.rare,
        text: 'What is the largest planet?',
        options: ['Mars', 'Earth', 'Jupiter', 'Saturn'],
        correctIndex: 2,
      );

      expect(question.options.length, 4);
    });

    test('two models with same fields are equal', () {
      const a = QuestionModel(
        id: 'q1', category: 'science', rarity: QuestionRarity.common,
        text: 'Question?', options: ['A', 'B', 'C', 'D'], correctIndex: 0,
      );
      const b = QuestionModel(
        id: 'q1', category: 'science', rarity: QuestionRarity.common,
        text: 'Question?', options: ['A', 'B', 'C', 'D'], correctIndex: 0,
      );
      expect(a, equals(b));
    });
  });
}
