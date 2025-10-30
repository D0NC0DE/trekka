import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// Reusable overlay modal with gradient styling.
class GradientOverlayModal extends StatelessWidget {
  const GradientOverlayModal({required this.child, this.maxWidth, super.key});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      minimum: EdgeInsets.only(
        top: AppSpacing.sm,
        left: AppSpacing.smLg,
        right: AppSpacing.smLg,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.smMd),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.smMd),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppGradients.logisticsSheet,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.smLg),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
