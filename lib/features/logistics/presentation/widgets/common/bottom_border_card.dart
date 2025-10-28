import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

/// Reusable card with a translucent background and bottom divider.
class BottomBorderCard extends StatelessWidget {
  const BottomBorderCard({
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppSpacing.smLg,
      horizontal: AppSpacing.smLg,
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.logisticsActionInactive,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: child,
    );
  }
}
