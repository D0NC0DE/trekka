import 'package:trekka/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:trekka/features/auth/data/models/email_response_dto.dart';

/// Mock implementation of [AuthRemoteDataSource] for testing/development
class AuthMockDataSource implements AuthRemoteDataSource {
  const AuthMockDataSource();

  @override
  Future<EmailResponseDto> requestEmailOtp(String email) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    return const EmailResponseDto(
      message: 'OTP sent successfully to your email',
    );
  }

  @override
  Future<EmailResponseDto> resendEmailOtp(String email) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    return const EmailResponseDto(
      message: 'OTP resent successfully',
    );
  }

  @override
  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock successful verification
    return <String, dynamic>{
      'accessToken': 'mock_access_token',
      'refreshToken': 'mock_refresh_token',
      'user': <String, dynamic>{
        'id': 'mock_user_id',
        'email': email,
        'username': 'mockuser',
        'avatar': 1,
        'isEmailVerified': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<void> logout(String refreshToken) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Mock successful logout
  }
}

