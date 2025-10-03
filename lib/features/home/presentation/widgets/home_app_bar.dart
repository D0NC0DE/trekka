import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/home/presentation/widgets/home_point_badge.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.onNotificationPressed,
  });

  static const double _topPadding = 12;
  static const double _bottomPadding = 30;

  final VoidCallback? onNotificationPressed;

  @override
  Size get preferredSize => const Size.fromHeight(
        _topPadding + HomePointBadge.height + _bottomPadding,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlayFadeBlack,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: _topPadding,
            bottom: _bottomPadding,
            left: AppSpacing.mdLg,
            right: AppSpacing.mdLg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const HomePointBadge(),
              const Spacer(),
              _ActionIcon(
                assetPath: AppAssetIcons.notification,
                onPressed: onNotificationPressed ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.assetPath, required this.onPressed});

  final String assetPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Image.asset(
          assetPath,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
