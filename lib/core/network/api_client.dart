import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:trekka/core/error/exceptions.dart';
import 'package:trekka/core/network/api_constants.dart';
import 'package:trekka/core/network/network_logger_interceptor.dart';

/// HTTP client for making API requests
class ApiClient {
  ApiClient({
    required String baseUrl,
    bool enableLogging = true,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: <String, dynamic>{
              ApiConstants.contentType: ApiConstants.applicationJson,
              ApiConstants.accept: ApiConstants.applicationJson,
            },
          ),
        ) {
    if (enableLogging) {
      _dio.interceptors.add(NetworkLoggerInterceptor());
    }
  }

  final Dio _dio;
  QueuedInterceptorsWrapper? _authInterceptor;
  Future<String?> Function()? _refreshTokenProvider;
  Future<void> Function(String accessToken, String refreshToken)? _onTokensUpdated;
  Future<void> Function()? _onUnauthorized;
  Completer<void>? _refreshCompleter;

  static const String _retryKey = '__trekka_retry';
  static const String _skipRefreshKey = '__trekka_skip_refresh';

  /// Make a GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a PATCH request
  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  /// Remove authorization token
  void clearAuthToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  /// Configure automatic token refresh handling for authenticated requests.
  void configureAuthRefresh({
    required Future<String?> Function() getRefreshToken,
    required Future<void> Function(String accessToken, String refreshToken) onTokensUpdated,
    required Future<void> Function() onUnauthorized,
  }) {
    _refreshTokenProvider = getRefreshToken;
    _onTokensUpdated = onTokensUpdated;
    _onUnauthorized = onUnauthorized;

    _authInterceptor ??= QueuedInterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (!_shouldAttemptRefresh(error)) {
          handler.next(error);
          return;
        }

        final RequestOptions requestOptions = error.requestOptions;

        if (_shouldRetryWithUpdatedToken(requestOptions)) {
          final Object? originalRetryFlag = requestOptions.extra[_retryKey];
          requestOptions.extra[_retryKey] = true;
          requestOptions.headers[ApiConstants.authorization] =
              _dio.options.headers[ApiConstants.authorization];

          try {
            final Response<dynamic> response = await _dio.fetch<dynamic>(requestOptions);
            handler.resolve(response);
            return;
          } catch (_) {
            if (originalRetryFlag == null) {
              requestOptions.extra.remove(_retryKey);
            } else {
              requestOptions.extra[_retryKey] = originalRetryFlag;
            }
          }
        }

        try {
          await _refreshAccessToken();
          requestOptions.extra[_retryKey] = true;
          requestOptions.headers[ApiConstants.authorization] =
              _dio.options.headers[ApiConstants.authorization];

          final Response<dynamic> response = await _dio.fetch<dynamic>(requestOptions);
          handler.resolve(response);
        } catch (refreshError, stackTrace) {
          await _handleRefreshFailure(refreshError, stackTrace);
          handler.next(error);
        }
      },
    );

    if (!_dio.interceptors.contains(_authInterceptor)) {
      _dio.interceptors.add(_authInterceptor!);
    }
  }

  Map<String, dynamic> _handleResponse(Response<dynamic> response) {
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    // If response is not a map, wrap it
    return <String, dynamic>{'data': response.data};
  }

  Exception _handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException();

        case DioExceptionType.connectionError:
          if (error.error is SocketException) {
            return const NetworkException();
          }
          return ServerException(
            message: error.message ?? 'Connection error',
            statusCode: error.response?.statusCode,
          );

        case DioExceptionType.badResponse:
          final int? statusCode = error.response?.statusCode;
          final dynamic data = error.response?.data;

          String message = 'Server error occurred';
          if (data is Map<String, dynamic>) {
            message = data['message'] as String? ??
                data['error'] as String? ??
                message;
          }

          return ServerException(
            message: message,
            statusCode: statusCode,
          );

        case DioExceptionType.cancel:
          return const ServerException(message: 'Request cancelled');

        case DioExceptionType.badCertificate:
          return const ServerException(message: 'Bad certificate');

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return const NetworkException();
          }
          return ServerException(
            message: error.message ?? 'Unknown error occurred',
          );
      }
    }

    return ServerException(message: error.toString());
  }

  bool _shouldAttemptRefresh(DioException error) {
    if (_refreshTokenProvider == null || _onTokensUpdated == null) return false;
    final Response<dynamic>? response = error.response;
    if (response == null || response.statusCode != HttpStatus.unauthorized) {
      return false;
    }

    final RequestOptions requestOptions = error.requestOptions;
    if (requestOptions.extra[_skipRefreshKey] == true) return false;
    if (requestOptions.extra[_retryKey] == true) return false;
    if (_isRefreshRequest(requestOptions)) return false;
    return true;
  }

  bool _shouldRetryWithUpdatedToken(RequestOptions requestOptions) {
    final String? currentAuthHeader = _dio.options.headers[ApiConstants.authorization] as String?;
    if (currentAuthHeader == null) return false;
    final String? requestAuthHeader =
        requestOptions.headers[ApiConstants.authorization] as String?;
    if (requestAuthHeader == null) return false;
    if (requestAuthHeader == currentAuthHeader) return false;
    if (requestOptions.extra[_retryKey] == true) return false;
    return true;
  }

  bool _isRefreshRequest(RequestOptions requestOptions) {
    final Uri uri = requestOptions.uri;
    return uri.path == ApiConstants.refresh;
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final Completer<void> completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      final String? refreshToken = await _refreshTokenProvider!.call();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const AuthException(message: 'Missing refresh token');
      }

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.refresh,
        data: <String, dynamic>{'refreshToken': refreshToken},
        options: Options(
          headers: <String, dynamic>{
            ApiConstants.authorization: null,
            ApiConstants.contentType: ApiConstants.applicationJson,
          },
          extra: const <String, dynamic>{_skipRefreshKey: true},
        ),
      );

      final Map<String, dynamic> data = _normalizeResponseData(response.data);
      final Map<String, dynamic>? tokens =
          data['tokens'] is Map<String, dynamic> ? data['tokens'] as Map<String, dynamic> : null;
      final String? newAccessToken =
          tokens?['accessToken'] as String? ?? data['accessToken'] as String?;
      final String? newRefreshTokenRaw =
          tokens?['refreshToken'] as String? ?? data['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw const AuthException(message: 'Invalid refresh response');
      }

      final String resolvedRefreshToken = (newRefreshTokenRaw == null || newRefreshTokenRaw.isEmpty)
          ? refreshToken
          : newRefreshTokenRaw;

      setAuthToken(newAccessToken);
      await _onTokensUpdated!.call(newAccessToken, resolvedRefreshToken);

      completer.complete();
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    } finally {
      _refreshCompleter = null;
    }

    return completer.future;
  }

  Map<String, dynamic> _normalizeResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return <String, dynamic>{};
  }

  Future<void> _handleRefreshFailure(Object error, StackTrace _) async {
    if (_onUnauthorized == null) return;
    if (!_shouldForceLogout(error)) return;

    try {
      await _onUnauthorized!.call();
    } catch (_) {
      // Swallow to avoid propagating errors during unauthorized handling
    }
  }

  bool _shouldForceLogout(Object error) {
    if (error is AuthException) {
      return true;
    }
    if (error is DioException) {
      final int? statusCode = error.response?.statusCode;
      if (statusCode == HttpStatus.unauthorized ||
          statusCode == HttpStatus.forbidden ||
          statusCode == HttpStatus.badRequest) {
        return true;
      }
    }
    return false;
  }
}
