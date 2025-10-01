import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/home/presentation/widgets/home_app_bar.dart';
import 'package:trekka/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:trekka/features/home/presentation/widgets/home_pin.dart';
import 'package:trekka/features/home/presentation/viewmodels/home_pin_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _navInsetWide = 47;
  static const double _navCompactContentWidth = 264;

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
        appBar: const HomeAppBar(),
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(AppAssetImages.homeBackground, fit: BoxFit.cover),
            const _HomePinsLayer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: isIOS
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: const HomeBottomNav(),
                      ),
                    )
                  : SafeArea(
                      minimum: const EdgeInsets.only(bottom: 20),
                      child: _ResponsiveNavInset(
                        horizontalInset: navHorizontalInset,
                        child: const HomeBottomNav(),
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

class _HomePinsLayer extends StatefulWidget {
  const _HomePinsLayer();

  @override
  State<_HomePinsLayer> createState() => _HomePinsLayerState();
}

class _HomePinsLayerState extends State<_HomePinsLayer> {
  static const double _circleRadius = 0.65;
  static const double _radiusVariation = 0.08;
  static const double _angleVariation = 0.15;
  
  late final List<_PinPlacement> _placements;

  @override
  void initState() {
    super.initState();
    _placements = _generateCircularPlacements();
  }

  List<_PinPlacement> _generateCircularPlacements() {
    final List<HomePinType> pinTypes = HomePinType.values;
    final int count = pinTypes.length;
    final math.Random random = math.Random(DateTime.now().microsecondsSinceEpoch);
    final double rotationOffset = random.nextDouble() * 2 * math.pi;
    
    final List<_PinPlacement> placements = <_PinPlacement>[];

    for (int i = 0; i < count; i++) {
      final double baseAngle = (2 * math.pi * i) / count + rotationOffset;
      
      final double angleOffset = (random.nextDouble() - 0.5) * _angleVariation;
      final double radiusOffset = (random.nextDouble() - 0.5) * _radiusVariation;
      
      final double angle = baseAngle + angleOffset;
      final double radius = _circleRadius + radiusOffset;
      
      final double x = math.cos(angle) * radius;
      final double y = math.sin(angle) * radius;
      
      placements.add(
        _PinPlacement(
          pinType: pinTypes[i],
          alignment: Alignment(x, y),
        ),
      );
    }

    return placements;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _placements
          .map(
            (_PinPlacement placement) => Align(
              alignment: placement.alignment,
              child: HomePin(pinType: placement.pinType),
            ),
          )
          .toList(),
    );
  }
}

class _PinPlacement {
  const _PinPlacement({required this.pinType, required this.alignment});

  final HomePinType pinType;
  final Alignment alignment;
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
