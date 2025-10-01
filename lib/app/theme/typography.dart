import 'package:flutter/material.dart';
import 'package:trekka/core/design/tokens.dart';

TextTheme buildTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontWeight: AppFontWeights.bold),
    displayMedium: base.displayMedium?.copyWith(fontWeight: AppFontWeights.bold),
    headlineLarge: base.headlineLarge?.copyWith(fontWeight: AppFontWeights.bold),
    headlineMedium: base.headlineMedium?.copyWith(fontWeight: AppFontWeights.semiBold),
    headlineSmall: base.headlineSmall?.copyWith(fontWeight: AppFontWeights.semiBold),
    titleLarge: base.titleLarge?.copyWith(fontWeight: AppFontWeights.semiBold),
    titleMedium: base.titleMedium?.copyWith(fontWeight: AppFontWeights.medium),
    titleSmall: base.titleSmall?.copyWith(fontWeight: AppFontWeights.medium),
    bodyLarge: base.bodyLarge?.copyWith(fontWeight: AppFontWeights.regular),
    bodyMedium: base.bodyMedium?.copyWith(fontWeight: AppFontWeights.regular),
    bodySmall: base.bodySmall?.copyWith(fontWeight: AppFontWeights.regular),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: AppFontWeights.semiBold,
      fontSize: AppSpacing.md,
      height: 20 / 16,
      letterSpacing: 0,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: AppSpacing.smXl,
      fontWeight: AppFontWeights.semiBold,
      height: 1.0,
      letterSpacing: 0,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontWeight: AppFontWeights.medium,
      fontSize: AppSpacing.smLg,
      height: 1.0,
      letterSpacing: 0,
    ),
  );
}
