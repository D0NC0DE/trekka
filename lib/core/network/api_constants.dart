/// API endpoint and header constants
class ApiConstants {
  ApiConstants._();

  // Base paths
  static const String apiVersion = '/api/v1';

  // Headers
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String applicationJson = 'application/json';

  // Auth endpoints
  static const String authBase = '$apiVersion/auth';
  static const String emailRequest = '$authBase/email/request';
  static const String emailResend = '$authBase/email/resend';
  static const String emailVerify = '$authBase/email/verify';
  static const String googleAuth = '$authBase/google';
  static const String logout = '$authBase/logout';
  static const String refresh = '$authBase/refresh';

  // User endpoints
  static const String usersBase = '$apiVersion/users';
  static const String usersMe = '$usersBase/me';
  static const String usersById = '$usersBase/:id';

  // Wallet endpoints
  static const String walletsBase = '$apiVersion/wallets';
  static const String walletsMe = '$walletsBase/me';
  static const String walletsBalance = '$walletsMe/balance';
  static const String walletsAddress = '$walletsMe/address';
}
