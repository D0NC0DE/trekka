import 'package:flutter/material.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_info_button.dart';

/// A button with inner shadow, leading icon, text, and optional trailing icon.
///
/// Similar to LocationSearchField but with InnerShadow like AppButton.
/// Uses padding instead of fixed height.
class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.text,
    this.leadingIcon,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.trailingIcon,
    super.key,
  });

  final String text;
  final String? leadingIcon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final String? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final Color txtColor = textColor ?? AppColors.textPrimary;

    final bool hasLeading = leadingIcon != null;
    final bool hasTrailing = trailingIcon != null;

    return GradientInfoButton(
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: (!hasLeading && !hasTrailing)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          if (hasLeading) ...<Widget>[
            Image.asset(
              leadingIcon!,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],

          // Text
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.25,
                fontWeight: AppFontWeights.semiBold,
                color: txtColor,
              ),
              textAlign: (!hasLeading && !hasTrailing)
                  ? TextAlign.center
                  : TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),

          if (hasTrailing) ...<Widget>[
            const SizedBox(width: AppSpacing.smLg),
            Image.asset(
              trailingIcon!,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ],
        ],
      ),
    );

    // return InnerShadow(
    //   borderRadius: BorderRadius.circular(AppRadius.sm),
    //   shadows: AppShadows.buttonInner,
    //   child: Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: isEnabled ? onPressed : null,
    //       borderRadius: BorderRadius.circular(AppRadius.sm),
    //       child: Container(
    //         padding: const EdgeInsets.all(AppSpacing.md),
    //         decoration: BoxDecoration(
    //           color: bgColor,
    //           borderRadius: BorderRadius.circular(AppRadius.sm),
    //         ),
    //         child: Row(
    //           children: <Widget>[
    //             // Leading icon
    //             Image.asset(
    //               leadingIcon,
    //               width: 24,
    //               height: 24,
    //               fit: BoxFit.contain,
    //             ),
    //             const SizedBox(width: AppSpacing.sm),

    //             // Text
    //             Expanded(
    //               child: Text(
    //                 text,
    //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                   height: 1.25,
    //                   fontWeight: AppFontWeights.semiBold,
    //                   color: txtColor,
    //                 ),
    //               ),
    //             ),
    //             if (trailingIcon != null) ...<Widget>[
    //               const SizedBox(width: AppSpacing.smLg),
    //               Image.asset(
    //                 trailingIcon!,
    //                 width: 24,
    //                 height: 24,
    //                 fit: BoxFit.contain,
    //               ),
    //             ],
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
