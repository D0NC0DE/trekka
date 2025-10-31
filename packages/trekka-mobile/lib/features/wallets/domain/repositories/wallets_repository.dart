import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Repository contract for wallet operations
abstract interface class WalletsRepository {
  Future<Result<Wallet>> getMyWallet();

  Future<Result<double>> getBalance();

  Future<Result<String>> getAddress();
}

