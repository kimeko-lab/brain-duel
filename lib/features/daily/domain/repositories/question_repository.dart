import '../../data/models/question_model.dart';

abstract class QuestionRepository {
  Future<List<QuestionModel>> getQuestionsForCategory(String category);
}
