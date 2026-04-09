import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/data/services/mock/mock_question_service.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';

final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => MockQuestionService(),
);
