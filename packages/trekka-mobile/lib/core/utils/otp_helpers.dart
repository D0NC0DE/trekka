/// OTP formatting and validation utilities.
class OtpHelpers {
  OtpHelpers._();

  /// Maximum number of characters allowed in an OTP code.
  static const int maxOtpLength = 8;

  /// Formats an alphanumeric string with dashes between each character.
  ///
  /// Example: "5F6165D0" → "5-F-6-1-6-5-D-0"
  ///
  /// Only alphanumeric characters (0-9, A-Z) are preserved and converted to uppercase,
  /// limited to [maxOtpLength] characters.
  static String formatOtpWithDashes(String input) {
    // Only keep alphanumeric characters and convert to uppercase
    final String alphanumericOnly =
        input.toUpperCase().replaceAll(RegExp(r'[^0-9A-Z]'), '');
    final String limitedChars = alphanumericOnly.length > maxOtpLength
        ? alphanumericOnly.substring(0, maxOtpLength)
        : alphanumericOnly;

    // Add dashes between each character
    final StringBuffer formatted = StringBuffer();
    for (int i = 0; i < limitedChars.length; i++) {
      if (i > 0) {
        formatted.write('-');
      }
      formatted.write(limitedChars[i]);
    }

    return formatted.toString();
  }

  /// Removes all non-alphanumeric characters from OTP input.
  ///
  /// Example: "5-F-6-1-6-5-D-0" → "5F6165D0"
  static String cleanOtp(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^0-9A-Z]'), '');
  }

  /// Validates if an OTP code is complete and valid.
  ///
  /// Returns `true` if the OTP has exactly [maxOtpLength] alphanumeric characters.
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
