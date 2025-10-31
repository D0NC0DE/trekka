import 'package:flutter/material.dart';

import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/widgets/floating_location_button.dart';
import 'package:trekka/features/logistics/presentation/widgets/logistics_modal.dart';

class LogisticsSheetOverlay extends StatelessWidget {
  const LogisticsSheetOverlay({
    required this.stage,
    required this.onLocationPressed,
    required this.onNext,
    required this.onBack,
    required this.onCancel,
    this.showFloatingButton = true,
    this.onEditPickup,
    this.onCompleteTrip,
    super.key,
  });

  final LogisticsStage stage;
  final VoidCallback onLocationPressed;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback? onEditPickup;
  final VoidCallback? onCompleteTrip;
  final bool showFloatingButton;

  @override
  Widget build(BuildContext context) {
    final bool isCloseButton = stage.canGoBack;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (showFloatingButton)
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 12),
            child: FloatingLocationButton(
              onPressed: isCloseButton ? onBack : onLocationPressed,
              isCloseButton: isCloseButton,
            ),
          ),
        LogisticsModal(
          stage: stage,
          onNext: onNext,
          onBack: onBack,
          onCancel: onCancel,
          onEditPickup: onEditPickup,
          onCompleteTrip: onCompleteTrip,
        ),
      ],
    );
  }
}
