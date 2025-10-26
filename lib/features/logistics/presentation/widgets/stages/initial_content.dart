import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';

/// Content for the location selection stage
class InitialContent extends StatelessWidget {
  const InitialContent({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Action Buttons Row - JOURNEY and COURIER
        Row(
          children: <Widget>[
            Expanded(
              child: GradientActionButton(
                leadingImage: AppAssetIcons.journey,
                label: 'JOURNEY',
                color: AppColors.logisticsActionActive,
                isActive: true,
                onTap: () {
                  // TODO: Handle journey action
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GradientActionButton(
                leadingImage: AppAssetIcons.courier,
                label: 'COURIER',
                color: AppColors.logisticsActionInactive,
                isActive: false,
                onTap: () {
                  // TODO: Handle courier action
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.mdLg),

        // Location Search Field
        LocationSearchField(
          hintText: 'Where to go?',
          readOnly: true,
          onTap: () {
            // TODO: Open location picker
            onNext(); 
          },
        ),
      ],
    );
  }
}
