import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

const Duration splashInitialDelay = Duration(milliseconds: 100);
const Duration splashExpandDuration = Duration(milliseconds: 3000);
const Duration splashLoaderDelay = Duration(milliseconds: 100);
const Duration splashLoaderMinimumDuration = Duration(milliseconds: 2000);
const Duration splashFogFadeDuration = Duration(milliseconds: 3500);
const Duration splashContentFadeDuration = Duration(milliseconds: 600);

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, SplashViewState>(
  (ref) => SplashViewModel(),
);

class SplashViewModel extends StateNotifier<SplashViewState> {
  SplashViewModel() : super(const SplashViewState.initial());

  Future<void> start({required int totalLogoSteps}) async {
    if (state.hasStarted) return;

    state = state.copyWith(hasStarted: true);

    if (splashInitialDelay > Duration.zero) {
      await Future<void>.delayed(splashInitialDelay);
    }

    if (!mounted) return;
    state = state.copyWith(
      currentLogoIndex: totalLogoSteps - 1,
      currentAnimationDuration: splashExpandDuration,
    );

    await Future<void>.delayed(splashExpandDuration);

    if (!mounted) return;
    if (splashLoaderDelay > Duration.zero) {
      await Future<void>.delayed(splashLoaderDelay);
    }

    if (!mounted) return;
    state = state.copyWith(showLoader: true);

    await Future<void>.delayed(splashLoaderMinimumDuration);

    if (!mounted) return;
    state = state.copyWith(
      showLoader: false,
      backgroundVisible: true,
      fogOpacity: 1.0,
      particlesActive: true,
      logoGlow: true,
      contentOpacity: 0.0,
      readyForHome: false,
    );

    await Future<void>.delayed(splashContentFadeDuration);

    if (!mounted) return;
    // TODO: Trigger wind ambience when the fog begins clearing.
    state = state.copyWith(fogOpacity: 0.0);

    await Future<void>.delayed(splashFogFadeDuration);

    if (!mounted) return;
    state = state.copyWith(
      particlesActive: false,
      logoGlow: false,
      readyForHome: true,
    );
  }
}

class SplashViewState {
  const SplashViewState({
    required this.currentLogoIndex,
    required this.showLoader,
    required this.hasStarted,
    required this.currentAnimationDuration,
    required this.backgroundVisible,
    required this.fogOpacity,
    required this.particlesActive,
    required this.logoGlow,
    required this.contentOpacity,
    required this.readyForHome,
  });

  const SplashViewState.initial()
      : currentLogoIndex = 0,
        showLoader = false,
        hasStarted = false,
        currentAnimationDuration = Duration.zero,
        backgroundVisible = false,
        fogOpacity = 1.0,
        particlesActive = false,
        logoGlow = false,
        contentOpacity = 1.0,
        readyForHome = false;

  final int currentLogoIndex;
  final bool showLoader;
  final bool hasStarted;
  final Duration currentAnimationDuration;
  final bool backgroundVisible;
  final double fogOpacity;
  final bool particlesActive;
  final bool logoGlow;
  final double contentOpacity;
  final bool readyForHome;

  SplashViewState copyWith({
    int? currentLogoIndex,
    bool? showLoader,
    bool? hasStarted,
    Duration? currentAnimationDuration,
    bool? backgroundVisible,
    double? fogOpacity,
    bool? particlesActive,
    bool? logoGlow,
    double? contentOpacity,
    bool? readyForHome,
  }) {
    return SplashViewState(
      currentLogoIndex: currentLogoIndex ?? this.currentLogoIndex,
      showLoader: showLoader ?? this.showLoader,
      hasStarted: hasStarted ?? this.hasStarted,
      currentAnimationDuration:
          currentAnimationDuration ?? this.currentAnimationDuration,
      backgroundVisible: backgroundVisible ?? this.backgroundVisible,
      fogOpacity: fogOpacity ?? this.fogOpacity,
      particlesActive: particlesActive ?? this.particlesActive,
      logoGlow: logoGlow ?? this.logoGlow,
      contentOpacity: contentOpacity ?? this.contentOpacity,
      readyForHome: readyForHome ?? this.readyForHome,
    );
  }
}
