import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Design tokens (Figma export) ────────────────────────────────────────────
const Color _bg        = Color(0xFF06161A);
const Color _navBg     = Color(0xFF0D1B1E);
const Color _navActive = Color(0xFF00D084);
const Color _navActiveBg  = Color(0xFF020B0E); // dark pill behind active tab
const Color _navInactive  = Color(0xFFB0C8CF); // visible but not active

/// The persistent app shell that wraps all tab screens.
/// Uses [StatefulNavigationShell] from go_router's StatefulShellRoute.
///
/// Branch vs visual tab order:
///   Branch 0 = Main         (path: /)            → visual position 2 (center)
///   Branch 1 = Shop         (path: /shop)        → visual position 0
///   Branch 2 = Card         (path: /card)        → visual position 1
///   Branch 3 = Event        (path: /event)       → visual position 3
///   Branch 4 = Rank         (path: /leaderboard) → visual position 4
///
/// Visual order: [Shop, Card, Main, Event, Rank] = branch [1, 2, 0, 3, 4]
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Maps visual tab position → branch index
  static const List<int> _branchForVisualIndex = [1, 2, 0, 3, 4];
  // Maps branch index → visual tab position
  static const List<int> _visualForBranchIndex = [2, 0, 1, 3, 4];

  void _onTabTap(int visualIndex) {
    final branchIndex = _branchForVisualIndex[visualIndex];
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeVisualIndex =
        _visualForBranchIndex[navigationShell.currentIndex];
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return ColoredBox(
      color: _bg,
      child: Column(
        children: [
          Expanded(child: navigationShell),
          // Floating pill nav with bottom safe-area padding
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad > 0 ? bottomPad : 16),
            child: RepaintBoundary(
              child: _FloatingBottomNav(
                activeIndex: activeVisualIndex,
                onTap: _onTabTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating pill bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _FloatingBottomNav extends StatelessWidget {
  const _FloatingBottomNav({
    required this.activeIndex,
    required this.onTap,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _TabData(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: 'Shop',
    ),
    _TabData(
      icon: Icons.style_outlined,
      activeIcon: Icons.style_rounded,
      label: 'Card',
    ),
    _TabData(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Main',
    ),
    _TabData(
      icon: Icons.celebration_outlined,
      activeIcon: Icons.celebration_rounded,
      label: 'Event',
    ),
    _TabData(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events_rounded,
      label: 'Rank',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: _navBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (i) => Expanded(
            child: Center(
              child: _NavItem(
                data: _tabs[i],
                isActive: i == activeIndex,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabData {
  const _TabData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _TabData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        // Pill height: taller for active (covers icon + label), shorter inactive
        height: isActive ? 52 : 44,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 10),
        decoration: BoxDecoration(
          color: isActive ? _navActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              isActive ? data.activeIcon : data.icon,
              size: 24,
              color: isActive ? _navActive : _navInactive,
            ),
            // Label below icon — active only
            if (isActive) ...[
              const SizedBox(height: 3),
              Text(
                data.label,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _navActive,
                  decoration: TextDecoration.none,
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
