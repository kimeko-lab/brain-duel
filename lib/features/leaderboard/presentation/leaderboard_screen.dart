import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/background/deep_night_background.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg = Color(0xFF06081F);
const Color _cardDark = Color(0xFF112226);
const Color _border = Color(0xFF2A2F52);
const Color _textSub = Color(0xFF9CA3AF);
const Color _classicColor = Color(0xFF6366F1);
const Color _survivalColor = Color(0xFFEF4444);
const Color _rushColor = Color(0xFFFACC15);
const Color _gold = Color(0xFFFFD700);
const Color _silver = Color(0xFFB8BABB);
const Color _bronze = Color(0xFFCD7F32);

// ─── Enums ────────────────────────────────────────────────────────────────────
enum _Mode { classic, survival, rush }

enum _Period { daily, weekly, season }

enum _Category { science, geography, history, sport, entertainment }

// Category metadata (matches daily/category_select_screen.dart)
const _categoryMeta = <_Category, (String, IconData)>{
  _Category.science: ('Science', Icons.science_rounded),
  _Category.geography: ('Geography', Icons.public_rounded),
  _Category.history: ('History', Icons.history_edu_rounded),
  _Category.sport: ('Sport', Icons.sports_rounded),
  _Category.entertainment: ('Entertainment', Icons.movie_rounded),
};

// ─── Data model ───────────────────────────────────────────────────────────────
class _Entry {
  const _Entry({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.scoreLabel,
    this.isMe = false,
  });
  final int rank;
  final String name;
  final String avatar;
  final String scoreLabel;
  final bool isMe;
}

// ─── Mock data ────────────────────────────────────────────────────────────────
const _mockNames = [
  'BrainMaster',
  'QuizKing',
  'NeuralNinja',
  'FactFury',
  'MindBender',
  'ThinkTank',
  'Cerebro_X',
  'LogicLord',
  'WisdomWolf',
  'PuzzlePro',
];

const _mockAvatars = [
  '🧠',
  '👑',
  '⚡',
  '🔥',
  '🌊',
  '💡',
  '🎯',
  '🦁',
  '🐺',
  '🎲',
];

// ── Helpers ───────────────────────────────────────────────────────────────────
String _fmtPts(int v) {
  if (v >= 10000) return '${(v / 1000).toStringAsFixed(0)}k pts';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k pts';
  return '$v pts';
}

int _myRankFor(_Period p) => switch (p) {
  _Period.daily => 28,
  _Period.weekly => 15,
  _Period.season => 42,
};

// ── Classic (per category × period) ──────────────────────────────────────────
(List<_Entry>, _Entry) _classicMock(_Category cat, _Period p) {
  // Base top score: category popularity × period multiplier
  const catBoost = <_Category, double>{
    _Category.science: 1.00,
    _Category.geography: 1.10,
    _Category.history: 0.95,
    _Category.sport: 1.05,
    _Category.entertainment: 0.90,
  };
  final baseDaily = (4850 * catBoost[cat]!).round();
  final top = switch (p) {
    _Period.daily => baseDaily,
    _Period.weekly => baseDaily * 7,
    _Period.season => baseDaily * 28,
  };
  final step = (top * 0.03).round();

  final top10 = List.generate(10, (i) {
    final v = (top - i * step).clamp(0, top);
    return _Entry(
      rank: i + 1,
      name: _mockNames[i],
      avatar: _mockAvatars[i],
      scoreLabel: _fmtPts(v),
    );
  });
  final me = _Entry(
    rank: _myRankFor(p),
    name: 'You',
    avatar: '😎',
    scoreLabel: _fmtPts((top * 0.45).round()),
    isMe: true,
  );
  return (top10, me);
}

// ── Survival (period only) — shows answered + pts ────────────────────────────
(List<_Entry>, _Entry) _survivalMock(_Period p) {
  // Top streak per period (max possible = 25)
  final topAns = switch (p) {
    _Period.daily => 23,
    _Period.weekly => 25,
    _Period.season => 25,
  };
  // Each correct answer ≈ 320 pts (with bonus for higher streaks)
  String label(int answered) {
    final pts = answered * 320 + (answered ~/ 5) * 200;
    return '$answered ans · ${_fmtPts(pts)}';
  }

  final top10 = List.generate(10, (i) {
    final ans = (topAns - i).clamp(1, 25);
    return _Entry(
      rank: i + 1,
      name: _mockNames[i],
      avatar: _mockAvatars[i],
      scoreLabel: label(ans),
    );
  });
  final me = _Entry(
    rank: _myRankFor(p),
    name: 'You',
    avatar: '😎',
    scoreLabel: label(8),
    isMe: true,
  );
  return (top10, me);
}

