import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// Reusable overlay modal with logistics gradient styling.
class LogisticsOverlayModal extends StatelessWidget {
  const LogisticsOverlayModal({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      minimum: EdgeInsets.only(top: AppSpacing.sm),
      child: Align(
        alignment: Alignment.topCenter,
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
    );
  }
}
