import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/home/presentation/viewmodels/home_pin_view_model.dart';

class HomePin extends StatefulWidget {
  const HomePin({
    super.key,
    this.label,
    this.pinType = HomePinType.logisticsCourier,
  });

  final String? label;
  final HomePinType pinType;

  @override
  State<HomePin> createState() => _HomePinState();
}

class _HomePinState extends State<HomePin> with SingleTickerProviderStateMixin {
  late final HomePinViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomePinViewModel(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _viewModel.start();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomePinDisplay display = _viewModel.resolveDisplay(widget.pinType, widget.label);
    final String formattedLabel = display.label
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .map((String word) => word.toUpperCase())
        .join('\n');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _viewModel.controller,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: _BlurredRingPainter(
                color: _viewModel.ringColor.value ?? AppColors.overlayBlurBlack,
                strokeWidth: HomePinAnimationSpec.borderWidth,
                blurSigma: HomePinAnimationSpec.blurSigma,
              ),
              child: SizedBox(
                width: HomePinAnimationSpec.diameter,
                height: HomePinAnimationSpec.diameter,
                child: Padding(
                  padding: const EdgeInsets.only(top: HomePinAnimationSpec.iconTopPadding),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: _viewModel.iconWidth.value,
                      height: _viewModel.iconHeight.value,
                      child: Image.asset(
                        display.assetPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.smLg),
        AnimatedBuilder(
          animation: _viewModel.controller,
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: _viewModel.pinpointWidth.value,
              height: _viewModel.pinpointHeight.value,
              child: Image.asset(
                AppAssetIcons.pinpoint,
                color: AppColors.accentPinpoint,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        Builder(
          builder: (BuildContext context) {
            return Text(
              formattedLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: AppSpacing.smMd,
                    color: AppColors.accentAmber,
                  ),
            );
          },
        ),
      ],
    );
  }
}

class _BlurredRingPainter extends CustomPainter {
  _BlurredRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.blurSigma,
  });

  final Color color;
  final double strokeWidth;
  final double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _BlurredRingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.blurSigma != blurSigma;
  }
}
