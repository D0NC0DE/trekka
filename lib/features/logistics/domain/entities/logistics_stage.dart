/// Represents the different stages of a logistics journey.
enum LogisticsStage {
  /// Initial/default stage - the first view with read-only search field
  initial,

  /// Entering destination in search field
  enterDestination,

  /// Confirming ride details and requesting
  confirmRequest,

  /// Waiting for driver to accept
  waitingForDriver,

  /// Driver accepted, on the way to pickup
  driverEnRoute,

  /// Driver arrived at pickup location
  driverArrived,

  /// Ride in progress
  inProgress,

  /// Ride completed
  completed,
}

extension LogisticsStageExtension on LogisticsStage {
  /// Returns true if the user can go back to the previous stage
  bool get canGoBack {
    switch (this) {
      case LogisticsStage.initial:
        return false; // First stage, nowhere to go back
      case LogisticsStage.enterDestination:
        return true; // Can go back to initial stage
      case LogisticsStage.confirmRequest:
        return true; // Can go back to enter destination
      case LogisticsStage.waitingForDriver:
      case LogisticsStage.driverEnRoute:
      case LogisticsStage.driverArrived:
      case LogisticsStage.inProgress:
        return false; // Cannot go back once ride is active
      case LogisticsStage.completed:
        return false; // Final stage
    }
  }

  /// Returns true if the modal can be dismissed at this stage
  bool get isDismissible {
    switch (this) {
      case LogisticsStage.initial:
      case LogisticsStage.enterDestination:
      case LogisticsStage.confirmRequest:
        return true; // Can dismiss before ride starts
      case LogisticsStage.waitingForDriver:
      case LogisticsStage.driverEnRoute:
      case LogisticsStage.driverArrived:
      case LogisticsStage.inProgress:
        return false; // Cannot dismiss active ride
      case LogisticsStage.completed:
        return true; // Can dismiss after completion
    }
  }
}

