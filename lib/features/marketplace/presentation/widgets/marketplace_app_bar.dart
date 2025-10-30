import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_back_button.dart';
import 'package:trekka/core/widgets/button/gradient_icon_button.dart';

class MarketplaceAppBar extends StatelessWidget {
  const MarketplaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GradientBackButton(onPressed: () => context.pop()),
        Expanded(
          child: Center(
            child: Text(
              'Marketplace',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: AppFontWeights.semiBold,
                height: 1.25,
              ),
            ),
          ),
        ),
        GradientIconButton(iconAsset: AppAssetIcons.profile, onPressed: () {}),
      ],
    );
  }
}
