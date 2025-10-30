import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';

/// Avatar selector modal with grid of avatars.
class AvatarSelectorModal extends StatelessWidget {
  const AvatarSelectorModal({
    required this.currentAvatarId,
    super.key,
  });

  final int currentAvatarId;

  Future<void> _showAvatarPreviewBeforeUpdate(
    BuildContext context,
    int avatarId,
  ) async {
    final bool? confirmed = await showDialog<bool>(
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
                      color: AppColors.primaryBright,
                      gradient: AppGradients.transparent,
                      borderColor: AppColors.primaryBright,
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
    );

    if (context.mounted && confirmed == true) {
      Navigator.of(context).pop(avatarId);
    }
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
