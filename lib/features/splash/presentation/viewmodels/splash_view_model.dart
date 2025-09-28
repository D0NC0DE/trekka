import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import 'package:trekka/core/router/route_paths.dart';

const Duration splashInitialDelay = Duration(milliseconds: 100);
const Duration splashExpandDuration = Duration(milliseconds: 3000);
const Duration splashLoaderDelay = Duration(milliseconds: 100);
const Duration splashLoaderMinimumDuration = Duration(milliseconds: 2000);

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
    state = state.copyWith(navigationTarget: RoutePaths.placeholder);
  }

  void clearNavigationRequest() {
    if (state.navigationTarget == null) return;
    state = state.copyWith(clearNavigationTarget: true);
  }
}

class SplashViewState {
  const SplashViewState({
    required this.currentLogoIndex,
    required this.showLoader,
    required this.hasStarted,
    required this.currentAnimationDuration,
    this.navigationTarget,
  });

  const SplashViewState.initial()
      : currentLogoIndex = 0,
        showLoader = false,
        navigationTarget = null,
        hasStarted = false,
        currentAnimationDuration = Duration.zero;

  final int currentLogoIndex;
  final bool showLoader;
  final bool hasStarted;
  final Duration currentAnimationDuration;
  final String? navigationTarget;

  SplashViewState copyWith({
    int? currentLogoIndex,
    bool? showLoader,
    bool? hasStarted,
    Duration? currentAnimationDuration,
    String? navigationTarget,
    bool clearNavigationTarget = false,
  }) {
    return SplashViewState(
      currentLogoIndex: currentLogoIndex ?? this.currentLogoIndex,
      showLoader: showLoader ?? this.showLoader,
      hasStarted: hasStarted ?? this.hasStarted,
      currentAnimationDuration:
          currentAnimationDuration ?? this.currentAnimationDuration,
      navigationTarget: clearNavigationTarget
          ? null
          : navigationTarget ?? this.navigationTarget,
    );
  }
}
