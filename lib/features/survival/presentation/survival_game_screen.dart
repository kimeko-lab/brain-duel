import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/background/arcane_library_background.dart';
import '../../daily/domain/state/daily_classic_state.dart';
import '../../daily/presentation/widgets/answer_option_tile.dart';
import '../../daily/presentation/widgets/countdown_timer.dart';
import '../../daily/presentation/widgets/question_card.dart';
import '../domain/providers/survival_providers.dart';
import '../domain/state/survival_state.dart';

class SurvivalGameScreen extends ConsumerStatefulWidget {
  const SurvivalGameScreen({super.key});

  @override
  ConsumerState<SurvivalGameScreen> createState() =>
      _SurvivalGameScreenState();
}

class _SurvivalGameScreenState extends ConsumerState<SurvivalGameScreen> {
  DateTime? _questionStartTime;

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(survivalProvider.notifier).loadQuestions();
    });
  }

  void _handleAnswer(int index) {
    final responseMs = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 10000;
    ref.read(survivalProvider.notifier).submitAnswer(index, responseMs);
  }

  void _handleTimerExpired() {
    ref.read(survivalProvider.notifier).timerExpired();
  }

  /// Maps [SurvivalPhase] to the [GamePhase] enum used by reusable widgets.
  GamePhase _toGamePhase(SurvivalPhase phase) {
    switch (phase) {
      case SurvivalPhase.loading:
        return GamePhase.loading;
      case SurvivalPhase.answering:
        return GamePhase.answering;
      case SurvivalPhase.showingFeedback:
        return GamePhase.showingFeedback;
      case SurvivalPhase.finished:
        return GamePhase.finished;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SurvivalState>(survivalProvider, (prev, next) {
      if (next.phase == SurvivalPhase.answering &&
          (prev == null || prev.phase != SurvivalPhase.answering)) {
        _questionStartTime = DateTime.now();
      }
      if (next.phase == SurvivalPhase.finished) {
        context.go('/survival/result', extra: {
          'score': next.score,
          'crystals': next.crystals,
          'correctCount': next.correctCount,
          'totalCount': next.answers.length,
        });
      }
    });

    final state = ref.watch(survivalProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ArcaneLibraryBackground(
        child: SafeArea(
          child: _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SurvivalState state) {
    if (state.phase == SurvivalPhase.loading || state.currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    final question = state.currentQuestion!;
    final phase = state.phase;
    final isAnswering = phase == SurvivalPhase.answering;
    final gamePhase = _toGamePhase(phase);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'QUESTION ${state.currentIndex + 1}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  '🔥 ${state.correctCount}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.center,
            child: CountdownTimer(
              key: ValueKey(state.currentIndex),
              onExpired: _handleTimerExpired,
              isActive: isAnswering,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          QuestionCard(question: question),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                question.options.length.clamp(0, 4),
                (i) => AnswerOptionTile(
                  key: ValueKey('option_${state.currentIndex}_$i'),
                  label: _optionLabels[i],
                  text: question.options[i],
                  index: i,
                  correctIndex: question.correctIndex,
                  selectedIndex: state.selectedIndex,
                  phase: gamePhase,
                  onTap: isAnswering ? () => _handleAnswer(i) : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
