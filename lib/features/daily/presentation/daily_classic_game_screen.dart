import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/providers/question_providers.dart';
import '../domain/state/daily_classic_state.dart';
import 'widgets/answer_option_tile.dart';
import 'widgets/countdown_timer.dart';
import 'widgets/question_card.dart';
import 'widgets/round_progress_bar.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg       = Color(0xFF06161A);
const Color _cardDark = Color(0xFF112226);
const Color _border   = Color(0xFF2D4A4A);

// ─── Category helpers ─────────────────────────────────────────────────────────

List<Color> _gradientFor(String cat) {
  const map = <String, List<Color>>{
    'science':       [Color(0xFFF97316), Color(0xFFC2410C)],
    'geography':     [Color(0xFF0EA5E9), Color(0xFF0369A1)],
    'history':       [Color(0xFFA855F7), Color(0xFF6B21A8)],
    'sport':         [Color(0xFF00D084), Color(0xFF008A5B)],
    'entertainment': [Color(0xFFEC4899), Color(0xFFBE185D)],
  };
  return map[cat] ?? [const Color(0xFF00D084), const Color(0xFF008A5B)];
}

IconData _iconFor(String cat) {
  switch (cat) {
    case 'science':       return Icons.science_rounded;
    case 'geography':     return Icons.public_rounded;
    case 'history':       return Icons.history_edu_rounded;
    case 'sport':         return Icons.sports_rounded;
    case 'entertainment': return Icons.movie_rounded;
    default:              return Icons.quiz_rounded;
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

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

  /// Shows the abort confirmation dialog.
  /// The game timer intentionally keeps running while the dialog is open —
  /// this prevents abuse of the daily attempt quota.
  void _showAbortDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D2226),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        title: const Text(
          'Abort Quiz?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'The timer is still running. Your daily attempt for this category will be used regardless.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
            height: 1.5,
          ),
        ),
        actionsPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    const Color(0xFF00D084).withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Keep Playing',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF00D084),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF6B6B).withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/');
              },
              child: const Text(
                'Abort',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    // PopScope intercepts the system back gesture/button.
    // canPop: false prevents automatic pop; we handle it manually via
    // onPopInvokedWithResult so the abort dialog (and timer) fire instead.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showAbortDialog();
      },
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DailyClassicState state) {
    if (state.phase == GamePhase.loading || state.currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D084)),
        ),
      );
    }

    final question     = state.currentQuestion!;
    final phase        = state.phase;
    final isAnswering  = phase == GamePhase.answering;
    final catName      = widget.category[0].toUpperCase() +
                         widget.category.substring(1);
    final gradColors   = _gradientFor(widget.category);
    final catIcon      = _iconFor(widget.category);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top bar: [← Abort] ················· [Q X / Y] ────────────
          Row(
            children: [
              GestureDetector(
                onTap: _showAbortDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 11,
                        color: Colors.white60,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Abort',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Text(
                  'Q ${state.currentIndex + 1} / ${state.questions.length}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Category logo ──────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradColors,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradColors[0].withValues(alpha: 0.40),
                        blurRadius: 20,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Icon(catIcon, color: Colors.white, size: 34),
                ),
                const SizedBox(height: 7),
                Text(
                  catName.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Countdown timer (full-width progress bar) ──────────────────
          CountdownTimer(
            key: ValueKey(state.currentIndex),
            onExpired: _handleTimerExpired,
            isActive: isAnswering,
          ),

          const SizedBox(height: 10),

          // ── Round progress ─────────────────────────────────────────────
          RoundProgressBar(
            current: state.currentIndex + 1,
            total: state.questions.length,
          ),

          const SizedBox(height: 12),

          // ── Question card ──────────────────────────────────────────────
          QuestionCard(question: question),

          const SizedBox(height: 14),

          // ── Answer grid ────────────────────────────────────────────────
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
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
