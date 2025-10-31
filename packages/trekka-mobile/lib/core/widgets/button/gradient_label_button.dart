import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

class GradientLabelButton extends StatelessWidget {
  const GradientLabelButton({
    required this.label,
    required this.onTap,
    this.gradient = AppGradients.logisticsActionButton,
    this.textColor = AppColors.white,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    this.borderRadius = 4,
    this.style,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final Gradient gradient;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          label,
          style: style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
