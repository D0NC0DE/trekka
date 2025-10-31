import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';

class FloatingLocationButton extends StatelessWidget {
  const FloatingLocationButton({
    required this.onPressed,
    this.isCloseButton = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isCloseButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCloseButton ? null : AppColors.white,
          gradient: isCloseButton ? AppGradients.backButton : null,
          borderRadius: BorderRadius.circular(isCloseButton ? 2 : 6),
          boxShadow: AppShadows.floatingButton,
        ),
        child: Center(
          child: Image.asset(
            isCloseButton ? AppAssetIcons.close : AppAssetIcons.myLocation,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
