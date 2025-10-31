import 'package:trekka/features/wallets/data/datasources/wallets_remote_datasource.dart';
import 'package:trekka/features/wallets/data/models/wallet_dto.dart';

/// Mock implementation of [WalletsRemoteDataSource]
class WalletsMockDataSource implements WalletsRemoteDataSource {
  const WalletsMockDataSource();

  @override
  Future<WalletDto> getMyWallet() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return WalletDto(
      id: 'mock_wallet_id',
      userId: 'mock_user_id',
      address: '0.0.8686868',
      balance: 1250.50,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<double> getBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return 1250.50;
  }

  @override
  Future<String> getAddress() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return '0.0.8686868';
  }
}
