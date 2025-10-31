import 'package:equatable/equatable.dart';
import 'package:trekka/core/error/failures.dart';

/// Represents the result of an operation that can either succeed or fail
sealed class Result<T> extends Equatable {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Error<T>;

  /// Executes the appropriate callback based on the result type
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Error<T>(:final error) => failure(error),
    };
  }

  /// Maps the success value if present
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success<R>(transform(data)),
      Error<T>(:final error) => Error<R>(error),
    };
  }

  @override
  List<Object?> get props => switch (this) {
        Success<T>(:final data) => <Object?>[data],
        Error<T>(:final error) => <Object?>[error],
      };
}

/// Represents a successful result
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

/// Represents a failed result
final class Error<T> extends Result<T> {
  const Error(this.error);

  final Failure error;
}

