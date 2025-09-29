import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';
import 'package:trekka/features/home/presentation/widgets/home_nav_option.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key, this.initialIndex = 0, this.onChanged});

  final int initialIndex;
  final ValueChanged<int>? onChanged;

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  static const double _navMinWidth = 296;
  static const double _navHeight = 72;
  static const double _compactHorizontalPadding = 8;
  static const double _regularHorizontalPadding = 12;

  int _selectedIndex = 0;

  /// TODO: Add the animation from one tab to another.

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 2);
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _navHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isCompact =
              maxWidth.isFinite && maxWidth < _navMinWidth;
          final EdgeInsetsGeometry horizontalPadding = EdgeInsets.symmetric(
            horizontal: isCompact
                ? _compactHorizontalPadding
                : _regularHorizontalPadding,
          );

          return DecoratedBox(
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
                  padding: horizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _onTap(0),
                        child: HomeNavOption(
                          assetPath: AppAssetIcons.homeTab,
                          label: 'Home',
                          isActive: _selectedIndex == 0,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _onTap(1),
                        child: HomeNavOption(
                          assetPath: AppAssetIcons.historyTab,
                          label: 'History',
                          isActive: _selectedIndex == 1,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _onTap(2),
                        child: HomeNavOption(
                          assetPath: AppAssetIcons.profileTab,
                          label: 'Profile',
                          isActive: _selectedIndex == 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
