import 'package:flutter/material.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// Custom button with inset shadows and specific styling.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.width,
    this.isLoading = false,
    this.borderRadius,
    this.loadingSize = 50,
  });

  final VoidCallback? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double? width;
  final bool isLoading;
  final double? borderRadius;
  final double loadingSize;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final Color bgColor = backgroundColor ?? AppColors.primary;
    final Color txtColor = textColor ?? AppColors.black;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.35,
      child: InnerShadow(
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
        shadows: AppShadows.buttonInner,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppRadius.sm,
                ),
              ),
              child: Center(
                child: isLoading
                    ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          txtColor,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          AppAssetGifs.loading,
                          width: loadingSize,
                          height: loadingSize,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Text(
                        label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.25,
                          fontWeight: AppFontWeights.semiBold,
                          color: txtColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
