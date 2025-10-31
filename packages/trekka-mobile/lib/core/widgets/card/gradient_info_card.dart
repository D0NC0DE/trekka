import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// A card with gradient background displaying a label and value in two lines.
/// Styled similarly to FullWidthGradientButton but non-interactive.
class GradientInfoCard extends StatelessWidget {
  const GradientInfoCard({
    required this.label,
    required this.value,
    this.gradient = AppGradients.logisticsActionButton,
    this.borderColor = AppColors.primaryBright,
    this.labelColor = AppColors.lightGrey,
    this.valueColor = AppColors.accentAmber,
    this.padding =
        const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
    this.borderWidth = 2,
    this.borderRadius,
    this.leading,
    this.trailing,
    this.iconSize = 24,
    this.gap = 4,
    super.key,
  });

  /// The label/title text (displayed on top)
  final String label;

  /// The value text (displayed below the label)
  final String value;

  /// Background gradient
  final Gradient gradient;

  /// Border color
  final Color borderColor;

  /// Label text color
  final Color labelColor;

  /// Value text color
  final Color valueColor;

  /// Internal padding
  final EdgeInsetsGeometry padding;

  /// Border width
  final double borderWidth;

  /// Border radius (defaults to AppRadius.sm)
  final double? borderRadius;

  /// Optional leading widget (icon, image, etc.)
  final Widget? leading;

  /// Optional trailing widget (icon, image, etc.)
  final Widget? trailing;

  /// Default icon size for leading/trailing widgets
  final double iconSize;

  /// Gap between leading, text column, and trailing
  final double gap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.25,
                      fontWeight: AppFontWeights.semiBold,
                      color: labelColor,
                    ),
                  ),
                  Text(
                    value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: valueColor,
                      height: 20 / 14,
                    ),
                  ),
                ],
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
    );
  }
}

