import 'package:flutter/material.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const Color _bg           = Color(0xFF06161A);
const Color _cardDark     = Color(0xFF112226);
const Color _border       = Color(0xFF2D4A4A);
const Color _textSub      = Color(0xFF9CA3AF);
const Color _classicColor = Color(0xFF00D084);
const Color _survivalColor= Color(0xFFEF4444);
const Color _rushColor    = Color(0xFFFACC15);
const Color _gold         = Color(0xFFFFD700);
const Color _silver       = Color(0xFFB8BABB);
const Color _bronze       = Color(0xFFCD7F32);

// ─── Enums ────────────────────────────────────────────────────────────────────
enum _Mode   { classic, survival, rush }
enum _Period { daily, weekly, season }

// ─── Data model ───────────────────────────────────────────────────────────────
class _Entry {
  const _Entry({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.scoreLabel,
    this.isMe = false,
  });
  final int    rank;
  final String name;
  final String avatar;
  final String scoreLabel;
  final bool   isMe;
}

// ─── Mock data ────────────────────────────────────────────────────────────────
const _mockNames = [
  'BrainMaster', 'QuizKing', 'NeuralNinja', 'FactFury', 'MindBender',
  'ThinkTank', 'Cerebro_X', 'LogicLord', 'WisdomWolf', 'PuzzlePro',
];

const _mockAvatars = ['🧠', '👑', '⚡', '🔥', '🌊', '💡', '🎯', '🦁', '🐺', '🎲'];

(List<_Entry>, _Entry) _buildMockData(_Mode mode, _Period period) {
  // Top score per mode + period combination
  final topScore = switch (mode) {
    _Mode.classic  => switch (period) {
      _Period.daily  => 4850,
      _Period.weekly => 31200,
      _Period.season => 128000,
    },
    _Mode.survival => switch (period) {
      _Period.daily  => 23,
      _Period.weekly => 25,
      _Period.season => 25,
    },
    _Mode.rush     => switch (period) {
      _Period.daily  => 1840,
      _Period.weekly => 12600,
      _Period.season => 54000,
    },
  };

  String fmtScore(int v) {
    if (mode == _Mode.survival) return '$v answered';
    if (v >= 10000) return '${(v / 1000).toStringAsFixed(0)}k pts';
    if (v >= 1000)  return '${(v / 1000).toStringAsFixed(1)}k pts';
    return '$v pts';
  }

  // Score decay per rank step (~3% for pts modes, 1 for survival streaks)
  final step = mode == _Mode.survival
      ? 1
      : (topScore * 0.03).round().clamp(1, 99999);

  final top10 = List.generate(10, (i) {
    final v = (topScore - i * step).clamp(0, topScore);
    return _Entry(
      rank:       i + 1,
      name:       _mockNames[i],
      avatar:     _mockAvatars[i],
      scoreLabel: fmtScore(v),
    );
  });

  // User rank varies by period to make the data feel real
  final myRank = switch (period) {
    _Period.daily  => 28,
    _Period.weekly => 15,
    _Period.season => 42,
  };
  final myVal = mode == _Mode.survival
      ? 8
      : (topScore * 0.45).round();

  final me = _Entry(
    rank:       myRank,
    name:       'You',
    avatar:     '😎',
    scoreLabel: fmtScore(myVal),
    isMe:       true,
  );

  return (top10, me);
}

// Pre-generate all 9 mode × period combos so rebuilds are instant
// Index layout: mode.index * 3 + period.index
final _allData = List<(List<_Entry>, _Entry)>.generate(
  9,
  (i) => _buildMockData(_Mode.values[i ~/ 3], _Period.values[i % 3]),
);

