import '../../data/models/question_model.dart';

abstract class QuestionRepository {
  Future<List<QuestionModel>> getQuestionsForCategory(String category);
  /// Returns all questions across all categories in a random order.
  Future<List<QuestionModel>> getAllQuestions();
}
