import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';

class GradientIconButton extends StatelessWidget {
  const GradientIconButton({
    required this.iconAsset,
    required this.onPressed,
    this.size = 36,
    this.iconSize = 16,
    this.borderRadius = 4,
    this.padding,
    super.key,
  });

  final String iconAsset;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    final double resolvedPadding = padding ?? (size - iconSize) / 2;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(resolvedPadding),
        decoration: BoxDecoration(
          gradient: AppGradients.backButton,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: AppShadows.floatingButton,
        ),
        child: Center(
          child: Image.asset(
            iconAsset,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
