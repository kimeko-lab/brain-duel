import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/data/services/mock/mock_question_service.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';
import 'package:brain_duel/features/daily/domain/notifiers/daily_classic_notifier.dart';
import 'package:brain_duel/features/daily/domain/state/daily_classic_state.dart';

final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => MockQuestionService(),
);

final dailyClassicProvider =
    StateNotifierProvider<DailyClassicNotifier, DailyClassicState>((ref) {
  return DailyClassicNotifier(ref.watch(questionRepositoryProvider));
});
