import 'package:flutter/material.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/utils/coming_soon.dart';
import 'package:trekka/core/widgets/button/gradient_icon_button.dart';
import 'package:trekka/core/widgets/input/gradient_input_container.dart';

class MarketplaceSearchBar extends StatelessWidget {
  const MarketplaceSearchBar({super.key});

  //TODO: Add search functionality
  @override
  Widget build(BuildContext context) {
    return GradientInputContainer(
      onTap: () => showComingSoon(context, featureLabel: 'Search Marketplace'),
      placeholder: 'Search for anything',
      leading: GradientIconButton(
        boxShadow: false,
        iconAsset: AppAssetIcons.searchWhite,
        onPressed: () {},
      ),
    );
  }
}
