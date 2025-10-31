import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// A full-width gradient button with optional leading and trailing widgets.
class FullWidthGradientButton extends StatelessWidget {
  const FullWidthGradientButton({
    required this.label,
    required this.onTap,
    this.color = AppColors.white,
    this.gradient = AppGradients.logisticsActionButton,
    this.borderColor = AppColors.primaryBright,
    this.isActive = true,
    this.leading,
    this.trailing,
    this.padding =
        const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 8),
    this.borderWidth = 2,
    this.borderRadius,
    this.iconSize = 24,
    this.gap = 4,
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

  /// Optional leading widget (icon, image, etc.)
  final Widget? leading;

  /// Optional trailing widget (icon, image, etc.)
  final Widget? trailing;

  /// Internal padding (default: 12px vertical, 16px left, 8px right)
  final EdgeInsetsGeometry padding;

  /// Border width
  final double borderWidth;

  /// Border radius (defaults to AppRadius.sm)
  final double? borderRadius;

  /// Default icon size for leading/trailing widgets
  final double iconSize;

  /// Gap between leading, text, and trailing (default: 4px)
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isActive ? onTap : null,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (leading != null) ...<Widget>[
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: leading!,
                    ),
                    SizedBox(width: gap),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.25,
                          fontWeight: AppFontWeights.semiBold,
                          color: color,
                        ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (trailing != null)
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: trailing!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

