import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_duel/features/daily/domain/providers/question_providers.dart';
import 'package:brain_duel/features/rush/domain/notifiers/rush_notifier.dart';
import 'package:brain_duel/features/rush/domain/state/rush_state.dart';

final rushProvider =
    StateNotifierProvider<RushNotifier, RushState>((ref) {
  return RushNotifier(ref.watch(questionRepositoryProvider));
});
