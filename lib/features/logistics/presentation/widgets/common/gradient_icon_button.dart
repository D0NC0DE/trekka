import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

class GradientIconButton extends StatelessWidget {
  const GradientIconButton({
    required this.iconPath,
    this.width = 28,
    this.height = 28,
    this.borderRadius = 4,
    this.iconWidth = 24,
    this.iconHeight = 24,
    this.onTap,
    super.key,
  });

  final String iconPath;
  final double width;
  final double height;
  final double borderRadius;
  final double iconWidth;
  final double iconHeight;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: AppGradients.logisticsSearchIcon,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            iconPath,
            width: iconWidth,
            height: iconHeight,
            fit: BoxFit.contain,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
