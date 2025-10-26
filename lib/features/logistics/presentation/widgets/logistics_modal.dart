import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/sheet/sheet_container.dart';
import 'package:trekka/core/widgets/sheet/sheet_drag_handle.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/widgets/logistics_content_factory.dart';

/// Constants for logistics modal
class _LogisticsConstants {
  _LogisticsConstants._();

  static const double maxHeightFactor = 0.85;
  static const double dragHandleWidth = 135;
  static const double verticalSpacing = 20;
}

class LogisticsModal extends StatelessWidget {
  const LogisticsModal({
    required this.stage,
    required this.onNext,
    required this.onBack,
    required this.onCancel,
    super.key,
  });

  final LogisticsStage stage;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;
    final double maxHeight =
        screenSize.height * _LogisticsConstants.maxHeightFactor;
    final double bottomInset = mediaQuery.viewPadding.bottom;

    final bool shouldExpandToMax = stage == LogisticsStage.enterDestination;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: shouldExpandToMax ? maxHeight : 0,
        ),
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

                    // Dynamic content based on stage
                    Padding(
                      padding: const EdgeInsets.only(
                        top: _LogisticsConstants.verticalSpacing,
                      ),
                      child: LogisticsContentFactory.createContent(
                        stage: stage,
                        onNext: onNext,
                        onBack: onBack,
                        onCancel: onCancel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
