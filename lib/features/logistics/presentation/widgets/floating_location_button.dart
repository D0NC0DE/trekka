import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';

class FloatingLocationButton extends StatelessWidget {
  const FloatingLocationButton({
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: AppShadows.floatingButton,
        ),
        child: Center(
          child: Image.asset(
            AppAssetIcons.myLocation,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

