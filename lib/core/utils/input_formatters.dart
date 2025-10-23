import 'package:flutter/services.dart';
import 'package:trekka/core/utils/otp_helpers.dart';

/// Formats OTP input to display with dashes between each character.
/// Converts input to uppercase and allows only alphanumeric characters (0-9, A-Z).
/// Example: 5f6165d0 displays as 5-F-6-1-6-5-D-0
class OtpDashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String formattedText = OtpHelpers.formatOtpWithDashes(newValue.text);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

