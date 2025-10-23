import 'package:trekka/core/network/api_client.dart';
import 'package:trekka/core/network/api_constants.dart';
import 'package:trekka/features/wallets/data/models/wallet_dto.dart';

/// Remote data source for wallet operations
abstract interface class WalletsRemoteDataSource {
  Future<WalletDto> getMyWallet();

  Future<double> getBalance();

  Future<String> getAddress();
}

/// Implementation of [WalletsRemoteDataSource] using [ApiClient]
class WalletsRemoteDataSourceImpl implements WalletsRemoteDataSource {
  const WalletsRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<WalletDto> getMyWallet() async {
    final Map<String, dynamic> response = await _apiClient.get(
      ApiConstants.walletsMe,
    );
    return WalletDto.fromJson(response);
  }

  @override
  Future<double> getBalance() async {
    final Map<String, dynamic> response = await _apiClient.get(
      ApiConstants.walletsBalance,
    );
    final dynamic balance = response['balance'];
    if (balance is num) {
      return balance.toDouble();
    }
    if (balance is String) {
      return double.parse(balance);
    }
    return 0.0;
  }

  @override
  Future<String> getAddress() async {
    final Map<String, dynamic> response = await _apiClient.get(
      ApiConstants.walletsAddress,
    );
    return response['address'] as String;
  }
}
