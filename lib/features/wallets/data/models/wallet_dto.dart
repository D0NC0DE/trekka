import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// DTO for wallet data from API
class WalletDto {
  const WalletDto({
    required this.id,
    required this.userId,
    required this.address,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) {
    return WalletDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      address: json['address'] as String,
      balance: _parseBalance(json['balance']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static double _parseBalance(dynamic balance) {
    if (balance is num) {
      return balance.toDouble();
    }
    if (balance is String) {
      return double.parse(balance);
    }
    return 0.0;
  }

  final String id;
  final String userId;
  final String address;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'address': address,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Wallet toEntity() {
    return Wallet(
      id: id,
      userId: userId,
      address: address,
      balance: balance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

