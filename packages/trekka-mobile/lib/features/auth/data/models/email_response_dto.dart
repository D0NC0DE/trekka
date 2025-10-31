/// DTO for email response from API
class EmailResponseDto {
  const EmailResponseDto({
    required this.message,
  });

  factory EmailResponseDto.fromJson(Map<String, dynamic> json) {
    return EmailResponseDto(
      message: json['message'] as String? ?? 'OTP sent successfully',
    );
  }

  final String message;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
    };
  }
}

