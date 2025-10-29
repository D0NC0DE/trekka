import 'package:trekka/core/network/api_client.dart';
import 'package:trekka/core/network/api_constants.dart';
import 'package:trekka/features/profile/data/models/user_dto.dart';

/// Remote data source for user operations
abstract interface class UsersRemoteDataSource {
  Future<UserDto> getMe();

  Future<UserDto> getUserById(String userId);

  Future<UserDto> updateProfile({String? username, int? avatar});

  Future<void> deleteAccount();
}

/// Implementation of [UsersRemoteDataSource] using [ApiClient]
class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  const UsersRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserDto> getMe() async {
    final Map<String, dynamic> response = await _apiClient.get(
      ApiConstants.usersMe,
    );
    return UserDto.fromJson(response);
  }

  @override
  Future<UserDto> getUserById(String userId) async {
    final Map<String, dynamic> response = await _apiClient.get(
      ApiConstants.usersById.replaceAll(':id', userId),
    );
    return UserDto.fromJson(response);
  }

  @override
  Future<UserDto> updateProfile({String? username, int? avatar}) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (avatar != null) data['avatar'] = avatar;

    final Map<String, dynamic> response = await _apiClient.patch(
      ApiConstants.usersMe,
      data: data,
    );
    return UserDto.fromJson(response);
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.delete(ApiConstants.usersMe);
  }
}
