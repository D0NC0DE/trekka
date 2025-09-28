import 'package:go_router/go_router.dart';

import 'package:trekka/core/router/route_paths.dart';
import 'package:trekka/features/splash/presentation/pages/splash_page.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
    ],
  );
}
