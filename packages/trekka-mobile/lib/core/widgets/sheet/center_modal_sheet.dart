import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// A centered modal sheet with gradient background and optional dismiss functionality.
class CenterModalSheet extends StatelessWidget {
  const CenterModalSheet({
    required this.child,
    this.dismissible = true,
    this.onDismiss,
    this.maxWidth,
    this.padding = const EdgeInsets.all(12),
    this.topButton,
    super.key,
  });

  final Widget child;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final Widget? topButton;

  static const double _borderWidth = 4;
  static const double _borderRadius = 8;
  static const double _closeButtonSize = 36;
  static const double _topButtonSize = 50;

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
                    if (topButton != null)
                      Positioned(
                        top: -_topButtonSize / 2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _TopCircularButton(
                            size: _topButtonSize,
                            child: topButton!,
                          ),
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

/// Wallet specific modal content prompting the user to top up via QR.
class CenterModalWalletTopUpSheet extends StatelessWidget {
  const CenterModalWalletTopUpSheet({
    required this.amount,
    required this.walletAddress,
    this.dismissible = true,
    this.onDismiss,
    super.key,
  });

  final String amount;
  final String walletAddress;
  final bool dismissible;
  final VoidCallback? onDismiss;

  static const double _qrSize = 92;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CenterModalSheet(
      dismissible: dismissible,
      onDismiss: onDismiss,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Top up with $amount to complete your order',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(color: AppColors.white) ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DashedBorderContainer(
            backgroundColor: AppColors.primaryBright.withOpacity(0.5),
            borderColor: AppColors.white50,
            borderRadius: AppRadius.xs,
            dashPattern: const <double>[2, 2],
            padding: const EdgeInsets.all(AppSpacing.md),
            strokeWidth: 1,
            child: SizedBox(
              width: _qrSize,
              height: _qrSize,
              child: QrImageView(
                data: walletAddress,
                gapless: false,
                backgroundColor: Colors.transparent,
                eyeStyle: const QrEyeStyle(
                  color: AppColors.white,
                  eyeShape: QrEyeShape.square,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  color: AppColors.white,
                  dataModuleShape: QrDataModuleShape.square,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableText(
            walletAddress,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
                  color: AppColors.white50,
                ) ??
                const TextStyle(
                  fontSize: 12,
                  color: AppColors.white50,
                ),
          ),
        ],
      ),
    );
  }
}

/// Presents the wallet top up sheet via the Navigator API.
Future<T?> showCenterModalWalletTopUpSheet<T>({
  required BuildContext context,
  required String amount,
  required String walletAddress,
  bool dismissible = true,
  VoidCallback? onDismiss,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: dismissible,
    builder: (BuildContext dialogContext) {
      return CenterModalWalletTopUpSheet(
        amount: amount,
        walletAddress: walletAddress,
        dismissible: dismissible,
        onDismiss: onDismiss,
      );
    },
  );
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

class _TopCircularButton extends StatelessWidget {
  const _TopCircularButton({
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: AppShadows.modalCircularButtonInner,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderContainer extends StatelessWidget {
  const _DashedBorderContainer({
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.dashPattern,
    required this.strokeWidth,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final List<double> dashPattern;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: borderColor,
        radius: borderRadius,
        dashPattern: dashPattern,
        strokeWidth: strokeWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashPattern,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final List<double> dashPattern;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double inset = strokeWidth / 2;
    final RRect borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        inset,
        inset,
        math.max(0, size.width - strokeWidth),
        math.max(0, size.height - strokeWidth),
      ),
      Radius.circular(math.max(0, radius - inset)),
    );

    final Path borderPath = Path()..addRRect(borderRect);

    for (final PathMetric metric in borderPath.computeMetrics()) {
      double distance = 0;
      int index = 0;

      while (distance < metric.length) {
        final double dashLength = dashPattern[index % dashPattern.length];
        index++;
        final double drawEnd =
            math.min(distance + dashLength, metric.length);

        if (drawEnd > distance) {
          final Path dashPath = metric.extractPath(distance, drawEnd);
          canvas.drawPath(dashPath, paint);
        }

        distance = drawEnd;
        if (distance >= metric.length) {
          break;
        }

        final double gapLength = dashPattern[index % dashPattern.length];
        index++;
        distance = math.min(distance + gapLength, metric.length);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        !listEquals(oldDelegate.dashPattern, dashPattern);
  }
}
