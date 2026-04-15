import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'background/arcane_library_background.dart';

/// The persistent app shell that wraps all tab screens.
/// Uses [StatefulNavigationShell] from go_router's StatefulShellRoute.
///
/// Branch vs visual tab order:
///   Branch 0 = Main   (path: /)    → visual position 2 (center)
///   Branch 1 = Shop   (path: /shop)  → visual position 0
///   Branch 2 = Card   (path: /card)  → visual position 1
///   Branch 3 = Event  (path: /event) → visual position 3
///   Branch 4 = Rank   (path: /leaderboard) → visual position 4
///
/// Mapping visual tap index → branch index:
///   visual [Shop, Card, Main, Event, Rank] = branch [1, 2, 0, 3, 4]
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Maps visual tab position → branch index
  static const List<int> _branchForVisualIndex = [1, 2, 0, 3, 4];
  // Maps branch index → visual tab position (reverse lookup)
  static const List<int> _visualForBranchIndex = [2, 0, 1, 3, 4];

  void _onTabTap(int visualIndex) {
    final branchIndex = _branchForVisualIndex[visualIndex];
    navigationShell.goBranch(
      branchIndex,
      // If tapping the already-active tab, go back to its initial location
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeVisualIndex =
        _visualForBranchIndex[navigationShell.currentIndex];

    return ArcaneLibraryBackground(
      child: Column(
        children: [
          Expanded(child: navigationShell),
          _ArcaneBottomNav(
            activeIndex: activeVisualIndex,
            onTap: _onTabTap,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _ArcaneBottomNav extends StatelessWidget {
  const _ArcaneBottomNav({
    required this.activeIndex,
    required this.onTap,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _TabData(icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: 'Shop'),
    _TabData(icon: Icons.style_outlined, activeIcon: Icons.style, label: 'Card'),
    _TabData(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Main'),
    _TabData(icon: Icons.celebration_outlined, activeIcon: Icons.celebration, label: 'Event'),
    _TabData(icon: Icons.leaderboard_outlined, activeIcon: Icons.leaderboard, label: 'Rank'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mountainGround.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: bottomPadding > 0 ? bottomPadding : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (i) {
          return _NavItem(
            data: _tabs[i],
            isActive: i == activeIndex,
            onTap: () => onTap(i),
          );
        }),
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
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator pill (above icon)
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isActive ? 20 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 6)]
                    : [],
              ),
            ),
            // Icon
            Icon(
              isActive ? data.activeIcon : data.icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(height: 3),
            // Label
            Text(
              data.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                letterSpacing: 0.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
