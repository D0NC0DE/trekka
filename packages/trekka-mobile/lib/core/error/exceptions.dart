/// Base exception class for API errors
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  String toString() {
    final String status = statusCode?.toString() ?? 'unknown';
    final String codePart = code != null ? ' code=$code,' : '';
    return 'ServerException:$codePart status=$status message=$message';
  }
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
