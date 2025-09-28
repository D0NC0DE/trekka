import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/router/route_paths.dart';

import '../viewmodels/splash_view_model.dart';
import '../widgets/fog_particle_field.dart';

const _backgroundAssetPath = 'assets/images/splash_bg.png';
const _logoAssetPath = 'assets/icons/trekka_ani.png';
const _loaderAssetPath = 'assets/gifs/loader.gif';
const _loaderRotationRadians = -22.17 * (math.pi / 180);

const _logoSizes = <Size>[Size(60, 49), Size(230, 189)];

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
      ref
          .read(splashViewModelProvider.notifier)
          .start(totalLogoSteps: _logoSizes.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashViewState>(
      splashViewModelProvider,
      (SplashViewState? previous, SplashViewState next) {
        final bool wasReady = previous?.readyForHome ?? false;
        if (!wasReady && next.readyForHome) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.go(RoutePaths.home);
          });
        }
      },
    );

    final SplashViewState state = ref.watch(splashViewModelProvider);
    final Size size = _logoSizes[state.currentLogoIndex];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            opacity: state.backgroundVisible ? 1.0 : 0.0,
            child: Image.asset(
              _backgroundAssetPath,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            key: const ValueKey('splashFogOverlay'),
            duration: state.fogOpacity >= 1.0
                ? const Duration(milliseconds: 120)
                : splashFogFadeDuration,
            curve: Curves.easeOut,
            opacity: state.backgroundVisible ? state.fogOpacity : 0.0,
            child: Transform.scale(
              scale: 1.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white.withValues(alpha: 0.72),
                              Colors.white.withValues(alpha: 0.52),
                              Colors.white.withValues(alpha: 0.34),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              opacity: state.particlesActive ? 1.0 : 0.0,
              child: FogParticleField(active: state.particlesActive),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  duration: splashContentFadeDuration,
                  opacity: state.contentOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: state.logoGlow ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: state.currentAnimationDuration,
                          curve: Curves.easeInOut,
                          width: size.width,
                          height: size.height,
                          decoration: const BoxDecoration(),
                          child: Image.asset(
                            _logoAssetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedOpacity(
                        key: const ValueKey('splashLoaderOpacity'),
                        duration: const Duration(milliseconds: 300),
                        opacity: state.showLoader ? 1.0 : 0.0,
                        child: Transform.rotate(
                          angle: _loaderRotationRadians,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: Image.asset(
                              _loaderAssetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
