import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';

/// Displays the user's avatar and handles tap interactions.
/// Tapping the avatar shows a full-size preview modal.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.size = 80, super.key});

  final double size;

  void _showAvatarPreview(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CenterModalSheet(
          dismissible: true,
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.smMd),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    AppAssetImages.avatar,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GradientActionButton(
                label: 'Change avatar',
                onTap: () {
                  // TODO: Implement avatar change functionality
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(AppRadius.smMd);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => _showAvatarPreview(context),
        borderRadius: borderRadius,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.deepTeal50,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.primaryBright, width: 2),
            image: const DecorationImage(
              image: AssetImage(AppAssetImages.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
