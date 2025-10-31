import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.onRefresh,
    this.onAddFunds,
    this.onRequestFromFriend,
    super.key,
  });

  final String amount;
  final String walletAddress;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final VoidCallback? onRefresh;
  final VoidCallback? onAddFunds;
  final VoidCallback? onRequestFromFriend;

  static const double _qrSize = 120;

  void _copyWalletAddress(BuildContext context) {
    final String trimmed = walletAddress.trim();
    if (trimmed.isEmpty) return;

    Clipboard.setData(ClipboardData(text: trimmed));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wallet address copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool hasWalletAddress =
        walletAddress.trim().isNotEmpty && walletAddress.contains('.');
    final String displayAddress =
        hasWalletAddress ? walletAddress : 'Wallet address unavailable';

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
            backgroundColor: AppColors.primaryBright.withOpacity(0.35),
            borderColor: AppColors.white50,
            borderRadius: AppRadius.sm,
            dashPattern: const <double>[4, 3],
            padding: const EdgeInsets.all(AppSpacing.lg),
            strokeWidth: 1.4,
            child: SizedBox(
              width: _qrSize,
              height: _qrSize,
              child: hasWalletAddress
                  ? QrImageView(
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
                    )
                  : const _QrPlaceholder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          WalletAddressDisplay(
            address: displayAddress,
            onCopy: hasWalletAddress ? () => _copyWalletAddress(context) : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Other methods',
              style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: AppFontWeights.semiBold,
                  ) ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.smLg),
          _GradientQuickActionButton(
            icon: Icons.credit_card,
            label: 'Add funds with bank/card',
            onTap: onAddFunds,
          ),
          const SizedBox(height: AppSpacing.sm),
          _GradientQuickActionButton(
            icon: Icons.group_add,
            label: 'Request from friend',
            onTap: onRequestFromFriend,
          ),
          const SizedBox(height: AppSpacing.lg),
          _RefreshButton(
            label: 'Refresh after payment',
            onTap: onRefresh,
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
  VoidCallback? onRefresh,
  VoidCallback? onAddFunds,
  VoidCallback? onRequestFromFriend,
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
        onRefresh: onRefresh,
        onAddFunds: onAddFunds,
        onRequestFromFriend: onRequestFromFriend,
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

class WalletAddressDisplay extends StatelessWidget {
  const WalletAddressDisplay({
    required this.address,
    this.onCopy,
  });

  final String address;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCopyEnabled = onCopy != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.white50, width: 1.4),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: AppFontWeights.semiBold,
                      ) ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              GestureDetector(
                onTap: isCopyEnabled ? onCopy : null,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(isCopyEnabled ? 0.2 : 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: AppColors.white50,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: isCopyEnabled ? AppColors.white : AppColors.white50,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap copy to share or fund manually',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
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

class _GradientQuickActionButton extends StatelessWidget {
  const _GradientQuickActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.white,
          fontWeight: AppFontWeights.semiBold,
        ) ??
        const TextStyle(
          fontSize: 15,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.white,
        );

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.6,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: AppGradients.logisticsActionButton,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.primaryBright, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.deepTeal,
          fontWeight: AppFontWeights.semiBold,
        ) ??
        const TextStyle(
          fontSize: 15,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.deepTeal,
        );

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.6,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.primaryBright, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white25,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: const Center(
        child: Icon(
          Icons.qr_code_2_rounded,
          color: AppColors.white50,
          size: 36,
        ),
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
