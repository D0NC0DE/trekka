import 'package:flutter/material.dart';

import 'package:trekka/features/logistics/presentation/widgets/floating_location_button.dart';
import 'package:trekka/features/logistics/presentation/widgets/logistics_modal.dart';

class LogisticsSheetOverlay extends StatelessWidget {
  const LogisticsSheetOverlay({required this.onLocationPressed, super.key});

  final VoidCallback onLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Floating My Location Button (12px above modal)
        Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 12),
          child: FloatingLocationButton(onPressed: onLocationPressed),
        ),
        // Logistics Modal
        const LogisticsModal(),
      ],
    );
  }
}
