/// Base exception class for API errors
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (${statusCode ?? "unknown"})';
}

/// Exception thrown when there's a network connectivity issue
class NetworkException implements Exception {
  const NetworkException({
    this.message = 'No internet connection',
  });

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when request times out
class TimeoutException implements Exception {
  const TimeoutException({
    this.message = 'Request timed out',
  });

  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when data parsing fails
class ParsingException implements Exception {
  const ParsingException({
    this.message = 'Failed to parse response data',
  });

  final String message;

  @override
  String toString() => 'ParsingException: $message';
}

/// Exception thrown for authentication errors
class AuthException implements Exception {
  const AuthException({
    required this.message,
  });

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

