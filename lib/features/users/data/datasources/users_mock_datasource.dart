import 'package:trekka/features/users/data/datasources/users_remote_datasource.dart';
import 'package:trekka/features/users/data/models/user_dto.dart';

/// Mock implementation of [UsersRemoteDataSource]
class UsersMockDataSource implements UsersRemoteDataSource {
  const UsersMockDataSource();

  @override
  Future<UserDto> getMe() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return UserDto(
      id: 'mock_user_id',
      email: 'mock@trekka.app',
      username: 'mockuser',
      avatar: 1,
      isEmailVerified: true,
      lastLoginAt: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserDto> getUserById(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return UserDto(
      id: userId,
      email: 'user$userId@trekka.app',
      username: 'user$userId',
      avatar: 2,
      isEmailVerified: true,
      lastLoginAt: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserDto> updateProfile({String? username, int? avatar}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return UserDto(
      id: 'mock_user_id',
      email: 'mock@trekka.app',
      username: username ?? 'mockuser',
      avatar: avatar ?? 1,
      isEmailVerified: true,
      lastLoginAt: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }
}
