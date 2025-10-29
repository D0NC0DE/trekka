import 'package:flutter/material.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/card/gradient_info_card.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';

class EditProfileModal extends StatelessWidget {
  const EditProfileModal({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
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
  }
}