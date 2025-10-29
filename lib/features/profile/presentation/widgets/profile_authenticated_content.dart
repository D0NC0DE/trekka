import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/full_width_gradient_button.dart';
import 'package:trekka/core/widgets/card/gradient_info_card.dart';
import 'package:trekka/core/widgets/card/gradient_volume_card.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_avatar.dart';
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
    super.key,
  });

  final User user;
  final Wallet? wallet;
  final bool isWalletLoading;
  final VoidCallback onLogout;

  void _showEditProfileModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CenterModalSheet(
          dismissible: true,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          topButton: Image.asset(AppAssetIcons.user, width: 24, height: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GradientInfoCard(
                label: 'Username',
                value: user.username.isNotEmpty ? user.username : 'Not set',
                trailing: Image.asset(AppAssetIcons.editProfile, width: 16, height: 16),
                iconSize: 16,
              ),
              const SizedBox(height: AppSpacing.sm),
              GradientInfoCard(
                label: 'Email',
                value: user.email,
                trailing: Image.asset(AppAssetIcons.editProfile, width: 16, height: 16),
                iconSize: 16,
              ),
            ],
          ),
        );
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
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

// /// Settings modal content with interactive controls.
// class _SettingsModalContent extends StatefulWidget {
//   const _SettingsModalContent();

//   @override
//   State<_SettingsModalContent> createState() => _SettingsModalContentState();
// }

// class _SettingsModalContentState extends State<_SettingsModalContent> {
//   bool _volumeEnabled = true;
//   double _volumeLevel = 0.7;
//   bool _musicEnabled = true;
//   double _musicLevel = 0.5;

//   @override
//   Widget build(BuildContext context) {
//     return CenterModalSheet(
//       dismissible: true,
//       padding: const EdgeInsets.all(AppSpacing.xxl),
//       topButton: Image.asset(AppAssetIcons.settings, width: 24, height: 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           GradientVolumeCard(
//             label: 'hfx Audio',
//             icon: Image.asset(AppAssetIcons.volume, width: 20, height: 20),
//             isEnabled: _volumeEnabled,
//             onToggle: () {
//               setState(() {
//                 _volumeEnabled = !_volumeEnabled;
//               });
//             },
//             value: _volumeLevel,
//             onChanged: (double value) {
//               setState(() {
//                 _volumeLevel = value;
//               });
//             },
//           ),
//           const SizedBox(height: AppSpacing.smLg),
//           GradientVolumeCard(
//             label: 'Music',
//             icon: Image.asset(AppAssetIcons.music, width: 20, height: 20),
//             isEnabled: _musicEnabled,
//             onToggle: () {
//               setState(() {
//                 _musicEnabled = !_musicEnabled;
//               });
//             },
//             value: _musicLevel,
//             onChanged: (double value) {
//               setState(() {
//                 _musicLevel = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