// ─────────────────────────────────────────────────────────────────────────────
// LeaderboardScreen
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  _Mode   _mode   = _Mode.classic;
  _Period _period = _Period.daily;

  Color get _modeColor => switch (_mode) {
    _Mode.classic  => _classicColor,
    _Mode.survival => _survivalColor,
    _Mode.rush     => _rushColor,
  };

  (List<_Entry>, _Entry) get _data =>
      _allData[_mode.index * 3 + _period.index];

  @override
  Widget build(BuildContext context) {
    final (entries, me) = _data;
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildModeSelector(),
            const SizedBox(height: 10),
            _buildPeriodSelector(),
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
                            entry:     e,
                            modeColor: _modeColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Pinned "You" row at bottom
                  Positioned(
                    bottom: 0,
                    left:   0,
                    right:  0,
                    child:  _UserPinnedRow(entry: me, modeColor: _modeColor),
                  ),
                ],
              ),
            ),
          ],
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
            child: Icon(Icons.emoji_events_rounded, color: _modeColor, size: 20),
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
      (_Mode.classic,  'Classic',  Icons.calendar_today_rounded),
      (_Mode.survival, 'Survival', Icons.local_fire_department_rounded),
      (_Mode.rush,     'Rush',     Icons.bolt_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: List.generate(modes.length, (i) {
            final (mode, label, icon) = modes[i];
            final isActive = _mode == mode;
            final col = switch (mode) {
              _Mode.classic  => _classicColor,
              _Mode.survival => _survivalColor,
              _Mode.rush     => _rushColor,
            };
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mode = mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isActive
                        ? col.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: isActive
                        ? Border.all(color: col.withValues(alpha: 0.50))
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 14,
                          color: isActive ? col : _textSub),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive ? col : _textSub,
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

  // ── Period selector (Daily / Weekly / Season) ────────────────────────────────
  Widget _buildPeriodSelector() {
    const periods = [
      (_Period.daily,  'Daily',  Icons.today_rounded,        Color(0xFF60A5FA)),
      (_Period.weekly, 'Weekly', Icons.date_range_rounded,   Color(0xFFA855F7)),
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
              onTap: () => setState(() => _period = period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withValues(alpha: 0.14)
                      : _cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? color.withValues(alpha: 0.50)
                        : _border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 12,
                        color: isActive ? color : _textSub),
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

  final List<_Entry> entries;   // expects exactly 3
  final Color        modeColor;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox.shrink();

    final first  = entries[0];
    final second = entries[1];
    final third  = entries[2];

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
                    entry: first, rankColor: _gold, isFirst: true),
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
  final Color  rankColor;
  final bool   isFirst;

  @override
  Widget build(BuildContext context) {
    final avatarSize = isFirst ? 72.0 : 58.0;
    final pedestalH  = entry.rank == 1
        ? 90.0
        : entry.rank == 2
            ? 68.0
            : 50.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown (1st only) — spacer keeps rows aligned for 2nd/3rd
        if (isFirst)
          const Icon(
              Icons.workspace_premium_rounded, size: 22, color: _gold)
        else
          const SizedBox(height: 22),
        const SizedBox(height: 4),

        // Avatar circle
        Container(
          width:  avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape:  BoxShape.circle,
            color:  rankColor.withValues(alpha: 0.12),
            border: Border.all(
                color: rankColor, width: isFirst ? 2.5 : 2.0),
            boxShadow: isFirst
                ? [
                    BoxShadow(
                      color:      rankColor.withValues(alpha: 0.40),
                      blurRadius: 14,
                      spreadRadius: -2,
                    )
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
            fontSize:   isFirst ? 13.0 : 11.0,
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
            fontSize:   10,
            fontWeight: FontWeight.w600,
            color: rankColor,
          ),
        ),
        const SizedBox(height: 8),

        // Pedestal block
        Container(
          width:  double.infinity,
          height: pedestalH,
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:   Alignment.bottomCenter,
              colors: [
                rankColor.withValues(alpha: 0.32),
                rankColor.withValues(alpha: 0.12),
              ],
            ),
            border: Border(
              top:   BorderSide(
                  color: rankColor.withValues(alpha: 0.55), width: 1),
              left:  BorderSide(
                  color: rankColor.withValues(alpha: 0.30), width: 1),
              right: BorderSide(
                  color: rankColor.withValues(alpha: 0.30), width: 1),
            ),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize:   isFirst ? 28.0 : 20.0,
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
  final Color  modeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: entry.isMe
            ? modeColor.withValues(alpha: 0.08)
            : _cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isMe
              ? modeColor.withValues(alpha: 0.35)
              : _border,
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
                fontSize:   13,
                fontWeight: FontWeight.w800,
                color: _textSub,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.isMe
                  ? modeColor.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: entry.isMe
                    ? modeColor.withValues(alpha: 0.40)
                    : _border,
              ),
            ),
            child: Center(
              child: Text(
                  entry.avatar,
                  style: const TextStyle(fontSize: 16)),
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
                fontSize:   13,
                fontWeight: entry.isMe
                    ? FontWeight.w700
                    : FontWeight.w600,
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
              fontSize:   12,
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
  final Color  modeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: modeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: modeColor.withValues(alpha: 0.40), width: 1.5),
        boxShadow: [
          BoxShadow(
            color:      modeColor.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, -6),
          ),
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.55),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          // "YOU" badge
          Container(
            width:   34,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color:         modeColor.withValues(alpha: 0.20),
              borderRadius:  BorderRadius.circular(6),
            ),
            child: Text(
              'YOU',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize:   8,
                fontWeight: FontWeight.w900,
                color:      modeColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width:  38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: modeColor.withValues(alpha: 0.15),
              border:
                  Border.all(color: modeColor.withValues(alpha: 0.50)),
            ),
            child: const Center(
                child: Text('😎', style: TextStyle(fontSize: 18))),
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
                    fontSize:   13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rank #${entry.rank}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize:   11,
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
              fontSize:   13,
              fontWeight: FontWeight.w700,
              color: modeColor,
            ),
          ),
        ],
      ),
    );
  }
}
