import 'package:flutter/material.dart';
import 'package:trekka/core/design/tokens.dart';

TextTheme buildTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontWeight: AppFontWeights.bold),
    displayMedium: base.displayMedium?.copyWith(
      fontWeight: AppFontWeights.bold,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontWeight: AppFontWeights.extraBold,
      height: 1.0,
      letterSpacing: 0.48,
      fontSize: AppSpacing.lg,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: AppFontWeights.bold,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: AppFontWeights.semiBold,
    ),
    titleLarge: base.titleLarge?.copyWith(fontWeight: AppFontWeights.semiBold),
    titleMedium: base.titleMedium?.copyWith(fontWeight: AppFontWeights.medium),
    titleSmall: base.titleSmall?.copyWith(
      fontWeight: AppFontWeights.bold,
      height: 1.0,
      letterSpacing: 0,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontWeight: AppFontWeights.regular,
      letterSpacing: 0,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontWeight: AppFontWeights.regular,
      letterSpacing: 0,
      height: 1.0,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontWeight: AppFontWeights.regular,
      fontSize: AppSpacing.smXl,
      height: 20 / 14,
      letterSpacing: 0,
    ),
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
