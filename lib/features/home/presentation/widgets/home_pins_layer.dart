import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:trekka/features/home/presentation/widgets/home_pin.dart';
import 'package:trekka/features/home/presentation/viewmodels/home_pin_view_model.dart';

class HomePinsLayer extends StatefulWidget {
  const HomePinsLayer({
    super.key,
    required this.onPinTap,
  });

  final VoidCallback onPinTap;

  @override
  State<HomePinsLayer> createState() => _HomePinsLayerState();
}

class _HomePinsLayerState extends State<HomePinsLayer> {
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
          .map((_PinPlacement placement) {
            final bool isDisabled = HomePinViewModel.isTypeDisabled(placement.pinType);
            return Align(
              alignment: placement.alignment,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: isDisabled ? null : widget.onPinTap,
                child: HomePin(pinType: placement.pinType),
              ),
            );
          })
          .toList(),
    );
  }
}

class _PinPlacement {
  const _PinPlacement({required this.pinType, required this.alignment});

  final HomePinType pinType;
  final Alignment alignment;
}
