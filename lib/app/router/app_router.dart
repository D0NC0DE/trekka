import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trekka/core/router/route_paths.dart';
import 'package:trekka/features/home/presentation/pages/home_page.dart';
import 'package:trekka/features/logistics/presentation/pages/logistics_page.dart';
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
      GoRoute(
        path: RoutePaths.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final Animation<double> fadeIn = CurvedAnimation(
              parent: animation,
              curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
            );

            final Animation<double> fadeOut = CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeOut,
            );

            return FadeTransition(
              opacity: fadeIn,
              child: FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0).animate(fadeOut),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.logisticsHailing,
        name: 'logisticsHailing',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          child: const LogisticsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final Animation<double> fadeIn = CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
              reverseCurve: Curves.easeOut,
            );

            return FadeTransition(opacity: fadeIn, child: child);
          },
        ),
      ),
    ],
  );
}
