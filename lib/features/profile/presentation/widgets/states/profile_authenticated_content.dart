import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/full_width_gradient_button.dart';
import 'package:trekka/core/widgets/loading/linear_loader.dart';
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
    required this.isUpdatingAvatar,
    required this.isUpdatingUsername,
    required this.isDeletingAccount,
    required this.isLoggingOut,
    required this.onLogout,
    required this.onAvatarChanged,
    required this.onUsernameChanged,
    this.onDeleteAccount,
    super.key,
  });

  final User user;
  final Wallet? wallet;
  final bool isWalletLoading;
  final bool isUpdatingAvatar;
  final bool isUpdatingUsername;
  final bool isDeletingAccount;
  final bool isLoggingOut;
  final VoidCallback onLogout;
  final ValueChanged<int> onAvatarChanged;
  final ValueChanged<String> onUsernameChanged;
  final VoidCallback? onDeleteAccount;

  void _showEditProfileModal(BuildContext context) {
    if (isUpdatingUsername) return; // Prevent opening while updating
    
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditProfileModal(
          user: user,
          onUsernameEdit: () {
            Navigator.of(context).pop();
            _showUsernameEditModal(context);
          },
        );
      },
    );
  }

  void _showUsernameEditModal(BuildContext context) {
    showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return _UsernameEditModal(currentUsername: user.username);
      },
    ).then((String? newUsername) {
      if (newUsername != null && newUsername.isNotEmpty && newUsername != user.username) {
        onUsernameChanged(newUsername);
      }
    });
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
    
    // Disable all actions when any operation is in progress
    final bool isAnyOperationInProgress = isUpdatingAvatar || 
        isUpdatingUsername || 
        isDeletingAccount || 
        isLoggingOut;

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
          ProfileAvatar(
            user: user,
            onAvatarChanged: isUpdatingAvatar ? (_) {} : onAvatarChanged,
          ),
          if (isUpdatingAvatar) ...[
            const SizedBox(height: AppSpacing.xs),
            const CenteredLinearLoader(),
          ],
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
            onTap: isAnyOperationInProgress ? () {} : () => _showEditProfileModal(context),
            leading: Image.asset(AppAssetIcons.user, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
            isActive: !isAnyOperationInProgress,
          ),
          if (isUpdatingUsername) ...[
            const SizedBox(height: AppSpacing.xs),
            const CenteredLinearLoader(),
          ],
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Settings',
            onTap: isAnyOperationInProgress ? () {} : () => _showSettingsModal(context),
            leading: Image.asset(AppAssetIcons.settings, width: 24, height: 24),
            trailing: Image.asset(AppAssetIcons.forward, width: 24, height: 24),
            isActive: !isAnyOperationInProgress,
          ),
          const SizedBox(height: AppSpacing.sm),
          FullWidthGradientButton(
            label: 'Sign Out',
            onTap: isAnyOperationInProgress ? () {} : onLogout,
            trailing: Image.asset(AppAssetIcons.signout, width: 24, height: 24),
            isActive: !isAnyOperationInProgress,
          ),
          if (isLoggingOut) ...[
            const SizedBox(height: AppSpacing.xs),
            const CenteredLinearLoader(),
          ],
          const SizedBox(height: AppSpacing.md),
          ProfileDeleteAccountButton(
            onPressed: isAnyOperationInProgress ? () {} : () => _showDeleteAccountModal(context),
          ),
          if (isDeletingAccount) ...[
            const SizedBox(height: AppSpacing.xs),
            const CenteredLinearLoader(),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

/// Username edit modal
class _UsernameEditModal extends StatefulWidget {
  const _UsernameEditModal({required this.currentUsername});

  final String currentUsername;

  @override
  State<_UsernameEditModal> createState() => _UsernameEditModalState();
}

class _UsernameEditModalState extends State<_UsernameEditModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CenterModalSheet(
      dismissible: true,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      topButton: Image.asset(AppAssetIcons.editProfile, width: 24, height: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Edit Username',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter username',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: AppColors.white50,
              ),
              filled: true,
              fillColor: AppColors.deepTeal,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: AppColors.primaryBright, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: AppColors.primaryBright, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: AppColors.accentAmber, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.primaryBright, width: 1),
                    ),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final String newUsername = _controller.text.trim();
                    Navigator.of(context).pop(newUsername);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      gradient: AppGradients.logisticsActionButton,
                    ),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
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
