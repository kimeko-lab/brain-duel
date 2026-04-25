import 'package:go_router/go_router.dart';

import '../../features/card/presentation/card_screen.dart';
import '../../features/daily/presentation/category_select_screen.dart';
import '../../features/daily/presentation/daily_classic_game_screen.dart';
import '../../features/daily/presentation/daily_classic_result_screen.dart';
import '../../features/event/presentation/event_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../features/rush/presentation/rush_game_screen.dart';
import '../../features/rush/presentation/rush_result_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/survival/presentation/survival_game_screen.dart';
import '../../features/survival/presentation/survival_result_screen.dart';
import '../widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Shell routes (bottom nav visible) ──────────────────────────────────
    // Branch 0: Main (/), Branch 1: Shop, Branch 2: Card, Branch 3: Event, Branch 4: Leaderboard
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/shop',
              builder: (context, state) => const ShopScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/card',
              builder: (context, state) => const CardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/event',
              builder: (context, state) => const EventScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/leaderboard',
              builder: (context, state) => const LeaderboardScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Standalone routes (no bottom nav — full screen game) ───────────────
    GoRoute(
      path: '/daily/select',
      builder: (context, state) => const CategorySelectScreen(),
    ),
    GoRoute(
      path: '/daily/game/:category',
      builder: (context, state) => DailyClassicGameScreen(
        category: state.pathParameters['category'] ?? '',
      ),
    ),
    // TODO: extra is not URL-serialized; persist result to state/storage for deep-link safety
    GoRoute(
      path: '/daily/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return DailyClassicResultScreen(extra: extra ?? {});
      },
    ),
    GoRoute(
      path: '/survival/game',
      builder: (context, state) => const SurvivalGameScreen(),
    ),
    GoRoute(
      path: '/survival/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SurvivalResultScreen(extra: extra ?? {});
      },
    ),
    GoRoute(
      path: '/rush/game',
      builder: (context, state) => const RushGameScreen(),
    ),
    GoRoute(
      path: '/rush/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RushResultScreen(extra: extra ?? {});
      },
    ),
  ],
);
