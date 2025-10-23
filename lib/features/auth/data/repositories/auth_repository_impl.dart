import 'package:trekka/core/error/exceptions.dart';
import 'package:trekka/core/error/failures.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:trekka/features/auth/data/models/email_response_dto.dart';
import 'package:trekka/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<String>> requestEmailOtp(String email) async {
    try {
      final EmailResponseDto response =
          await _remoteDataSource.requestEmailOtp(email);
      return Success<String>(response.message);
    } on ServerException catch (e) {
      return Error<String>(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    } on NetworkException catch (e) {
      return Error<String>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<String>(TimeoutFailure(message: e.message));
    } on AuthException catch (e) {
      return Error<String>(AuthFailure(message: e.message));
    } catch (e) {
      return Error<String>(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<String>> resendEmailOtp(String email) async {
    try {
      final EmailResponseDto response =
          await _remoteDataSource.resendEmailOtp(email);
      return Success<String>(response.message);
    } on ServerException catch (e) {
      return Error<String>(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    } on NetworkException catch (e) {
      return Error<String>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<String>(TimeoutFailure(message: e.message));
    } on AuthException catch (e) {
      return Error<String>(AuthFailure(message: e.message));
    } catch (e) {
      return Error<String>(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> response =
          await _remoteDataSource.verifyEmailOtp(
        email: email,
        otp: otp,
      );
      return Success<Map<String, dynamic>>(response);
    } on ServerException catch (e) {
      return Error<Map<String, dynamic>>(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    } on NetworkException catch (e) {
      return Error<Map<String, dynamic>>(
        NetworkFailure(message: e.message),
      );
    } on TimeoutException catch (e) {
      return Error<Map<String, dynamic>>(
        TimeoutFailure(message: e.message),
      );
    } on AuthException catch (e) {
      return Error<Map<String, dynamic>>(AuthFailure(message: e.message));
    } catch (e) {
      return Error<Map<String, dynamic>>(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }
}

