import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:trekka/features/home/presentation/widgets/home_app_bar.dart';
import 'package:trekka/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:trekka/features/home/presentation/widgets/home_pins_layer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _navInsetWide = 47;
  static const double _navCompactContentWidth = 264;

  int _currentIndex = 0;

  Future<void> _showAuthSheet(BuildContext context) {
    // TODO: Show Auth sheet when user is not authenticated
    return AuthSheet.show(context);
  }

  void _onNavChanged(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
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
            _buildTabBody(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: isIOS
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: HomeBottomNav(
                          initialIndex: _currentIndex,
                          onChanged: _onNavChanged,
                        ),
                      ),
                    )
                  : SafeArea(
                      minimum: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: HomeBottomNav(
                          initialIndex: _currentIndex,
                          onChanged: _onNavChanged,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return HomePinsLayer(onPinTap: () => _showAuthSheet(context));
      case 1:
        return const _TabPlaceholder(
          title: 'History',
          message: 'Track quests and rewards -- coming soon.',
        );
      case 2:
        return const _TabPlaceholder(
          title: 'Profile',
          message: 'Customize your Trekka identity -- coming soon.',
        );
      default:
        return const SizedBox.shrink();
    }
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

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                letterSpacing: 1.6,
                color: AppColors.accentAmber,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.white75),
            ),
          ],
        ),
      ),
    );
  }
}
