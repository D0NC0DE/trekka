import 'package:equatable/equatable.dart';

/// Domain entity for user data
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.isEmailVerified,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String email;
  final String username;
  final int avatar;
  final bool isEmailVerified;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    email,
    username,
    avatar,
    isEmailVerified,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
}
