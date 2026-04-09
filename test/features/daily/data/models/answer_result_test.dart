import 'package:flutter_test/flutter_test.dart';
import 'package:brain_duel/features/daily/data/models/answer_result.dart';

void main() {
  group('AnswerResult', () {
    test('AnswerResult can be constructed and all fields are accessible', () {
      const answerResult = AnswerResult(
        questionId: 'q1',
        isCorrect: true,
        responseMs: 5000,
        scoreEarned: 100,
      );

      expect(answerResult.questionId, 'q1');
      expect(answerResult.isCorrect, true);
      expect(answerResult.responseMs, 5000);
      expect(answerResult.scoreEarned, 100);
    });

    test('two results with same fields are equal', () {
      const a = AnswerResult(questionId: 'q1', isCorrect: true, responseMs: 1200, scoreEarned: 760);
      const b = AnswerResult(questionId: 'q1', isCorrect: true, responseMs: 1200, scoreEarned: 760);
      expect(a, equals(b));
    });

    test('AnswerResult with isCorrect: false', () {
      const answerResult = AnswerResult(
        questionId: 'q3',
        isCorrect: false,
        responseMs: 8000,
        scoreEarned: 0,
      );

      expect(answerResult.isCorrect, false);
      expect(answerResult.scoreEarned, 0);
    });
  });
}
