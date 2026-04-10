import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/background/sky_background.dart';
import '../domain/providers/question_providers.dart';
import '../domain/state/daily_classic_state.dart';
import 'widgets/answer_option_tile.dart';
import 'widgets/countdown_timer.dart';
import 'widgets/question_card.dart';
import 'widgets/round_progress_bar.dart';

class DailyClassicGameScreen extends ConsumerStatefulWidget {
  const DailyClassicGameScreen({super.key, required this.category});

  final String category;

  @override
  ConsumerState<DailyClassicGameScreen> createState() =>
      _DailyClassicGameScreenState();
}

class _DailyClassicGameScreenState
    extends ConsumerState<DailyClassicGameScreen> {
  DateTime? _questionStartTime;

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dailyClassicProvider.notifier)
          .loadQuestions(widget.category);
    });
  }

  void _handleAnswer(int index) {
    final responseMs = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 10000;
    ref
        .read(dailyClassicProvider.notifier)
        .submitAnswer(index, responseMs);
  }

  void _handleTimerExpired() {
    ref.read(dailyClassicProvider.notifier).timerExpired();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for finished phase → navigate to result
    ref.listen<DailyClassicState>(dailyClassicProvider, (prev, next) {
      if (next.phase == GamePhase.answering &&
          (prev == null || prev.phase != GamePhase.answering)) {
        _questionStartTime = DateTime.now();
      }
      if (next.phase == GamePhase.finished) {
        context.go('/daily/result', extra: {
          'score': next.score,
          'crystals': next.crystals,
          'correctCount': next.answers.where((a) => a.isCorrect).length,
          'totalCount': next.answers.length,
        });
      }
    });

    final state = ref.watch(dailyClassicProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DailyClassicState state) {
    if (state.phase == GamePhase.loading || state.currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    final question = state.currentQuestion!;
    final phase = state.phase;
    final isAnswering = phase == GamePhase.answering;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundProgressBar(
            current: state.currentIndex + 1,
            total: state.questions.length,
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
                  phase: phase,
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
