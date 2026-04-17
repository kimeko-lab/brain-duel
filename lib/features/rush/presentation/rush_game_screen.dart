import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../daily/domain/state/daily_classic_state.dart';
import '../../daily/presentation/widgets/answer_option_tile.dart';
import '../../daily/presentation/widgets/question_card.dart';
import '../domain/providers/rush_providers.dart';
import '../domain/state/rush_state.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg       = Color(0xFF06161A);
const Color _cardDark = Color(0xFF112226);
const Color _border   = Color(0xFF2D4A4A);

class RushGameScreen extends ConsumerStatefulWidget {
  const RushGameScreen({super.key});

  @override
  ConsumerState<RushGameScreen> createState() => _RushGameScreenState();
}

class _RushGameScreenState extends ConsumerState<RushGameScreen> {
  DateTime? _questionStartTime;

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rushProvider.notifier).loadQuestions();
    });
  }

  void _handleAnswer(int index) {
    final responseMs = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 10000;
    ref.read(rushProvider.notifier).submitAnswer(index, responseMs);
  }

  /// Shows abort confirmation — global timer keeps running.
  void _showAbortDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D2226),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: const Text(
          'Abort Game?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'The countdown is still running. Your current progress will be lost.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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

  /// Maps [RushPhase] → [GamePhase] for reusable widgets.
  GamePhase _toGamePhase(RushPhase phase) {
    switch (phase) {
      case RushPhase.loading:         return GamePhase.loading;
      case RushPhase.answering:       return GamePhase.answering;
      case RushPhase.showingFeedback: return GamePhase.showingFeedback;
      case RushPhase.finished:        return GamePhase.finished;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RushState>(rushProvider, (prev, next) {
      if (next.phase == RushPhase.answering &&
          (prev == null || prev.phase != RushPhase.answering)) {
        _questionStartTime = DateTime.now();
      }
      if (next.phase == RushPhase.finished) {
        context.go('/rush/result', extra: {
          'score':        next.score,
          'crystals':     next.crystals,
          'correctCount': next.correctCount,
          'totalCount':   next.answers.length,
        });
      }
    });

    final state = ref.watch(rushProvider);

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

  Widget _buildBody(BuildContext context, RushState state) {
    if (state.phase == RushPhase.loading || state.currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFACC15)),
        ),
      );
    }

    final question    = state.currentQuestion!;
    final phase       = state.phase;
    final isAnswering = phase == RushPhase.answering;
    final gamePhase   = _toGamePhase(phase);

    // Timer color: green → yellow → red
    final secsLeft = state.timeRemainingMs / 1000;
    final timerColor = secsLeft > 20
        ? const Color(0xFF00D084)
        : secsLeft > 10
            ? const Color(0xFFFACC15)
            : const Color(0xFFFF6B6B);
    final timerProgress = (state.timeRemainingMs / 60000).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top bar: [← Abort] ··············· [answered] ────────────
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
              // Answered counter
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
                  '${state.answers.length} answered',
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

          // ── Rush mode logo ────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFACC15), Color(0xFFB45309)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFACC15).withValues(alpha: 0.40),
                        blurRadius: 20,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'RUSH',
                  style: TextStyle(
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

          // ── Global 60s countdown bar ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: timerProgress,
                    minHeight: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 38,
                child: Text(
                  '${secsLeft.ceil()}s',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: timerColor,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Question card ─────────────────────────────────────────────
          QuestionCard(question: question),

          const SizedBox(height: 14),

          // ── Answer grid ───────────────────────────────────────────────
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
