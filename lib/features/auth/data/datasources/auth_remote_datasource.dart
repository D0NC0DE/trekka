import 'package:trekka/core/network/api_client.dart';
import 'package:trekka/core/network/api_constants.dart';
import 'package:trekka/features/auth/data/models/email_request_dto.dart';
import 'package:trekka/features/auth/data/models/email_response_dto.dart';

/// Remote data source for authentication operations
abstract interface class AuthRemoteDataSource {
  /// Request OTP to be sent to the provided email
  Future<EmailResponseDto> requestEmailOtp(String email);

  /// Resend OTP to the provided email
  Future<EmailResponseDto> resendEmailOtp(String email);

  /// Verify OTP for the provided email
  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  });

  /// Logout the current user
  Future<void> logout(String refreshToken);
}

/// Implementation of [AuthRemoteDataSource] using [ApiClient]
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<EmailResponseDto> requestEmailOtp(String email) async {
    final EmailRequestDto requestDto = EmailRequestDto(email: email);
    final Map<String, dynamic> response = await _apiClient.post(
      ApiConstants.emailRequest,
      data: requestDto.toJson(),
    );
    return EmailResponseDto.fromJson(response);
  }

  @override
  Future<EmailResponseDto> resendEmailOtp(String email) async {
    final EmailRequestDto requestDto = EmailRequestDto(email: email);
    final Map<String, dynamic> response = await _apiClient.post(
      ApiConstants.emailResend,
      data: requestDto.toJson(),
    );
    return EmailResponseDto.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final Map<String, dynamic> response = await _apiClient.post(
      ApiConstants.emailVerify,
      data: <String, dynamic>{
        'email': email,
        'otp': otp,
      },
    );
    return response;
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      ApiConstants.logout,
      data: <String, dynamic>{
        'refreshToken': refreshToken,
      },
    );
  }
}

