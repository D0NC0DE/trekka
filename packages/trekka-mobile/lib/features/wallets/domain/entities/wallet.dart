import 'package:equatable/equatable.dart';

/// Domain entity for wallet data
class Wallet extends Equatable {
  const Wallet({
    required this.id,
    required this.userId,
    required this.address,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String address;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    userId,
    address,
    balance,
    createdAt,
    updatedAt,
  ];
}
