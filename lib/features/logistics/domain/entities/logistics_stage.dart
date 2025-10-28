/// Represents the different stages of a logistics journey.
enum LogisticsStage {
  /// Initial/default stage - the first view with read-only search field
  initial,

  /// Entering destination in search field
  enterDestination,

  /// Confirm automatically detected pickup details
  confirmPickupLocation,

  /// Manually enter pickup details if auto-detected option is unsuitable
  enterPickupLocation,

  /// Confirming ride details and requesting
  confirmRequest,

  /// Searching for available drivers
  lookingForDriver,

  /// Waiting for driver to accept
  waitingForDriver,

  /// Driver arrived at pickup location
  driverArrived,

  /// Ride in progress
  inProgress,

  /// Ride completed
  complete,

  /// Post-ride review and feedback
  review,
}

extension LogisticsStageExtension on LogisticsStage {
  /// Returns true if the user can go back to the previous stage
  bool get canGoBack {
    switch (this) {
      case LogisticsStage.initial:
        return false;
      case LogisticsStage.inProgress:
      case LogisticsStage.complete:
        return false;
      case LogisticsStage.enterDestination:
      case LogisticsStage.confirmPickupLocation:
      case LogisticsStage.enterPickupLocation:
      case LogisticsStage.confirmRequest:
        return true;
      case LogisticsStage.lookingForDriver:
        return false;
      case LogisticsStage.waitingForDriver:
      case LogisticsStage.driverArrived:
      case LogisticsStage.review:
        return true;
    }
  }

  /// Returns true if the modal can be dismissed at this stage
  bool get isDismissible {
    switch (this) {
      case LogisticsStage.initial:
      case LogisticsStage.enterDestination:
      case LogisticsStage.confirmPickupLocation:
      case LogisticsStage.enterPickupLocation:
      case LogisticsStage.confirmRequest:
      case LogisticsStage.lookingForDriver:
      case LogisticsStage.waitingForDriver:
      case LogisticsStage.driverArrived:
      case LogisticsStage.inProgress:
      case LogisticsStage.complete:
      case LogisticsStage.review:
        return false;
    }
  }
}
