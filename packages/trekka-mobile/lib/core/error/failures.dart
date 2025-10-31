import 'package:equatable/equatable.dart';

/// Base class for failures
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Failure from server errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

/// Failure from network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Failure from timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
  });
}

/// Failure from parsing errors
class ParsingFailure extends Failure {
  const ParsingFailure({
    super.message = 'Something went wrong. Please try again.',
  });
}

/// Failure from authentication errors
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}

