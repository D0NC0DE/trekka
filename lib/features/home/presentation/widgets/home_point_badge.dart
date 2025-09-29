import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

class HomePointBadge extends StatelessWidget {
  // TODO: Add the logic to get the label from the backend.
  const HomePointBadge({super.key, this.label = '400 989'});

  static const double _iconSize = 34;
  static const double _containerWidth = 101;
  static const double _containerHeight = 25;
  static const double _iconOverlap = 14;

  static const double height = _iconSize;
  static const double width = _containerWidth + _iconSize - _iconOverlap;

  final String label;

  @override
  Widget build(BuildContext context) {
    final double containerTopOffset = (_iconSize - _containerHeight) / 2;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: _iconSize - _iconOverlap,
            top: containerTopOffset,
            child: InnerShadow(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              shadows: AppShadows.homePointBadgeInner,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: SizedBox(
                  width: _containerWidth,
                  height: _containerHeight,
                  child: Center(
                    child: Text(
                      label,
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: AppFontWeights.extraBold,
                          ) ??
                          const TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: AppFontWeights.extraBold,
                            fontSize: 12,
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              height: _iconSize,
              width: _iconSize,
              child: Image.asset(
                AppAssetIcons.trekkaPoint,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
