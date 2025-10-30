import 'package:flutter/material.dart';

/// A container for bottom sheet content with consistent styling.
///
/// Provides:
/// - Rounded top corners
/// - Proper clipping behavior
/// - Optional background image
/// - Optional gradient overlay
class SheetContainer extends StatelessWidget {
  const SheetContainer({
    required this.child,
    this.borderRadius = 40,
    this.backgroundImage,
    this.gradient,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final String? backgroundImage;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (backgroundImage != null)
            Image.asset(backgroundImage!, fit: BoxFit.cover),
          if (gradient != null)
            DecoratedBox(
              decoration: BoxDecoration(gradient: gradient),
            ),
          child,
        ],
      ),
    );
  }
}

