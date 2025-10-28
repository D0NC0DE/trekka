import 'package:trekka/core/error/exceptions.dart';
import 'package:trekka/core/error/failures.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/profile/data/datasources/users_remote_datasource.dart';
import 'package:trekka/features/profile/data/models/user_dto.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/domain/repositories/users_repository.dart';

/// Implementation of [UsersRepository]
class UsersRepositoryImpl implements UsersRepository {
  const UsersRepositoryImpl({required UsersRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<Result<User>> getMe() async {
    try {
      final UserDto dto = await _remoteDataSource.getMe();
      return Success<User>(dto.toEntity());
    } on ServerException catch (e) {
      return Error<User>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<User>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<User>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<User>(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<User>> getUserById(String userId) async {
    try {
      final UserDto dto = await _remoteDataSource.getUserById(userId);
      return Success<User>(dto.toEntity());
    } on ServerException catch (e) {
      return Error<User>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<User>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<User>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<User>(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<User>> updateProfile({String? username, int? avatar}) async {
    try {
      final UserDto dto = await _remoteDataSource.updateProfile(
        username: username,
        avatar: avatar,
      );
      return Success<User>(dto.toEntity());
    } on ServerException catch (e) {
      return Error<User>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<User>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<User>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<User>(UnexpectedFailure(message: e.toString()));
    }
  }
}
