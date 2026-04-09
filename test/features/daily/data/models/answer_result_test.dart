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

    test('AnswerResult with isCorrect: true', () {
      const answerResult = AnswerResult(
        questionId: 'q2',
        isCorrect: true,
        responseMs: 3000,
        scoreEarned: 150,
      );

      expect(answerResult.isCorrect, true);
      expect(answerResult.scoreEarned, greaterThan(0));
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
