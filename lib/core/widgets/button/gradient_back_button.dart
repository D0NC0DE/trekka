import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';

class GradientBackButton extends StatelessWidget {
  const GradientBackButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          gradient: AppGradients.backButton,
          borderRadius: BorderRadius.circular(4),
          boxShadow: AppShadows.floatingButton,
        ),
        child: Center(
          child: Image.asset(
            AppAssetIcons.back,
            width: 8,
            height: 16,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

