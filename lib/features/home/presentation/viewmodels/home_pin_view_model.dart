import 'dart:async';

import 'package:flutter/animation.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/assets/app_assets.dart';

class HomePinAnimationSpec {
  HomePinAnimationSpec._();

  static const double diameter = 94;
  static const double borderWidth = 26;
  static const double blurSigma = 39;

  static const double iconWidth = 40;
  static const double iconHeight = 53;
  static const double iconTopPadding = 24;
  static const double iconWidthExpanded = 50;
  static const double iconHeightExpanded = 66;

  static const double pinpointWidth = 35;
  static const double pinpointHeight = 5;
  static const double pinpointWidthExpanded = 49;
  static const double pinpointHeightExpanded = 7;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration expandedDelay = Duration(milliseconds: 2);
  static const Duration idleDelay = Duration(milliseconds: 1);
}

enum HomePinType {
  logisticsCourier,
  logisticsHailing,
  marketplace,
  questOnline,
  questPhysical,
  recycling,
}

class HomePinDisplay {
  const HomePinDisplay({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;
}

class HomePinViewModel {
  HomePinViewModel({required TickerProvider vsync})
      : _controller = AnimationController(
          vsync: vsync,
          duration: HomePinAnimationSpec.animationDuration,
          reverseDuration: HomePinAnimationSpec.animationDuration,
        ) {
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    ringColor = ColorTween(
      begin: AppColors.overlayBlurBlack,
      end: AppColors.overlayDenseBlack,
    ).animate(curvedAnimation);

    iconWidth = Tween<double>(
      begin: HomePinAnimationSpec.iconWidth,
      end: HomePinAnimationSpec.iconWidthExpanded,
    ).animate(curvedAnimation);

    iconHeight = Tween<double>(
      begin: HomePinAnimationSpec.iconHeight,
      end: HomePinAnimationSpec.iconHeightExpanded,
    ).animate(curvedAnimation);

    pinpointWidth = Tween<double>(
      begin: HomePinAnimationSpec.pinpointWidth,
      end: HomePinAnimationSpec.pinpointWidthExpanded,
    ).animate(curvedAnimation);

    pinpointHeight = Tween<double>(
      begin: HomePinAnimationSpec.pinpointHeight,
      end: HomePinAnimationSpec.pinpointHeightExpanded,
    ).animate(curvedAnimation);
  }

  final AnimationController _controller;
  late final Animation<Color?> ringColor;
  late final Animation<double> iconWidth;
  late final Animation<double> iconHeight;
  late final Animation<double> pinpointWidth;
  late final Animation<double> pinpointHeight;

  bool _loopRunning = false;
  bool _isDisposed = false;

  AnimationController get controller => _controller;

  static const Map<HomePinType, HomePinDisplay> _defaultDisplays = <HomePinType, HomePinDisplay>{
    HomePinType.logisticsCourier: HomePinDisplay(
      assetPath: AppAssetIcons.courierPin,
      label: 'Logistics Courier',
    ),
    HomePinType.logisticsHailing: HomePinDisplay(
      assetPath: AppAssetIcons.hailingPin,
      label: 'Logistics Hailing',
    ),
    HomePinType.marketplace: HomePinDisplay(
      assetPath: AppAssetIcons.marketplacePin,
      label: 'Marketplace',
    ),
    HomePinType.questOnline: HomePinDisplay(
      assetPath: AppAssetIcons.questOnlinePin,
      label: 'Quest Online',
    ),
    HomePinType.questPhysical: HomePinDisplay(
      assetPath: AppAssetIcons.questPhysicalPin,
      label: 'Quest Physical',
    ),
    HomePinType.recycling: HomePinDisplay(
      assetPath: AppAssetIcons.recyclePin,
      label: 'Recycling',
    ),
  };

  HomePinDisplay resolveDisplay(HomePinType type, String? overrideLabel) {
    final HomePinDisplay defaults = _defaultDisplays[type] ?? _defaultDisplays[HomePinType.logisticsCourier]!;
    if (overrideLabel == null || overrideLabel.isEmpty) {
      return defaults;
    }

    return HomePinDisplay(
      assetPath: defaults.assetPath,
      label: overrideLabel,
    );
  }

  void start() {
    if (_loopRunning || _isDisposed) return;
    _loopRunning = true;
    _runLoop();
  }

  Future<void> _runLoop() async {
    while (!_isDisposed) {
      await _delay(HomePinAnimationSpec.idleDelay);
      if (_isDisposed) break;

      if (!await _animate(() => _controller.forward())) break;
      if (_isDisposed) break;

      await _delay(HomePinAnimationSpec.expandedDelay);
      if (_isDisposed) break;

      if (!await _animate(() => _controller.reverse())) break;
    }
  }

  Future<void> _delay(Duration duration) async {
    if (duration <= Duration.zero || _isDisposed) return;
    await Future<void>.delayed(duration);
  }

  Future<bool> _animate(TickerFuture Function() animator) async {
    if (_isDisposed) return false;
    try {
      await animator();
      return true;
    } on TickerCanceled {
      return false;
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _controller.dispose();
  }
}

