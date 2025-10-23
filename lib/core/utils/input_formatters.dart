import 'package:flutter/services.dart';
import 'package:trekka/core/utils/otp_helpers.dart';

/// Formats OTP input to display with dashes between each digit.
/// Example: 49048044 displays as 4-9-0-4-8-0-4-4
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

