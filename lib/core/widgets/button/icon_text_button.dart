import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// A button with inner shadow, leading icon, text, and optional trailing icon.
/// 
/// Similar to LocationSearchField but with InnerShadow like AppButton.
/// Uses padding instead of fixed height.
class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.text,
    required this.leadingIcon,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.trailingIcon,
    super.key,
  });

  final String text;
  final String leadingIcon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final String? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    final Color bgColor = backgroundColor ?? AppColors.surfaceMuted;
    final Color txtColor = textColor ?? AppColors.textPrimary;

    return InnerShadow(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      shadows: AppShadows.buttonInner,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: <Widget>[
                // Leading icon
                Image.asset(
                  leadingIcon,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSpacing.md),
                
                // Text
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.25,
                      fontWeight: AppFontWeights.semiBold,
                      color: txtColor,
                    ),
                  ),
                ),
                
                //TODO: check if this is needed
                // Optional trailing icon (should be 32x32... )
                if (trailingIcon != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.smLg),
                  Image.asset(
                    trailingIcon!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