// ── Rush (period only) — shows answered + pts ────────────────────────────────
(List<_Entry>, _Entry) _rushMock(_Period p) {
  // Top answered count in 60s
  final topAns = switch (p) {
    _Period.daily => 18,
    _Period.weekly => 22,
    _Period.season => 24,
  };
  // Per period accumulator multiplier (best run only for daily, sums for week/season)
  final mult = switch (p) {
    _Period.daily => 1,
    _Period.weekly => 6,
    _Period.season => 24,
  };
  String label(int answered) {
    final pts = (answered * 95 * mult);
    return '$answered ans · ${_fmtPts(pts)}';
  }

  final top10 = List.generate(10, (i) {
    final ans = (topAns - i).clamp(1, 25);
    return _Entry(
      rank: i + 1,
      name: _mockNames[i],
      avatar: _mockAvatars[i],
      scoreLabel: label(ans),
    );
  });
  final me = _Entry(
    rank: _myRankFor(p),
    name: 'You',
    avatar: '😎',
    scoreLabel: label(7),
    isMe: true,
  );
  return (top10, me);
}

// Pre-generate caches so tab switches are instant
final _classicCache = <int, (List<_Entry>, _Entry)>{
  for (var c in _Category.values)
    for (var p in _Period.values) c.index * 3 + p.index: _classicMock(c, p),
};
final _survivalCache = <int, (List<_Entry>, _Entry)>{
  for (var p in _Period.values) p.index: _survivalMock(p),
};
final _rushCache = <int, (List<_Entry>, _Entry)>{
  for (var p in _Period.values) p.index: _rushMock(p),
};

