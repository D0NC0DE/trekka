import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import 'package:trekka/core/router/route_paths.dart';

const Duration splashInitialDelay = Duration(milliseconds: 100);
const Duration splashAnimationDuration = Duration(milliseconds: 500);
const Duration splashLoaderDisplayDuration = Duration(seconds: 10);

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, SplashViewState>(
  (ref) => SplashViewModel(),
);

class SplashViewModel extends StateNotifier<SplashViewState> {
  SplashViewModel() : super(const SplashViewState.initial());

  Future<void> start({required int totalLogoSteps}) async {
    if (state.hasStarted) return;

    state = state.copyWith(hasStarted: true);

    await Future<void>.delayed(splashInitialDelay);

    for (int index = 1; index < totalLogoSteps; index++) {
      if (!mounted) return;
      await Future<void>.delayed(splashAnimationDuration);
      if (!mounted) return;
      state = state.copyWith(currentLogoIndex: index);
    }

    if (!mounted) return;
    state = state.copyWith(showLoader: true);

    await Future<void>.delayed(splashLoaderDisplayDuration);

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
    this.navigationTarget,
  });

  const SplashViewState.initial()
      : currentLogoIndex = 0,
        showLoader = false,
        navigationTarget = null,
        hasStarted = false;

  final int currentLogoIndex;
  final bool showLoader;
  final bool hasStarted;
  final String? navigationTarget;

  SplashViewState copyWith({
    int? currentLogoIndex,
    bool? showLoader,
    bool? hasStarted,
    String? navigationTarget,
    bool clearNavigationTarget = false,
  }) {
    return SplashViewState(
      currentLogoIndex: currentLogoIndex ?? this.currentLogoIndex,
      showLoader: showLoader ?? this.showLoader,
      hasStarted: hasStarted ?? this.hasStarted,
      navigationTarget: clearNavigationTarget
          ? null
          : navigationTarget ?? this.navigationTarget,
    );
  }
}
