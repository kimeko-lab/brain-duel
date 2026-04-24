import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/background/deep_night_background.dart';

// ─── Design tokens (Figma export) ────────────────────────────────────────────
const Color _bg = Color(0xFF06081F);
const Color _primary = Color(0xFF6366F1);
const Color _cardDark = Color(0xFF112226);
const Color _cardMid = Color(0xFF1C3D3D);
const Color _textSub = Color(0xFF9CA3AF);
const Color _border = Color(0xFF2A2F52);
const Color _silver = Color(0xFFCBD5E1);
const Color _gold = Color(0xFFFACC15);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeTab = 0; // 0 = Daily Challenge, 1 = Versus Player
  int _activeModeCard = 0; // 0 = Classic, 1 = Survival, 2 = Rush

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: DeepNightBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildTopBar()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(child: _buildWelcome()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(child: _buildFeaturedCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: _buildTabSelector()),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(child: _buildStatCards()),
              SliverToBoxAdapter(child: _buildClassicBanner()),
              SliverToBoxAdapter(child: _buildGameGrid()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
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
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _cardMid,
              border: Border.all(
                color: _primary.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white70,
              size: 22,
            ),
          ),
          const Spacer(),
          _CurrencyPill(
            icon: Icons.menu_book_rounded,
            amount: 240,
            color: _silver,
          ),
          const SizedBox(width: 8),
          _CurrencyPill(
            icon: Icons.auto_stories_rounded,
            amount: 80,
            color: _gold,
          ),
        ],
      ),
    );
  }

  // ── Welcome ───────────────────────────────────────────────────────────────

  Widget _buildWelcome() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, John!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ready for today\'s challenge?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: _textSub,
            ),
          ),
        ],
      ),
    );
  }

  // ── Featured card ─────────────────────────────────────────────────────────

  Widget _buildFeaturedCard() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // No fixed height — card grows with content/font scale
              constraints: const BoxConstraints(minHeight: 130),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFF3730A3)],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles (clipped by ClipRRect above)
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: -35,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Content — sized to children, no overflow possible
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // grow with content
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'NEW EVENT',
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
                                'Total New 1000 Questions',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  height: 1.2,
                                ),
                              ),
                              // Fixed gap replaces Spacer — no overflow risk
                              const SizedBox(height: 14),
                              // Event page not yet live — button disabled
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white54,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Progress ring — centered vertically next to column
                        const SizedBox(width: 12),
                        const _ProgressRing(
                          progress: 0.53,
                          size: 84,
                          strokeWidth: 7,
                          color: Colors.white,
                          label: '14',
                          sublabel: 'Days Left!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }

  // ── Tab selector ──────────────────────────────────────────────────────────

  Widget _buildTabSelector() {
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
          children: [
            _TabPill(
              label: 'Daily Challenge',
              isActive: _activeTab == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = 0);
              },
            ),
            _TabPill(
              label: 'Versus Player',
              isActive: _activeTab == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat cards ────────────────────────────────────────────────────────────

  Widget _buildStatCards() {
    final modes = [
      const _ModeData(
        title: 'Classic',
        subtitle: '',
        icon: Icons.calendar_today_rounded,
        color: Color(0xFF6366F1),
      ),
      const _ModeData(
        title: 'Survival',
        subtitle: '',
        icon: Icons.local_fire_department_rounded,
        color: Color(0xFFFF6B6B),
      ),
      const _ModeData(
        title: 'Rush',
        subtitle: '',
        icon: Icons.bolt_rounded,
        color: Color(0xFFFACC15),
      ),
    ];

    return SizedBox(
      height: 106,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: modes.length,
        itemBuilder: (context, i) => Padding(
          padding: EdgeInsets.only(right: i < modes.length - 1 ? 10 : 0),
          child: _StatCard(
            data: modes[i],
            isActive: _activeModeCard == i,
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _activeModeCard = i);
              if (i == 1) _showModeSheet(context, _ModeSheetData.survival);
              if (i == 2) _showModeSheet(context, _ModeSheetData.rush);
            },
          ),
        ),
      ),
    );
  }

  // ── Classic info banner (visible only when Classic is active) ────────────

  Widget _buildClassicBanner() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 220),
      crossFadeState: _activeModeCard == 0
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _primary.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: _primary,
                  size: 15,
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Each category has 1 daily attempt. Starting a quiz will use it — resets at midnight.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _primary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      secondChild: const SizedBox.shrink(),
    );
  }

  // ── Mode start bottom sheet ───────────────────────────────────────────────

  void _showModeSheet(BuildContext context, _ModeSheetData data) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ModeStartSheet(data: data),
    );
  }

  // ── Game grid ─────────────────────────────────────────────────────────────

  Widget _buildGameGrid() {
    const topGap = SizedBox(height: 20);
    const games = [
      _GameData(
        title: 'Science',
        category: 'science',
        gradientColors: [Color(0xFFF97316), Color(0xFFC2410C)],
        icon: Icons.science_rounded,
      ),
      _GameData(
        title: 'Geography',
        category: 'geography',
        gradientColors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
        icon: Icons.public_rounded,
      ),
      _GameData(
        title: 'History',
        category: 'history',
        gradientColors: [Color(0xFFEC4899), Color(0xFF6B21A8)],
        icon: Icons.history_edu_rounded,
      ),
      _GameData(
        title: 'Sport',
        category: 'sport',
        gradientColors: [Color(0xFF6366F1), Color(0xFF008A5B)],
        icon: Icons.sports_rounded,
      ),
      _GameData(
        title: 'Entertainment',
        category: 'entertainment',
        gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
        icon: Icons.movie_rounded,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        topGap,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              games.length,
              (i) => _GameCard(data: games[i], delay: 80 * i),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.icon,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            '$amount',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isActive ? _primary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? _bg : _textSub,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeData {
  const _ModeData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _ModeData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? data.color.withValues(alpha: 0.12) : _cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? data.color.withValues(alpha: 0.55) : _border,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon in a tinted rounded container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: isActive ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(data.icon, color: data.color, size: 22),
            ),
            const SizedBox(height: 9),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFFCFD9E0),
              ),
            ),
            // Active accent bar
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: isActive
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              secondChild: const SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameData {
  const _GameData({
    required this.title,
    required this.category,
    required this.gradientColors,
    required this.icon,
  });

  final String title;
  final String category;
  final List<Color> gradientColors;
  final IconData icon;
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.data, required this.delay});

  final _GameData data;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            context.go('/daily/game/${data.category}');
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradientColors,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Decorative circle
                Positioned(
                  right: -14,
                  bottom: -14,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(data.icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 10),
                      // Title
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // High score row
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events_rounded,
                            size: 10,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Best: —',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Daily reset badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Daily reset',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode start bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

/// Static data for each mode's start sheet.
class _ModeSheetData {
  const _ModeSheetData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.stats,
    required this.route,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final List<String> stats;
  final String route;

  static const survival = _ModeSheetData(
    title: 'Survival Mode',
    description:
        'Answer as many questions as you can. One wrong answer ends the game — how far can you go?',
    icon: Icons.local_fire_department_rounded,
    gradientColors: [Color(0xFFFF6B6B), Color(0xFFDC2626)],
    stats: ['∞ Questions', '10s / Question', 'Wrong = Over'],
    route: '/survival/game',
  );

  static const rush = _ModeSheetData(
    title: 'Rush Mode',
    description:
        'Race against the clock! Answer as many questions as possible in 60 seconds.',
    icon: Icons.bolt_rounded,
    gradientColors: [Color(0xFFFACC15), Color(0xFFB45309)],
    stats: ['All Questions', '60s Total', 'Speed Counts'],
    route: '/rush/game',
  );
}

class _ModeStartSheet extends StatelessWidget {
  const _ModeStartSheet({required this.data});

  final _ModeSheetData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111428),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradientColors,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: data.gradientColors[0].withValues(alpha: 0.40),
                  blurRadius: 22,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Icon(data.icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),

          // Stat chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.stats
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF112226),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF2A2F52),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),

          // Start Game button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
                GoRouter.of(context).go(data.route);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: data.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: data.gradientColors[0].withValues(alpha: 0.35),
                      blurRadius: 18,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Start Game',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress ring — CustomPainter (no BackdropFilter needed)
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
  final Color color;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress,
          color: color,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.75),
                  height: 1.2,
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
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
