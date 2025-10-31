import 'package:flutter/material.dart';

import 'typography.dart';
import 'package:trekka/core/design/tokens.dart';

ThemeData buildAppTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    secondary: AppColors.primaryBright,
    surface: AppColors.white,
    outline: AppColors.divider,
  );

  final ThemeData base = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: 'Jost',
  );

  return base.copyWith(
    textTheme: buildTextTheme(base.textTheme),
    scaffoldBackgroundColor: AppColors.backgroundAlt,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.deepTeal,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );
}
