import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'event_tokens.dart';
import 'widgets/day_box.dart';
import 'widgets/ink_button.dart';
import 'widgets/leaderboard_row.dart';
import 'widgets/manga_panel.dart';
import 'widgets/manga_paper_background.dart';
import 'widgets/milestone_row.dart';
import 'widgets/podium_slot.dart';
import 'widgets/sfx_text.dart';
import 'widgets/speed_lines.dart';
import 'widgets/starburst_badge.dart';

/// Events screen — manga page redesign (see spec
/// docs/superpowers/specs/2026-04-19-events-manga-redesign-design.md).
class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Mock state (same shape as pre-redesign screen)
  int _claimedUpTo = 2;
  bool _todayClaimed = false;
  static const int _todayIndex = 3; // D4
  static const bool _dailyClassicDone = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _claimToday() {
    if (_todayClaimed) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _todayClaimed = true;
      _claimedUpTo = _todayIndex + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Day ${_todayIndex + 1} claimed! +1 📘',
          style: EventTokens.bangers(
            size: 16,
            color: EventTokens.paper,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: EventTokens.ink,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: EventTokens.red, width: 2),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Clamp text scaling to 1.3× inside Events tab to prevent manga display
    // fonts from overflowing fixed-size panels.
    final clamped = mq.copyWith(
      textScaler: TextScaler.linear(
        mq.textScaler.scale(1).clamp(1.0, 1.3),
      ),
    );

    return MediaQuery(
      data: clamped,
      child: Scaffold(
        // Dark bg outside the paper area keeps bottom nav area consistent.
        backgroundColor: const Color(0xFF06081F),
        body: MangaPaperBackground(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopBar(),
                const SizedBox(height: 10),
                _buildTabSelector(),
                const SizedBox(height: 12),
                Expanded(
                  child: IndexedStack(
                    index: _tabs.index,
                    children: [
                      _PlayTab(
                        claimedUpTo: _claimedUpTo,
                        todayClaimed: _todayClaimed,
                        todayIndex: _todayIndex,
                        dailyClassicDone: _dailyClassicDone,
                        onClaim: _claimToday,
                      ),
                      const _RewardsTab(),
                      const _RankTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Row(
        children: [
          Transform.rotate(
            angle: -2 * 3.1415926535 / 180,
            child: Text(
              'EVENTS',
              style: EventTokens.bangers(
                size: 32,
                color: EventTokens.ink,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Transform.rotate(
            angle: 1.5 * 3.1415926535 / 180,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: EventTokens.ink,
                border: Border.all(color: EventTokens.ink, width: 2),
              ),
              child: Text(
                'SEASON 1',
                style: EventTokens.bebas(
                  size: 12,
                  color: EventTokens.paper,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: EventTokens.ink, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: EventTokens.ink,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              '★ 430 XP',
              style: EventTokens.bebas(
                size: 13,
                color: EventTokens.ink,
                letterSpacing: 0.5,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab selector ──────────────────────────────────────────────────────

  Widget _buildTabSelector() {
    const labels = ['PLAY', 'REWARDS', 'RANK'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _tabs.index == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < labels.length - 1 ? 6 : 0),
              child: GestureDetector(
                onTap: () {
                  if (_tabs.index != i) HapticFeedback.selectionClick();
                  _tabs.animateTo(i);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? EventTokens.ink : Colors.white,
                    border: Border.all(color: EventTokens.ink, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: EventTokens.ink,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: EventTokens.bangers(
                      size: 14,
                      color: active ? EventTokens.paper : EventTokens.ink,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLAY TAB
// ─────────────────────────────────────────────────────────────────────────────

class _PlayTab extends StatelessWidget {
  const _PlayTab({
    required this.claimedUpTo,
    required this.todayClaimed,
    required this.todayIndex,
    required this.dailyClassicDone,
    required this.onClaim,
  });

  final int claimedUpTo;
  final bool todayClaimed;
  final int todayIndex;
  final bool dailyClassicDone;
  final VoidCallback onClaim;

  static const _rewards = [
    '50💎',
    '1📘',
    '100💎',
    '1📘',
    '200💎',
    '2📗',
    '🃏',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
      physics: const BouncingScrollPhysics(),
      children: [
        _FeaturedPanel(),
        const SizedBox(height: 10),
        _DailyLoginPanel(
          claimedUpTo: claimedUpTo,
          todayClaimed: todayClaimed,
          todayIndex: todayIndex,
          rewards: _rewards,
          onClaim: onClaim,
        ),
        const SizedBox(height: 14),
        Transform.rotate(
          angle: -1 * 3.1415926535 / 180,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'EVENT MODES',
              style: EventTokens.bangers(
                size: 16,
                color: EventTokens.ink,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _ClassicModeCard(isDone: dailyClassicDone),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SmallModeCard(
                icon: '🔥',
                title: 'SURVIVAL',
                xpText: '+80 XP/RUN',
                route: '/survival/game',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SmallModeCard(
                icon: '⚡',
                title: 'RUSH',
                xpText: '+60 XP/RUN',
                route: '/rush/game',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SmallModeCard(
          icon: '🗓',
          title: 'DAILY',
          xpText: '+40 XP · 1×/DAY',
          route: '/daily/select',
          wide: true,
        ),
      ],
    );
  }
}

class _FeaturedPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MangaPanel(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            const Positioned.fill(child: SpeedLines()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: -3 * 3.1415926535 / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: EventTokens.red,
                      border: Border.all(color: EventTokens.ink, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: EventTokens.ink,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      'LIVE NOW!!',
                      style: EventTokens.bangers(
                        size: 13,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'JAPANESE\nANIME',
                  style: EventTokens.bangers(
                    size: 28,
                    color: EventTokens.ink,
                    letterSpacing: 0.5,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '1,000 exclusive questions',
                  style: EventTokens.inter(
                    size: 11,
                    weight: FontWeight.w700,
                    color: EventTokens.ink.withValues(alpha: 0.70),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 10,
              child: StarburstBadge(
                size: 88,
                color: EventTokens.red,
                label: '14',
                sublabel: 'DAYS LEFT',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyLoginPanel extends StatelessWidget {
  const _DailyLoginPanel({
    required this.claimedUpTo,
    required this.todayClaimed,
    required this.todayIndex,
    required this.rewards,
    required this.onClaim,
  });

  final int claimedUpTo;
  final bool todayClaimed;
  final int todayIndex;
  final List<String> rewards;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return MangaPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7-DAY STREAK',
                style: EventTokens.bangers(
                    size: 18, color: EventTokens.ink, letterSpacing: 0.5),
              ),
              Text(
                todayClaimed
                    ? 'CLAIMED TODAY!'
                    : 'D${todayIndex + 1} · TAP TO CLAIM!',
                style: EventTokens.bebas(
                  size: 11,
                  color: EventTokens.red,
                  letterSpacing: 0.6,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(7, (i) {
              final isClaimed =
                  i < claimedUpTo || (i == todayIndex && todayClaimed);
              final isToday = i == todayIndex && !todayClaimed;
              final state = isClaimed
                  ? DayBoxState.claimed
                  : isToday
                      ? DayBoxState.today
                      : DayBoxState.future;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 4 : 0),
                  child: DayBox(
                    dayNumber: i + 1,
                    state: state,
                    reward: rewards[i],
                    onTap: isToday ? onClaim : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ClassicModeCard extends StatelessWidget {
  const _ClassicModeCard({required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final bg = isDone
        ? Colors.white
        : null; // gradient handled via Container decoration below

    return GestureDetector(
      onTap: isDone
          ? null
          : () {
              HapticFeedback.mediumImpact();
              context.go('/daily/select');
            },
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          gradient: isDone
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF9DC), Color(0xFFFFE88F)],
                ),
          border: Border.all(color: EventTokens.ink, width: 3),
          boxShadow: const [
            BoxShadow(
              color: EventTokens.ink,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLASSIC',
                    style: EventTokens.bangers(
                      size: 18,
                      color: EventTokens.ink,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    isDone ? 'DONE TODAY · +50 EVENT XP' : '+50 EVENT XP',
                    style: EventTokens.bebas(
                      size: 11,
                      color: EventTokens.ink.withValues(alpha: 0.70),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isDone)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: EventTokens.doneGreen,
                  border: Border.all(color: EventTokens.ink, width: 2),
                ),
                child: Text(
                  'DONE',
                  style: EventTokens.bangers(
                    size: 12,
                    color: EventTokens.paper,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            else
              const InkButton(
                label: 'PLAY!',
                backgroundColor: EventTokens.ink,
                foregroundColor: EventTokens.paper,
                fontSize: 12,
                rotationDeg: -2,
              ),
          ],
        ),
      ),
    );
  }
}

class _SmallModeCard extends StatelessWidget {
  const _SmallModeCard({
    required this.icon,
    required this.title,
    required this.xpText,
    required this.route,
    this.wide = false,
  });

  final String icon;
  final String title;
  final String xpText;
  final String route;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.go(route);
      },
      child: MangaPanel(
        backgroundColor: Colors.white,
        shadowOffset: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SizedBox(
          height: wide ? 56 : 68,
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: EventTokens.bangers(
                        size: 16,
                        color: EventTokens.ink,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      xpText,
                      style: EventTokens.bebas(
                        size: 10,
                        color: EventTokens.ink.withValues(alpha: 0.70),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const InkButton(
                label: 'PLAY!',
                backgroundColor: EventTokens.ink,
                foregroundColor: EventTokens.paper,
                fontSize: 12,
                rotationDeg: -2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REWARDS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _RewardsTab extends StatelessWidget {
  const _RewardsTab();

  static const int _currentXp = 430;
  static const int _seasonTarget = 1000;

  static const _milestones = [
    MilestoneData(
      xp: 100,
      icon: '💎',
      label: '50 CRYSTALS',
      state: MilestoneState.claimed,
    ),
    MilestoneData(
      xp: 200,
      icon: '📕',
      label: 'SILVER BOOK',
      state: MilestoneState.claimed,
    ),
    MilestoneData(
      xp: 350,
      icon: '💎',
      label: '100 CRYSTALS',
      state: MilestoneState.claimed,
    ),
    MilestoneData(
      xp: 500,
      icon: '📘',
      label: 'EVENT BOOK',
      state: MilestoneState.next,
    ),
    MilestoneData(
      xp: 650,
      icon: '🃏',
      label: 'UNCOMMON CARD',
      state: MilestoneState.future,
    ),
    MilestoneData(
      xp: 800,
      icon: '📘',
      label: '2× EVENT BOOK',
      state: MilestoneState.future,
    ),
    MilestoneData(
      xp: 1000,
      icon: '★',
      label: 'RARE EVENT CARD',
      state: MilestoneState.future,
      isFinal: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
      physics: const BouncingScrollPhysics(),
      children: [
        MangaPanel(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SEASON PASS',
                    style: EventTokens.bangers(
                      size: 16,
                      color: EventTokens.ink,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '$_currentXp / $_seasonTarget',
                    style: EventTokens.bebas(
                      size: 11,
                      color: EventTokens.ink,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SeasonBar(
                progress: _currentXp / _seasonTarget,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._milestones.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MilestoneRow(data: m, currentXp: _currentXp),
          ),
        ),
      ],
    );
  }
}

class _SeasonBar extends StatelessWidget {
  const _SeasonBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: EventTokens.ink, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          return Align(
            alignment: Alignment.centerLeft,
            child: ClipRect(
              child: SizedBox(
                width: c.maxWidth * progress.clamp(0.0, 1.0),
                height: c.maxHeight,
                child: CustomPaint(painter: _HatchingPainter()),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HatchingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintInk = Paint()
      ..color = EventTokens.ink
      ..strokeWidth = 3;
    final paintAlt = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 3;
    const gap = 8.0;
    final length = size.width + size.height;
    bool alt = false;
    for (double t = -size.height; t < length; t += gap) {
      canvas.drawLine(
        Offset(t, 0),
        Offset(t + size.height, size.height),
        alt ? paintAlt : paintInk,
      );
      alt = !alt;
    }
  }

  @override
  bool shouldRepaint(covariant _HatchingPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// RANK TAB
// ─────────────────────────────────────────────────────────────────────────────

class _RankTab extends StatelessWidget {
  const _RankTab();

  static const List<LbEntry> _entries = [
    LbEntry(rank: 1, name: 'AnimeMaster', xp: 1250),
    LbEntry(rank: 2, name: 'QuizKing', xp: 1100),
    LbEntry(rank: 3, name: 'BrainDuelist', xp: 980),
    LbEntry(rank: 4, name: 'TriviaPro', xp: 870),
    LbEntry(rank: 5, name: 'KnowledgeHunter', xp: 760),
    LbEntry(rank: 6, name: 'AnimeExpert', xp: 650),
    LbEntry(rank: 7, name: 'QuizWizard', xp: 590),
    LbEntry(rank: 8, name: 'StudyBuddy', xp: 480),
  ];

  static const LbEntry _me = LbEntry(rank: 42, name: 'You', xp: 430, isMe: true);

  LbEntry? _slotFor(int rank) {
    try {
      return _entries.firstWhere((e) => e.rank == rank);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInTop3 = _me.rank <= 3;
    final others = _entries.where((e) => e.rank > 3).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
      physics: const BouncingScrollPhysics(),
      children: [
        _PodiumPanel(
          one: _slotFor(1),
          two: _slotFor(2),
          three: _slotFor(3),
          meRank: _me.rank,
        ),
        const SizedBox(height: 10),
        _YourRankChip(rank: _me.rank, xp: _me.xp),
        const SizedBox(height: 12),
        if (others.isNotEmpty) ...[
          Transform.rotate(
            angle: -1 * 3.1415926535 / 180,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OTHER PLAYERS',
                style: EventTokens.bangers(
                  size: 15,
                  color: EventTokens.ink,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          ...others.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: LeaderboardRow(entry: e),
            ),
          ),
        ],
        if (!userInTop3) ...[
          const SizedBox(height: 10),
          Text(
            '· · · ·',
            textAlign: TextAlign.center,
            style: EventTokens.bebas(
              size: 11,
              color: EventTokens.ink.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 6),
          LeaderboardRow(entry: _me),
        ],
      ],
    );
  }
}

class _PodiumPanel extends StatelessWidget {
  const _PodiumPanel({
    required this.one,
    required this.two,
    required this.three,
    required this.meRank,
  });

  final LbEntry? one;
  final LbEntry? two;
  final LbEntry? three;
  final int meRank;

  @override
  Widget build(BuildContext context) {
    return MangaPanel(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Transform.rotate(
              angle: -1 * 3.1415926535 / 180,
              child: Text(
                'TOP 3 ★',
                style: EventTokens.bangers(
                  size: 14,
                  color: EventTokens.ink,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const Positioned(
            top: -4,
            right: 4,
            child: SfxText(text: 'WOW!!', size: 18, rotationDeg: 8),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 10, child: _slot(2, two)),
                const SizedBox(width: 8),
                Expanded(flex: 12, child: _slot(1, one)),
                const SizedBox(width: 8),
                Expanded(flex: 10, child: _slot(3, three)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slot(int rank, LbEntry? e) {
    return PodiumSlot(
      rank: rank,
      name: e?.name ?? '—',
      xp: e?.xp ?? 0,
      isMe: meRank == rank,
      isPlaceholder: e == null,
    );
  }
}

class _YourRankChip extends StatelessWidget {
  const _YourRankChip({required this.rank, required this.xp});
  final int rank;
  final int xp;

  @override
  Widget build(BuildContext context) {
    return MangaPanel(
      backgroundColor: EventTokens.red,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'YOUR RANK',
                  style: EventTokens.bebas(
                    size: 10,
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '#$rank',
                  style: EventTokens.bangers(
                    size: 20,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$xp XP',
            style: EventTokens.bangers(
              size: 18,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
