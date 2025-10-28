import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/full_width_gradient_button.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_wallet_section.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Renders authenticated profile details inside the modal.
class ProfileAuthenticatedContent extends StatelessWidget {
  const ProfileAuthenticatedContent({
    required this.user,
    required this.wallet,
    required this.isWalletLoading,
    required this.onLogout,
    super.key,
  });

  final User user;
  final Wallet? wallet;
  final bool isWalletLoading;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String displayName = user.username.isNotEmpty
        ? user.username
        : user.email;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.md,
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const ProfileAvatar(),
            const SizedBox(height: AppSpacing.xs),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.25,
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.accentAmber,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ProfileWalletSection(wallet: wallet, isLoading: isWalletLoading),
          const SizedBox(height: AppSpacing.md),
          FullWidthGradientButton(
            label: 'Edit Profile',
            onTap: () => {},
            leading: Image.asset(AppAssetIcons.user, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Settings',
            onTap: () => {},
            leading: Image.asset(AppAssetIcons.settings, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Sign Out',
            onTap: onLogout,
            trailing: Image.asset(AppAssetIcons.signout, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
