import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';
import 'package:trekka/features/home/presentation/widgets/home_nav_option.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  static const double _navMinWidth = 296;
  static const double _navHeight = 72;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _navHeight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _navMinWidth),
        child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: AppShadows.homeNavDrop,
        ),
        child: InnerShadow(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          shadows: AppShadows.homeNav,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  HomeNavOption(
                    assetPath: 'assets/icons/home_tab.png',
                    label: 'Home',
                    isActive: true,
                  ),
                  HomeNavOption(
                    assetPath: 'assets/icons/history_tab.png',
                    label: 'History',
                  ),
                  HomeNavOption(
                    assetPath: 'assets/icons/profile_tab.png',
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }
}

// moved to its own file: HomeNavOption
