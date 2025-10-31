import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

/// A multiline text field with consistent styling for user input.
class AppMultilineTextField extends StatelessWidget {
  const AppMultilineTextField({
    required this.controller,
    this.hintText,
    this.maxLines = 3,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: hintColor ?? AppColors.textPrimary50,
        ),
        filled: true,
        fillColor: fillColor ?? AppColors.backgroundAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.smMd),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.divider,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.smMd),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.divider,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.smMd),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primary,
            width: focusedBorderWidth,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor ?? AppColors.textPrimary,
      ),
    );
  }
}

