import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:trekka/features/home/presentation/widgets/home_app_bar.dart';
import 'package:trekka/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:trekka/features/home/presentation/widgets/home_pins_layer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _navInsetWide = 47;
  static const double _navCompactContentWidth = 264;

  Future<void> _showAuthSheet(BuildContext context) {
    // TODO: Show Auth sheet when user is not authenticated
    return AuthSheet.show(context);
  }

  void _onNavChanged(BuildContext context, int index) {
    // TODO: OnCancel if still not authenticated go back to home
    if (index == 1 || index == 2) {
      _showAuthSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final Size screenSize = MediaQuery.of(context).size;
    final double navHorizontalInset = _resolveBottomNavInset(screenSize.width);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: HomeAppBar(
          onNotificationPressed: () => _showAuthSheet(context),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(AppAssetImages.homeBackground, fit: BoxFit.cover),
            HomePinsLayer(onPinTap: () => _showAuthSheet(context)),
            Align(
              alignment: Alignment.bottomCenter,
              child: isIOS
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: HomeBottomNav(
                          onChanged: (int index) =>
                              _onNavChanged(context, index),
                        ),
                      ),
                    )
                  : SafeArea(
                      minimum: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: HomeBottomNav(
                          onChanged: (int index) =>
                              _onNavChanged(context, index),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  double _resolveBottomNavInset(double width) {
    final double maxInsetToFit = ((width - _navCompactContentWidth) / 2)
        .clamp(0, _navInsetWide)
        .toDouble();

    if (width <= 360) return maxInsetToFit.clamp(0, AppSpacing.md).toDouble();
    if (width <= 400) {
      return maxInsetToFit.clamp(AppSpacing.md, AppSpacing.lg).toDouble();
    }
    if (width <= 440) {
      return maxInsetToFit.clamp(AppSpacing.lg, AppSpacing.xl).toDouble();
    }
    return maxInsetToFit;
  }
}

class _ResponsiveNavInset extends StatelessWidget {
  const _ResponsiveNavInset({
    required this.horizontalInset,
    required this.child,
  });

  static const double _maxNavWidth = 300;
  final double horizontalInset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalInset),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxNavWidth),
        child: child,
      ),
    );
  }
}
