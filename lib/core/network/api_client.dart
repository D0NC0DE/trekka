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
}

