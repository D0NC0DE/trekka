import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// A gradient action button with optional leading image/icon.
///
/// Features:
/// - Gradient background (customizable)
/// - Optional leading image
/// - Custom text color
/// - Active/Inactive states
/// - Consistent padding and border styling
class GradientActionButton extends StatelessWidget {
  const GradientActionButton({
    required this.label,
    required this.onTap,
    this.color = AppColors.white,
    this.gradient = AppGradients.logisticsActionButton,
    this.borderColor = AppColors.primaryBright,
    this.isActive = true,
    this.leadingImage,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.padding = 12,
    this.borderWidth = 2,
    this.borderRadius,
    super.key,
  });

  /// The text label displayed on the button
  final String label;

  /// Callback when button is tapped (only works if isActive is true)
  final VoidCallback onTap;

  /// Text color
  final Color color;

  /// Background gradient
  final Gradient gradient;

  /// Border color
  final Color borderColor;

  /// Whether the button is active/enabled
  final bool isActive;

  /// Optional leading image path (asset path)
  final String? leadingImage;

  /// Width of the leading image
  final double imageWidth;

  /// Height of the leading image
  final double imageHeight;

  /// Internal padding
  final double padding;

  /// Border width
  final double borderWidth;

  /// Border radius (defaults to AppRadius.sm)
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (leadingImage != null) ...<Widget>[
              Image.asset(
                leadingImage!,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
                color: color,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.25,
                      fontWeight: AppFontWeights.semiBold,
                      color: color,
                    ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

