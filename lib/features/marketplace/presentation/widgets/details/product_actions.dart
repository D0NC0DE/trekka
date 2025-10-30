import 'package:flutter/material.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/button/gradient_icon_button.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GradientIconButton(
              iconAsset: AppAssetIcons.call,
              onPressed: () {},
              size: 50,
              iconSize: 32,
              borderRadius: AppRadius.sm,
              gradient: AppGradients.logisticsActionButton,
              boxShadow: false,
            ),
            const SizedBox(width: AppSpacing.smLg),
            Expanded(
              child: GradientActionButton(
                label: 'Chat the seller',
                onTap: () {},
                gradient: AppGradients.transparent,
                borderColor: AppColors.primary,
                color: AppColors.primary,
                borderWidth: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.smLg),
        GradientActionButton(label: 'Buy it now', onTap: () {}),
      ],
    );
  }
}
