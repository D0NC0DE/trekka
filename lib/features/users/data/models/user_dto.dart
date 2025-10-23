import 'package:trekka/features/users/domain/entities/user.dart';

/// DTO for user data from API
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.isEmailVerified,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as int,
      isEmailVerified: json['isEmailVerified'] as bool,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String email;
  final String username;
  final int avatar;
  final bool isEmailVerified;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'isEmailVerified': isEmailVerified,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      isEmailVerified: isEmailVerified,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
