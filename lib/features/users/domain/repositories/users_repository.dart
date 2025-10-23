import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/users/domain/entities/user.dart';

/// Repository contract for user operations
abstract interface class UsersRepository {
  Future<Result<User>> getMe();

  Future<Result<User>> getUserById(String userId);

  Future<Result<User>> updateProfile({String? username, int? avatar});
}
