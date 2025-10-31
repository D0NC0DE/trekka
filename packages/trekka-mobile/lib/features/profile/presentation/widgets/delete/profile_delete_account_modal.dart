import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';

/// Confirmation dialog displayed when user attempts to delete their account.
class ProfileDeleteAccountModal extends StatelessWidget {
  const ProfileDeleteAccountModal({this.onConfirm, super.key});

  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CenterModalSheet(
      dismissible: true,
      padding: const EdgeInsets.only(
        top: AppSpacing.xxl,
        bottom: AppSpacing.smLg,
        left: AppSpacing.lgXl,
        right: AppSpacing.lgXl,
      ),
      topButton: Image.asset(AppAssetIcons.delete, width: 24, height: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'You are about to delete your account',
            style: textTheme.bodyLarge?.copyWith(
              height: 1.25,
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.destructiveTextOn,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This action is permanent and cannot be undone',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.divider,
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Are you sure?',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.divider,
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.mdLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(
                  'Cancel',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.divider,
                    height: 20 / 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: AppColors.destructive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                  onConfirm?.call();
                },
                child: Text(
                  'Delete',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: AppFontWeights.semiBold,
                    height: 20 / 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
