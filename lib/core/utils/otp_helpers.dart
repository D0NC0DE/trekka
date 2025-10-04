/// OTP formatting and validation utilities.
class OtpHelpers {
  OtpHelpers._();

  /// Maximum number of digits allowed in an OTP code.
  static const int maxOtpLength = 8;

  /// Formats a numeric string with dashes between each digit.
  ///
  /// Example: "12345678" → "1-2-3-4-5-6-7-8"
  ///
  /// Only numeric characters are preserved, limited to [maxOtpLength] digits.
  static String formatOtpWithDashes(String input) {
    final String digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    final String limitedDigits = digitsOnly.length > maxOtpLength
        ? digitsOnly.substring(0, maxOtpLength)
        : digitsOnly;

    // Add dashes between each digit
    final StringBuffer formatted = StringBuffer();
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i > 0) {
        formatted.write('-');
      }
      formatted.write(limitedDigits[i]);
    }

    return formatted.toString();
  }

  /// Removes all non-numeric characters from OTP input.
  ///
  /// Example: "1-2-3-4-5-6-7-8" → "12345678"
  static String cleanOtp(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Validates if an OTP code is complete and valid.
  ///
  /// Returns `true` if the OTP has exactly [maxOtpLength] digits.
  static bool isValidOtp(String input) {
    final String cleaned = cleanOtp(input);
    return cleaned.length == maxOtpLength;
  }

  /// Formats time in seconds to MM:SS format.
  ///
  /// Example: 125 seconds → "2:05"
  static String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
