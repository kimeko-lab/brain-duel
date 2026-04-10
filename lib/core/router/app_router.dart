import 'package:go_router/go_router.dart';

import '../../features/daily/presentation/category_select_screen.dart';
import '../../features/daily/presentation/daily_classic_game_screen.dart';
import '../../features/daily/presentation/daily_classic_result_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/rush/presentation/rush_game_screen.dart';
import '../../features/rush/presentation/rush_result_screen.dart';
import '../../features/survival/presentation/survival_game_screen.dart';
import '../../features/survival/presentation/survival_result_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
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
