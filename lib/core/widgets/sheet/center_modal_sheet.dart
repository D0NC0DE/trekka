import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// A centered modal sheet with gradient background and optional dismiss functionality.
class CenterModalSheet extends StatelessWidget {
  const CenterModalSheet({
    required this.child,
    this.dismissible = true,
    this.onDismiss,
    this.maxWidth,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final Widget child;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;

  static const double _borderWidth = 4;
  static const double _borderRadius = 8;
  static const double _closeButtonSize = 36;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissible
                  ? (onDismiss ?? () => Navigator.of(context).maybePop())
                  : null,
              child: Container(
                color: dismissible
                    ? AppColors.overlayBlurBlack
                    : Colors.transparent,
              ),
            ),
          ),

          Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? double.infinity,
                ),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Modal container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppGradients.centerModal,
                        border: Border.all(
                          color: AppColors.primaryBright,
                          width: _borderWidth,
                        ),
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      padding: padding,
                      child: child,
                    ),

                    if (dismissible)
                      Positioned(
                        top: -_closeButtonSize / 2,
                        right: -_closeButtonSize / 2,
                        child: _CloseButton(
                          size: _closeButtonSize,
                          onTap:
                              onDismiss ??
                              () => Navigator.of(context).maybePop(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Close button for the center modal sheet.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.size, required this.onTap});

  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryBright, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowMidBlack,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 20,
          color: AppColors.deepTeal,
        ),
      ),
    );
  }
}
