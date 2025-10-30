import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  static const List<String> _icons = <String>[
    AppAssetIcons.apple,
    AppAssetIcons.x,
    AppAssetIcons.facebook,
    AppAssetIcons.google,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int index = 0; index < _icons.length; index++) ...<Widget>[
          SocialLoginButton(assetPath: _icons[index]),
          if (index != _icons.length - 1)
            const SizedBox(width: AppSpacing.smXl),
        ],
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.assetPath,
    super.key,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.white),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

