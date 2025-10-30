import 'package:trekka/core/utils/result.dart';

/// Repository contract for authentication operations
abstract interface class AuthRepository {
  /// Request OTP to be sent to the provided email
  Future<Result<String>> requestEmailOtp(String email);

  /// Resend OTP to the provided email
  Future<Result<String>> resendEmailOtp(String email);

  /// Verify OTP for the provided email
  Future<Result<Map<String, dynamic>>> verifyEmailOtp({
    required String email,
    required String otp,
  });

  /// Logout the current user
  Future<Result<void>> logout(String refreshToken);
}

