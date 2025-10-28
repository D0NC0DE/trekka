import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';

/// A flexible input field that can also act as a button.
///
/// When [readOnly] is true and [onTap] is provided, it acts as a button.
/// Otherwise, it functions as a text input field.
class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    this.controller,
    this.focusNode,
    this.hintText = 'Where to go?',
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.smLg),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          border: Border.all(color: AppColors.deepTeal50, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              AppAssetIcons.search,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: readOnly
                  ? Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.25,
                        fontWeight: AppFontWeights.semiBold,
                        color: AppColors.textPrimary50,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: autofocus,
                      onChanged: onChanged,
                      enabled: enabled,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.25,
                        fontWeight: AppFontWeights.semiBold,
                        color: AppColors.textPrimary50,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(
                              height: 1.25,
                              fontWeight: AppFontWeights.semiBold,
                              color: AppColors.textPrimary50,
                            ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
