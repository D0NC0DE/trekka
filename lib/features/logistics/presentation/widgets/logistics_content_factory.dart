import 'package:flutter/material.dart';

import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/confirm_pickup_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/enter_destination_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/enter_pickup_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/confirm_request_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/looking_for_driver_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/initial_content.dart';
// TODO: Import other stage content widgets

/// Factory that returns the appropriate content widget for each logistics stage.
class LogisticsContentFactory {
  /// Creates the content widget for the given stage
  static Widget createContent({
    required LogisticsStage stage,
    required VoidCallback onNext,
    required VoidCallback onBack,
    required VoidCallback onCancel,
    VoidCallback? onEditPickup,
  }) {
    switch (stage) {
      case LogisticsStage.initial:
        return InitialContent(
          onNext: onNext,
        );

      case LogisticsStage.enterDestination:
        return EnterDestinationContent(
          onNext: onNext,
        );

      case LogisticsStage.confirmPickupLocation:
        return ConfirmPickupLocationContent(
          onConfirm: onNext,
          onEditPickup: onEditPickup ?? onBack,
        );

      case LogisticsStage.enterPickupLocation:
        return EnterPickupLocationContent(
          onNext: onNext,
        );

      case LogisticsStage.confirmRequest:
        return ConfirmRequestContent(
          onConfirm: onNext,
        );

      case LogisticsStage.lookingForDriver:
        return LookingForDriverContent(
          onCancel: onCancel,
        );

      case LogisticsStage.waitingForDriver:
        return const Center(
          child: Text('Waiting for Driver Stage - TODO'),
        );

      case LogisticsStage.driverArrived:
        return const Center(
          child: Text('Driver Arrived Stage - TODO'),
        );

      case LogisticsStage.inProgress:
        return const Center(
          child: Text('Ride In Progress Stage - TODO'),
        );

      case LogisticsStage.complete:
        return const Center(
          child: Text('Ride Complete Stage - TODO'),
        );

      case LogisticsStage.review:
        return const Center(
          child: Text('Review Stage - TODO'),
        );
    }
  }
}
