import 'package:dio/dio.dart';

/// Interceptor for logging network requests and responses
class NetworkLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logResponse(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    // ignore: avoid_print
    print(
      '╔══════════════════════════════════════════════════════════════════════',
    );
    // ignore: avoid_print
    print('║ 🌐 REQUEST: ${options.method} ${options.uri}');
    // ignore: avoid_print
    print('║ Headers: ${options.headers}');
    if (options.data != null) {
      // ignore: avoid_print
      print('║ Body: ${options.data}');
    }
    // ignore: avoid_print
    print(
      '╚══════════════════════════════════════════════════════════════════════',
    );
  }

  void _logResponse(Response<dynamic> response) {
    // ignore: avoid_print
    print(
      '╔══════════════════════════════════════════════════════════════════════',
    );
    // ignore: avoid_print
    print(
      '║ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    // ignore: avoid_print
    print('║ Data: ${response.data}');
    // ignore: avoid_print
    print(
      '╚══════════════════════════════════════════════════════════════════════',
    );
  }

  void _logError(DioException err) {
    // ignore: avoid_print
    print(
      '╔══════════════════════════════════════════════════════════════════════',
    );
    // ignore: avoid_print
    print('║ ❌ ERROR: ${err.type} ${err.requestOptions.uri}');
    // ignore: avoid_print
    print('║ Message: ${err.message}');
    if (err.response != null) {
      // ignore: avoid_print
      print('║ Status: ${err.response?.statusCode}');
      // ignore: avoid_print
      print('║ Data: ${err.response?.data}');
    }
    // ignore: avoid_print
    print(
      '╚══════════════════════════════════════════════════════════════════════',
    );
  }
}
