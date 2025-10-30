/// Common validation utilities.
class Validators {
  Validators._();

  /// Email validation regex pattern.
  /// Matches standard email formats like user@example.com
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates if a string is a valid email address.
  ///
  /// Returns `true` if [email] matches a valid email format, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// Validators.isValidEmail('test@gmail.com'); // true
  /// Validators.isValidEmail('invalid'); // false
  /// ```
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates if a string is not empty.
  ///
  /// Returns `true` if [value] is not null and not empty, `false` otherwise.
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates if a string meets minimum length requirement.
  ///
  /// Returns `true` if [value] length is >= [minLength], `false` otherwise.
  static bool hasMinLength(String? value, int minLength) {
    if (value == null) return false;
    return value.length >= minLength;
  }

  /// Validates if a password is strong enough.
  ///
  /// Password must be at least 8 characters long.
  ///
  /// Returns `true` if [password] meets requirements, `false` otherwise.
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 8;
  }

  /// Validates if a phone number is valid.
  ///
  /// Basic validation for phone numbers (10+ digits).
  ///
  /// Returns `true` if [phone] is valid, `false` otherwise.
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final String digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length >= 10;
  }
}

