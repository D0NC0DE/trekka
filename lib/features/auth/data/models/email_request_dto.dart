/// DTO for email request API call
class EmailRequestDto {
  const EmailRequestDto({
    required this.email,
  });

  final String email;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
    };
  }
}

