import 'package:flutter/material.dart';
import 'package:trekka/core/assets/app_assets.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';
import 'package:trekka/core/widgets/sheet/sheet_container.dart';
import 'package:trekka/core/widgets/sheet/sheet_drag_handle.dart';

/// Constants for logistics modal
class _LogisticsConstants {
  _LogisticsConstants._();

  static const double maxHeightFactor = 0.85;
  static const double dragHandleWidth = 135;
  static const double verticalSpacing = 20;
}

class LogisticsModal extends StatelessWidget {
  const LogisticsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxHeight =
        screenSize.height * _LogisticsConstants.maxHeightFactor;
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: IntrinsicHeight(
        child: SheetContainer(
          key: const ValueKey<String>('logistics'),
          borderRadius: 20,
          gradient: AppGradients.logisticsBottomSheet,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: bottomInset + _LogisticsConstants.verticalSpacing,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Drag Handle
                  Center(
                    child: SizedBox(
                      width: _LogisticsConstants.dragHandleWidth,
                      child: const SheetDragHandle(),
                    ),
                  ),

                  // Action Buttons Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: _LogisticsConstants.verticalSpacing,
                    ),
                    child: Row(
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
                  ),

                  LocationSearchField(
                    // onTap: ,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
