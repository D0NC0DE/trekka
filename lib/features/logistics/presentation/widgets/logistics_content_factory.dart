import 'package:flutter/material.dart';

import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/enter_destination_content.dart';
import 'package:trekka/features/logistics/presentation/widgets/stages/initial_content.dart';
// TODO: Import other stage content widgets as you create them

/// Factory that returns the appropriate content widget for each logistics stage.
class LogisticsContentFactory {
  /// Creates the content widget for the given stage
  static Widget createContent({
    required LogisticsStage stage,
    required VoidCallback onNext,
    required VoidCallback onBack,
    required VoidCallback onCancel,
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

      case LogisticsStage.confirmRequest:
        // TODO: Create and return ConfirmRequestContent
        return Center(
          child: Text('Confirm Request Stage - TODO'),
        );

      case LogisticsStage.waitingForDriver:
        // TODO: Create and return WaitingForDriverContent
        return Center(
          child: Text('Waiting for Driver Stage - TODO'),
        );

      case LogisticsStage.driverEnRoute:
        // TODO: Create and return DriverEnRouteContent
        return Center(
          child: Text('Driver En Route Stage - TODO'),
        );

      case LogisticsStage.driverArrived:
        // TODO: Create and return DriverArrivedContent
        return Center(
          child: Text('Driver Arrived Stage - TODO'),
        );

      case LogisticsStage.inProgress:
        // TODO: Create and return InProgressContent
        return Center(
          child: Text('In Progress Stage - TODO'),
        );

      case LogisticsStage.completed:
        // TODO: Create and return CompletedContent
        return Center(
          child: Text('Completed Stage - TODO'),
        );
    }
  }
}

