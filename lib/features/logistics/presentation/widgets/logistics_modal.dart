import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
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
  static const double topSpacing = 10;
  static const double bottomSpacing = 5;
}

class LogisticsModal extends StatelessWidget {
  const LogisticsModal({
    required this.stage,
    required this.onNext,
    required this.onBack,
    required this.onCancel,
    this.onEditPickup,
    super.key,
  });

  final LogisticsStage stage;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback? onEditPickup;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;
    final double maxHeight =
        screenSize.height * _LogisticsConstants.maxHeightFactor;
    final double bottomInset = mediaQuery.viewPadding.bottom;

    final bool shouldExpandToMax =
        stage == LogisticsStage.enterDestination ||
        stage == LogisticsStage.enterPickupLocation;

    final bool shouldShowDragger =
        stage == LogisticsStage.initial ||
        stage == LogisticsStage.enterDestination ||
        stage == LogisticsStage.enterPickupLocation;

    final bool shouldShowStatusBanner =
        stage == LogisticsStage.waitingForDriver ||
        stage == LogisticsStage.driverArrived ||
        stage == LogisticsStage.inProgress;

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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (shouldShowStatusBanner)
                Positioned(
                  left: 0,
                  right: 0,
                  top: -40,
                  child: _DriverStatusBanner(message: _getStatusMessage(stage)),
                ),
              // Main modal
              SheetContainer(
                key: const ValueKey<String>('logistics'),
                borderRadius: 20,
                gradient: AppGradients.logisticsSheet,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: _LogisticsConstants.topSpacing,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      bottom: bottomInset + _LogisticsConstants.bottomSpacing,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (shouldShowDragger)
                          Center(
                            child: SizedBox(
                              width: _LogisticsConstants.dragHandleWidth,
                              child: const SheetDragHandle(),
                            ),
                          ),

                        // Dynamic content based on stage
                        Padding(
                          padding: EdgeInsets.only(
                            top: shouldShowDragger
                                ? _LogisticsConstants.verticalSpacing
                                : _LogisticsConstants.topSpacing,
                          ),
                          child: LogisticsContentFactory.createContent(
                            stage: stage,
                            onNext: onNext,
                            onBack: onBack,
                            onCancel: onCancel,
                            onEditPickup: onEditPickup,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusMessage(LogisticsStage stage) {
    switch (stage) {
      case LogisticsStage.waitingForDriver:
        return 'Driver is on the way';
      case LogisticsStage.driverArrived:
        return 'Driver has arrived';
      case LogisticsStage.inProgress:
        return 'Trip in progress';
      default:
        return '';
    }
  }
}

/// Curved status banner that appears on top of the modal
class _DriverStatusBanner extends StatelessWidget {
  const _DriverStatusBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 52, // Total height of banner
      decoration: const BoxDecoration(
        color: AppColors.logisticsDriverStatusBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: AppShadows.avatarBorderShadow,
      ),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.deepTeal,
          fontWeight: AppFontWeights.medium,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
