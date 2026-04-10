import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/domain/providers/question_providers.dart';
import 'package:brain_duel/features/survival/domain/notifiers/survival_notifier.dart';
import 'package:brain_duel/features/survival/domain/state/survival_state.dart';

final survivalProvider =
    StateNotifierProvider<SurvivalNotifier, SurvivalState>((ref) {
  return SurvivalNotifier(ref.watch(questionRepositoryProvider));
});
