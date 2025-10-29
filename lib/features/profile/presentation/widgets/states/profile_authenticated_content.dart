import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/full_width_gradient_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/presentation/widgets/edit_profile_modal.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:trekka/features/profile/presentation/widgets/delete/profile_delete_account_button.dart';
import 'package:trekka/features/profile/presentation/widgets/delete/profile_delete_account_modal.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_settings_modal.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_wallet_section.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Renders authenticated profile details inside the modal.
class ProfileAuthenticatedContent extends StatelessWidget {
  const ProfileAuthenticatedContent({
    required this.user,
    required this.wallet,
    required this.isWalletLoading,
    required this.onLogout,
    this.onDeleteAccount,
    super.key,
  });

  final User user;
  final Wallet? wallet;
  final bool isWalletLoading;
  final VoidCallback onLogout;
  final VoidCallback? onDeleteAccount;

  void _showEditProfileModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditProfileModal(user: user);
      },
    );
  }

  void _showSettingsModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const ProfileSettingsModal();
      },
    );
  }

  void _showDeleteAccountModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext _) {
        return ProfileDeleteAccountModal(
          onConfirm: onDeleteAccount,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String displayName = user.username.isNotEmpty
        ? user.username
        : user.email;

    return CenterModalSheet(
      dismissible: false,
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
            onTap: () => _showEditProfileModal(context),
            leading: Image.asset(AppAssetIcons.user, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Settings',
            onTap: () => _showSettingsModal(context),
            leading: Image.asset(AppAssetIcons.settings, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Sign Out',
            onTap: onLogout,
            trailing: Image.asset(AppAssetIcons.signout, width: 24, height: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileDeleteAccountButton(
            onPressed: () => _showDeleteAccountModal(context),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
