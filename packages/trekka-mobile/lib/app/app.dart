import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:trekka/app/router/app_router.dart';
import 'package:trekka/app/theme/app_theme.dart';

class TrekkaApp extends StatelessWidget {
  const TrekkaApp({super.key});

  static final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trekka',
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}
