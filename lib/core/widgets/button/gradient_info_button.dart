import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// A info button with gradient background and widgets inside.
class GradientInfoButton extends StatelessWidget {
  const GradientInfoButton({
    required this.child,
    this.onPressed,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    final Color bgColor = backgroundColor ?? AppColors.surfaceMuted;

    return InnerShadow(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      shadows: AppShadows.buttonInner,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
