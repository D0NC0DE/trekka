import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:trekka/core/design/tokens.dart';

import '../viewmodels/splash_view_model.dart';

const _logoAssetPath = 'assets/icons/trekka_ani.png';
const _loaderAssetPath = 'assets/gifs/loader.gif';
const _loaderRotationRadians = -22.17 * (math.pi / 180);
const ValueKey<String> _logoImageKey = ValueKey<String>('splash_logo_image');
const ValueKey<String> _loaderImageKey = ValueKey<String>('splash_loader_image');
const _logoSizes = <Size>[
  Size(60, 49),
  Size(230, 189),
];

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(splashViewModelProvider.notifier).start(
            totalLogoSteps: _logoSizes.length,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashViewState>(
      splashViewModelProvider,
      (SplashViewState? previous, SplashViewState next) {
        final String? target = next.navigationTarget;
        if (target != null && previous?.navigationTarget != target) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.go(target);
            ref
                .read(splashViewModelProvider.notifier)
                .clearNavigationRequest();
          });
        }
      },
    );

    final SplashViewState state = ref.watch(splashViewModelProvider);
    final Size size = _logoSizes[state.currentLogoIndex];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: state.currentAnimationDuration,
              curve: Curves.easeInOut,
              width: size.width,
              height: size.height,
              child: Image.asset(
                key: _logoImageKey,
                _logoAssetPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: state.showLoader ? 1.0 : 0.0,
              child: Transform.rotate(
                angle: _loaderRotationRadians,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: Image.asset(
                    key: _loaderImageKey,
                    _loaderAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