// ─────────────────────────────────────────────────────────────────────────────
// LeaderboardScreen
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  _Mode _mode = _Mode.classic;
  _Period _period = _Period.daily;
  _Category _category = _Category.science;

  Color get _modeColor => switch (_mode) {
    _Mode.classic => _classicColor,
    _Mode.survival => _survivalColor,
    _Mode.rush => _rushColor,
  };

  (List<_Entry>, _Entry) get _data {
    switch (_mode) {
      case _Mode.classic:
        return _classicCache[_category.index * 3 + _period.index]!;
      case _Mode.survival:
        return _survivalCache[_period.index]!;
      case _Mode.rush:
        return _rushCache[_period.index]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (entries, me) = _data;
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    return Scaffold(
      backgroundColor: _bg,
      body: DeepNightBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildModeSelector(),
              const SizedBox(height: 10),
              _buildPeriodSelector(),
              // Category selector — only for Classic mode
              if (_mode == _Mode.classic) ...[
                const SizedBox(height: 10),
                _buildCategorySelector(),
              ],
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    // Scrollable podium + list
                    ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                      children: [
                        _Podium(entries: top3, modeColor: _modeColor),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 2),
                          child: Text(
                            'RANK 4 – 10',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _textSub,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        ...rest.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _LeaderboardRow(
                              entry: e,
                              modeColor: _modeColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Pinned "You" row at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _UserPinnedRow(entry: me, modeColor: _modeColor),
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

  // ── Top bar ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _modeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _modeColor.withValues(alpha: 0.30)),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: _modeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'RANK',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: const Text(
              'Season 1 · Week 2',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _textSub,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mode selector (Classic / Survival / Rush) ────────────────────────────────
  Widget _buildModeSelector() {
    const modes = [
      (_Mode.classic, 'Classic', Icons.calendar_today_rounded),
      (_Mode.survival, 'Survival', Icons.local_fire_department_rounded),
      (_Mode.rush, 'Rush', Icons.bolt_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: List.generate(modes.length, (i) {
            final (mode, label, icon) = modes[i];
            final isActive = _mode == mode;
            final col = switch (mode) {
              _Mode.classic => _classicColor,
              _Mode.survival => _survivalColor,
              _Mode.rush => _rushColor,
            };
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_mode != mode) HapticFeedback.selectionClick();
                  setState(() => _mode = mode);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? col.withValues(alpha: 0.20)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: isActive
                        ? Border.all(
                            color: col.withValues(alpha: 0.55),
                            width: 1,
                          )
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: col.withValues(alpha: 0.25),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 17, color: isActive ? col : _textSub),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isActive ? col : _textSub,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Category selector (Classic only) — horizontal chips ──────────────────────
  Widget _buildCategorySelector() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _Category.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _Category.values[i];
          final (label, icon) = _categoryMeta[cat]!;
          final isActive = _category == cat;
          return GestureDetector(
            onTap: () {
              if (_category != cat) HapticFeedback.selectionClick();
              setState(() => _category = cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? _classicColor.withValues(alpha: 0.15)
                    : _cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive
                      ? _classicColor.withValues(alpha: 0.55)
                      : _border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isActive ? _classicColor : _textSub,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive ? _classicColor : _textSub,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Period selector (Daily / Weekly / Season) ────────────────────────────────
  Widget _buildPeriodSelector() {
    const periods = [
      (_Period.daily, 'Daily', Icons.today_rounded, Color(0xFF60A5FA)),
      (_Period.weekly, 'Weekly', Icons.date_range_rounded, Color(0xFFEC4899)),
      (_Period.season, 'Season', Icons.auto_awesome_rounded, Color(0xFFFFD700)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(periods.length, (i) {
          final (period, label, icon, color) = periods[i];
          final isActive = _period == period;
          return Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                if (_period != period) HapticFeedback.selectionClick();
                setState(() => _period = period);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? color.withValues(alpha: 0.14) : _cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? color.withValues(alpha: 0.50) : _border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 12, color: isActive ? color : _textSub),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? color : _textSub,
                      ),
                    ),
                  ],
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
// Podium — top 3 with tiered pedestals
// ─────────────────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  const _Podium({required this.entries, required this.modeColor});

  final List<_Entry> entries; // expects exactly 3
  final Color modeColor;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox.shrink();

    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          // Sub-header
          Text(
            '— TOP 3 —',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _textSub,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 14),
          // Podium row: 2nd | 1st | 3rd  (bottom-aligned)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _PodiumSlot(entry: second, rankColor: _silver),
              ),
              Expanded(
                child: _PodiumSlot(
                  entry: first,
                  rankColor: _gold,
                  isFirst: true,
                ),
              ),
              Expanded(
                child: _PodiumSlot(entry: third, rankColor: _bronze),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  const _PodiumSlot({
    required this.entry,
    required this.rankColor,
    this.isFirst = false,
  });

  final _Entry entry;
  final Color rankColor;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final avatarSize = isFirst ? 72.0 : 58.0;
    final pedestalH = entry.rank == 1
        ? 90.0
        : entry.rank == 2
        ? 68.0
        : 50.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown (1st only) — spacer keeps rows aligned for 2nd/3rd
        if (isFirst)
          const Icon(Icons.workspace_premium_rounded, size: 22, color: _gold)
        else
          const SizedBox(height: 22),
        const SizedBox(height: 4),

        // Avatar circle
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: rankColor.withValues(alpha: 0.12),
            border: Border.all(color: rankColor, width: isFirst ? 2.5 : 2.0),
            boxShadow: isFirst
                ? [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.40),
                      blurRadius: 14,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              entry.avatar,
              style: TextStyle(fontSize: isFirst ? 30.0 : 22.0),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Name
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isFirst ? 13.0 : 11.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),

        // Score
        Text(
          entry.scoreLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: rankColor,
          ),
        ),
        const SizedBox(height: 8),

        // Pedestal block
        Container(
          width: double.infinity,
          height: pedestalH,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                rankColor.withValues(alpha: 0.32),
                rankColor.withValues(alpha: 0.12),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: rankColor.withValues(alpha: 0.55),
                width: 1,
              ),
              left: BorderSide(
                color: rankColor.withValues(alpha: 0.30),
                width: 1,
              ),
              right: BorderSide(
                color: rankColor.withValues(alpha: 0.30),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isFirst ? 28.0 : 20.0,
                fontWeight: FontWeight.w900,
                color: rankColor.withValues(alpha: 0.80),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Leaderboard row (ranks 4 – 10)
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, required this.modeColor});

  final _Entry entry;
  final Color modeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: entry.isMe ? modeColor.withValues(alpha: 0.08) : _cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isMe ? modeColor.withValues(alpha: 0.35) : _border,
        ),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: _textSub,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.isMe
                  ? modeColor.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: entry.isMe ? modeColor.withValues(alpha: 0.40) : _border,
              ),
            ),
            child: Center(
              child: Text(entry.avatar, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Text(
              entry.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: entry.isMe ? FontWeight.w700 : FontWeight.w600,
                color: entry.isMe
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),

          // Score
          Text(
            entry.scoreLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: entry.isMe ? modeColor : _textSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User pinned row — always visible at bottom of screen
// ─────────────────────────────────────────────────────────────────────────────

class _UserPinnedRow extends StatelessWidget {
  const _UserPinnedRow({required this.entry, required this.modeColor});

  final _Entry entry;
  final Color modeColor;

  @override
  Widget build(BuildContext context) {
    // Opaque tinted background — pre-blend mode color over the bg so the
    // scrolling list behind the pinned row never bleeds through.
    final opaqueBg = Color.alphaBlend(
      modeColor.withValues(alpha: 0.18),
      _cardDark,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: opaqueBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: modeColor.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          // Soft glow above the pill
          BoxShadow(
            color: modeColor.withValues(alpha: 0.25),
            blurRadius: 22,
            spreadRadius: -4,
            offset: const Offset(0, -6),
          ),
          // Hard drop shadow to separate from list scrolling underneath
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.75),
            blurRadius: 18,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // "YOU" badge
          Container(
            width: 34,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'YOU',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: modeColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: modeColor.withValues(alpha: 0.15),
              border: Border.all(color: modeColor.withValues(alpha: 0.50)),
            ),
            child: const Center(
              child: Text('😎', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),

          // Name + rank label
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rank #${entry.rank}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: modeColor,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Text(
            entry.scoreLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: modeColor,
            ),
          ),
        ],
      ),
    );
  }
}
