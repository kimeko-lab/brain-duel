import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Design tokens (identical to home_screen.dart) ────────────────────────────

const Color _bg       = Color(0xFF06161A);
const Color _primary  = Color(0xFF00D084);
const Color _cardDark = Color(0xFF112226);
const Color _textSub  = Color(0xFF9CA3AF);
const Color _border   = Color(0xFF2D4A4A);
const Color _purple   = Color(0xFFA855F7);

// ─── Mode palette ─────────────────────────────────────────────────────────────

const Color _classicColor  = Color(0xFF00D084);
const Color _survivalColor = Color(0xFFEF4444);
const Color _rushColor     = Color(0xFFFACC15);
const Color _dailyColor    = Color(0xFF0EA5E9);

// ─── Screen ───────────────────────────────────────────────────────────────────

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Days 0-2 claimed; day 3 = today (claimable)
  int  _claimedUpTo  = 2;
  bool _todayClaimed = false;

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
    setState(() {
      _todayClaimed = true;
      _claimedUpTo  = 3;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Day 4 reward claimed!  +1 Event Book',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildEventBanner(),
            const SizedBox(height: 14),
            _buildTabSelector(),
            const SizedBox(height: 14),
            Expanded(
              child: IndexedStack(
                index: _tabs.index,
                children: [
                  _PlayTab(
                    claimedUpTo:  _claimedUpTo,
                    todayClaimed: _todayClaimed,
                    onClaim:      _claimToday,
                  ),
                  const _RewardsTab(),
                  const _LeaderboardTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Text(
            'Events',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _purple.withValues(alpha: 0.35)),
            ),
            child: const Text(
              'Season 1',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _purple,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),
          // Season XP pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: _cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _purple.withValues(alpha: 0.30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: _purple, size: 14),
                const SizedBox(width: 5),
                const Text(
                  '430 XP',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Featured event banner ─────────────────────────────────────────────────

  Widget _buildEventBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 120),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFF3730A3)],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -20, top: -20,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                right: 28, bottom: -30,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // "LIVE NOW" badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'LIVE NOW',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.3,
                                height: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Japanese Anime',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1,000 exclusive questions',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // XP progress bar
                          Row(
                            children: [
                              Text(
                                'Season XP',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  color: Colors.white.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: const LinearProgressIndicator(
                                    value: 430 / 1000,
                                    backgroundColor:
                                        Color(0x26FFFFFF), // white 15%
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '430 / 1000',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Colors.white.withValues(alpha: 0.80),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const _ProgressRing(
                      progress: 0.53,
                      size: 76,
                      strokeWidth: 6,
                      color: Colors.white,
                      label: '14',
                      sublabel: 'Days Left',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab selector ──────────────────────────────────────────────────────────

  Widget _buildTabSelector() {
    const labels = ['Play', 'Rewards', 'Leaderboard'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: List.generate(labels.length, (i) {
            final active = _tabs.index == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => _tabs.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: active ? _primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: active
                          ? const Color(0xFF06161A)
                          : _textSub,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Play Tab
// ─────────────────────────────────────────────────────────────────────────────

class _PlayTab extends StatelessWidget {
  const _PlayTab({
    required this.claimedUpTo,
    required this.todayClaimed,
    required this.onClaim,
  });

  final int claimedUpTo;
  final bool todayClaimed;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // ── Daily login ───────────────────────────────────────────────────
        const _SectionLabel(label: 'Daily Login'),
        const SizedBox(height: 8),
        _DailyLoginCard(
          claimedUpTo:  claimedUpTo,
          todayClaimed: todayClaimed,
          onClaim:      onClaim,
        ),
        const SizedBox(height: 20),

        // ── Event modes ───────────────────────────────────────────────────
        const _SectionLabel(label: 'Event Modes'),
        const SizedBox(height: 8),

        _EventModeCard(
          icon:        Icons.calendar_today_rounded,
          color:       _classicColor,
          title:       'Classic',
          xpText:      '+50 Event XP',
          statusText:  'Done today',
          statusColor: _classicColor,
          buttonLabel: 'Done',
          buttonStyle: _BtnStyle.done,
          onTap:       () => context.go('/daily/select'),
        ),
        const SizedBox(height: 8),

        _EventModeCard(
          icon:        Icons.local_fire_department_rounded,
          color:       _survivalColor,
          title:       'Survival',
          xpText:      '+80 Event XP per run',
          statusText:  'Event questions only',
          buttonLabel: 'Play',
          buttonStyle: _BtnStyle.survival,
          onTap:       () => context.go('/survival/game'),
        ),
        const SizedBox(height: 8),

        _EventModeCard(
          icon:        Icons.bolt_rounded,
          color:       _rushColor,
          title:       'Rush',
          xpText:      '+60 Event XP per run',
          statusText:  '60 seconds challenge',
          buttonLabel: 'Play',
          buttonStyle: _BtnStyle.rush,
          onTap:       () => context.go('/rush/game'),
        ),
        const SizedBox(height: 8),

        _EventModeCard(
          icon:        Icons.today_rounded,
          color:       _dailyColor,
          title:       'Daily',
          xpText:      '+40 Event XP · 1× per day',
          statusText:  'Special event question',
          buttonLabel: 'Play',
          buttonStyle: _BtnStyle.daily,
          onTap:       () => context.go('/daily/select'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Daily Login Card
// ─────────────────────────────────────────────────────────────────────────────

class _DailyLoginCard extends StatelessWidget {
  const _DailyLoginCard({
    required this.claimedUpTo,
    required this.todayClaimed,
    required this.onClaim,
  });

  final int claimedUpTo;
  final bool todayClaimed;
  final VoidCallback onClaim;

  // Day 3 (index) is today; 0-2 already claimed.
  static const int _todayIndex = 3;

  static const _rewards = [
    '50 💎', '1 📘', '100 💎', '📗 Book', '200 💎', '2 📗', '🃏 Card',
  ];

  @override
  Widget build(BuildContext context) {
    final canClaim = !todayClaimed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                '7-Day Streak',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                canClaim ? 'Day ${_todayIndex + 1} · Tap to claim' : 'Claimed today!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Day boxes
          Row(
            children: List.generate(7, (i) {
              final isClaimed = i < claimedUpTo || (i == _todayIndex && todayClaimed);
              final isToday   = i == _todayIndex;
              final isFuture  = i > _todayIndex;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 5 : 0),
                  child: GestureDetector(
                    onTap: (isToday && canClaim) ? onClaim : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isClaimed
                            ? _primary.withValues(alpha: 0.12)
                            : isToday
                                ? _primary.withValues(alpha: 0.20)
                                : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isClaimed
                              ? _primary.withValues(alpha: 0.40)
                              : isToday
                                  ? _primary
                                  : _border,
                          width: isToday ? 1.5 : 1.0,
                        ),
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: _primary.withValues(alpha: 0.28),
                                  blurRadius: 8,
                                  spreadRadius: -2,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon row
                          Text(
                            isClaimed
                                ? '✓'
                                : isToday
                                    ? '🎁'
                                    : '·',
                            style: TextStyle(
                              fontSize: isClaimed || isToday ? 12 : 10,
                              color: isClaimed || isToday
                                  ? _primary
                                  : _textSub,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _rewards[i],
                            style: TextStyle(
                              fontSize: 9,
                              color: isFuture
                                  ? _textSub
                                  : isClaimed
                                      ? _primary.withValues(alpha: 0.7)
                                      : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'D${i + 1}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: isFuture ? _textSub : _primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          // Reward hint for today
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 12, color: _textSub),
              const SizedBox(width: 5),
              Text(
                'Day 7 reward: guaranteed Rare event card',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: _textSub,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Event Mode Card
// ─────────────────────────────────────────────────────────────────────────────

enum _BtnStyle { done, survival, rush, daily, primary }

class _EventModeCard extends StatelessWidget {
  const _EventModeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.xpText,
    required this.statusText,
    required this.buttonLabel,
    required this.buttonStyle,
    required this.onTap,
    this.statusColor,
  });

  final IconData  icon;
  final Color     color;
  final String    title;
  final String    xpText;
  final String    statusText;
  final Color?    statusColor;
  final String    buttonLabel;
  final _BtnStyle buttonStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor   = color.withValues(alpha: 0.10);
    final bdrColor  = color.withValues(alpha: 0.28);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: bdrColor),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: bdrColor),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    xpText,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _purple,
                    ),
                  ),
                  if (statusText.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: statusColor ?? _textSub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Button
            _ModeButton(label: buttonLabel, style: buttonStyle),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.style});

  final String    label;
  final _BtnStyle style;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final bool  outlined;

    switch (style) {
      case _BtnStyle.done:
        bg      = _primary.withValues(alpha: 0.12);
        fg      = _primary;
        outlined = true;
      case _BtnStyle.survival:
        bg      = const Color(0xFFEF4444);
        fg      = Colors.white;
        outlined = false;
      case _BtnStyle.rush:
        bg      = const Color(0xFFFACC15);
        fg      = const Color(0xFF1A1000);
        outlined = false;
      case _BtnStyle.daily:
        bg      = const Color(0xFF0EA5E9);
        fg      = Colors.white;
        outlined = false;
      case _BtnStyle.primary:
        bg      = _primary;
        fg      = const Color(0xFF06161A);
        outlined = false;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: outlined
            ? Border.all(color: _primary.withValues(alpha: 0.35))
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rewards Tab
// ─────────────────────────────────────────────────────────────────────────────

class _RewardsTab extends StatelessWidget {
  const _RewardsTab();

  static const _milestones = [
    _Milestone(xp: 100,  icon: Icons.diamond_rounded,     color: Color(0xFF67E8F9), label: '50 Crystals',    claimed: true),
    _Milestone(xp: 200,  icon: Icons.menu_book_rounded,   color: Color(0xFFCBD5E1), label: '1 Silver Book',  claimed: true),
    _Milestone(xp: 350,  icon: Icons.diamond_rounded,     color: Color(0xFF67E8F9), label: '100 Crystals',   claimed: true),
    _Milestone(xp: 500,  icon: Icons.auto_stories_rounded,color: Color(0xFFA855F7), label: '1 Event Book',   claimed: false),
    _Milestone(xp: 650,  icon: Icons.style_rounded,       color: Color(0xFF0EA5E9), label: 'Uncommon Card',  claimed: false),
    _Milestone(xp: 800,  icon: Icons.auto_stories_rounded,color: Color(0xFFA855F7), label: '2 Event Books',  claimed: false),
    _Milestone(xp: 1000, icon: Icons.style_rounded,       color: Color(0xFFFBBF24), label: 'Rare Event Card',claimed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        const _SectionLabel(label: 'Season Pass'),
        const SizedBox(height: 4),

        // Overall progress row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _purple.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Text(
                'Season XP',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 430 / 1000,
                    backgroundColor: _border,
                    valueColor: const AlwaysStoppedAnimation<Color>(_purple),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '430 / 1000',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _purple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Milestone list
        ...List.generate(_milestones.length, (i) {
          final m         = _milestones[i];
          final isNext    = !m.claimed && (i == 0 || _milestones[i - 1].claimed);
          final progress  = (430 / m.xp).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RewardMilestoneRow(
              milestone: m,
              isNext: isNext,
              progress: progress,
            ),
          );
        }),
      ],
    );
  }
}

@immutable
class _Milestone {
  const _Milestone({
    required this.xp,
    required this.icon,
    required this.color,
    required this.label,
    required this.claimed,
  });

  final int      xp;
  final IconData icon;
  final Color    color;
  final String   label;
  final bool     claimed;
}

class _RewardMilestoneRow extends StatelessWidget {
  const _RewardMilestoneRow({
    required this.milestone,
    required this.isNext,
    required this.progress,
  });

  final _Milestone milestone;
  final bool       isNext;
  final double     progress;

  @override
  Widget build(BuildContext context) {
    final m = milestone;
    final dimmed = !m.claimed && !isNext;

    return Opacity(
      opacity: dimmed ? 0.55 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: m.claimed
                ? _primary.withValues(alpha: 0.30)
                : isNext
                    ? _purple.withValues(alpha: 0.45)
                    : _border,
            width: isNext ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: m.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: m.color.withValues(alpha: 0.35)),
              ),
              child: m.claimed
                  ? Icon(Icons.check_rounded, color: _primary, size: 20)
                  : Icon(m.icon, color: m.color, size: 20),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (m.claimed)
                    const Text(
                      'Claimed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _primary,
                      ),
                    )
                  else if (isNext)
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: _border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  _purple),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _purple,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '${m.xp} XP required',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: _textSub,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // XP badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: m.claimed
                    ? _primary.withValues(alpha: 0.10)
                    : _cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: m.claimed
                      ? _primary.withValues(alpha: 0.30)
                      : _border,
                ),
              ),
              child: Text(
                '${m.xp} XP',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: m.claimed ? _primary : _textSub,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Leaderboard Tab
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  static const _entries = [
    _LbEntry(rank: 1,  name: 'AnimeMaster',     xp: 1250, isMe: false),
    _LbEntry(rank: 2,  name: 'QuizKing',         xp: 1100, isMe: false),
    _LbEntry(rank: 3,  name: 'BrainDuelist',     xp:  980, isMe: false),
    _LbEntry(rank: 4,  name: 'TriviaPro',         xp:  870, isMe: false),
    _LbEntry(rank: 5,  name: 'KnowledgeHunter',  xp:  760, isMe: false),
    _LbEntry(rank: 6,  name: 'AnimeExpert',       xp:  650, isMe: false),
    _LbEntry(rank: 7,  name: 'QuizWizard',        xp:  590, isMe: false),
    _LbEntry(rank: 8,  name: 'StudyBuddy',        xp:  480, isMe: false),
    _LbEntry(rank: 9,  name: 'MegaMind',          xp:  455, isMe: false),
    _LbEntry(rank: 10, name: 'Challenger',        xp:  440, isMe: false),
  ];

  static const _me = _LbEntry(rank: 42, name: 'You', xp: 430, isMe: true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            // Your rank chip
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: _purple.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _purple.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events_rounded,
                      color: _purple, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Your rank:  #42',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _purple,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '430 XP',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _purple,
                    ),
                  ),
                ],
              ),
            ),

            const _SectionLabel(label: 'Top Players'),
            const SizedBox(height: 8),

            // Top 3 + rest
            ...List.generate(_entries.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _LeaderboardRow(entry: _entries[i]),
            )),
          ],
        ),

        // Pinned "You" row at bottom
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: _bg,
              border: Border(
                top: BorderSide(
                  color: _purple.withValues(alpha: 0.25),
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: _LeaderboardRow(entry: _me),
          ),
        ),
      ],
    );
  }
}

@immutable
class _LbEntry {
  const _LbEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.isMe,
  });

  final int    rank;
  final String name;
  final int    xp;
  final bool   isMe;
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final _LbEntry entry;

  static const _rankColors = {
    1: Color(0xFFFACC15),
    2: Color(0xFFCBD5E1),
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final rankColor = _rankColors[entry.rank];
    final isTop3    = entry.rank <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: entry.isMe
            ? _purple.withValues(alpha: 0.10)
            : _cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isTop3
              ? (rankColor?.withValues(alpha: 0.40) ?? _border)
              : entry.isMe
                  ? _purple.withValues(alpha: 0.40)
                  : _border,
          width: isTop3 || entry.isMe ? 1.5 : 1.0,
        ),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: (rankColor ?? Colors.transparent)
                      .withValues(alpha: 0.12),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 28,
            child: isTop3
                ? Icon(Icons.emoji_events_rounded,
                    color: rankColor, size: 22)
                : Text(
                    '#${entry.rank}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: entry.isMe ? _purple : _textSub,
                    ),
                  ),
          ),
          const SizedBox(width: 10),

          // Avatar circle
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTop3
                  ? rankColor?.withValues(alpha: 0.15)
                  : entry.isMe
                      ? _purple.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: isTop3
                    ? (rankColor?.withValues(alpha: 0.40) ?? _border)
                    : entry.isMe
                        ? _purple.withValues(alpha: 0.40)
                        : _border,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 18,
              color: isTop3
                  ? rankColor
                  : entry.isMe
                      ? _purple
                      : Colors.white54,
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Text(
              entry.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: entry.isMe ? _purple : Colors.white,
              ),
            ),
          ),

          // XP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isTop3
                  ? rankColor?.withValues(alpha: 0.12)
                  : entry.isMe
                      ? _purple.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${entry.xp} XP',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isTop3
                    ? rankColor
                    : entry.isMe
                        ? _purple
                        : _textSub,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress Ring (identical pattern to home_screen.dart)
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.label,
    required this.sublabel,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color  color;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress:    progress,
          color:       color,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                sublabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.75),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color  color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color      = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = strokeWidth
        ..style      = PaintingStyle.stroke,
    );

    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color      = color
        ..strokeWidth = strokeWidth
        ..style      = PaintingStyle.stroke
        ..strokeCap  = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _textSub,
        letterSpacing: 1.1,
      ),
    );
  }
}
