import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';

/// Displays the user's avatar and handles tap interactions.
/// Tapping the avatar shows a full-size preview modal.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.user,
    required this.onAvatarChanged,
    this.size = 80,
    super.key,
  });

  final User user;
  final ValueChanged<int> onAvatarChanged;
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
                    AppAssetImages.getAvatarById(user.avatar),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GradientActionButton(
                label: 'Change avatar',
                onTap: () {
                  Navigator.of(context).pop();
                  _showAvatarSelector(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAvatarSelector(BuildContext context) {
    showDialog<int>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return _AvatarSelectorModal(
          currentAvatarId: user.avatar,
        );
      },
    ).then((int? selectedAvatarId) {
      if (selectedAvatarId != null) {
        onAvatarChanged(selectedAvatarId);
      }
    });
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
            image: DecorationImage(
              image: AssetImage(AppAssetImages.getAvatarById(user.avatar)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar selector modal with grid of avatars
class _AvatarSelectorModal extends StatelessWidget {
  const _AvatarSelectorModal({
    required this.currentAvatarId,
  });

  final int currentAvatarId;

  void _showAvatarPreviewBeforeUpdate(BuildContext context, int avatarId) {
    showDialog<bool>(
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
                    AppAssetImages.getAvatarById(avatarId),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GradientActionButton(
                      label: 'Cancel',
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientActionButton(
                      label: 'Confirm',
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((bool? confirmed) {
      if (confirmed == true) {
        Navigator.of(context).pop(avatarId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CenterModalSheet(
      dismissible: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Avatar',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: AppFontWeights.semiBold,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              final int avatarId = index + 1;
              final bool isSelected = avatarId == currentAvatarId;

              return GestureDetector(
                onTap: () => _showAvatarPreviewBeforeUpdate(context, avatarId),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentAmber
                          : AppColors.primaryBright,
                      width: isSelected ? 3 : 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(AppAssetImages.getAvatarById(avatarId)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
