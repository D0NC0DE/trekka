import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/full_width_gradient_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';

/// Loading state shown while profile data initializes.
class ProfileLoadingContent extends StatelessWidget {
  const ProfileLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CenterModalSheet(
      dismissible: false,
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.md,
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
      ),
      child: Skeletonizer(
        enabled: true,
        enableSwitchAnimation: true,
        effect: ShimmerEffect(
          baseColor: AppColors.skeletonProfileBase,
          highlightColor: AppColors.skeletonProfileHighlight,
          duration: const Duration(milliseconds: 1000),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Avatar skeleton
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.deepTeal50,
                borderRadius: BorderRadius.circular(AppRadius.smMd),
                border: Border.all(color: AppColors.primaryBright, width: 2),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Username skeleton
            Bone.text(
              words: 2,
              style: textTheme.bodyLarge?.copyWith(
                height: 1.25,
                fontWeight: AppFontWeights.semiBold,
                color: AppColors.accentAmber,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Bone.text(words: 3, fontSize: 10),
            const SizedBox(height: AppSpacing.sm),
            Bone.text(words: 1, fontSize: 32),
            const SizedBox(height: AppSpacing.md),
            FullWidthGradientButton(
              label: 'Edit Profile',
              onTap: () {},
              leading: Image.asset(AppAssetIcons.user, width: 24, height: 24),
              trailing: Image.asset(
                AppAssetIcons.forward,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FullWidthGradientButton(
              label: 'Settings',
              onTap: () {},
              leading: Image.asset(
                AppAssetIcons.settings,
                width: 24,
                height: 24,
              ),
              trailing: Image.asset(
                AppAssetIcons.forward,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FullWidthGradientButton(
              label: 'Sign Out',
              onTap: () {},
              trailing: Image.asset(
                AppAssetIcons.signout,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
